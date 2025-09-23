import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/edit_player/bloc/edit_player_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPlayerCubit extends Cubit<EditPlayerState> {
  final PlayerUsecase playerUsecase;

  EditPlayerCubit({
    required this.playerUsecase,
    required PlayerEntity player,
  }) : super(EditPlayerState(player: player));

  void updatePlayerName(String name) {
    final updatedPlayer = state.player.copyWith(fullName: name);
    emit(state.copyWith(player: updatedPlayer));
  }

  void updatePlayerCode(String code) {
    final updatedPlayer = state.player.copyWith(playerCode: code);
    emit(state.copyWith(player: updatedPlayer));
  }

  void updatePlayerDob(DateTime dob) {
    final updatedPlayer = state.player.copyWith(dob: dob);
    emit(state.copyWith(player: updatedPlayer));
  }

  void updatePlayerHeight(String height) {
    final heightInt = int.tryParse(height);
    if (heightInt != null) {
      final updatedPlayer = state.player.copyWith(height: heightInt);
      emit(state.copyWith(player: updatedPlayer));
    }
  }

  void updatePlayerWeight(String weight) {
    final weightInt = int.tryParse(weight);
    if (weightInt != null) {
      final updatedPlayer = state.player.copyWith(weight: weightInt);
      emit(state.copyWith(player: updatedPlayer));
    }
  }

  bool validateForm() {
    if (state.player.fullName == null || state.player.fullName!.isEmpty) {
      emit(state.copyWith(errorMessage: 'Tên cầu thủ không được để trống'));
      return false;
    }

    if (state.player.playerCode == null || state.player.playerCode!.isEmpty) {
      emit(state.copyWith(errorMessage: 'Mã cầu thủ không được để trống'));
      return false;
    }

    if (state.player.dob == null) {
      emit(state.copyWith(errorMessage: 'Ngày sinh không được để trống'));
      return false;
    }

    if (state.player.height == null || state.player.height! <= 0) {
      emit(state.copyWith(errorMessage: 'Chiều cao phải lớn hơn 0'));
      return false;
    }

    if (state.player.weight == null || state.player.weight! <= 0) {
      emit(state.copyWith(errorMessage: 'Cân nặng phải lớn hơn 0'));
      return false;
    }

    return true;
  }

  Future<void> updatePlayer() async {
    if (!validateForm()) {
      return;
    }

    emit(state.copyWith(status: EditPlayerStatus.loading));

    if (state.player.id == null) {
      emit(state.copyWith(
        status: EditPlayerStatus.failure,
        errorMessage: 'ID cầu thủ không hợp lệ',
      ));
      return;
    }

    final result = await playerUsecase.updatePlayer(state.player.id!, state.player);

    result.fold(
      (exception) => emit(state.copyWith(
        status: EditPlayerStatus.failure,
        errorMessage: exception.toString(),
      )),
      (success) => emit(state.copyWith(
        status: EditPlayerStatus.success,
      )),
    );
  }

  void resetState() {
    emit(EditPlayerState(player: state.player));
  }
}
