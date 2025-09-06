import 'package:baseketball_league_mobile/data/models/player_season_model.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức API để quản lý thông tin cầu thủ theo mùa giải
abstract class PlayerSeasonApi {
  /// Tạo mới thông tin cầu thủ trong mùa giải
  ///
  /// [playerSeasonEntity]: Thông tin cầu thủ theo mùa giải cần tạo
  ///
  /// Trả về ID của bản ghi vừa tạo nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, String>> createPlayerSeason(
    PlayerSeasonModel playerSeasonEntity,
  );

  /// Lấy danh sách thông tin cầu thủ theo mùa giải
  ///
  /// [seasonTeamId]: ID của đội trong mùa giải (tùy chọn)
  /// [playerId]: ID của cầu thủ (tùy chọn)
  ///
  /// Trả về danh sách thông tin cầu thủ theo mùa giải nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<PlayerSeasonModel>>> getPlayerSeasons({
    int? seasonTeamId,
    int? playerId,
  });

  /// Lấy thông tin chi tiết của một cầu thủ trong mùa giải
  ///
  /// [playerSeasonId]: ID của bản ghi cầu thủ theo mùa giải
  ///
  /// Trả về thông tin chi tiết của cầu thủ trong mùa giải nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, PlayerSeasonModel?>> getPlayerSeasonById(
    String playerSeasonId,
  );

  /// Cập nhật thông tin cầu thủ trong mùa giải
  ///
  /// [playerSeasonEntity]: Thông tin cầu thủ theo mùa giải cần cập nhật
  ///
  /// Trả về Unit nếu cập nhật thành công hoặc Exception nếu thất bại
  Future<Either<Exception, Unit>> updatePlayerSeason(
    PlayerSeasonModel playerSeasonEntity,
  );

  /// Xóa thông tin cầu thủ trong mùa giải
  ///
  /// [playerSeasonId]: ID của bản ghi cầu thủ theo mùa giải cần xóa
  ///
  /// Trả về Unit nếu xóa thành công hoặc Exception nếu thất bại
  Future<Either<Exception, Unit>> deletePlayerSeason(String playerSeasonId);
}
