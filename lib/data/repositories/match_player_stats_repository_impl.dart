import 'package:baseketball_league_mobile/data/datasources/match_player_stats_api.dart';
import 'package:baseketball_league_mobile/data/models/match_player_stats_model.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_stats_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_player_stats_repository.dart';
import 'package:dartz/dartz.dart';

/// Triển khai repository để quản lý thống kê cầu thủ trong trận đấu
class MatchPlayerStatsRepositoryImpl implements MatchPlayerStatsRepository {
  final MatchPlayerStatsApi _matchPlayerStatsApi;

  MatchPlayerStatsRepositoryImpl({
    required MatchPlayerStatsApi matchPlayerStatsApi,
  }) : _matchPlayerStatsApi = matchPlayerStatsApi;

  @override
  Future<Either<Exception, MatchPlayerStatsEntity>> addFouls({
    required int matchPlayerStatsId,
    required int fouls,
  }) async {
    try {
      final result = await _matchPlayerStatsApi.addFouls(
        matchPlayerStatsId: matchPlayerStatsId,
        fouls: fouls,
      );
      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật số lỗi: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity>> addPoints({
    required int matchPlayerStatsId,
    required int points,
  }) async {
    try {
      final result = await _matchPlayerStatsApi.addPoints(
        matchPlayerStatsId: matchPlayerStatsId,
        points: points,
      );
      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật điểm số: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity>> createMatchPlayerStats(
    MatchPlayerStatsEntity stats,
  ) async {
    try {
      final model = MatchPlayerStatsModel.fromEntity(stats);

      final result = await _matchPlayerStatsApi.createMatchPlayerStats(model);
      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tạo thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatchPlayerStats(
    int matchPlayerStatsId,
  ) async {
    try {
      return await _matchPlayerStatsApi.deleteMatchPlayerStats(
        matchPlayerStatsId,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi xóa thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity?>> getMatchPlayerStatsById(
    int matchPlayerStatsId,
  ) async {
    try {
      final result = await _matchPlayerStatsApi.getMatchPlayerStatsById(
        matchPlayerStatsId,
      );
      return result.fold(
        (error) => Left(error),
        (model) => Right(model?.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity>> updateMatchPlayerStats(
    MatchPlayerStatsEntity stats,
  ) async {
    try {
      final model = MatchPlayerStatsModel.fromEntity(stats);

      final result = await _matchPlayerStatsApi.updateMatchPlayerStats(model);
      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity?>>
  getMatchPlayerStatsByMatchPlayerId(int matchPlayerId) async {
    try {
      final result = await _matchPlayerStatsApi
          .getMatchPlayerStatsByMatchPlayerId(matchPlayerId);
      return result.fold(
        (error) => Left(error),
        (model) => Right(model?.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thống kê cầu thủ: $e'));
    }
  }
}
