import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/player_season_api.dart';
import 'package:baseketball_league_mobile/data/models/player_season_model.dart';
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
}
