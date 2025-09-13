import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý state của màn hình bảng xếp hạng
class TeamStandingCubit extends Cubit<TeamStandingState> {
  final SeasonTeamUseCase _seasonTeamUseCase;

  TeamStandingCubit(this._seasonTeamUseCase) : super(const TeamStandingState());

  Future<void> initial(int seasonId, String seasonName) async {
    emit(
      state.copyWith(
        isLoading: true,
        seasonId: seasonId,
        seasonName: seasonName,
      ),
    );
    final teamStandings = await getTeamStandings();
    emit(state.copyWith(isLoading: false, teamStandings: teamStandings));
  }

  /// Lấy bảng xếp hạng của một mùa giải
  Future<List<TeamStandingEntity>> getTeamStandings() async {
    try {
      // Cập nhật state để hiển thị loading

      // Gọi use case để lấy dữ liệu
      final result = await _seasonTeamUseCase.getTeamStandings(
        seasonId: state.seasonId,
      );

      // Xử lý kết quả
      return result.fold(
        (exception) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: exception.toString(),
            ),
          );
          return [];
        },
        (teamStandings) {
          return teamStandings;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
      return [];
    }
  }

  /// Tìm kiếm đội bóng theo tên
  Future<void> searchTeamStandingByName(String name) async {
    try {
      if (name.isEmpty) {
        // Nếu tên rỗng, lấy lại bảng xếp hạng của mùa giải hiện tại
        if (state.seasonId != null) {
          await getTeamStandings();
        }
        return;
      }

      // Cập nhật state để hiển thị loading
      emit(state.copyWith(isLoading: true));

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
          emit(state.copyWith(isLoading: false, teamStandings: teamStandings));
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
  Future<void> sortTeamStandings(SortCriteria criteria) async {
    emit(state.copyWith(isLoading: true));
    List<TeamStandingEntity> sortedList = [];

    switch (criteria) {
      case SortCriteria.points:
        sortedList = await getTeamStandings();
        break;
      case SortCriteria.awayWins:
        sortedList = await getTeamStandingsByAwayWins();
        break;
      case SortCriteria.pointDifference:
        sortedList = await getTeamStandingsByPointDifference();
        break;
      case SortCriteria.totalPointsScored:
        sortedList = await getTeamStandingsByTotalPointsScored();
        break;
      case SortCriteria.totalFouls:
        sortedList = await getTeamStandingsByTotalFouls();
        break;
    }

    emit(state.copyWith(teamStandings: sortedList, isLoading: false));
  }

  Future<List<TeamStandingEntity>> getTeamStandingsByPointDifference() async {
    final results = await _seasonTeamUseCase.getTeamStandingsByPointDifference(
      seasonId: state.seasonId,
    );

    return results.fold(
      (exception) {
        emit(
          state.copyWith(isLoading: false, errorMessage: exception.toString()),
        );
        return [];
      },
      (teamStandings) {
        return teamStandings;
      },
    );
  }

  Future<List<TeamStandingEntity>> getTeamStandingsByTotalPointsScored() async {
    final results = await _seasonTeamUseCase
        .getTeamStandingsByTotalPointsScored(seasonId: state.seasonId);

    return results.fold(
      (exception) {
        emit(
          state.copyWith(isLoading: false, errorMessage: exception.toString()),
        );
        return [];
      },
      (teamStandings) {
        return teamStandings;
      },
    );
  }

  Future<List<TeamStandingEntity>> getTeamStandingsByAwayWins() async {
    final results = await _seasonTeamUseCase.getTeamStandingsByAwayWins(
      seasonId: state.seasonId,
    );

    return results.fold(
      (exception) {
        emit(
          state.copyWith(isLoading: false, errorMessage: exception.toString()),
        );
        return [];
      },
      (teamStandings) {
        return teamStandings;
      },
    );
  }

  Future<List<TeamStandingEntity>> getTeamStandingsByTotalFouls() async {
    final results = await _seasonTeamUseCase.getTeamStandingsByTotalFouls(
      seasonId: state.seasonId,
    );

    return results.fold(
      (exception) {
        emit(
          state.copyWith(isLoading: false, errorMessage: exception.toString()),
        );
        return [];
      },
      (teamStandings) {
        return teamStandings;
      },
    );
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
      emit(state.copyWith(isLoading: true));

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
          getTeamStandings();
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

  /// Sắp xếp theo số trận thắng (trận khách)
  awayWins,

  /// Sắp xếp theo hiệu số
  pointDifference,

  /// Sắp xếp theo tổng điểm ghi được
  totalPointsScored,

  /// Sắp xếp theo tổng số lỗi ít nhất
  totalFouls,
}
