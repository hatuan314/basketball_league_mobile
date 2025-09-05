import 'dart:math';

import 'package:baseketball_league_mobile/data/datasources/mock/stadium_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/stadium_api.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:baseketball_league_mobile/domain/repositories/stadium_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

/// Triển khai của StadiumRepository
class StadiumRepositoryImpl implements StadiumRepository {
  /// StadiumApi để thao tác với dữ liệu
  final StadiumApi _stadiumApi;

  /// Constructor
  StadiumRepositoryImpl(this._stadiumApi);

  @override
  Future<Either<Exception, bool>> createTable() async {
    try {
      return await _stadiumApi.createTable();
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
      return await _stadiumApi.getStadiums();
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
      return await _stadiumApi.getStadiumById(id);
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
      return await _stadiumApi.createStadium(stadium);
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
      return await _stadiumApi.updateStadium(stadium);
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
      return await _stadiumApi.deleteStadium(id);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi xóa sân vận động: $e');
      }
      return Left(Exception('Lỗi khi xóa sân vận động: $e'));
    }
  }

  @override
  Future<Either<Exception, List<StadiumModel>>> generateRandomStadiums(int count) async {
    try {
      // Sử dụng mockStadiumList để tạo danh sách ngẫu nhiên
      final random = Random();
      final List<StadiumModel> randomStadiums = [];
      
      // Đảm bảo count không vượt quá số lượng sân vận động có sẵn
      final actualCount = count > mockStadiumList.length ? mockStadiumList.length : count;
      
      // Tạo một bản sao của danh sách để không ảnh hưởng đến danh sách gốc
      final List<StadiumModel> availableStadiums = List.from(mockStadiumList);
      
      // Chọn ngẫu nhiên các sân vận động từ danh sách có sẵn
      for (int i = 0; i < actualCount; i++) {
        if (availableStadiums.isEmpty) break;
        
        // Chọn một sân vận động ngẫu nhiên từ danh sách còn lại
        final randomIndex = random.nextInt(availableStadiums.length);
        final selectedStadium = availableStadiums[randomIndex];
        
        // Tạo một bản sao của sân vận động đã chọn và thêm vào danh sách kết quả
        final stadium = StadiumModel(
          id: i + 1, // Gán ID mới theo thứ tự
          name: selectedStadium.name,
          address: selectedStadium.address,
          capacity: selectedStadium.capacity,
          ticketPrice: selectedStadium.ticketPrice,
        );
        
        // Thêm vào database thông qua API
        final result = await _stadiumApi.createStadium(stadium);
        
        // Nếu thêm thành công, thêm vào danh sách kết quả
        if (result.isRight()) {
          randomStadiums.add(stadium);
        }
        
        // Loại bỏ sân vận động đã chọn khỏi danh sách để tránh trùng lặp
        availableStadiums.removeAt(randomIndex);
      }
      
      return Right(randomStadiums);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo danh sách sân vận động ngẫu nhiên: $e');
      }
      return Left(Exception('Lỗi khi tạo danh sách sân vận động ngẫu nhiên: $e'));
    }
  }
  
  @override
  Future<Either<Exception, List<StadiumModel>>> searchStadiumsByName(String name) async {
    try {
      return await _stadiumApi.searchStadiumsByName(name);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tìm kiếm sân vận động theo tên: $e');
      }
      return Left(Exception('Lỗi khi tìm kiếm sân vận động theo tên: $e'));
    }
  }
}
