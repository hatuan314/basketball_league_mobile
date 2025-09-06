import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/team_api.dart';
import 'package:baseketball_league_mobile/data/models/team_model.dart';
import 'package:dartz/dartz.dart';

class TeamApiImpl implements TeamApi {
  @override
  Future<Either<Exception, bool>> createTeam(TeamModel team) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      INSERT INTO team (
        team_name, 
        team_code
      ) VALUES (
        '${team.name}', 
        '${team.code}'
      )
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi tạo đội bóng: $e');
      return Left(Exception('Lỗi khi tạo đội bóng: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteTeam(int id) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''DELETE FROM team WHERE team_id = $id''';
      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi xóa đội bóng: $e');
      return Left(Exception('Lỗi khi xóa đội bóng: $e'));
    }
  }

  @override
  Future<Either<Exception, List<TeamModel>>> getTeamByName(String name) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''SELECT * FROM team WHERE team_name ILIKE '%$name%' ''';
      final results = await conn.execute(query);
      return Right(results.map((row) => TeamModel.fromRow(row)).toList());
    } catch (e) {
      print('Lỗi khi tìm kiếm đội bóng: $e');
      return Left(Exception('Lỗi khi tìm kiếm đội bóng: $e'));
    }
  }

  @override
  Future<Either<Exception, List<TeamModel>>> getTeams() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final results = await conn.execute(
        'SELECT * FROM team ORDER BY team_name',
      );
      return Right(results.map((row) => TeamModel.fromRow(row)).toList());
    } catch (e) {
      print('Lỗi khi lấy danh sách đội bóng: $e');
      return Left(Exception('Lỗi khi lấy danh sách đội bóng: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateTeam(TeamModel team) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      if (team.id == null) {
        print('Không thể cập nhật đội bóng: ID không được cung cấp');
        return Left(Exception('Không thể cập nhật đội bóng: ID không được cung cấp'));
      }

      final query = '''
      UPDATE team 
      SET 
        team_name = '${team.name}',
        team_code = '${team.code}'
      WHERE team_id = ${team.id}
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi cập nhật đội bóng: $e');
      return Left(Exception('Lỗi khi cập nhật đội bóng: $e'));
    }
  }

  @override
  Future<Either<Exception, TeamModel?>> getTeamById(int teamId) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      // Truy vấn để lấy thông tin đội bóng dựa trên team_id
      final query = '''
      SELECT * 
      FROM team
      WHERE team_id = $teamId
      ''';

      final results = await conn.execute(query);
      
      // Nếu không tìm thấy kết quả, trả về null
      if (results.isEmpty) {
        return const Right(null);
      }
      
      // Chuyển đổi kết quả thành TeamModel
      return Right(TeamModel.fromRow(results.first));
    } catch (e) {
      print('Lỗi khi lấy thông tin đội bóng theo ID: $e');
      return Left(Exception('Lỗi khi lấy thông tin đội bóng theo ID: $e'));
    }
  }
  
  // Giữ lại phương thức getTeamBySeasonTeamId để tránh lỗi ở các file đang sử dụng
  Future<Either<Exception, TeamModel?>> getTeamBySeasonTeamId(int seasonTeamId) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      // Truy vấn để lấy thông tin đội bóng dựa trên season_team_id
      final query = '''
      SELECT t.* 
      FROM team t
      JOIN season_team st ON t.team_id = st.team_id
      WHERE st.season_team_id = $seasonTeamId
      ''';

      final results = await conn.execute(query);
      
      // Nếu không tìm thấy kết quả, trả về null
      if (results.isEmpty) {
        return const Right(null);
      }
      
      // Chuyển đổi kết quả thành TeamModel
      return Right(TeamModel.fromRow(results.first));
    } catch (e) {
      print('Lỗi khi lấy thông tin đội bóng từ season_team_id: $e');
      return Left(Exception('Lỗi khi lấy thông tin đội bóng từ season_team_id: $e'));
    }
  }
}
