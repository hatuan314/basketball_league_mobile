import 'package:baseketball_league_mobile/data/datasources/mock/referee_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/referee_api.dart';
import 'package:baseketball_league_mobile/data/models/referee_model.dart';
import 'package:baseketball_league_mobile/domain/entities/referee_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/referee_repository.dart';
import 'package:dartz/dartz.dart';

/// Triển khai các phương thức repository để quản lý thông tin trọng tài
class RefereeRepositoryImpl implements RefereeRepository {
  final RefereeApi _refereeApi;

  /// Constructor
  RefereeRepositoryImpl({required RefereeApi refereeApi})
    : _refereeApi = refereeApi;

  @override
  Future<Either<Exception, List<RefereeEntity>>> getRefereeList() async {
    try {
      // Gọi API để lấy danh sách trọng tài
      final result = await _refereeApi.getRefereeList();

      return result.fold((exception) => Left(exception), (refereeModels) {
        // Chuyển đổi từ model sang entity
        final refereeEntities =
            refereeModels.map((model) => model.toEntity()).toList();
        return Right(refereeEntities);
      });
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> createReferee(RefereeEntity referee) async {
    try {
      // Chuyển đổi từ entity sang model
      final refereeModel = RefereeModel.fromEntity(referee);

      // Gọi API để tạo mới trọng tài
      final result = await _refereeApi.createReferee(refereeModel);

      return result;
    } catch (e) {
      return Left(Exception('Lỗi khi tạo mới trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateReferee(
    int id,
    RefereeEntity referee,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (id <= 0) {
        return Left(Exception('ID trọng tài không hợp lệ'));
      }

      // Chuyển đổi từ entity sang model
      final refereeModel = RefereeModel.fromEntity(referee);

      // Gọi API để cập nhật thông tin trọng tài
      final result = await _refereeApi.updateReferee(id, refereeModel);

      return result;
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật thông tin trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteReferee(int id) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (id <= 0) {
        return Left(Exception('ID trọng tài không hợp lệ'));
      }

      // Gọi API để xóa trọng tài
      final result = await _refereeApi.deleteReferee(id);

      return result;
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, List<RefereeEntity>>> searchReferee(
    String name,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (name.isEmpty) {
        return Left(Exception('Tên tìm kiếm không được để trống'));
      }

      // Gọi API để tìm kiếm trọng tài
      final result = await _refereeApi.searchReferee(name);

      return result.fold((exception) => Left(exception), (refereeModels) {
        // Chuyển đổi từ model sang entity
        final refereeEntities =
            refereeModels.map((model) => model.toEntity()).toList();
        return Right(refereeEntities);
      });
    } catch (e) {
      return Left(Exception('Lỗi khi tìm kiếm trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, RefereeEntity?>> getRefereeById(
    int refereeId,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (refereeId <= 0) {
        return Left(Exception('ID trọng tài không hợp lệ'));
      }

      // Gọi API để lấy thông tin chi tiết của trọng tài
      final result = await _refereeApi.getRefereeById(refereeId);

      return result.fold((exception) => Left(exception), (refereeModel) {
        // Chuyển đổi từ model sang entity nếu có dữ liệu
        if (refereeModel == null) {
          return const Right(null);
        }
        return Right(refereeModel.toEntity());
      });
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin chi tiết trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, int>> generateMockRefereeData() async {
    try {
      // Thêm các trọng tài mới vào database
      int successCount = 0;
      final results = <Future<Either<Exception, bool>>>[];

      for (final referee in mockReferees) {
        results.add(_refereeApi.createReferee(referee));
      }

      // Đợi tất cả các thao tác thêm hoàn tất
      final createResults = await Future.wait(results);

      // Đếm số lượng thêm thành công
      for (final result in createResults) {
        result.fold(
          (exception) => null, // Bỏ qua các lỗi
          (success) {
            if (success) {
              successCount++;
            }
          },
        );
      }

      return Right(successCount);
    } catch (e) {
      return Left(Exception('Lỗi khi thêm dữ liệu trọng tài từ data mock: $e'));
    }
  }
}
