import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository để quản lý các trận đấu
abstract class MatchRepository {
  /// Tạo một trận đấu mới
  Future<Either<Exception, MatchEntity>> createMatch(MatchEntity match);

  /// Lấy danh sách trận đấu theo vòng đấu
  /// [roundId] là ID của vòng đấu, nếu null sẽ lấy tất cả trận đấu
  Future<Either<Exception, List<MatchEntity>>> getMatches({int? roundId});

  /// Lấy thông tin chi tiết của một trận đấu
  Future<Either<Exception, MatchEntity>> getMatchById(int id);

  /// Cập nhật thông tin trận đấu
  Future<Either<Exception, MatchEntity>> updateMatch(MatchEntity match);

  /// Xóa trận đấu theo ID
  Future<Either<Exception, bool>> deleteMatch(int id);

  /// Tạo nhiều trận đấu cho một vòng đấu
  Future<Either<Exception, List<MatchEntity>>> generateMatches(int roundId);

  /// Lấy thông tin chi tiết của các trận đấu theo vòng đấu
  /// Bao gồm thông tin về đội bóng, sân vận động, mùa giải, vòng đấu
  /// [roundId] là ID của vòng đấu
  Future<Either<Exception, List<MatchDetailEntity>>> getMatchDetailByRoundId(
    int roundId, {
    int? matchId,
  });
}
