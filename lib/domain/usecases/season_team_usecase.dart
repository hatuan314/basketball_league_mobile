import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:dartz/dartz.dart';

/// Interface cho các use case liên quan đến mối quan hệ giữa giải đấu và đội bóng
abstract class SeasonTeamUseCase {
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
  Future<Either<Exception, List<TeamStandingEntity>>> searchTeamStandingByName(
    String name,
  );
  
  /// Lấy bảng xếp hạng đội bóng trong một mùa giải
  /// [seasonId] là ID của mùa giải cần lấy bảng xếp hạng
  /// Nếu [seasonId] là null, sẽ lấy bảng xếp hạng của tất cả các mùa giải
  Future<Either<Exception, List<TeamStandingEntity>>> getTeamStandings({
    int? seasonId,
  });
  
  /// Tạo hàng loạt mối quan hệ giữa giải đấu và đội bóng
  /// Tự động chọn ngẫu nhiên ít nhất 8 đội bóng và sân vận động từ cơ sở dữ liệu
  /// [seasonId] là ID của mùa giải cần tạo mối quan hệ
  /// Trả về danh sách các mối quan hệ đã được tạo thành công
  Future<Either<Exception, List<SeasonTeamEntity>>> createBulkSeasonTeams({
    required int seasonId,
  });
  
  /// Lấy thông tin đội bóng trong một mùa giải dựa trên season_id và team_id
  /// 
  /// [seasonId]: ID của mùa giải
  /// [teamId]: ID của đội bóng
  /// 
  /// Trả về thông tin đội bóng trong mùa giải nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, SeasonTeamEntity?>> getSeasonTeamBySeasonAndTeam({
    required int seasonId,
    required int teamId,
  });
}
