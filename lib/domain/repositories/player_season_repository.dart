import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức repository để quản lý thông tin cầu thủ theo mùa giải
abstract class PlayerSeasonRepository {
  /// Tạo mới thông tin cầu thủ trong mùa giải
  ///
  /// [playerSeasonEntity]: Thông tin cầu thủ theo mùa giải cần tạo
  ///
  /// Trả về ID của bản ghi vừa tạo nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, String>> createPlayerSeason(
    PlayerSeasonEntity playerSeasonEntity,
  );

  /// Lấy danh sách thông tin cầu thủ theo mùa giải
  ///
  /// [seasonTeamId]: ID của đội trong mùa giải (tùy chọn)
  /// [playerId]: ID của cầu thủ (tùy chọn)
  ///
  /// Trả về danh sách thông tin cầu thủ theo mùa giải nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<PlayerSeasonEntity>>> getPlayerSeasons({
    int? seasonTeamId,
    int? playerId,
  });

  /// Lấy thông tin chi tiết của một cầu thủ trong mùa giải
  ///
  /// [playerSeasonId]: ID của bản ghi cầu thủ theo mùa giải
  ///
  /// Trả về thông tin chi tiết của cầu thủ trong mùa giải nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, PlayerSeasonEntity?>> getPlayerSeasonById(
    String playerSeasonId,
  );

  /// Cập nhật thông tin cầu thủ trong mùa giải
  ///
  /// [playerSeasonEntity]: Thông tin cầu thủ theo mùa giải cần cập nhật
  ///
  /// Trả về Unit nếu cập nhật thành công hoặc Exception nếu thất bại
  Future<Either<Exception, Unit>> updatePlayerSeason(
    PlayerSeasonEntity playerSeasonEntity,
  );

  /// Xóa thông tin cầu thủ trong mùa giải
  ///
  /// [playerSeasonId]: ID của bản ghi cầu thủ theo mùa giải cần xóa
  ///
  /// Trả về Unit nếu xóa thành công hoặc Exception nếu thất bại
  Future<Either<Exception, Unit>> deletePlayerSeason(String playerSeasonId);

  /// Tạo tự động danh sách cầu thủ cho một đội trong một mùa giải
  ///
  /// [teamId]: ID của đội
  /// [seasonId]: ID của mùa giải
  ///
  /// Trả về danh sách cầu thủ đã được tạo nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<PlayerSeasonEntity>>> generatePlayerSeasons({
    required int teamId,
    required int seasonId,
    required int seasonTeamId,
  });
}
