import 'package:baseketball_league_mobile/domain/usecases/referee_usecase.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/bloc/referee_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý trạng thái của màn hình chi tiết trọng tài
class RefereeDetailCubit extends Cubit<RefereeDetailState> {
  final RefereeUsecase _refereeUsecase;

  /// Constructor
  RefereeDetailCubit({required RefereeUsecase refereeUsecase})
    : _refereeUsecase = refereeUsecase,
      super(const RefereeDetailState());

  /// Lấy thông tin chi tiết của trọng tài
  Future<void> getRefereeDetail(int id) async {
    emit(state.copyWith(status: RefereeDetailStatus.loading, clearError: true));

    try {
      final result = await _refereeUsecase.getRefereeById(id);

      result.fold(
        (exception) => emit(
          state.copyWith(
            status: RefereeDetailStatus.failure,
            errorMessage: exception.toString(),
          ),
        ),
        (referee) {
          if (referee == null) {
            emit(
              state.copyWith(
                status: RefereeDetailStatus.failure,
                errorMessage: 'Không tìm thấy thông tin trọng tài',
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: RefereeDetailStatus.success,
                referee: referee,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeDetailStatus.failure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }
}
