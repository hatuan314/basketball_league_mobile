import 'package:baseketball_league_mobile/data/models/match_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match_model.dart';
import 'package:dartz/dartz.dart';

abstract class MatchApi {
  /// Tạo một trận đấu mới
  Future<Either<Exception, MatchModel>> createMatch(MatchModel match);

  /// Lấy danh sách trận đấu theo vòng đấu
  /// [roundId] là ID của vòng đấu, nếu null sẽ lấy tất cả trận đấu
  Future<Either<Exception, List<MatchModel>>> getMatches({int? roundId});

  /// Lấy thông tin chi tiết của một trận đấu
  Future<Either<Exception, MatchModel>> getMatchById(int id);

  /// Cập nhật thông tin trận đấu
  Future<Either<Exception, MatchModel>> updateMatch(MatchModel match);

  /// Xóa trận đấu theo ID
  Future<Either<Exception, bool>> deleteMatch(int id);

  /// Tạo nhiều trận đấu cho một vòng đấu
  Future<Either<Exception, List<MatchModel>>> generateMatches(int roundId);

  /// Lấy thông tin chi tiết của các trận đấu theo vòng đấu
  /// Bao gồm thông tin về đội bóng, sân vận động, mùa giải, vòng đấu
  /// [roundId] là ID của vòng đấu
  Future<Either<Exception, List<MatchDetailModel>>> getMatchDetailByRoundId(
    int roundId, {
    int? matchId,
  });

  /// Cập nhật tỉ số và số lỗi của trận đấu
  /// [matchId] là ID của trận đấu cần cập nhật
  /// [homeScore] là điểm số của đội nhà
  /// [awayScore] là điểm số của đội khách
  /// [homeFouls] là số lỗi của đội nhà (tùy chọn)
  /// [awayFouls] là số lỗi của đội khách (tùy chọn)
  /// [attendance] là số lượng người xem (tùy chọn)
  /// Trả về thông tin trận đấu sau khi cập nhật
  /// Lưu ý: Kết quả trận đấu chỉ có thắng hoặc thua, không có hòa
  Future<Either<Exception, MatchModel>> updateMatchScore({
    required int matchId,
    required int homeScore,
    required int awayScore,
    int? homeFouls,
    int? awayFouls,
    int? attendance,
  });
}
