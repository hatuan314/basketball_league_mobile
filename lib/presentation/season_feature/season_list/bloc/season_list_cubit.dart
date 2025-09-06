import 'dart:async';

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
  
  /// Biến lưu trữ timer cho debounce
  Timer? _debounce;
  
  /// Tìm kiếm mùa giải theo tên
  Future<void> searchSeasons(String query) async {
    // Hủy timer trước đó nếu có
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    // Tạo timer mới để tránh gọi API liên tục khi người dùng đang nhập
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(state.copyWith(status: SeasonListStatus.loading));
      
      if (query.isEmpty) {
        // Nếu query rỗng, lấy tất cả mùa giải
        final seasons = await getSeasonList();
        emit(state.copyWith(status: SeasonListStatus.loaded, seasons: seasons));
        return;
      }
      
      final result = await seasonUsecase.searchSeason(query);
      
      result.fold(
        (exception) {
          emit(
            state.copyWith(
              status: SeasonListStatus.error,
              errorMessage: "Lỗi khi tìm kiếm mùa giải: ${exception.toString()}",
            ),
          );
        },
        (seasons) {
          emit(state.copyWith(status: SeasonListStatus.loaded, seasons: seasons));
        },
      );
    });
  }
  
  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
  
  /// Xóa mùa giải
  Future<void> deleteSeason(SeasonEntity season) async {
    if (season.id == null) return;
    
    EasyLoading.show(status: 'Đang xóa mùa giải...');
    final result = await seasonUsecase.deleteSeason(season.id!);
    
    result.fold(
      (exception) {
        EasyLoading.showError('Lỗi khi xóa mùa giải: ${exception.toString()}');
        emit(
          state.copyWith(
            status: SeasonListStatus.error,
            errorMessage: "Lỗi khi xóa mùa giải: ${exception.toString()}",
          ),
        );
      },
      (success) async {
        if (success) {
          emit(state.copyWith(status: SeasonListStatus.loading));
          final seasons = await getSeasonList(); // Cập nhật lại danh sách sau khi xóa thành công
          emit(state.copyWith(status: SeasonListStatus.loaded, seasons: seasons));
          EasyLoading.showSuccess('Xóa mùa giải thành công');
        } else {
          EasyLoading.showError('Xóa mùa giải thất bại');
        }
      },
    );
  }
  
  /// Cập nhật mùa giải
  Future<void> updateSeason(SeasonEntity season) async {
    EasyLoading.show(status: 'Đang cập nhật mùa giải...');
    final result = await seasonUsecase.updateSeason(season);
    
    result.fold(
      (exception) {
        EasyLoading.showError('Lỗi khi cập nhật mùa giải: ${exception.toString()}');
        emit(
          state.copyWith(
            status: SeasonListStatus.error,
            errorMessage: "Lỗi khi cập nhật mùa giải: ${exception.toString()}",
          ),
        );
      },
      (success) async {
        if (success) {
          emit(state.copyWith(status: SeasonListStatus.loading));
          final seasons = await getSeasonList(); // Cập nhật lại danh sách sau khi cập nhật thành công
          emit(state.copyWith(status: SeasonListStatus.loaded, seasons: seasons));
          EasyLoading.showSuccess('Cập nhật mùa giải thành công');
        } else {
          EasyLoading.showError('Cập nhật mùa giải thất bại');
        }
      },
    );
  }
}
