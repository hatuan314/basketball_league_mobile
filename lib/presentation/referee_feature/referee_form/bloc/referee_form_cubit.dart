import 'package:baseketball_league_mobile/domain/entities/referee_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/referee_usecase.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_form/bloc/referee_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý trạng thái của màn hình form trọng tài
class RefereeFormCubit extends Cubit<RefereeFormState> {
  final RefereeUsecase _refereeUsecase;

  /// Constructor
  RefereeFormCubit({required RefereeUsecase refereeUsecase})
    : _refereeUsecase = refereeUsecase,
      super(const RefereeFormState());

  /// Lấy thông tin trọng tài để chỉnh sửa
  Future<void> loadRefereeForEdit(int id) async {
    emit(state.copyWith(status: RefereeFormStatus.loading, clearError: true));

    try {
      final result = await _refereeUsecase.getRefereeById(id);

      result.fold(
        (exception) => emit(
          state.copyWith(
            status: RefereeFormStatus.initial,
            errorMessage: exception.toString(),
          ),
        ),
        (referee) {
          if (referee == null) {
            emit(
              state.copyWith(
                status: RefereeFormStatus.initial,
                errorMessage: 'Không tìm thấy thông tin trọng tài',
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: RefereeFormStatus.initial,
                referee: referee,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeFormStatus.initial,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  /// Lưu thông tin trọng tài
  Future<void> saveReferee({
    int? id,
    required String fullName,
    required String email,
  }) async {
    emit(state.copyWith(status: RefereeFormStatus.saving, clearError: true));

    try {
      // Kiểm tra dữ liệu đầu vào
      if (fullName.isEmpty) {
        emit(
          state.copyWith(
            status: RefereeFormStatus.saveFailure,
            errorMessage: 'Tên trọng tài không được để trống',
          ),
        );
        return;
      }

      if (email.isEmpty) {
        emit(
          state.copyWith(
            status: RefereeFormStatus.saveFailure,
            errorMessage: 'Email không được để trống',
          ),
        );
        return;
      }

      // Kiểm tra định dạng email
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(email)) {
        emit(
          state.copyWith(
            status: RefereeFormStatus.saveFailure,
            errorMessage: 'Email không đúng định dạng',
          ),
        );
        return;
      }

      // Tạo đối tượng trọng tài
      final referee = RefereeEntity(id: id, fullName: fullName, email: email);

      // Gọi usecase để lưu thông tin
      final result =
          id == null
              ? await _refereeUsecase.createReferee(referee)
              : await _refereeUsecase.updateReferee(id, referee);

      result.fold(
        (exception) => emit(
          state.copyWith(
            status: RefereeFormStatus.saveFailure,
            errorMessage: exception.toString(),
          ),
        ),
        (success) {
          if (success) {
            emit(
              state.copyWith(
                status: RefereeFormStatus.saveSuccess,
                referee: referee,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: RefereeFormStatus.saveFailure,
                errorMessage: 'Không thể lưu thông tin trọng tài',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeFormStatus.saveFailure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }
}
