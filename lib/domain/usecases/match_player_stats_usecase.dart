import 'package:baseketball_league_mobile/domain/match/match_player_stats_entity.dart';
import 'package:dartz/dartz.dart';

/// UseCase để quản lý thống kê cầu thủ trong trận đấu
abstract class MatchPlayerStatsUseCase {
  /// Lấy thống kê chi tiết của một cầu thủ trong trận đấu
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  Future<Either<Exception, MatchPlayerStatsEntity?>> getMatchPlayerStatsById(
    int matchPlayerStatsId,
  );

  /// Lấy thống kê chi tiết của một cầu thủ trong trận đấu
  /// [matchPlayerId] là ID của cầu thủ
  Future<Either<Exception, MatchPlayerStatsEntity?>>
  getMatchPlayerStatsByMatchPlayerId(int matchPlayerId);

  /// Tạo mới thống kê cầu thủ trong trận đấu
  Future<Either<Exception, MatchPlayerStatsEntity>> createMatchPlayerStats(
    MatchPlayerStatsEntity stats,
  );

  /// Cập nhật thống kê cầu thủ trong trận đấu
  Future<Either<Exception, MatchPlayerStatsEntity>> updateMatchPlayerStats(
    MatchPlayerStatsEntity stats,
  );

  /// Xóa thống kê cầu thủ trong trận đấu
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  Future<Either<Exception, bool>> deleteMatchPlayerStats(
    int matchPlayerStatsId,
  );

  /// Cập nhật điểm số cho cầu thủ
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  /// [points] là số điểm cần thêm vào
  Future<Either<Exception, MatchPlayerStatsEntity>> addPoints({
    required int matchPlayerStatsId,
    required int points,
  });

  /// Cập nhật số lỗi cho cầu thủ
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  /// [fouls] là số lỗi cần thêm vào
  Future<Either<Exception, MatchPlayerStatsEntity>> addFouls({
    required int matchPlayerStatsId,
    required int fouls,
  });
}
