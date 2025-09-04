part of 'team_list_cubit.dart';

enum TeamListStatus { initial, loading, failure }

class TeamListState {
  final TeamListStatus status;
  final String? errorMessage;
  final List<TeamEntity> teams;

  TeamListState({
    required this.status,
    this.errorMessage,
    this.teams = const [],
  });

  TeamListState copyWith({
    TeamListStatus? status,
    String? errorMessage,
    List<TeamEntity>? teams,
  }) {
    return TeamListState(
      status: status ?? this.status,
      errorMessage: this.errorMessage,
      teams: teams ?? this.teams,
    );
  }
}
