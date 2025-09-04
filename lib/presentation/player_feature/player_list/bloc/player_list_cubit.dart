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
    try {
      final result = await _getPlayerList();
      emit(
        PlayerListState(status: PlayerListStatus.loaded, playerList: result),
      );
    } catch (e) {
      emit(
        PlayerListState(
          status: PlayerListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<List<PlayerEntity>> _getPlayerList() async {
    return await playerUseCase.getPlayerList();
  }

  Future<void> createRandomGeneratedPlayerList() async {
    EasyLoading.show();
    // try {
    final result = await playerUseCase.createRandomGeneratedPlayerList();
    if (result) {
      emit(PlayerListState(status: PlayerListStatus.loading));
      final result = await _getPlayerList();
      emit(
        PlayerListState(status: PlayerListStatus.loaded, playerList: result),
      );
    }
    // } catch (e) {
    //   emit(
    //     PlayerListState(
    //       status: PlayerListStatus.error,
    //       errorMessage: e.toString(),
    //     ),
    //   );
    // }
    EasyLoading.dismiss();
  }
}
