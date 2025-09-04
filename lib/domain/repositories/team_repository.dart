import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TeamRepository {
  Future<Either<Exception, List<TeamEntity>>> getTeams();
  Future<Either<Exception, bool>> createTeam(TeamEntity team);
  Future<Either<Exception, bool>> generateTeams();
  Future<Either<Exception, bool>> updateTeam(TeamEntity team);
  Future<Either<Exception, bool>> deleteTeam(int id);
  Future<Either<Exception, List<TeamEntity>>> getTeamByName(String name);
}
