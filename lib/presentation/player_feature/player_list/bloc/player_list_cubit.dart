import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'player_list_state.dart';

class PlayerListCubit extends Cubit<PlayerListState> {
  final PlayerUsecase playerUseCase;
  PlayerListCubit({required this.playerUseCase})
    : super(PlayerListState(status: PlayerListStatus.loading));

  Future<void> initial() async {
    emit(PlayerListState(status: PlayerListStatus.loading));
    final result = await _getPlayerList();
    emit(
      PlayerListState(status: PlayerListStatus.loaded, playerList: result),
    );
  }

  Future<List<PlayerEntity>> _getPlayerList() async {
    final result = await playerUseCase.getPlayerList();
    
    return result.fold(
      (exception) {
        emit(
          PlayerListState(
            status: PlayerListStatus.error,
            errorMessage: exception.toString(),
          ),
        );
        return [];
      },
      (players) => players,
    );
  }

  Future<void> createRandomGeneratedPlayerList() async {
    EasyLoading.show();
    
    final result = await playerUseCase.createRandomGeneratedPlayerList();
    
    result.fold(
      (exception) {
        EasyLoading.dismiss();
        emit(
          PlayerListState(
            status: PlayerListStatus.error,
            errorMessage: exception.toString(),
          ),
        );
      },
      (success) async {
        if (success) {
          emit(PlayerListState(status: PlayerListStatus.loading));
          final players = await _getPlayerList();
          emit(
            PlayerListState(status: PlayerListStatus.loaded, playerList: players),
          );
        }
        EasyLoading.dismiss();
      },
    );
  }
}
