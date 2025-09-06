import 'package:baseketball_league_mobile/domain/entities/team_color_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository định nghĩa các phương thức quản lý áo đấu theo đội và mùa giải
abstract class TeamColorRepository {
  /// Tạo áo đấu mới cho đội trong mùa giải
  /// 
  /// Trả về [TeamColorEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, TeamColorEntity>> createTeamColor(TeamColorEntity teamColor);

  /// Lấy danh sách áo đấu theo mùa giải và đội
  /// 
  /// [seasonId] ID của mùa giải
  /// [teamId] ID của đội bóng (có thể null để lấy tất cả áo đấu của mùa giải)
  /// 
  /// Trả về danh sách [TeamColorEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<TeamColorEntity>>> getTeamColors({
    required int seasonId,
    int? teamId,
  });

  /// Cập nhật thông tin áo đấu
  /// 
  /// Trả về [TeamColorEntity] đã cập nhật nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, TeamColorEntity>> updateTeamColor(TeamColorEntity teamColor);

  /// Xóa áo đấu theo ID
  /// 
  /// Trả về [Unit] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, Unit>> deleteTeamColor(int seasonTeamId);
  
  /// Tự động tạo áo đấu cho các đội trong một mùa giải
  /// 
  /// [seasonId] ID của mùa giải
  /// [teamIds] Danh sách ID của các đội bóng
  /// [colorsPerTeam] Số lượng mẫu áo đấu cho mỗi đội (mặc định là 3)
  /// 
  /// Đảm bảo mỗi đội có tối thiểu 3 mẫu áo đấu khác nhau
  /// Trả về danh sách [TeamColorEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<TeamColorEntity>>> generateUniqueTeamColors({
    required int seasonId,
    required List<int> teamIds,
    int colorsPerTeam = 3,
  });
}
