import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/team_usecase.dart';
import 'package:dartz/dartz.dart';

class TeamUsecaseImpl implements TeamUsecase {
  final TeamRepository teamRepository;

  TeamUsecaseImpl({required this.teamRepository});

  @override
  Future<Either<Exception, List<TeamEntity>>> getTeams() {
    return teamRepository.getTeams();
  }

  @override
  Future<Either<Exception, bool>> createTeam(TeamEntity team) {
    return teamRepository.createTeam(team);
  }

  @override
  Future<Either<Exception, bool>> generateTeams() {
    return teamRepository.generateTeams();
  }

  @override
  Future<Either<Exception, bool>> updateTeam(TeamEntity team) {
    return teamRepository.updateTeam(team);
  }

  @override
  Future<Either<Exception, bool>> deleteTeam(int id) {
    return teamRepository.deleteTeam(id);
  }

  @override
  Future<Either<Exception, List<TeamEntity>>> getTeamByName(String name) {
    return teamRepository.getTeamByName(name);
  }
}
