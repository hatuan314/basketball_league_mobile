import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/team_color_api.dart';
import 'package:baseketball_league_mobile/data/models/team_color_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

class TeamColorApiImpl implements TeamColorApi {
  @override
  Future<Either<Exception, TeamColorModel>> createTeamColor(
    TeamColorModel teamColor,
  ) async {
    final postgresConnection = sl<PostgresConnection>();
    try {
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để thêm mới áo đấu
      final query = '''
      INSERT INTO team_color (team_id, season_id, color_name)
      VALUES (@teamId, @seasonId, @colorName)
      RETURNING team_id, season_id, color_name;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'teamId': teamColor.teamId,
          'seasonId': teamColor.seasonId,
          'colorName': teamColor.colorName,
        },
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        return Right(teamColor);
      } else {
        return Left(Exception('Không thể tạo áo đấu cho đội bóng'));
      }
    } catch (e) {
      return Left(
        Exception('Lỗi khi tạo áo đấu cho đội bóng: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteTeamColor(int seasonTeamId) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để xóa áo đấu
      final query = '''
      DELETE FROM team_color
      WHERE season_team_id = @seasonTeamId;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {'seasonTeamId': seasonTeamId},
      );

      // Kiểm tra kết quả trả về
      if (result.affectedRows > 0) {
        return const Right(unit);
      } else {
        return Left(Exception('Không tìm thấy áo đấu với ID: $seasonTeamId'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi xóa áo đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<TeamColorModel>>> getTeamColors({
    required int seasonId,
    int? teamId,
  }) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Câu lệnh SQL để lấy danh sách áo đấu
      String query;
      Map<String, dynamic>? parameters;

      if (teamId != null) {
        // Nếu có teamId, lấy áo đấu của đội cụ thể trong mùa giải
        query = '''
        SELECT tc.team_id, tc.season_id, tc.color_name
        FROM team_color tc
        JOIN season_team st ON tc.season_team_id = st.season_team_id
        WHERE tc.season_id = @seasonId AND st.team_id = @teamId
        ORDER BY tc.color_name;
        ''';
        parameters = {'seasonId': seasonId, 'teamId': teamId};
      } else {
        // Nếu không có teamId, lấy tất cả áo đấu của mùa giải
        query = '''
        SELECT tc.team_id, tc.season_id, tc.color_name
        FROM team_color tc
        WHERE tc.season_id = @seasonId
        ORDER BY tc.color_name;
        ''';
        parameters = {'seasonId': seasonId};
      }

      // Thực thi câu lệnh SQL
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: parameters,
      );

      // Chuyển đổi kết quả thành danh sách model
      final teamColors =
          result.map((row) {
            return TeamColorModel.fromPostgres(row);
          }).toList();

      return Right(teamColors);
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách áo đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, TeamColorModel>> updateTeamColor(
    TeamColorModel teamColor,
  ) async {
    try {
      final postgresConnection = sl<PostgresConnection>();
      // Kiểm tra kết nối
      if (!postgresConnection.conn.isOpen) {
        await postgresConnection.connectDb();
      }

      // Kiểm tra seasonTeamId có tồn tại
      if (teamColor.teamId == null) {
        return Left(Exception('Không thể cập nhật áo đấu không có ID'));
      }

      // Câu lệnh SQL để cập nhật áo đấu
      final query = '''
      UPDATE team_color
      SET color_name = @colorName
      WHERE team_id = @teamId AND season_id = @seasonId
      RETURNING team_id, season_id, color_name;
      ''';

      // Thực thi câu lệnh SQL với các tham số
      final result = await postgresConnection.conn.execute(
        Sql.named(query),
        parameters: {
          'teamId': teamColor.teamId,
          'seasonId': teamColor.seasonId,
          'colorName': teamColor.colorName,
        },
      );

      // Kiểm tra kết quả trả về
      if (result.isNotEmpty) {
        return Right(teamColor);
      } else {
        return Left(
          Exception('Không tìm thấy áo đấu với ID: ${teamColor.teamId}'),
        );
      }
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật áo đấu: ${e.toString()}'));
    }
  }
}
