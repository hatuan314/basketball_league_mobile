import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/team_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'team_list_state.dart';

class TeamListCubit extends Cubit<TeamListState> {
  final TeamUsecase teamUsecase;
  TeamListCubit({required this.teamUsecase})
    : super(TeamListState(status: TeamListStatus.loading));

  Future<void> initial() async {
    emit(TeamListState(status: TeamListStatus.loading));
    final results = await _getTeams();
    emit(TeamListState(status: TeamListStatus.initial, teams: results));
  }

  Future<List<TeamEntity>> _getTeams() async {
    final result = await teamUsecase.getTeams();
    
    return result.fold(
      (exception) {
        emit(
          TeamListState(
            status: TeamListStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
        return [];
      },
      (teams) {
        emit(TeamListState(status: TeamListStatus.initial, teams: teams));
        return teams;
      },
    );
  }

  Future<void> generateTeams() async {
    EasyLoading.show();
    final generateResult = await teamUsecase.generateTeams();
    
    generateResult.fold(
      (exception) {
        EasyLoading.dismiss();
        emit(
          TeamListState(
            status: TeamListStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
      },
      (success) async {
        EasyLoading.dismiss();
        emit(TeamListState(status: TeamListStatus.loading));
        
        final teamsResult = await teamUsecase.getTeams();
        teamsResult.fold(
          (exception) {
            emit(
              TeamListState(
                status: TeamListStatus.failure,
                errorMessage: exception.toString(),
              ),
            );
          },
          (teams) {
            emit(TeamListState(status: TeamListStatus.initial, teams: teams));
          },
        );
      },
    );
  }

  Future<void> deleteTeam(int teamId) async {
    emit(state.copyWith(status: TeamListStatus.loading));
    
    final deleteResult = await teamUsecase.deleteTeam(teamId);
    
    deleteResult.fold(
      (exception) {
        emit(
          state.copyWith(
            status: TeamListStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
      },
      (success) async {
        final teamsResult = await teamUsecase.getTeams();
        teamsResult.fold(
          (exception) {
            emit(
              state.copyWith(
                status: TeamListStatus.failure,
                errorMessage: exception.toString(),
              ),
            );
          },
          (teams) {
            emit(TeamListState(status: TeamListStatus.initial, teams: teams));
          },
        );
      },
    );
  }

  Future<void> addTeam(TeamEntity team) async {
    emit(state.copyWith(status: TeamListStatus.loading));
    
    final createResult = await teamUsecase.createTeam(team);
    
    createResult.fold(
      (exception) {
        emit(
          state.copyWith(
            status: TeamListStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
      },
      (success) async {
        final teamsResult = await teamUsecase.getTeams();
        teamsResult.fold(
          (exception) {
            emit(
              state.copyWith(
                status: TeamListStatus.failure,
                errorMessage: exception.toString(),
              ),
            );
          },
          (teams) {
            emit(TeamListState(status: TeamListStatus.initial, teams: teams));
          },
        );
      },
    );
  }

  Future<void> updateTeam(TeamEntity team) async {
    emit(state.copyWith(status: TeamListStatus.loading));
    
    final updateResult = await teamUsecase.updateTeam(team);
    
    updateResult.fold(
      (exception) {
        emit(
          state.copyWith(
            status: TeamListStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
      },
      (success) async {
        final teamsResult = await teamUsecase.getTeams();
        teamsResult.fold(
          (exception) {
            emit(
              state.copyWith(
                status: TeamListStatus.failure,
                errorMessage: exception.toString(),
              ),
            );
          },
          (teams) {
            emit(TeamListState(status: TeamListStatus.initial, teams: teams));
          },
        );
      },
    );
  }
}
