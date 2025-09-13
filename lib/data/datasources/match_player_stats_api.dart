import 'package:baseketball_league_mobile/data/models/match/match_player_stats_model.dart';
import 'package:dartz/dartz.dart';

/// API để quản lý thống kê cầu thủ trong trận đấu
abstract class MatchPlayerStatsApi {
  /// Lấy thống kê chi tiết của một cầu thủ trong trận đấu
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  Future<Either<Exception, MatchPlayerStatsModel?>> getMatchPlayerStatsById(
    int matchPlayerStatsId,
  );

  /// Lấy thống kê chi tiết của một cầu thủ trong trận đấu
  /// [matchPlayerId] là ID của cầu thủ
  Future<Either<Exception, MatchPlayerStatsModel?>>
  getMatchPlayerStatsByMatchPlayerId(int matchPlayerId);

  /// Tạo mới thống kê cầu thủ trong trận đấu
  Future<Either<Exception, MatchPlayerStatsModel>> createMatchPlayerStats(
    MatchPlayerStatsModel stats,
  );

  /// Cập nhật thống kê cầu thủ trong trận đấu
  Future<Either<Exception, MatchPlayerStatsModel>> updateMatchPlayerStats(
    MatchPlayerStatsModel stats,
  );

  /// Xóa thống kê cầu thủ trong trận đấu
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  Future<Either<Exception, bool>> deleteMatchPlayerStats(
    int matchPlayerStatsId,
  );

  /// Cập nhật điểm số cho cầu thủ
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  /// [points] là số điểm cần thêm vào
  Future<Either<Exception, MatchPlayerStatsModel>> addPoints({
    required int matchPlayerStatsId,
    required int points,
  });

  /// Cập nhật số lỗi cho cầu thủ
  /// [matchPlayerStatsId] là ID của bản ghi thống kê
  /// [fouls] là số lỗi cần thêm vào
  Future<Either<Exception, MatchPlayerStatsModel>> addFouls({
    required int matchPlayerStatsId,
    required int fouls,
  });
}
