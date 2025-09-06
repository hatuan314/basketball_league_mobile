import 'package:baseketball_league_mobile/data/models/team_color_model.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức quản lý áo đấu theo đội và mùa giải
abstract class TeamColorApi {
  /// Tạo áo đấu mới cho đội trong mùa giải
  ///
  /// Trả về [TeamColorModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, TeamColorModel>> createTeamColor(
    TeamColorModel teamColor,
  );

  /// Lấy danh sách áo đấu theo mùa giải và đội
  ///
  /// [seasonId] ID của mùa giải
  /// [teamId] ID của đội bóng (có thể null để lấy tất cả áo đấu của mùa giải)
  ///
  /// Trả về danh sách [TeamColorModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<TeamColorModel>>> getTeamColors({
    required int seasonId,
    int? teamId,
  });

  /// Cập nhật thông tin áo đấu
  ///
  /// Trả về [TeamColorModel] đã cập nhật nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, TeamColorModel>> updateTeamColor(
    TeamColorModel teamColor,
  );

  /// Xóa áo đấu theo ID
  ///
  /// Trả về [Unit] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, Unit>> deleteTeamColor(int seasonTeamId);
}
