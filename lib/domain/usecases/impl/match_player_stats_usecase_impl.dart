import 'package:baseketball_league_mobile/domain/entities/match_player_stats_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_player_stats_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_player_stats_usecase.dart';
import 'package:dartz/dartz.dart';

/// Triển khai UseCase để quản lý thống kê cầu thủ trong trận đấu
class MatchPlayerStatsUseCaseImpl implements MatchPlayerStatsUseCase {
  final MatchPlayerStatsRepository _matchPlayerStatsRepository;
  final MatchRepository _matchRepository;

  MatchPlayerStatsUseCaseImpl({
    required MatchPlayerStatsRepository matchPlayerStatsRepository,
    required MatchRepository matchRepository,
  }) : _matchPlayerStatsRepository = matchPlayerStatsRepository,
       _matchRepository = matchRepository;

  @override
  Future<Either<Exception, MatchPlayerStatsEntity>> addFouls({
    required int matchPlayerStatsId,
    required int fouls,
  }) async {
    try {
      // Kiểm tra số lỗi hợp lệ
      if (fouls < 0) {
        return Left(Exception('Số lỗi không được âm'));
      }

      // Lấy thông tin hiện tại
      final currentStats = await _matchPlayerStatsRepository
          .getMatchPlayerStatsById(matchPlayerStatsId);

      return await currentStats.fold((error) => Left(error), (stats) async {
        if (stats == null) {
          return Left(
            Exception(
              'Không tìm thấy thống kê cầu thủ với ID: $matchPlayerStatsId',
            ),
          );
        }

        // Kiểm tra số lỗi tối đa
        final currentFouls = stats.fouls ?? 0;
        final updatedFouls = currentFouls + fouls;

        if (updatedFouls > 5) {
          return Left(Exception('Số lỗi không được vượt quá 5'));
        }

        return await _matchPlayerStatsRepository.addFouls(
          matchPlayerStatsId: matchPlayerStatsId,
          fouls: fouls,
        );
      });
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
      // Kiểm tra điểm số hợp lệ
      if (points < 0) {
        return Left(Exception('Điểm số không được âm'));
      }

      return await _matchPlayerStatsRepository.addPoints(
        matchPlayerStatsId: matchPlayerStatsId,
        points: points,
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
      return await _matchPlayerStatsRepository.createMatchPlayerStats(stats);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatchPlayerStats(
    int matchPlayerStatsId,
  ) async {
    try {
      return await _matchPlayerStatsRepository.deleteMatchPlayerStats(
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
      return await _matchPlayerStatsRepository.getMatchPlayerStatsById(
        matchPlayerStatsId,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity?>>
  getMatchPlayerStatsByMatchPlayerId(int matchPlayerId) async {
    try {
      return await _matchPlayerStatsRepository
          .getMatchPlayerStatsByMatchPlayerId(matchPlayerId);
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thống kê cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchPlayerStatsEntity>> updateMatchPlayerStats(
    MatchPlayerStatsEntity stats,
  ) async {
    try {
      // Kiểm tra ID
      if (stats.id == null) {
        return Left(Exception('ID thống kê không được trống'));
      }

      return await _matchPlayerStatsRepository.updateMatchPlayerStats(stats);
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật thống kê cầu thủ: $e'));
    }
  }
}
