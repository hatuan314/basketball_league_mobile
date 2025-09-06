import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';
import 'package:dartz/dartz.dart';

/// Interface cho các use case liên quan đến thông tin cầu thủ theo mùa giải
abstract class PlayerSeasonUsecase {
  /// Tạo thông tin cầu thủ theo mùa giải mới
  /// [playerSeason] là thông tin cầu thủ cần tạo
  /// Trả về ID của thông tin cầu thủ đã được tạo
  Future<Either<Exception, String>> createPlayerSeason(
    PlayerSeasonEntity playerSeason,
  );

  /// Lấy danh sách thông tin cầu thủ theo mùa giải
  /// [seasonTeamId] là ID của đội trong mùa giải (tùy chọn)
  /// [playerId] là ID của cầu thủ (tùy chọn)
  /// Nếu không cung cấp tham số nào, sẽ lấy tất cả thông tin cầu thủ theo mùa giải
  Future<Either<Exception, List<PlayerSeasonEntity>>> getPlayerSeasons({
    int? seasonTeamId,
    int? playerId,
  });

  /// Lấy thông tin chi tiết của một cầu thủ trong mùa giải
  /// [playerSeasonId] là ID của thông tin cầu thủ cần lấy
  /// Trả về thông tin cầu thủ hoặc null nếu không tìm thấy
  Future<Either<Exception, PlayerSeasonEntity?>> getPlayerSeasonById(
    String playerSeasonId,
  );

  /// Cập nhật thông tin cầu thủ trong mùa giải
  /// [playerSeason] là thông tin cầu thủ cần cập nhật
  Future<Either<Exception, Unit>> updatePlayerSeason(
    PlayerSeasonEntity playerSeason,
  );

  /// Xóa thông tin cầu thủ trong mùa giải
  /// [playerSeasonId] là ID của thông tin cầu thủ cần xóa
  Future<Either<Exception, Unit>> deletePlayerSeason(String playerSeasonId);

  /// Tạo tự động danh sách cầu thủ cho một đội trong một mùa giải
  /// [teamId] là ID của đội
  /// [seasonTeamId] là ID của đội trong mùa giải
  /// [seasonId] là ID của mùa giải
  /// Trả về danh sách cầu thủ đã được tạo
  Future<Either<Exception, List<PlayerSeasonEntity>>> generatePlayerSeasons({
    required int teamId,
    required int seasonTeamId,
    required int seasonId,
  });
}
