import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_player_stats_api.dart';
import 'package:baseketball_league_mobile/data/models/match/match_player_stats_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

/// Triển khai API để quản lý thống kê cầu thủ trong trận đấu
class MatchPlayerStatsApiImpl implements MatchPlayerStatsApi {
  MatchPlayerStatsApiImpl();

  @override
  Future<Either<Exception, MatchPlayerStatsModel>> addFouls({
    required int matchPlayerStatsId,
    required int fouls,
  }) async {
    final conn = sl<PostgresConnection>().conn;
    if (!conn.isOpen) {
      await sl<PostgresConnection>().connectDb();
    }
    try {
      // Kiểm tra số lỗi hợp lệ
      if (fouls < 0) {
        return Left(Exception('Số lỗi không được âm'));
      }

      // Lấy thông tin hiện tại
      final currentStats = await getMatchPlayerStatsById(matchPlayerStatsId);
      return await currentStats.fold((error) => Left(error), (stats) async {
        if (stats == null) {
          return Left(
            Exception(
              'Không tìm thấy thống kê cầu thủ với ID: $matchPlayerStatsId',
            ),
          );
        }

        // Cập nhật số lỗi
        final currentFouls = stats.fouls ?? 0;
        final updatedFouls = currentFouls + fouls;

        // Kiểm tra số lỗi tối đa
        if (updatedFouls > 5) {
          return Left(Exception('Số lỗi không được vượt quá 5'));
        }

        // Cập nhật vào database
        final sql = '''
          UPDATE match_player_stats
          SET fouls = @fouls
          WHERE match_player_stats_id = @id
          RETURNING *;
          ''';

        final result = await conn.execute(
          Sql.named(sql),
          parameters: {'id': id, 'fouls': updatedFouls},
        );

        if (result.isNotEmpty) {
          return Right(MatchPlayerStatsModel.fromPostgres(result[0]));
        } else {
          return Left(Exception('Không thể cập nhật số lỗi'));
        }
      });
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật số lỗi: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsModel>> addPoints({
    required int matchPlayerStatsId,
    required int points,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;
      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Kiểm tra điểm số hợp lệ
      if (points < 0) {
        return Left(Exception('Điểm số không được âm'));
      }

      // Lấy thông tin hiện tại
      final currentStats = await getMatchPlayerStatsById(matchPlayerStatsId);
      return await currentStats.fold((error) => Left(error), (stats) async {
        if (stats == null) {
          return Left(
            Exception(
              'Không tìm thấy thống kê cầu thủ với ID: $matchPlayerStatsId',
            ),
          );
        }

        // Cập nhật điểm số
        final currentPoints = stats.points ?? 0;
        final updatedPoints = currentPoints + points;

        // Cập nhật vào database
        final sql = '''
          UPDATE match_player_stats
          SET points = @points
          WHERE match_player_stats_id = @id
          RETURNING *;
          ''';

        final result = await conn.execute(
          Sql.named(sql),
          parameters: {'id': id, 'points': updatedPoints},
        );

        if (result.isNotEmpty) {
          return Right(MatchPlayerStatsModel.fromPostgres(result[0]));
        } else {
          return Left(Exception('Không thể cập nhật điểm số'));
        }
      });
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật điểm số: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsModel>> createMatchPlayerStats(
    MatchPlayerStatsModel stats,
  ) async {
    try {
      final conn = sl<PostgresConnection>().conn;
      if (!conn.isOpen) {
        await sl<PostgresConnection>().connectDb();
      }

      // Tạo bản ghi mới
      final sql = '''
      INSERT INTO match_player_stats (
        match_player_id, points, fouls
      ) VALUES (
        @matchPlayerId, @points, @fouls
      ) RETURNING *;
      ''';

      final result = await conn.execute(
        Sql.named(sql),
        parameters: {
          'matchPlayerId': stats.matchPlayerId,
          'points': stats.points ?? 0,
          'fouls': stats.fouls ?? 0,
        },
      );

      if (result.isNotEmpty) {
        return Right(MatchPlayerStatsModel.fromPostgres(result[0]));
      } else {
        return Left(Exception('Không thể tạo thống kê cầu thủ'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi tạo thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatchPlayerStats(
    int matchPlayerStatsId,
  ) async {
    try {
      final conn = sl<PostgresConnection>().conn;
      if (!conn.isOpen) {
        await sl<PostgresConnection>().connectDb();
      }

      final sql = '''
      DELETE FROM match_player_stats
      WHERE match_player_stats_id = @id;
      ''';

      final result = await conn.execute(Sql.named(sql), parameters: {'id': id});
      return Right(result.affectedRows > 0);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsModel?>> getMatchPlayerStatsById(
    int matchPlayerStatsId,
  ) async {
    try {
      final conn = sl<PostgresConnection>().conn;
      if (!conn.isOpen) {
        await sl<PostgresConnection>().connectDb();
      }

      final sql = '''
      SELECT * FROM match_player_stats
      WHERE match_player_stats_id = @matchPlayerStatsId;
      ''';

      final result = await conn.execute(
        Sql.named(sql),
        parameters: {'matchPlayerStatsId': matchPlayerStatsId},
      );

      if (result.isEmpty) {
        return const Right(null);
      }

      return Right(MatchPlayerStatsModel.fromPostgres(result[0]));
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsModel>> updateMatchPlayerStats(
    MatchPlayerStatsModel stats,
  ) async {
    try {
      final conn = sl<PostgresConnection>().conn;
      if (!conn.isOpen) {
        await sl<PostgresConnection>().connectDb();
      }

      // Kiểm tra ID
      if (stats.id == null) {
        return Left(Exception('ID thống kê không được trống'));
      }

      // Cập nhật vào database
      final sql = '''
      UPDATE match_player_stats
      SET 
        points = @points,
        fouls = @fouls,
      WHERE match_player_stats_id = @id
      RETURNING *;
      ''';

      final result = await conn.execute(
        Sql.named(sql),
        parameters: {
          'id': stats.id,
          'points': stats.points ?? 0,
          'fouls': stats.fouls ?? 0,
        },
      );

      if (result.isNotEmpty) {
        return Right(MatchPlayerStatsModel.fromPostgres(result[0]));
      } else {
        return Left(Exception('Không thể cập nhật thống kê cầu thủ'));
      }
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsModel?>>
  getMatchPlayerStatsByMatchPlayerId(int matchPlayerId) async {
    try {
      final conn = sl<PostgresConnection>().conn;
      if (!conn.isOpen) {
        await sl<PostgresConnection>().connectDb();
      }

      final sql = '''
      SELECT * FROM match_player_stats
      WHERE match_player_id = @matchPlayerId;
      ''';

      final result = await conn.execute(
        Sql.named(sql),
        parameters: {'matchPlayerId': matchPlayerId},
      );

      if (result.isEmpty) {
        return const Right(null);
      }

      return Right(MatchPlayerStatsModel.fromPostgres(result[0]));
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thống kê cầu thủ: $e'));
    }
  }
}
