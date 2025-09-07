import 'package:baseketball_league_mobile/data/models/season_team_model.dart';
import 'package:baseketball_league_mobile/data/models/team_standing_model.dart';
import 'package:dartz/dartz.dart';

abstract class SeasonTeamApi {
  /// Tạo một mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, SeasonTeamModel>> createSeasonTeam(
    SeasonTeamModel seasonTeam,
  );

  /// Cập nhật một mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, SeasonTeamModel>> updateSeasonTeam(
    SeasonTeamModel seasonTeam,
  );

  /// Xóa một mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, Unit>> deleteSeasonTeam(SeasonTeamModel seasonTeam);

  /// Lấy danh sách mối quan hệ giữa giải đấu và đội bóng
  Future<Either<Exception, List<SeasonTeamModel>>> getSeasonTeams();

  /// Tìm kiếm đội bóng theo tên và trả về bảng xếp hạng của các đội bóng đó
  Future<Either<Exception, List<TeamStandingModel>>> searchSeasonTeamByName(
    String name,
  );

  /// Lấy bảng xếp hạng đội bóng trong một mùa giải
  /// [seasonId] là ID của mùa giải cần lấy bảng xếp hạng
  /// Nếu [seasonId] là null, sẽ lấy bảng xếp hạng của tất cả các mùa giải
  Future<Either<Exception, List<TeamStandingModel>>> getTeamStandings({
    int? seasonId,
    int? teamId,
  });

  /// Lấy thông tin đội bóng trong một mùa giải dựa trên season_id và team_id
  ///
  /// [seasonId]: ID của mùa giải
  /// [teamId]: ID của đội bóng
  ///
  /// Trả về thông tin đội bóng trong mùa giải nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, SeasonTeamModel?>> getSeasonTeamBySeasonAndTeam({
    required int seasonId,
    required int teamId,
  });
}
