import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_player_api.dart';
import 'package:baseketball_league_mobile/data/models/match_player_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match_player_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

/// Triển khai các phương thức API để quản lý thông tin cầu thủ trong trận đấu
class MatchPlayerApiImpl implements MatchPlayerApi {
  /// Constructor
  MatchPlayerApiImpl();

  @override
  Future<Either<Exception, int>> createMatchPlayer(
    MatchPlayerModel matchPlayerModel,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Kiểm tra dữ liệu đầu vào
      if (matchPlayerModel.matchId == null ||
          matchPlayerModel.playerSeasonId == null) {
        return Left(
          Exception('match_id và player_season_id không được để trống'),
        );
      }

      // Thực hiện truy vấn SQL để thêm mới thông tin cầu thủ trong trận đấu
      final sql = '''
      INSERT INTO match_player (match_id, player_id) 
      VALUES (@matchId, @playerId) 
      RETURNING match_player_id
      ''';

      final params = {
        'matchId': matchPlayerModel.matchId,
        'playerId': matchPlayerModel.playerSeasonId,
      };

      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Trả về ID của bản ghi vừa tạo
      if (result.isNotEmpty) {
        return Right(result[0][0] as int);
      } else {
        return Left(
          Exception('Không thể tạo thông tin cầu thủ trong trận đấu'),
        );
      }
    } catch (e) {
      print('Lỗi khi tạo thông tin cầu thủ trong trận đấu: $e');
      return Left(
        Exception('Lỗi khi tạo thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchPlayerModel>>> getMatchPlayers({
    int? matchId,
    int? seasonPlayerId,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Xây dựng câu truy vấn SQL dựa trên các tham số đầu vào
      String sql = '''
      SELECT match_player_id, match_id, player_id 
      FROM match_player 
      WHERE 1=1
      ''';

      final params = <String, dynamic>{};

      // Thêm điều kiện lọc theo match_id nếu được cung cấp
      if (matchId != null) {
        sql += ' AND match_id = @matchId';
        params['matchId'] = matchId;
      }

      // Thêm điều kiện lọc theo season_player_id nếu được cung cấp
      if (seasonPlayerId != null) {
        sql += ' AND season_player_id = @seasonPlayerId';
        params['seasonPlayerId'] = seasonPlayerId;
      }

      // Thực hiện truy vấn SQL
      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Chuyển đổi kết quả truy vấn thành danh sách MatchPlayerModel
      final List<MatchPlayerModel> matchPlayers = [];
      for (final row in result) {
        matchPlayers.add(MatchPlayerModel.fromPostgres(row));
      }

      return Right(matchPlayers);
    } catch (e) {
      print('Lỗi khi lấy danh sách cầu thủ trong trận đấu: $e');
      return Left(
        Exception('Lỗi khi lấy danh sách cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, MatchPlayerModel?>> getMatchPlayerById(
    int matchPlayerId,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Thực hiện truy vấn SQL để lấy thông tin chi tiết của một cầu thủ trong trận đấu
      final sql = '''
      SELECT match_player_id, match_id, player_id 
      FROM match_player 
      WHERE match_player_id = @matchPlayerId
      ''';

      final params = {'matchPlayerId': matchPlayerId};
      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Trả về thông tin chi tiết của cầu thủ trong trận đấu nếu tìm thấy
      if (result.isNotEmpty) {
        return Right(MatchPlayerModel.fromPostgres(result[0]));
      } else {
        return const Right(null);
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin chi tiết của cầu thủ trong trận đấu: $e');
      return Left(
        Exception(
          'Lỗi khi lấy thông tin chi tiết của cầu thủ trong trận đấu: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> updateMatchPlayer(
    MatchPlayerModel matchPlayerModel,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Kiểm tra dữ liệu đầu vào
      if (matchPlayerModel.id == null) {
        return Left(Exception('match_player_id không được để trống'));
      }

      // Xây dựng câu truy vấn SQL để cập nhật thông tin cầu thủ trong trận đấu
      final List<String> updateFields = [];
      final params = <String, dynamic>{'matchPlayerId': matchPlayerModel.id};

      if (matchPlayerModel.matchId != null) {
        updateFields.add('match_id = @matchId');
        params['matchId'] = matchPlayerModel.matchId;
      }

      if (matchPlayerModel.playerSeasonId != null) {
        updateFields.add('player_id = @playerId');
        params['playerId'] = matchPlayerModel.playerSeasonId;
      }

      // Nếu không có trường nào cần cập nhật, trả về thành công
      if (updateFields.isEmpty) {
        return const Right(unit);
      }

      // Hoàn thiện câu truy vấn SQL
      final sql = '''
      UPDATE match_player 
      SET ${updateFields.join(', ')} 
      WHERE match_player_id = @matchPlayerId
      ''';

      // Thực hiện truy vấn SQL
      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Kiểm tra kết quả cập nhật
      if (result.affectedRows == 0) {
        return Left(
          Exception(
            'Không tìm thấy thông tin cầu thủ trong trận đấu để cập nhật',
          ),
        );
      }

      return const Right(unit);
    } catch (e) {
      print('Lỗi khi cập nhật thông tin cầu thủ trong trận đấu: $e');
      return Left(
        Exception('Lỗi khi cập nhật thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteMatchPlayer(int matchPlayerId) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Thực hiện truy vấn SQL để xóa thông tin cầu thủ trong trận đấu
      final sql = '''
      DELETE FROM match_player 
      WHERE match_player_id = @matchPlayerId
      ''';

      final params = {'matchPlayerId': matchPlayerId};
      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Kiểm tra kết quả xóa
      if (result.affectedRows == 0) {
        return Left(
          Exception('Không tìm thấy thông tin cầu thủ trong trận đấu để xóa'),
        );
      }

      return const Right(unit);
    } catch (e) {
      print('Lỗi khi xóa thông tin cầu thủ trong trận đấu: $e');
      return Left(
        Exception('Lỗi khi xóa thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchPlayerModel>>> getTeamPlayersInMatch(
    int matchId,
    int teamId,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Xây dựng câu truy vấn SQL để lấy danh sách cầu thủ của một đội trong trận đấu
      // Cần join với bảng player_season để lấy thông tin cầu thủ theo đội
      final sql = '''
      SELECT mp.match_player_id, mp.match_id, mp.player_id, mp.fouls, mp.points
      FROM match_player mp
      JOIN player_season ps ON mp.player_id = ps.player_season_id
      WHERE mp.match_id = @matchId AND ps.season_team_id = @teamId
      ''';

      final params = {'matchId': matchId, 'teamId': teamId};

      // Thực hiện truy vấn SQL
      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Chuyển đổi kết quả truy vấn thành danh sách MatchPlayerModel
      final List<MatchPlayerModel> matchPlayers = [];
      for (final row in result) {
        matchPlayers.add(MatchPlayerModel.fromPostgres(row));
      }

      return Right(matchPlayers);
    } catch (e) {
      print('Lỗi khi lấy danh sách cầu thủ của đội trong trận đấu: $e');
      return Left(
        Exception('Lỗi khi lấy danh sách cầu thủ của đội trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchPlayerDetailModel>>>
  getTeamPlayersDetailInMatch(int matchId, int teamId) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }
      // Xây dựng câu truy vấn SQL để lấy danh sách cầu thủ của một đội trong trận đấu
      // Cần join với bảng team để lấy thông tin đội bóng
      // Cần join với bảng season_team để lấy thông tin đội bóng trong mùa giải
      final sql = '''
      SELECT * FROM match_player_details mpd
         JOIN team t ON mpd.team_id = t.team_id
         JOIN season_team st ON t.team_id = st.team_id
         WHERE match_id = @matchId and st.season_team_id = @teamId;
      ''';

      final params = {'matchId': matchId, 'teamId': teamId};

      // Thực hiện truy vấn SQL
      final result = await conn.execute(Sql.named(sql), parameters: params);

      // Chuyển đổi kết quả truy vấn thành danh sách MatchPlayerModel
      final List<MatchPlayerDetailModel> matchPlayers = [];
      for (final row in result) {
        matchPlayers.add(MatchPlayerDetailModel.fromPostgres(row));
      }

      return Right(matchPlayers);
    } catch (e) {
      print('Lỗi khi lấy danh sách cầu thủ của đội trong trận đấu: $e');
      return Left(
        Exception('Lỗi khi lấy danh sách cầu thủ của đội trong trận đấu: $e'),
      );
    }
  }
}
