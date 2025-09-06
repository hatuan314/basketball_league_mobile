import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/season_team_api.dart';
import 'package:baseketball_league_mobile/data/models/season_team_model.dart';
import 'package:baseketball_league_mobile/data/models/team_standing_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

class SeasonTeamApiImpl implements SeasonTeamApi {
  SeasonTeamApiImpl();
  @override
  Future<Either<Exception, SeasonTeamModel>> createSeasonTeam(
    SeasonTeamModel seasonTeam,
  ) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để thêm mới season_team
      final query = '''
      INSERT INTO season_team (season_id, team_id, home_id)
      VALUES (@seasonId, @teamId, @homeId)
      RETURNING season_team_id, season_id, team_id, home_id;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'seasonId': seasonTeam.seasonId,
          'teamId': seasonTeam.teamId,
          'homeId': seasonTeam.homeId,
        },
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        // Chuyển đổi kết quả thành model
        final createdSeasonTeam = SeasonTeamModel.fromRow(result.first);
        return Right(createdSeasonTeam);
      } else {
        return Left(
          Exception('Không thể tạo mối quan hệ giữa giải đấu và đội bóng'),
        );
      }
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi tạo mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteSeasonTeam(
    SeasonTeamModel seasonTeam,
  ) async {
    final postgresConnection = sl<PostgresConnection>();
    try {
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Kiểm tra id có tồn tại
      if (seasonTeam.id == null) {
        return Left(Exception('Không thể xóa mối quan hệ không có ID'));
      }

      // Câu lệnh SQL để xóa season_team
      final query = '''
      DELETE FROM season_team
      WHERE season_team_id = @id;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {'id': seasonTeam.id},
      );

      // Kiểm tra kết quả trả về
      if (result.affectedRows > 0) {
        return const Right(unit);
      } else {
        return Left(
          Exception(
            'Không tìm thấy mối quan hệ giữa giải đấu và đội bóng với ID: ${seasonTeam.id}',
          ),
        );
      }
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi xóa mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<SeasonTeamModel>>> getSeasonTeams() async {
    final postgresConnection = sl<PostgresConnection>();
    try {
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để lấy danh sách season_team với thông tin chi tiết
      final query = '''
      SELECT st.season_team_id, st.season_id, st.team_id, st.home_id,
             s.name as season_name, s.code as season_code,
             t.team_name, t.team_code,
             sd.name as stadium_name
      FROM season_team st
      JOIN season s ON st.season_id = s.season_id
      JOIN team t ON st.team_id = t.team_id
      JOIN stadium sd ON st.home_id = sd.stadium_id
      ORDER BY s.name, t.team_name;
      ''';

      // Thực thi câu lệnh SQL
      final result = await postgresConnection.conn.execute(query);

      // Chuyển đổi kết quả thành danh sách model
      final seasonTeams =
          result.map((row) => SeasonTeamModel.fromRow(row)).toList();

      return Right(seasonTeams);
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy danh sách mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingModel>>> searchSeasonTeamByName(
    String name,
  ) async {
    final postgresConnection = sl<PostgresConnection>();
    try {
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để tìm kiếm đội bóng theo tên và trả về bảng xếp hạng
      // Sử dụng hàm unaccent để loại bỏ dấu trong quá trình tìm kiếm
      final query = '''
      SELECT 
        season_id,
        season_name,
        team_id,
        team_name,
        total_points,
        total_wins,
        total_losses,
        total_points_scored,
        total_points_conceded,
        point_difference,
        home_wins,
        away_wins,
        total_fouls
      FROM team_standings
      WHERE unaccent(team_name) ILIKE unaccent(@searchTerm)
      ORDER BY total_points DESC, point_difference DESC, total_points_scored DESC;
      ''';

      // Thực thi câu lệnh SQL với tham số tìm kiếm
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {'searchTerm': '%$name%'},
      );

      // Chuyển đổi kết quả thành danh sách model
      final teamStandings =
          result.map((row) => TeamStandingModel.fromRow(row)).toList();

      return Right(teamStandings);
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi tìm kiếm bảng xếp hạng đội bóng theo tên: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, SeasonTeamModel>> updateSeasonTeam(
    SeasonTeamModel seasonTeam,
  ) async {
    final postgresConnection = sl<PostgresConnection>();
    try {
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Kiểm tra id có tồn tại
      if (seasonTeam.id == null) {
        return Left(Exception('Không thể cập nhật mối quan hệ không có ID'));
      }

      // Câu lệnh SQL để cập nhật season_team
      final query = '''
      UPDATE season_team
      SET season_id = @seasonId, team_id = @teamId, home_id = @homeId
      WHERE season_team_id = @id
      RETURNING season_team_id, season_id, team_id, home_id;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'id': seasonTeam.id,
          'seasonId': seasonTeam.seasonId,
          'teamId': seasonTeam.teamId,
          'homeId': seasonTeam.homeId,
        },
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        // Chuyển đổi kết quả thành model
        final updatedSeasonTeam = SeasonTeamModel.fromRow(result.first);
        return Right(updatedSeasonTeam);
      } else {
        return Left(
          Exception(
            'Không tìm thấy mối quan hệ giữa giải đấu và đội bóng với ID: ${seasonTeam.id}',
          ),
        );
      }
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi cập nhật mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingModel>>> getTeamStandings({
    int? seasonId,
  }) async {
    if (seasonId == null) {
      return Right([]);
    }
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để lấy bảng xếp hạng đội bóng
      String query;
      Map<String, dynamic>? parameters;

      // Nếu có seasonId, chỉ lấy bảng xếp hạng của mùa giải đó
      query = '''
        SELECT 
          season_id,
          season_name,
          team_id,
          team_name,
          total_points,
          total_wins,
          total_losses,
          total_points_scored,
          total_points_conceded,
          point_difference,
          home_wins,
          away_wins,
          total_fouls
        FROM team_standings
        WHERE season_id = @seasonId
        ORDER BY total_points DESC, point_difference DESC, total_points_scored DESC
        ''';

      parameters = {'seasonId': seasonId};

      // Thực thi câu lệnh SQL
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: parameters,
      );

      // Chuyển đổi kết quả thành danh sách model
      final teamStandings =
          result.map((row) => TeamStandingModel.fromRow(row)).toList();

      return Right(teamStandings);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy bảng xếp hạng đội bóng: ${e.toString()}'),
      );
    }
  }
  
  @override
  Future<Either<Exception, SeasonTeamModel?>> getSeasonTeamBySeasonAndTeam({
    required int seasonId,
    required int teamId,
  }) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }
      
      // Câu lệnh SQL để lấy thông tin đội bóng trong một mùa giải
      final query = '''
      SELECT st.season_team_id, st.season_id, st.team_id, st.home_id,
             s.name as season_name, s.code as season_code,
             t.team_name, t.team_code,
             sd.name as stadium_name
      FROM season_team st
      JOIN season s ON st.season_id = s.season_id
      JOIN team t ON st.team_id = t.team_id
      JOIN stadium sd ON st.home_id = sd.stadium_id
      WHERE st.season_id = @seasonId AND st.team_id = @teamId
      ''';
      
      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'seasonId': seasonId,
          'teamId': teamId,
        },
      );
      
      // Kiểm tra kết quả trả về
      if (result.isEmpty) {
        return const Right(null);
      }
      
      // Chuyển đổi kết quả thành model
      final seasonTeam = SeasonTeamModel.fromRow(result.first);
      return Right(seasonTeam);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy thông tin đội bóng trong mùa giải: ${e.toString()}'),
      );
    }
  }
}
