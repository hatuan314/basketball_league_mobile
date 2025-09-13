import 'package:baseketball_league_mobile/data/models/match/match_referee_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match/match_referee_model.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức API để quản lý trọng tài cho trận đấu
abstract class MatchRefereeApi {
  /// Thêm mới trọng tài cho trận đấu
  /// [matchRefereeModel] là thông tin trọng tài cho trận đấu
  Future<Either<Exception, MatchRefereeModel>> createMatchReferee(
    MatchRefereeModel matchRefereeModel,
  );

  /// Lấy danh sách trọng tài cho trận đấu
  /// [matchId] là ID của trận đấu (tùy chọn)
  Future<Either<Exception, List<MatchRefereeModel>>> getMatchReferees({
    int? matchId,
  });

  /// Xóa trọng tài khỏi trận đấu
  /// [id] là ID của bản ghi match_referee
  Future<Either<Exception, bool>> deleteMatchReferee(String id);

  /// Lấy thông tin chi tiết của trọng tài theo trận đấu
  ///
  /// Hàm này sẽ trả về danh sách chi tiết của các trọng tài được phân công cho một trận đấu cụ thể,
  /// bao gồm cả thông tin về trận đấu, vòng đấu, mùa giải và phí trọng tài.
  ///
  /// [matchId] là ID của trận đấu cần lấy thông tin trọng tài
  ///
  /// Trả về danh sách thông tin chi tiết của trọng tài nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<MatchRefereeDetailModel>>>
  getMatchRefereeDetailsByMatchId(int matchId);
}
