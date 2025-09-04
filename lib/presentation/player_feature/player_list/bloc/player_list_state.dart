part of 'player_list_cubit.dart';

enum PlayerListStatus { loading, loaded, error }

class PlayerListState {
  final PlayerListStatus status;
  final String? errorMessage;
  final List<PlayerEntity>? playerList;

  PlayerListState({required this.status, this.errorMessage, this.playerList});

  PlayerListState copyWith({
    PlayerListStatus? status,
    String? errorMessage,
    List<PlayerEntity>? playerList,
  }) {
    return PlayerListState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      playerList: playerList ?? this.playerList,
    );
  }
}
