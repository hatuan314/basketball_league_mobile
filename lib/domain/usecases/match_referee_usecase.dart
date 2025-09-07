import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_entity.dart';
import 'package:dartz/dartz.dart';

/// Use case định nghĩa các phương thức để quản lý trọng tài cho trận đấu
abstract class MatchRefereeUseCase {
  /// Thêm mới trọng tài cho trận đấu
  /// [matchRefereeEntity] là thông tin trọng tài cho trận đấu
  Future<Either<Exception, MatchRefereeEntity>> createMatchReferee(
    MatchRefereeEntity matchRefereeEntity,
  );

  /// Lấy danh sách trọng tài cho trận đấu
  /// [matchId] là ID của trận đấu (tùy chọn)
  Future<Either<Exception, List<MatchRefereeEntity>>> getMatchReferees({
    int? matchId,
  });

  /// Xóa trọng tài khỏi trận đấu
  /// [id] là ID của bản ghi match_referee
  Future<Either<Exception, bool>> deleteMatchReferee(String id);
  
  /// Tự động phân công trọng tài cho trận đấu
  /// 
  /// Một trận đấu có 4 trọng tài, trong đó có 3 trọng tài chính và 1 trọng tài bàn
  /// Một trọng tài chỉ được điều khiển tối đa 1 trận đấu trong mỗi vòng đấu
  /// Một trọng tài có thể tham gia điều khiển trận đấu với vai trò khác nhau trong các trận đấu khác nhau
  /// 
  /// [roundId] là ID của vòng đấu
  /// [matchId] là ID của trận đấu cần phân công trọng tài
  /// 
  /// Trả về danh sách các trọng tài đã được phân công cho trận đấu
  Future<Either<Exception, List<MatchRefereeEntity>>> generateMatchReferees({
    required int roundId,
    required int matchId,
  });
  
  /// Lấy thông tin chi tiết của trọng tài theo trận đấu
  /// 
  /// Hàm này sẽ trả về danh sách chi tiết của các trọng tài được phân công cho một trận đấu cụ thể,
  /// bao gồm cả thông tin về trận đấu, vòng đấu, mùa giải và phí trọng tài.
  /// 
  /// [matchId] là ID của trận đấu cần lấy thông tin trọng tài
  /// 
  /// Trả về danh sách thông tin chi tiết của trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<MatchRefereeDetailEntity>>> getMatchRefereeDetailsByMatchId(int matchId);
}
