import 'package:baseketball_league_mobile/domain/entities/referee/referee_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/referee/referee_monthly_salary_entity.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức repository để quản lý thông tin trọng tài
abstract class RefereeRepository {
  /// Lấy danh sách trọng tài
  ///
  /// Trả về danh sách trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<RefereeEntity>>> getRefereeList();

  /// Tạo mới trọng tài
  ///
  /// [referee]: Thông tin trọng tài cần tạo
  ///
  /// Trả về true nếu tạo thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> createReferee(RefereeEntity referee);

  /// Cập nhật thông tin trọng tài
  ///
  /// [id]: ID của trọng tài cần cập nhật
  /// [referee]: Thông tin trọng tài mới
  ///
  /// Trả về true nếu cập nhật thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> updateReferee(int id, RefereeEntity referee);

  /// Xóa trọng tài
  ///
  /// [id]: ID của trọng tài cần xóa
  ///
  /// Trả về true nếu xóa thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> deleteReferee(int id);

  /// Tìm kiếm trọng tài theo tên
  ///
  /// [name]: Tên trọng tài cần tìm
  ///
  /// Trả về danh sách trọng tài phù hợp nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<RefereeEntity>>> searchReferee(String name);

  /// Lấy thông tin chi tiết của một trọng tài theo ID
  ///
  /// [refereeId]: ID của trọng tài cần lấy thông tin
  ///
  /// Trả về thông tin trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, RefereeEntity?>> getRefereeById(int refereeId);

  /// Tự động thêm dữ liệu trọng tài từ data mock vào database
  ///
  /// Trả về số lượng bản ghi đã thêm thành công nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, int>> generateMockRefereeData();

  /// Lấy danh sách lương của trọng tài theo tháng
  ///
  /// [refereeId]: ID của trọng tài cần lấy thông tin
  ///
  /// Trả về danh sách lương của trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<RefereeMonthlySalaryEntity>>>
  getRefereeMonthlySalaryListById(int refereeId);
}
