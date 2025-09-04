import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'season_list_state.dart';

class SeasonListCubit extends Cubit<SeasonListState> {
  final SeasonUsecase seasonUsecase;
  SeasonListCubit({required this.seasonUsecase})
    : super(SeasonListState(status: SeasonListStatus.loading, seasons: []));

  Future<void> initial() async {
    emit(state.copyWith(status: SeasonListStatus.loading));
    final seasons = await getSeasonList();
    emit(state.copyWith(status: SeasonListStatus.loaded, seasons: seasons));
  }

  /// Lấy danh sách mùa giải từ database
  Future<List<SeasonEntity>> getSeasonList() async {
    final result = await seasonUsecase.getSeasonList();
    
    return result.fold(
      (exception) {
        emit(
          state.copyWith(
            status: SeasonListStatus.error,
            errorMessage: "Lỗi khi lấy danh sách mùa giải: ${exception.toString()}",
          ),
        );
        return [];
      },
      (seasons) => seasons,
    );
  }

  /// Tạo các mùa giải ngẫu nhiên
  Future<void> createRandomSeasons() async {
    EasyLoading.show(status: 'Đang tạo mùa giải ngẫu nhiên...');
    final result = await seasonUsecase.createRandomGeneratedSeasonList();
    
    result.fold(
      (exception) {
        EasyLoading.showError('Lỗi khi tạo mùa giải: ${exception.toString()}');
        emit(
          state.copyWith(
            status: SeasonListStatus.error,
            errorMessage: "Lỗi khi tạo mùa giải: ${exception.toString()}",
          ),
        );
      },
      (success) async {
        if (success) {
          emit(state.copyWith(status: SeasonListStatus.loading));
          final seasons = await getSeasonList(); // Cập nhật lại danh sách sau khi tạo thành công
          emit(state.copyWith(status: SeasonListStatus.loaded, seasons: seasons));
          EasyLoading.showSuccess('Tạo mùa giải thành công');
        } else {
          EasyLoading.showError('Tạo mùa giải thất bại');
        }
      },
    );
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
