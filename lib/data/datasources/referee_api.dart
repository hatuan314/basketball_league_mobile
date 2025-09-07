import 'package:baseketball_league_mobile/data/models/referee_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/referee_model.dart';
import 'package:baseketball_league_mobile/data/models/referee_phone_model.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức API để quản lý thông tin trọng tài
abstract class RefereeApi {
  /// Lấy danh sách trọng tài
  ///
  /// Trả về danh sách trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<RefereeModel>>> getRefereeList();

  /// Tạo mới trọng tài
  ///
  /// [referee]: Thông tin trọng tài cần tạo
  ///
  /// Trả về true nếu tạo thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> createReferee(RefereeModel referee);

  /// Cập nhật thông tin trọng tài
  ///
  /// [id]: ID của trọng tài cần cập nhật
  /// [referee]: Thông tin trọng tài mới
  ///
  /// Trả về true nếu cập nhật thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> updateReferee(int id, RefereeModel referee);

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
  Future<Either<Exception, List<RefereeModel>>> searchReferee(String name);
  
  /// Lấy thông tin chi tiết của một trọng tài theo ID
  ///
  /// [refereeId]: ID của trọng tài cần lấy thông tin
  ///
  /// Trả về thông tin trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, RefereeModel?>> getRefereeById(int refereeId);
  
  /// Thêm số điện thoại cho trọng tài
  ///
  /// [refereePhone]: Thông tin số điện thoại cần thêm
  ///
  /// Trả về true nếu thêm thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> addRefereePhone(RefereePhoneModel refereePhone);
  
  /// Cập nhật số điện thoại cho trọng tài
  ///
  /// [refereeId]: ID của trọng tài
  /// [oldPhone]: Số điện thoại cũ cần cập nhật
  /// [refereePhone]: Thông tin số điện thoại mới
  ///
  /// Trả về true nếu cập nhật thành công hoặc Exception nếu thất bại
  Future<Either<Exception, bool>> updateRefereePhone(
    int refereeId,
    String oldPhone,
    RefereePhoneModel refereePhone,
  );
  
  /// Lấy danh sách thông tin chi tiết của trọng tài (bao gồm số điện thoại)
  ///
  /// Trả về danh sách thông tin chi tiết trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<RefereeDetailModel>>> getRefereeDetailList();
  
  /// Lấy thông tin chi tiết của một trọng tài theo ID (bao gồm số điện thoại)
  ///
  /// [refereeId]: ID của trọng tài cần lấy thông tin
  ///
  /// Trả về thông tin chi tiết trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, RefereeDetailModel?>> getRefereeDetailById(int refereeId);
}
