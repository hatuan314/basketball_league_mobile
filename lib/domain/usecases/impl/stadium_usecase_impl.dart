import 'package:baseketball_league_mobile/common/app_utils.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:baseketball_league_mobile/domain/repositories/stadium_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/stadium_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

/// Triển khai của StadiumUseCase
class StadiumUseCaseImpl implements StadiumUseCase {
  /// StadiumRepository để thao tác với dữ liệu
  final StadiumRepository _stadiumRepository;

  /// Constructor
  StadiumUseCaseImpl(this._stadiumRepository);

  @override
  Future<Either<Exception, bool>> createTable() async {
    try {
      return await _stadiumRepository.createTable();
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo bảng stadium: $e');
      }
      return Left(Exception('Lỗi khi tạo bảng stadium: $e'));
    }
  }

  @override
  Future<Either<Exception, List<StadiumModel>>> getStadiums() async {
    try {
      return await _stadiumRepository.getStadiums();
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy danh sách sân vận động: $e');
      }
      return Left(Exception('Lỗi khi lấy danh sách sân vận động: $e'));
    }
  }

  @override
  Future<Either<Exception, StadiumModel?>> getStadiumById(int id) async {
    try {
      return await _stadiumRepository.getStadiumById(id);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy thông tin sân vận động: $e');
      }
      return Left(Exception('Lỗi khi lấy thông tin sân vận động: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> createStadium(StadiumModel stadium) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (AppUtils.isNullEmpty(stadium.name)) {
        return Left(Exception('Tên sân vận động không được để trống'));
      }
      if (AppUtils.isNullEmpty(stadium.address)) {
        return Left(Exception('Địa chỉ sân vận động không được để trống'));
      }
      if (stadium.capacity! <= 0) {
        return Left(Exception('Sức chứa sân vận động phải lớn hơn 0'));
      }
      if (stadium.ticketPrice! <= 0) {
        return Left(Exception('Giá vé phải lớn hơn 0'));
      }

      return await _stadiumRepository.createStadium(stadium);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo sân vận động: $e');
      }
      return Left(Exception('Lỗi khi tạo sân vận động: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateStadium(StadiumModel stadium) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (stadium.id! <= 0) {
        return Left(Exception('ID sân vận động không hợp lệ'));
      }
      if (AppUtils.isNullEmpty(stadium.name)) {
        return Left(Exception('Tên sân vận động không được để trống'));
      }
      if (AppUtils.isNullEmpty(stadium.address)) {
        return Left(Exception('Địa chỉ sân vận động không được để trống'));
      }
      if (stadium.capacity! <= 0) {
        return Left(Exception('Sức chứa sân vận động phải lớn hơn 0'));
      }
      if (stadium.ticketPrice! <= 0) {
        return Left(Exception('Giá vé phải lớn hơn 0'));
      }

      return await _stadiumRepository.updateStadium(stadium);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi cập nhật sân vận động: $e');
      }
      return Left(Exception('Lỗi khi cập nhật sân vận động: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteStadium(int id) async {
    try {
      if (id <= 0) {
        return Left(Exception('ID sân vận động không hợp lệ'));
      }

      return await _stadiumRepository.deleteStadium(id);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi xóa sân vận động: $e');
      }
      return Left(Exception('Lỗi khi xóa sân vận động: $e'));
    }
  }

  @override
  Future<Either<Exception, List<StadiumModel>>> generateRandomStadiums(
    int count,
  ) async {
    try {
      if (count <= 0) {
        return Left(Exception('Số lượng sân vận động phải lớn hơn 0'));
      }

      return await _stadiumRepository.generateRandomStadiums(count);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo danh sách sân vận động ngẫu nhiên: $e');
      }
      return Left(
        Exception('Lỗi khi tạo danh sách sân vận động ngẫu nhiên: $e'),
      );
    }
  }
  
  @override
  Future<Either<Exception, List<StadiumModel>>> searchStadiumsByName(String name) async {
    try {
      if (name.isEmpty) {
        return await _stadiumRepository.getStadiums();
      }
      return await _stadiumRepository.searchStadiumsByName(name);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tìm kiếm sân vận động theo tên: $e');
      }
      return Left(Exception('Lỗi khi tìm kiếm sân vận động theo tên: $e'));
    }
  }
}
