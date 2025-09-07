import 'package:baseketball_league_mobile/domain/usecases/referee_usecase.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/bloc/referee_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý trạng thái của màn hình danh sách trọng tài
class RefereeListCubit extends Cubit<RefereeListState> {
  final RefereeUsecase _refereeUsecase;

  /// Constructor
  RefereeListCubit({required RefereeUsecase refereeUsecase})
    : _refereeUsecase = refereeUsecase,
      super(const RefereeListState());

  /// Lấy danh sách trọng tài
  Future<void> getReferees() async {
    emit(state.copyWith(status: RefereeListStatus.loading, clearError: true));

    try {
      final result = await _refereeUsecase.getRefereeList();

      result.fold(
        (exception) => emit(
          state.copyWith(
            status: RefereeListStatus.failure,
            errorMessage: exception.toString(),
          ),
        ),
        (referees) => emit(
          state.copyWith(status: RefereeListStatus.success, referees: referees),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeListStatus.failure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  /// Tìm kiếm trọng tài theo tên
  Future<void> searchReferees(String keyword) async {
    emit(
      state.copyWith(
        status: RefereeListStatus.loading,
        searchKeyword: keyword,
        clearError: true,
      ),
    );

    try {
      if (keyword.isEmpty) {
        await getReferees();
        return;
      }

      final result = await _refereeUsecase.searchReferee(keyword);

      result.fold(
        (exception) => emit(
          state.copyWith(
            status: RefereeListStatus.failure,
            errorMessage: exception.toString(),
          ),
        ),
        (referees) => emit(
          state.copyWith(status: RefereeListStatus.success, referees: referees),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeListStatus.failure,
          errorMessage: 'Đã xảy ra lỗi khi tìm kiếm: ${e.toString()}',
        ),
      );
    }
  }

  /// Xóa trọng tài
  Future<void> deleteReferee(int id) async {
    try {
      final result = await _refereeUsecase.deleteReferee(id);

      result.fold(
        (exception) => emit(state.copyWith(errorMessage: exception.toString())),
        (success) {
          if (success) {
            // Xóa thành công, cập nhật lại danh sách
            final updatedReferees =
                state.referees.where((referee) => referee.id != id).toList();

            emit(state.copyWith(referees: updatedReferees));
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Đã xảy ra lỗi khi xóa trọng tài: ${e.toString()}',
        ),
      );
    }
  }

  /// Tạo dữ liệu trọng tài từ data mock
  Future<void> generateMockData() async {
    emit(
      state.copyWith(
        status: RefereeListStatus.generating,
        clearError: true,
        clearGeneratedCount: true,
      ),
    );

    try {
      final result = await _refereeUsecase.generateMockRefereeData();

      result.fold(
        (exception) => emit(
          state.copyWith(
            status: RefereeListStatus.generateFailure,
            errorMessage: exception.toString(),
          ),
        ),
        (count) => emit(
          state.copyWith(
            status: RefereeListStatus.generateSuccess,
            generatedCount: count,
          ),
        ),
      );

      // Sau khi tạo xong, lấy lại danh sách trọng tài
      await getReferees();
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeListStatus.generateFailure,
          errorMessage: 'Đã xảy ra lỗi khi tạo dữ liệu: ${e.toString()}',
        ),
      );
    }
  }
}
