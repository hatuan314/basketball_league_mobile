import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:dartz/dartz.dart';

/// UseCase cho Stadium
abstract class StadiumUseCase {
  /// Tạo bảng stadium trong database
  Future<Either<Exception, bool>> createTable();

  /// Lấy danh sách tất cả sân vận động
  Future<Either<Exception, List<StadiumModel>>> getStadiums();

  /// Lấy thông tin chi tiết của một sân vận động theo ID
  Future<Either<Exception, StadiumModel?>> getStadiumById(int id);

  /// Tạo mới một sân vận động
  Future<Either<Exception, bool>> createStadium(StadiumModel stadium);

  /// Cập nhật thông tin sân vận động
  Future<Either<Exception, bool>> updateStadium(StadiumModel stadium);

  /// Xóa sân vận động theo ID
  Future<Either<Exception, bool>> deleteStadium(int id);

  /// Tạo danh sách sân vận động ngẫu nhiên từ dữ liệu mẫu
  Future<Either<Exception, List<StadiumModel>>> generateRandomStadiums(int count);
  
  /// Tìm kiếm sân vận động theo tên
  Future<Either<Exception, List<StadiumModel>>> searchStadiumsByName(String name);
}
