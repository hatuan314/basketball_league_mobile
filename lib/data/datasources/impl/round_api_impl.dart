import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/round_api.dart';
import 'package:baseketball_league_mobile/data/models/round/top_scores_by_round_model.dart';
import 'package:baseketball_league_mobile/data/models/round_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

class RoundApiImpl implements RoundApi {
  @override
  Future<Either<Exception, RoundModel>> createRound(RoundModel round) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Kiểm tra dữ liệu đầu vào
      if (round.seasonId == null || round.roundNo == null) {
        return Left(
          Exception('Thiếu thông tin bắt buộc: seasonId hoặc roundNo'),
        );
      }

      // Câu lệnh SQL để thêm mới vòng đấu
      final query = '''
      INSERT INTO round (season_id, round_no, start_date, end_date)
      VALUES (@seasonId, @roundNo, @startDate, @endDate)
      RETURNING round_id, season_id, round_no, start_date, end_date;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'seasonId': round.seasonId,
          'roundNo': round.roundNo,
          'startDate': round.startDate,
          'endDate': round.endDate,
        },
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        // Chuyển đổi kết quả thành model
        final createdRound = RoundModel.fromPostgres(result.first);
        return Right(createdRound);
      } else {
        return Left(Exception('Không thể tạo vòng đấu'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi tạo vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteRound(int id) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để xóa vòng đấu
      final query = '''
      DELETE FROM round
      WHERE round_id = @id;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {'id': id},
      );

      // Kiểm tra kết quả trả về
      if (result.affectedRows > 0) {
        return const Right(unit);
      } else {
        return Left(Exception('Không tìm thấy vòng đấu với ID: $id'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi xóa vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<RoundModel>>> generateRounds({
    required int seasonId,
    required int numberOfRounds,
    required DateTime startDate,
    required int daysBetweenRounds,
  }) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Kiểm tra dữ liệu đầu vào
      if (numberOfRounds <= 0) {
        return Left(Exception('Số lượng vòng đấu phải lớn hơn 0'));
      }

      // Danh sách vòng đấu sẽ được tạo
      final List<RoundModel> createdRounds = [];

      // Tạo từng vòng đấu
      for (int i = 1; i <= numberOfRounds; i++) {
        // Tính toán ngày bắt đầu và kết thúc của vòng đấu
        final roundStartDate = startDate.add(
          Duration(days: (i - 1) * daysBetweenRounds),
        );
        final roundEndDate = roundStartDate.add(
          Duration(days: daysBetweenRounds - 1),
        );

        // Tạo model vòng đấu
        final round = RoundModel(
          seasonId: seasonId,
          roundNo: i,
          startDate: roundStartDate,
          endDate: roundEndDate,
        );

        // Gọi API để tạo vòng đấu
        final result = await createRound(round);

        // Xử lý kết quả
        final createdRound = result.fold((exception) => null, (model) => model);

        // Nếu tạo thành công, thêm vào danh sách kết quả
        if (createdRound != null) {
          createdRounds.add(createdRound);
        } else {
          return Left(Exception('Lỗi khi tạo vòng đấu thứ $i'));
        }
      }

      return Right(createdRounds);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo vòng đấu tự động: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, RoundModel>> getRoundById(int id) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để lấy thông tin vòng đấu
      final query = '''
      SELECT round_id, season_id, round_no, start_date, end_date
      FROM round
      WHERE round_id = @id;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {'id': id},
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        // Chuyển đổi kết quả thành model
        final round = RoundModel.fromPostgres(result.first);
        return Right(round);
      } else {
        return Left(Exception('Không tìm thấy vòng đấu với ID: $id'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<RoundModel>>> getRounds({int? seasonId}) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để lấy danh sách vòng đấu
      String query;
      Map<String, dynamic>? parameters;

      if (seasonId != null) {
        // Nếu có seasonId, lấy vòng đấu của mùa giải cụ thể
        query = '''
        SELECT round_id, season_id, round_no, start_date, end_date
        FROM round
        WHERE season_id = @seasonId
        ORDER BY round_no;
        ''';
        parameters = {'seasonId': seasonId};
      } else {
        // Nếu không có seasonId, lấy tất cả vòng đấu
        query = '''
        SELECT round_id, season_id, round_no, start_date, end_date
        FROM round
        ORDER BY season_id, round_no;
        ''';
        parameters = null;
      }

      // Thực thi câu lệnh SQL
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: parameters,
      );

      // Chuyển đổi kết quả thành danh sách model
      final rounds =
          result.map((row) {
            return RoundModel(
              id: row[0] as int,
              seasonId: row[1] as int,
              roundNo: row[2] as int,
              startDate: row[3] as DateTime,
              endDate: row[4] as DateTime,
            );
          }).toList();

      return Right(rounds);
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, RoundModel>> updateRound(RoundModel round) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Kiểm tra id có tồn tại
      if (round.id == null) {
        return Left(Exception('Không thể cập nhật vòng đấu không có ID'));
      }

      // Câu lệnh SQL để cập nhật vòng đấu
      final query = '''
      UPDATE round
      SET season_id = @seasonId, round_no = @roundNo, start_date = @startDate, end_date = @endDate
      WHERE round_id = @id
      RETURNING round_id, season_id, round_no, start_date, end_date;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'id': round.id,
          'seasonId': round.seasonId,
          'roundNo': round.roundNo,
          'startDate': round.startDate,
          'endDate': round.endDate,
        },
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        // Chuyển đổi kết quả thành model
        final updatedRound = RoundModel.fromPostgres(result.first);
        return Right(updatedRound);
      } else {
        return Left(Exception('Không tìm thấy vòng đấu với ID: ${round.id}'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, TopScoresByRoundModel>> getTopScoresByRound({
    int? seasonId,
    int? roundId,
  }) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để lấy thông tin vòng đấu
      final query = '''
      SELECT 
        season_id,
        season_name,
        round_id,
        round_no,
        player_id,
        player_code,
        player_name,
        team_id,
        team_name,
        total_points
      FROM top_scorers_by_round WHERE season_id = @seasonId and round_id = @roundId ORDER BY total_points DESC LIMIT 1
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {'seasonId': seasonId, 'roundId': roundId},
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        // Chuyển đổi kết quả thành model
        final topScoresByRound = TopScoresByRoundModel.fromPostgres(
          result.first,
        );
        return Right(topScoresByRound);
      } else {
        return Left(Exception('Không tìm thấy vòng đấu với ID: $id'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin vòng đấu: ${e.toString()}'));
    }
  }
}
