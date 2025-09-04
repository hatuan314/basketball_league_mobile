import 'package:baseketball_league_mobile/data/models/team_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeamApi {
  Future<Either<Exception, List<TeamModel>>> getTeams();
  Future<Either<Exception, bool>> createTeam(TeamModel team);
  Future<Either<Exception, bool>> updateTeam(TeamModel team);
  Future<Either<Exception, bool>> deleteTeam(int id);
  Future<Either<Exception, List<TeamModel>>> getTeamByName(String name);
}
