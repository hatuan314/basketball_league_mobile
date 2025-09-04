import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SeasonUsecase seasonUsecase;
  HomeCubit({required this.seasonUsecase})
    : super(HomeState(status: HomeStatus.loading, seasons: []));

  Future<void> initial() async {
    EasyLoading.show();
    final isConnect = await _checkConnection();
    if (isConnect) {
      await _configDatabase();
      final seasons = await getSeasonList();
      emit(state.copyWith(status: HomeStatus.loaded, seasons: seasons));
    } else {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: "Kết nối tới database thất bại",
        ),
      );
    }
    EasyLoading.dismiss();
  }

  /// Lấy danh sách mùa giải từ database
  Future<List<SeasonEntity>> getSeasonList() async {
    try {
      final seasons = await seasonUsecase.getSeasonList();
      return seasons;
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: "Lỗi khi lấy danh sách mùa giải: $e",
        ),
      );
      return [];
    }
  }

  /// Tạo các mùa giải ngẫu nhiên
  Future<void> createRandomSeasons() async {
    try {
      EasyLoading.show(status: 'Đang tạo mùa giải ngẫu nhiên...');
      final result = await seasonUsecase.createRandomGeneratedSeasonList();
      if (result) {
        emit(state.copyWith(status: HomeStatus.loading));
        final seasons =
            await getSeasonList(); // Cập nhật lại danh sách sau khi tạo thành công
        emit(state.copyWith(status: HomeStatus.loaded, seasons: seasons));
        EasyLoading.showSuccess('Tạo mùa giải thành công');
      } else {
        EasyLoading.showError('Tạo mùa giải thất bại');
      }
    } catch (e) {
      EasyLoading.showError('Lỗi khi tạo mùa giải: $e');
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: "Lỗi khi tạo mùa giải: $e",
        ),
      );
    }
  }

  Future<bool> _checkConnection() async {
    final isConnect = await sl<PostgresConnection>().connectDb();

    if (isConnect) {
      return true;
    }
    return false;
  }

  Future<void> _configDatabase() async {
    await sl<PostgresConnection>().configDatabase();
  }
}
