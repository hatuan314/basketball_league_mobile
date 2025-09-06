import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_edit/bloc/season_edit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SeasonEditCubit extends Cubit<SeasonEditState> {
  final SeasonUsecase _seasonUsecase;

  SeasonEditCubit({
    required SeasonUsecase seasonUsecase,
    required SeasonEntity? season,
    required bool isEditing,
  })  : _seasonUsecase = seasonUsecase,
        super(SeasonEditState(
          season: season ?? SeasonEntity(),
          isEditing: isEditing,
        ));

  /// Cập nhật tên giải đấu
  void updateName(String name) {
    final updatedSeason = state.season?.copyWith(name: name);
    emit(state.copyWith(season: updatedSeason));
  }

  /// Cập nhật mã giải đấu
  void updateCode(String code) {
    final updatedSeason = state.season?.copyWith(code: code);
    emit(state.copyWith(season: updatedSeason));
  }

  /// Cập nhật ngày bắt đầu
  void updateStartDate(DateTime startDate) {
    final updatedSeason = state.season?.copyWith(startDate: startDate);
    emit(state.copyWith(season: updatedSeason));
  }

  /// Cập nhật ngày kết thúc
  void updateEndDate(DateTime endDate) {
    final updatedSeason = state.season?.copyWith(endDate: endDate);
    emit(state.copyWith(season: updatedSeason));
  }

  /// Lưu giải đấu
  Future<void> saveSeason() async {
    if (state.season == null) return;
    
    // Kiểm tra dữ liệu đầu vào
    if (state.season!.name == null || state.season!.name!.isEmpty) {
      emit(state.copyWith(
        status: SeasonEditStatus.error,
        errorMessage: 'Tên giải đấu không được để trống',
      ));
      return;
    }

    if (state.season!.code == null || state.season!.code!.isEmpty) {
      emit(state.copyWith(
        status: SeasonEditStatus.error,
        errorMessage: 'Mã giải đấu không được để trống',
      ));
      return;
    }

    if (state.season!.startDate == null) {
      emit(state.copyWith(
        status: SeasonEditStatus.error,
        errorMessage: 'Ngày bắt đầu không được để trống',
      ));
      return;
    }

    if (state.season!.endDate == null) {
      emit(state.copyWith(
        status: SeasonEditStatus.error,
        errorMessage: 'Ngày kết thúc không được để trống',
      ));
      return;
    }

    if (state.season!.startDate!.isAfter(state.season!.endDate!)) {
      emit(state.copyWith(
        status: SeasonEditStatus.error,
        errorMessage: 'Ngày bắt đầu phải trước ngày kết thúc',
      ));
      return;
    }

    emit(state.copyWith(status: SeasonEditStatus.loading));
    EasyLoading.show(status: 'Đang lưu...');

    try {
      final result = state.isEditing
          ? await _seasonUsecase.updateSeason(state.season!)
          : await _seasonUsecase.createSeason(state.season!);

      result.fold(
        (exception) {
          emit(state.copyWith(
            status: SeasonEditStatus.error,
            errorMessage: exception.toString(),
          ));
          EasyLoading.showError('Lỗi: ${exception.toString()}');
        },
        (success) {
          if (success) {
            emit(state.copyWith(status: SeasonEditStatus.success));
            EasyLoading.showSuccess(
              state.isEditing ? 'Cập nhật thành công' : 'Tạo mới thành công',
            );
          } else {
            emit(state.copyWith(
              status: SeasonEditStatus.error,
              errorMessage: 'Không thể lưu giải đấu',
            ));
            EasyLoading.showError('Không thể lưu giải đấu');
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: SeasonEditStatus.error,
        errorMessage: e.toString(),
      ));
      EasyLoading.showError('Lỗi: ${e.toString()}');
    }
  }
}
