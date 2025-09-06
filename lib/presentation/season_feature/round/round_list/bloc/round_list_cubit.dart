import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/round_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/bloc/round_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý state của màn hình danh sách vòng đấu
class RoundListCubit extends Cubit<RoundListState> {
  /// Use case để thao tác với vòng đấu
  final RoundUseCase _roundUseCase;

  /// Constructor
  RoundListCubit({required RoundUseCase roundUseCase})
    : _roundUseCase = roundUseCase,
      super(const RoundListState());

  /// Thiết lập ID mùa giải đang xem
  void setSeasonId(int seasonId) {
    emit(state.copyWith(seasonId: seasonId));
  }

  /// Lấy danh sách vòng đấu theo mùa giải
  Future<void> getRounds() async {
    try {
      // Kiểm tra seasonId
      if (state.seasonId == null) {
        emit(
          state.copyWith(
            status: RoundListStatus.failure,
            errorMessage: 'Không có thông tin mùa giải',
          ),
        );
        return;
      }

      // Cập nhật trạng thái loading
      emit(state.copyWith(status: RoundListStatus.loading));

      // Gọi use case để lấy danh sách vòng đấu
      final result = await _roundUseCase.getRounds(seasonId: state.seasonId);

      // Xử lý kết quả
      result.fold(
        (exception) {
          emit(
            state.copyWith(
              status: RoundListStatus.failure,
              errorMessage: exception.toString(),
            ),
          );
        },
        (rounds) {
          emit(
            state.copyWith(
              status: RoundListStatus.success,
              rounds: rounds,
              errorMessage: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RoundListStatus.failure,
          errorMessage: 'Lỗi không xác định: ${e.toString()}',
        ),
      );
    }
  }

  /// Tạo vòng đấu mới
  Future<void> createRound(RoundEntity round) async {
    try {
      // Cập nhật trạng thái creating
      emit(state.copyWith(status: RoundListStatus.creating));

      // Gọi use case để tạo vòng đấu mới
      final result = await _roundUseCase.createRound(round);

      // Xử lý kết quả
      result.fold(
        (exception) {
          emit(
            state.copyWith(
              status: RoundListStatus.createFailure,
              errorMessage: exception.toString(),
            ),
          );
        },
        (createdRound) {
          // Thêm vòng đấu mới vào danh sách
          final updatedRounds = List<RoundEntity>.from(state.rounds)
            ..add(createdRound);

          // Sắp xếp lại danh sách theo số thứ tự vòng đấu
          updatedRounds.sort(
            (a, b) => (a.roundNo ?? 0).compareTo(b.roundNo ?? 0),
          );

          emit(
            state.copyWith(
              status: RoundListStatus.createSuccess,
              rounds: updatedRounds,
              errorMessage: null,
            ),
          );

          // Sau khi tạo thành công, cập nhật lại trạng thái về success
          emit(state.copyWith(status: RoundListStatus.success));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RoundListStatus.createFailure,
          errorMessage: 'Lỗi không xác định: ${e.toString()}',
        ),
      );
    }
  }

  /// Tạo nhiều vòng đấu tự động
  Future<void> generateRounds() async {
    try {
      // Kiểm tra seasonId
      if (state.seasonId == null) {
        emit(
          state.copyWith(
            status: RoundListStatus.failure,
            errorMessage: 'Không có thông tin mùa giải',
          ),
        );
        return;
      }

      // Cập nhật trạng thái creating
      emit(state.copyWith(status: RoundListStatus.creating));

      // Gọi use case để tạo nhiều vòng đấu
      final result = await _roundUseCase.generateRounds(
        seasonId: state.seasonId!,
      );

      // Xử lý kết quả
      result.fold(
        (exception) {
          emit(
            state.copyWith(
              status: RoundListStatus.createFailure,
              errorMessage: exception.toString(),
            ),
          );
        },
        (rounds) {
          emit(
            state.copyWith(
              status: RoundListStatus.createSuccess,
              rounds: rounds,
              errorMessage: null,
            ),
          );

          // Sau khi tạo thành công, cập nhật lại trạng thái về success
          emit(state.copyWith(status: RoundListStatus.success));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RoundListStatus.createFailure,
          errorMessage: 'Lỗi không xác định: ${e.toString()}',
        ),
      );
    }
  }

  /// Reset trạng thái về initial
  void resetState() {
    emit(const RoundListState());
  }
}
