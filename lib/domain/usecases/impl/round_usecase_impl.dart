import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/round_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/round_usecase.dart';
import 'package:dartz/dartz.dart';

class RoundUseCaseImpl implements RoundUseCase {
  final RoundRepository _repository;

  RoundUseCaseImpl(this._repository);

  @override
  Future<Either<Exception, RoundEntity>> createRound(RoundEntity round) async {
    // Kiểm tra dữ liệu đầu vào
    if (round.seasonId == null || round.roundNo == null) {
      return Left(
        Exception('Thiếu thông tin bắt buộc: seasonId hoặc roundNo'),
      );
    }

    // Kiểm tra số thứ tự vòng đấu
    if (round.roundNo! <= 0) {
      return Left(Exception('Số thứ tự vòng đấu phải lớn hơn 0'));
    }

    // Kiểm tra ngày bắt đầu và kết thúc
    if (round.startDate != null && round.endDate != null) {
      if (round.startDate!.isAfter(round.endDate!)) {
        return Left(
          Exception('Ngày bắt đầu không thể sau ngày kết thúc'),
        );
      }
    }

    // Gọi repository để tạo vòng đấu
    return await _repository.createRound(round);
  }

  @override
  Future<Either<Exception, Unit>> deleteRound(int id) async {
    // Kiểm tra ID
    if (id <= 0) {
      return Left(Exception('ID vòng đấu không hợp lệ'));
    }

    // Gọi repository để xóa vòng đấu
    return await _repository.deleteRound(id);
  }

  @override
  Future<Either<Exception, List<RoundEntity>>> generateRounds({
    required int seasonId,
  }) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonId <= 0) {
      return Left(Exception('ID mùa giải không hợp lệ'));
    }

    // Gọi repository để tạo nhiều vòng đấu
    // Tất cả logic tính toán đã được chuyển xuống repository
    return await _repository.generateRounds(seasonId: seasonId);
  }

  @override
  Future<Either<Exception, RoundEntity>> getRoundById(int id) async {
    // Kiểm tra ID
    if (id <= 0) {
      return Left(Exception('ID vòng đấu không hợp lệ'));
    }

    // Gọi repository để lấy thông tin vòng đấu
    return await _repository.getRoundById(id);
  }

  @override
  Future<Either<Exception, List<RoundEntity>>> getRounds({
    int? seasonId,
  }) async {
    // Kiểm tra seasonId nếu có
    if (seasonId != null && seasonId <= 0) {
      return Left(Exception('ID mùa giải không hợp lệ'));
    }

    // Gọi repository để lấy danh sách vòng đấu
    return await _repository.getRounds(seasonId: seasonId);
  }

  @override
  Future<Either<Exception, RoundEntity>> updateRound(RoundEntity round) async {
    // Kiểm tra ID
    if (round.id == null || round.id! <= 0) {
      return Left(Exception('ID vòng đấu không hợp lệ'));
    }

    // Kiểm tra dữ liệu đầu vào
    if (round.seasonId == null || round.roundNo == null) {
      return Left(
        Exception('Thiếu thông tin bắt buộc: seasonId hoặc roundNo'),
      );
    }

    // Kiểm tra số thứ tự vòng đấu
    if (round.roundNo! <= 0) {
      return Left(Exception('Số thứ tự vòng đấu phải lớn hơn 0'));
    }

    // Kiểm tra ngày bắt đầu và kết thúc
    if (round.startDate != null && round.endDate != null) {
      if (round.startDate!.isAfter(round.endDate!)) {
        return Left(
          Exception('Ngày bắt đầu không thể sau ngày kết thúc'),
        );
      }
    }

    // Gọi repository để cập nhật vòng đấu
    return await _repository.updateRound(round);
  }
}
