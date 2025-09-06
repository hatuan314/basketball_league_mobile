import 'package:baseketball_league_mobile/data/models/team_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeamApi {
  Future<Either<Exception, List<TeamModel>>> getTeams();
  Future<Either<Exception, bool>> createTeam(TeamModel team);
  Future<Either<Exception, bool>> updateTeam(TeamModel team);
  Future<Either<Exception, bool>> deleteTeam(int id);
  Future<Either<Exception, List<TeamModel>>> getTeamByName(String name);
  
  /// Lấy thông tin đội bóng dựa trên ID của đội
  ///
  /// [teamId]: ID của đội bóng
  ///
  /// Trả về thông tin đội bóng nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, TeamModel?>> getTeamById(int teamId);
  
  /// Lấy thông tin đội bóng dựa trên ID của đội trong mùa giải
  ///
  /// [seasonTeamId]: ID của đội trong mùa giải
  ///
  /// Trả về thông tin đội bóng nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, TeamModel?>> getTeamBySeasonTeamId(int seasonTeamId);
}
