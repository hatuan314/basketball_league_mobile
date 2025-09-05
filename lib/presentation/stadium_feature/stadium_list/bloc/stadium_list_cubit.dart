import 'package:baseketball_league_mobile/domain/usecases/stadium_usecase.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

/// Cubit quản lý state cho màn hình danh sách sân vận động
class StadiumListCubit extends Cubit<StadiumListState> {
  final StadiumUseCase _stadiumUseCase;

  StadiumListCubit({required StadiumUseCase stadiumUseCase})
      : _stadiumUseCase = stadiumUseCase,
        super(const StadiumListInitial());

  /// Lấy danh sách sân vận động
  Future<void> getStadiums() async {
    emit(const StadiumListLoading());
    try {
      final result = await _stadiumUseCase.getStadiums();
      result.fold(
        (exception) => emit(StadiumListError(exception.toString())),
        (stadiums) => emit(StadiumListLoaded(stadiums)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy danh sách sân vận động: $e');
      }
      emit(StadiumListError(e.toString()));
    }
  }

  /// Tạo bảng stadium trong database
  Future<void> createTable() async {
    emit(const StadiumListLoading());
    try {
      final result = await _stadiumUseCase.createTable();
      result.fold(
        (exception) => emit(StadiumTableError(exception.toString())),
        (success) {
          emit(const StadiumTableCreated());
          getStadiums(); // Tải lại danh sách sau khi tạo bảng
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo bảng stadium: $e');
      }
      emit(StadiumTableError(e.toString()));
    }
  }

  /// Xóa sân vận động
  Future<void> deleteStadium(int id) async {
    emit(const StadiumListLoading());
    try {
      final result = await _stadiumUseCase.deleteStadium(id);
      result.fold(
        (exception) => emit(StadiumDeleteError(exception.toString())),
        (success) {
          emit(const StadiumDeleted());
          getStadiums(); // Tải lại danh sách sau khi xóa
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi xóa sân vận động: $e');
      }
      emit(StadiumDeleteError(e.toString()));
    }
  }

  /// Tạo danh sách sân vận động ngẫu nhiên
  Future<void> generateRandomStadiums(int count) async {
    emit(const StadiumListLoading());
    try {
      final result = await _stadiumUseCase.generateRandomStadiums(count);
      result.fold(
        (exception) => emit(StadiumRandomError(exception.toString())),
        (stadiums) {
          emit(StadiumRandomCreated(stadiums));
          getStadiums(); // Tải lại danh sách sau khi tạo ngẫu nhiên
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo danh sách sân vận động ngẫu nhiên: $e');
      }
      emit(StadiumRandomError(e.toString()));
    }
  }
  
  /// Biến lưu trữ timer cho debounce
  Timer? _debounce;
  
  /// Tìm kiếm sân vận động theo tên
  Future<void> searchStadiums(String query) async {
    // Hủy timer trước đó nếu có
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    // Tạo timer mới để tránh gọi API liên tục khi người dùng đang nhập
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(const StadiumListLoading());
      try {
        final result = await _stadiumUseCase.searchStadiumsByName(query);
        result.fold(
          (exception) => emit(StadiumListError(exception.toString())),
          (stadiums) => emit(StadiumListLoaded(stadiums)),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Lỗi khi tìm kiếm sân vận động: $e');
        }
        emit(StadiumListError(e.toString()));
      }
    });
  }
  
  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
