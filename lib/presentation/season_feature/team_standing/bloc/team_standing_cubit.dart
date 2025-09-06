import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý state của màn hình bảng xếp hạng
class TeamStandingCubit extends Cubit<TeamStandingState> {
  final SeasonTeamUseCase _seasonTeamUseCase;

  TeamStandingCubit(this._seasonTeamUseCase) : super(const TeamStandingState());

  /// Lấy bảng xếp hạng của một mùa giải
  Future<void> getTeamStandings(int seasonId, String seasonName) async {
    try {
      // Cập nhật state để hiển thị loading
      emit(
        state.copyWith(
          isLoading: true,
          seasonId: seasonId,
          seasonName: seasonName,
          clearError: true,
        ),
      );

      // Gọi use case để lấy dữ liệu
      final result = await _seasonTeamUseCase.getTeamStandings(
        seasonId: seasonId,
      );

      // Xử lý kết quả
      result.fold(
        (exception) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: exception.toString(),
            ),
          );
        },
        (teamStandings) {
          emit(
            state.copyWith(
              isLoading: false,
              teamStandings: teamStandings,
              clearError: true,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  /// Tìm kiếm đội bóng theo tên
  Future<void> searchTeamStandingByName(String name) async {
    try {
      if (name.isEmpty) {
        // Nếu tên rỗng, lấy lại bảng xếp hạng của mùa giải hiện tại
        if (state.seasonId != null) {
          await getTeamStandings(state.seasonId!, state.seasonName ?? '');
        }
        return;
      }

      // Cập nhật state để hiển thị loading
      emit(state.copyWith(isLoading: true, clearError: true));

      // Gọi use case để tìm kiếm
      final result = await _seasonTeamUseCase.searchTeamStandingByName(name);

      // Xử lý kết quả
      result.fold(
        (exception) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: exception.toString(),
            ),
          );
        },
        (teamStandings) {
          emit(
            state.copyWith(
              isLoading: false,
              teamStandings: teamStandings,
              clearError: true,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã xảy ra lỗi khi tìm kiếm: ${e.toString()}',
        ),
      );
    }
  }

  /// Sắp xếp bảng xếp hạng theo tiêu chí
  void sortTeamStandings(SortCriteria criteria) {
    final List<TeamStandingEntity> sortedList = List.from(state.teamStandings);

    switch (criteria) {
      case SortCriteria.points:
        sortedList.sort(
          (a, b) => (b.totalPoints ?? 0).compareTo(a.totalPoints ?? 0),
        );
        break;
      case SortCriteria.wins:
        sortedList.sort(
          (a, b) => (b.totalWins ?? 0).compareTo(a.totalWins ?? 0),
        );
        break;
      case SortCriteria.losses:
        sortedList.sort(
          (a, b) => (b.totalLosses ?? 0).compareTo(a.totalLosses ?? 0),
        );
        break;
      case SortCriteria.pointsScored:
        sortedList.sort(
          (a, b) =>
              (b.totalPointsScored ?? 0).compareTo(a.totalPointsScored ?? 0),
        );
        break;
      case SortCriteria.pointsConceded:
        sortedList.sort(
          (a, b) => (b.totalPointsConceded ?? 0).compareTo(
            a.totalPointsConceded ?? 0,
          ),
        );
        break;
      case SortCriteria.pointDifference:
        sortedList.sort(
          (a, b) => (b.pointDifference ?? 0).compareTo(a.pointDifference ?? 0),
        );
        break;
    }

    emit(state.copyWith(teamStandings: sortedList));
  }

  /// Tạo hàng loạt mối quan hệ giữa mùa giải và đội bóng
  /// Tự động chọn ngẫu nhiên ít nhất 8 đội bóng và sân vận động từ cơ sở dữ liệu
  Future<void> createBulkSeasonTeams() async {
    try {
      // Kiểm tra xem có seasonId không
      if (state.seasonId == null) {
        emit(state.copyWith(errorMessage: 'Không có mùa giải được chọn'));
        return;
      }

      // Cập nhật state để hiển thị loading
      emit(state.copyWith(isLoading: true, clearError: true));

      // Gọi use case để tạo hàng loạt mối quan hệ
      final result = await _seasonTeamUseCase.createBulkSeasonTeams(
        seasonId: state.seasonId!,
      );

      // Xử lý kết quả
      result.fold(
        (exception) {
          print(exception.toString());
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: exception.toString(),
            ),
          );
        },
        (seasonTeams) {
          // Sau khi tạo thành công, lấy lại bảng xếp hạng
          getTeamStandings(state.seasonId!, state.seasonName ?? '');
        },
      );
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã xảy ra lỗi khi tạo dữ liệu mẫu: ${e.toString()}',
        ),
      );
    }
  }
}

/// Tiêu chí sắp xếp bảng xếp hạng
enum SortCriteria {
  /// Sắp xếp theo điểm
  points,

  /// Sắp xếp theo số trận thắng
  wins,

  /// Sắp xếp theo số trận thua
  losses,

  /// Sắp xếp theo tổng điểm ghi được
  pointsScored,

  /// Sắp xếp theo tổng điểm bị ghi
  pointsConceded,

  /// Sắp xếp theo hiệu số
  pointDifference,
}
