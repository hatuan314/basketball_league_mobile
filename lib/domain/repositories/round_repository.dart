import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository định nghĩa các phương thức quản lý vòng đấu
abstract class RoundRepository {
  /// Tạo vòng đấu mới
  /// 
  /// Trả về [RoundEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, RoundEntity>> createRound(RoundEntity round);

  /// Lấy danh sách vòng đấu theo mùa giải
  /// 
  /// [seasonId] ID của mùa giải (có thể null để lấy tất cả vòng đấu)
  /// 
  /// Trả về danh sách [RoundEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<RoundEntity>>> getRounds({int? seasonId});

  /// Lấy thông tin chi tiết của một vòng đấu
  /// 
  /// [id] ID của vòng đấu
  /// 
  /// Trả về [RoundEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, RoundEntity>> getRoundById(int id);

  /// Cập nhật thông tin vòng đấu
  /// 
  /// Trả về [RoundEntity] đã cập nhật nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, RoundEntity>> updateRound(RoundEntity round);

  /// Xóa vòng đấu theo ID
  /// 
  /// Trả về [Unit] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, Unit>> deleteRound(int id);
  
  /// Tạo nhiều vòng đấu cho một mùa giải
  /// 
  /// [seasonId] ID của mùa giải
  /// 
  /// Số lượng vòng đấu tự động tính dựa vào số lượng đội tham gia trong giải
  /// Thời gian bắt đầu vòng đầu tiên là thời gian bắt đầu giải
  /// Thời gian tổ chức giữa 2 vòng đấu là 1 tuần
  /// 
  /// Trả về danh sách [RoundEntity] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<RoundEntity>>> generateRounds({
    required int seasonId,
  });
}
