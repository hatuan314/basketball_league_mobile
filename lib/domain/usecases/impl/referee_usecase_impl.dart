import 'package:baseketball_league_mobile/domain/entities/referee/referee_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/referee/referee_monthly_salary_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/referee_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/referee_usecase.dart';
import 'package:dartz/dartz.dart';

/// Triển khai các phương thức usecase để quản lý thông tin trọng tài
class RefereeUsecaseImpl implements RefereeUsecase {
  final RefereeRepository _refereeRepository;

  /// Constructor
  RefereeUsecaseImpl({required RefereeRepository refereeRepository})
    : _refereeRepository = refereeRepository;

  @override
  Future<Either<Exception, List<RefereeEntity>>> getRefereeList() async {
    try {
      // Gọi repository để lấy danh sách trọng tài
      return await _refereeRepository.getRefereeList();
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> createReferee(RefereeEntity referee) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (referee.fullName == null || referee.fullName!.isEmpty) {
        return Left(Exception('Tên trọng tài không được để trống'));
      }

      if (referee.email == null || referee.email!.isEmpty) {
        return Left(Exception('Email trọng tài không được để trống'));
      }

      // Kiểm tra định dạng email
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(referee.email!)) {
        return Left(Exception('Email không đúng định dạng'));
      }

      // Gọi repository để tạo mới trọng tài
      return await _refereeRepository.createReferee(referee);
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

      if (referee.fullName == null || referee.fullName!.isEmpty) {
        return Left(Exception('Tên trọng tài không được để trống'));
      }

      if (referee.email == null || referee.email!.isEmpty) {
        return Left(Exception('Email trọng tài không được để trống'));
      }

      // Kiểm tra định dạng email
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(referee.email!)) {
        return Left(Exception('Email không đúng định dạng'));
      }

      // Gọi repository để cập nhật thông tin trọng tài
      return await _refereeRepository.updateReferee(id, referee);
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

      // Gọi repository để xóa trọng tài
      return await _refereeRepository.deleteReferee(id);
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

      // Gọi repository để tìm kiếm trọng tài
      return await _refereeRepository.searchReferee(name);
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

      // Gọi repository để lấy thông tin chi tiết của trọng tài
      return await _refereeRepository.getRefereeById(refereeId);
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin chi tiết trọng tài: $e'));
    }
  }

  @override
  Future<Either<Exception, int>> generateMockRefereeData() async {
    try {
      // Gọi repository để tự động thêm dữ liệu trọng tài từ data mock
      return await _refereeRepository.generateMockRefereeData();
    } catch (e) {
      return Left(Exception('Lỗi khi thêm dữ liệu trọng tài từ data mock: $e'));
    }
  }

  @override
  Future<Either<Exception, List<RefereeMonthlySalaryEntity>>>
  getRefereeMonthlySalaryListById(int refereeId) async {
    try {
      // Gọi repository để lấy danh sách lương của trọng tài theo tháng
      return await _refereeRepository.getRefereeMonthlySalaryListById(
        refereeId,
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách lương của trọng tài theo tháng: $e'),
      );
    }
  }
}
