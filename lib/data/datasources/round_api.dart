import 'package:baseketball_league_mobile/data/models/round/top_scores_by_round_model.dart';
import 'package:baseketball_league_mobile/data/models/round_model.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức quản lý vòng đấu
abstract class RoundApi {
  /// Tạo vòng đấu mới
  ///
  /// Trả về [RoundModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, RoundModel>> createRound(RoundModel round);

  /// Lấy danh sách vòng đấu theo mùa giải
  ///
  /// [seasonId] ID của mùa giải (có thể null để lấy tất cả vòng đấu)
  ///
  /// Trả về danh sách [RoundModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<RoundModel>>> getRounds({int? seasonId});

  /// Lấy thông tin chi tiết của một vòng đấu
  ///
  /// [id] ID của vòng đấu
  ///
  /// Trả về [RoundModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, RoundModel>> getRoundById(int id);

  /// Cập nhật thông tin vòng đấu
  ///
  /// Trả về [RoundModel] đã cập nhật nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, RoundModel>> updateRound(RoundModel round);

  /// Xóa vòng đấu theo ID
  ///
  /// Trả về [Unit] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, Unit>> deleteRound(int id);

  /// Tạo nhiều vòng đấu cho một mùa giải
  ///
  /// [seasonId] ID của mùa giải
  /// [numberOfRounds] Số lượng vòng đấu cần tạo
  /// [startDate] Ngày bắt đầu của vòng đấu đầu tiên
  /// [daysBetweenRounds] Số ngày giữa các vòng đấu
  ///
  /// Trả về danh sách [RoundModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, List<RoundModel>>> generateRounds({
    required int seasonId,
    required int numberOfRounds,
    required DateTime startDate,
    required int daysBetweenRounds,
  });

  /// Lấy cầu thủ có điểm số cao nhất trong vòng đấu
  ///
  /// [seasonId] ID của mùa giải (có thể null để lấy tất cả mùa giải)
  /// [roundId] ID của vòng đấu (có thể null để lấy tất cả vòng đấu)
  ///
  /// Trả về [TopScoresByRoundModel] nếu thành công hoặc [Exception] nếu thất bại
  Future<Either<Exception, TopScoresByRoundModel?>> getTopScoresByRound({
    int? seasonId,
    int? roundId,
  });
}
