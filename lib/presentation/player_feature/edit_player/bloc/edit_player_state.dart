import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:equatable/equatable.dart';

enum EditPlayerStatus { initial, loading, success, failure }

class EditPlayerState extends Equatable {
  final EditPlayerStatus status;
  final PlayerEntity player;
  final String? errorMessage;

  const EditPlayerState({
    this.status = EditPlayerStatus.initial,
    required this.player,
    this.errorMessage,
  });

  EditPlayerState copyWith({
    EditPlayerStatus? status,
    PlayerEntity? player,
    String? errorMessage,
  }) {
    return EditPlayerState(
      status: status ?? this.status,
      player: player ?? this.player,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, player, errorMessage];
}
