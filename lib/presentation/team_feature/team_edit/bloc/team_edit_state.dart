part of 'team_edit_cubit.dart';

enum TeamEditStatus {
  initial,
  loading,
  success,
  failure,
}

class TeamEditState {
  final TeamEditStatus status;
  final String? errorMessage;
  final bool isEditing;

  TeamEditState({
    this.status = TeamEditStatus.initial,
    this.errorMessage,
    this.isEditing = false,
  });

  TeamEditState copyWith({
    TeamEditStatus? status,
    String? errorMessage,
    bool? isEditing,
  }) {
    return TeamEditState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
