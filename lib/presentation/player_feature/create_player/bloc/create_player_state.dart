import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:equatable/equatable.dart';

enum CreatePlayerStatus { initial, loading, success, failure }

class CreatePlayerState extends Equatable {
  final CreatePlayerStatus status;
  final PlayerEntity player;
  final String? errorMessage;

  CreatePlayerState({
    this.status = CreatePlayerStatus.initial,
    PlayerEntity? player,
    this.errorMessage,
  }) : player = player ?? PlayerEntity();

  CreatePlayerState copyWith({
    CreatePlayerStatus? status,
    PlayerEntity? player,
    String? errorMessage,
  }) {
    return CreatePlayerState(
      status: status ?? this.status,
      player: player ?? this.player,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, player, errorMessage];
}
