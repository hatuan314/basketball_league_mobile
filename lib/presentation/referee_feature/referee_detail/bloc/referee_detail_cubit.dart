import 'package:baseketball_league_mobile/domain/entities/referee/referee_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/referee/referee_monthly_salary_entity.dart';
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

  Future<void> initia(int id) async {
    emit(state.copyWith(status: RefereeDetailStatus.loading));
    final results = await Future.wait([
      getRefereeDetail(id),
      getRefereeMonthlySalaryListById(id),
    ]);
    if (results.isNotEmpty) {
      final referee = results[0] as RefereeEntity?;
      final monthlySalaries = results[1] as List<RefereeMonthlySalaryEntity>?;
      emit(
        state.copyWith(
          status: RefereeDetailStatus.success,
          referee: referee,
          monthlySalaries: monthlySalaries,
        ),
      );
    }
  }

  /// Lấy thông tin chi tiết của trọng tài
  Future<RefereeEntity?> getRefereeDetail(int id) async {
    try {
      final result = await _refereeUsecase.getRefereeById(id);

      return result.fold(
        (exception) {
          emit(
            state.copyWith(
              status: RefereeDetailStatus.failure,
              errorMessage: exception.toString(),
            ),
          );
          return null;
        },
        (referee) {
          if (referee == null) {
            emit(
              state.copyWith(
                status: RefereeDetailStatus.failure,
                errorMessage: 'Không tìm thấy thông tin trọng tài',
              ),
            );
            return null;
          }
          return referee;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeDetailStatus.failure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
      return null;
    }
  }

  Future<List<RefereeMonthlySalaryEntity>?> getRefereeMonthlySalaryListById(
    int id,
  ) async {
    try {
      final result = await _refereeUsecase.getRefereeMonthlySalaryListById(id);

      return result.fold(
        (exception) {
          emit(
            state.copyWith(
              status: RefereeDetailStatus.failure,
              errorMessage: exception.toString(),
            ),
          );
          return null;
        },
        (refereeMonthlySalary) {
          if (refereeMonthlySalary.isEmpty) {
            emit(
              state.copyWith(
                status: RefereeDetailStatus.failure,
                errorMessage: 'Không tìm thấy thông tin lương của trọng tài',
              ),
            );
            return null;
          }
          return refereeMonthlySalary;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RefereeDetailStatus.failure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
      return null;
    }
  }
}
