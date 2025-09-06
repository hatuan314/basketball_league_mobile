import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository interface cho quản lý mối quan hệ giữa giải đấu và đội bóng
abstract class SeasonTeamRepository {
  /// Tạo một mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, SeasonTeamEntity>> createSeasonTeam(
    SeasonTeamEntity seasonTeam,
  );

  /// Cập nhật một mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, SeasonTeamEntity>> updateSeasonTeam(
    SeasonTeamEntity seasonTeam,
  );

  /// Xóa một mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, Unit>> deleteSeasonTeam(SeasonTeamEntity seasonTeam);

  /// Lấy danh sách mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, List<SeasonTeamEntity>>> getSeasonTeams();

  /// Tìm kiếm đội bóng theo tên và trả về bảng xếp hạng của các đội bóng đó
  Future<Either<Exception, List<TeamStandingEntity>>> searchSeasonTeamByName(
    String name,
  );

  /// Lấy bảng xếp hạng đội bóng trong một mùa giải
  /// [seasonId] là ID của mùa giải cần lấy bảng xếp hạng
  /// Nếu [seasonId] là null, sẽ lấy bảng xếp hạng của tất cả các mùa giải
  Future<Either<Exception, List<TeamStandingEntity>>> getTeamStandings({
    int? seasonId,
  });

  /// Tạo nhiều mối quan hệ giữa giải đấu và đội bóng cùng lúc
  /// [seasonId] là ID của mùa giải
  /// [teamIds] là danh sách ID của các đội bóng
  /// [stadiumIds] là danh sách ID của các sân vận động (sân nhà của các đội bóng)
  /// Nếu [stadiumIds] không được cung cấp hoặc có ít phần tử hơn [teamIds],
  /// sẽ sử dụng stadiumId đầu tiên cho các đội bóng còn lại
  /// Trả về danh sách các mối quan hệ đã được tạo thành công
  Future<Either<Exception, List<SeasonTeamEntity>>> createBulkSeasonTeams({
    required int seasonId,
  });
}
