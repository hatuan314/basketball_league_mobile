import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/player_season_api.dart';
import 'package:baseketball_league_mobile/data/models/player_season_model.dart';
import 'package:baseketball_league_mobile/data/models/player_detail_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

/// Triển khai các phương thức API để quản lý thông tin cầu thủ theo mùa giải
class PlayerSeasonApiImpl implements PlayerSeasonApi {
  PlayerSeasonApiImpl();

  @override
  Future<Either<Exception, String>> createPlayerSeason(
    PlayerSeasonModel playerSeason,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      final query = '''
        INSERT INTO player_season (
          player_season_id, 
          season_team_id, 
          player_id, 
          shirt_number
        ) VALUES (
          @playerSeasonId, 
          @seasonTeamId, 
          @playerId, 
          @shirtNumber
        ) RETURNING player_season_id
      ''';

      final params = {
        'playerSeasonId': playerSeason.id,
        'seasonTeamId': playerSeason.seasonTeamId,
        'playerId': playerSeason.playerId,
        'shirtNumber': playerSeason.shirtNumber,
      };

      final result = await conn.execute(Sql.named(query), parameters: params);

      if (result.isNotEmpty) {
        return Right(result.first[0] as String);
      }

      return Left(Exception('Không thể tạo thông tin cầu thủ theo mùa giải'));
    } catch (e) {
      return Left(Exception('Lỗi khi tạo thông tin cầu thủ theo mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PlayerSeasonModel>>> getPlayerSeasons({
    int? seasonTeamId,
    int? playerId,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      String query = '''
        SELECT 
          player_season_id, 
          season_team_id, 
          player_id, 
          shirt_number
        FROM player_season
        WHERE 1=1
      ''';

      // Chỉ sử dụng parameters khi có tham số được truyền vào
      Map<String, dynamic>? params;

      if (seasonTeamId != null || playerId != null) {
        params = {};

        if (seasonTeamId != null) {
          query += ' AND season_team_id = @seasonTeamId';
          params['seasonTeamId'] = seasonTeamId;
        }

        if (playerId != null) {
          query += ' AND player_id = @playerId';
          params['playerId'] = playerId;
        }
      }

      final result = await conn.execute(Sql.named(query), parameters: params);

      final models =
          result
              .map(
                (row) => PlayerSeasonModel(
                  id: row[0] as String,
                  seasonTeamId: row[1] as int,
                  playerId: row[2] as int,
                  shirtNumber: row[3] as int,
                ),
              )
              .toList();

      return Right(models);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách thông tin cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, PlayerSeasonModel?>> getPlayerSeasonById(
    String playerSeasonId,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      final query = '''
        SELECT 
          player_season_id, 
          season_team_id, 
          player_id, 
          shirt_number
        FROM player_season
        WHERE player_season_id = @playerSeasonId
      ''';

      final params = {'playerSeasonId': playerSeasonId};

      final result = await conn.execute(Sql.named(query), parameters: params);

      if (result.isEmpty) {
        return const Right(null);
      }

      final row = result.first;

      final model = PlayerSeasonModel(
        id: row[0] as String,
        seasonTeamId: row[1] as int,
        playerId: row[2] as int,
        shirtNumber: row[3] as int,
      );

      return Right(model);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy thông tin chi tiết cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> updatePlayerSeason(
    PlayerSeasonModel playerSeason,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      final query = '''
        UPDATE player_season
        SET 
          season_team_id = @seasonTeamId,
          player_id = @playerId,
          shirt_number = @shirtNumber
        WHERE player_season_id = @playerSeasonId
      ''';

      final params = {
        'playerSeasonId': playerSeason.id,
        'seasonTeamId': playerSeason.seasonTeamId,
        'playerId': playerSeason.playerId,
        'shirtNumber': playerSeason.shirtNumber,
      };

      final result = await conn.execute(Sql.named(query), parameters: params);

      if (result.affectedRows > 0) {
        return const Right(unit);
      }

      return Left(Exception('Không tìm thấy bản ghi cần cập nhật'));
    } catch (e) {
      return Left(
        Exception('Lỗi khi cập nhật thông tin cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deletePlayerSeason(
    String playerSeasonId,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      final query = '''
        DELETE FROM player_season
        WHERE player_season_id = @playerSeasonId
      ''';

      final params = {'playerSeasonId': playerSeasonId};

      final result = await conn.execute(Sql.named(query), parameters: params);

      if (result.affectedRows > 0) {
        return const Right(unit);
      }

      return Left(Exception('Không tìm thấy bản ghi cần xóa'));
    } catch (e) {
      return Left(Exception('Lỗi khi xóa thông tin cầu thủ theo mùa giải: $e'));
    }
  }
  
  @override
  Future<Either<Exception, List<PlayerDetailModel>>> getPlayerDetailsBySeasonIdAndTeamId(
    int seasonId, {
    int? teamId,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;
      
      // Xây dựng câu truy vấn SQL với tham số
      String query = '''
      SELECT 
          p.player_id,
          p.player_code,
          p.full_name,
          p.dob,
          p.height_cm,
          p.weight_kg,
          t.team_id,
          t.team_name,
          t.team_code,
          ps.shirt_number,
          s.season_id,
          s.name AS season_name
      FROM 
          player p
      JOIN 
          player_season ps ON p.player_id = ps.player_id
      JOIN 
          season_team st ON ps.season_team_id = st.season_team_id
      JOIN 
          team t ON st.team_id = t.team_id
      JOIN 
          season s ON st.season_id = s.season_id
      WHERE 
          s.season_id = @seasonId
      ''';

      // Tham số cho truy vấn
      Map<String, dynamic> params = {'seasonId': seasonId};
      
      // Thêm điều kiện lọc theo đội bóng nếu có
      if (teamId != null) {
        query += ''' AND t.team_id = @teamId''';
        params['teamId'] = teamId;
      }
      
      // Thêm sắp xếp theo đội và số áo
      query += ''' ORDER BY t.team_name, ps.shirt_number''';
      
      // Thực thi truy vấn
      final results = await conn.execute(Sql.named(query), parameters: params);
      
      // Chuyển đổi kết quả thành danh sách PlayerDetailModel
      return Right(
        results.map((row) => PlayerDetailModel.fromPostgres(row)).toList(),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách chi tiết cầu thủ: $e'));
    }
  }
}
