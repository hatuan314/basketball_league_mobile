import 'package:baseketball_league_mobile/data/models/match_player_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match_player_model.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức API để quản lý thông tin cầu thủ trong trận đấu
abstract class MatchPlayerApi {
  /// Tạo mới thông tin cầu thủ trong trận đấu
  ///
  /// [matchPlayerModel]: Thông tin cầu thủ trong trận đấu cần tạo
  ///
  /// Trả về ID của bản ghi vừa tạo nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, int>> createMatchPlayer(
    MatchPlayerModel matchPlayerModel,
  );

  /// Lấy danh sách thông tin cầu thủ trong trận đấu
  ///
  /// [matchId]: ID của trận đấu (tùy chọn)
  /// [seasonPlayerId]: ID của cầu thủ trong mùa giải (tùy chọn)
  ///
  /// Trả về danh sách thông tin cầu thủ trong trận đấu nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<MatchPlayerModel>>> getMatchPlayers({
    int? matchId,
    int? seasonPlayerId,
  });

  /// Lấy thông tin chi tiết của một cầu thủ trong trận đấu
  ///
  /// [matchPlayerId]: ID của bản ghi cầu thủ trong trận đấu
  ///
  /// Trả về thông tin chi tiết của cầu thủ trong trận đấu nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, MatchPlayerModel?>> getMatchPlayerById(
    int matchPlayerId,
  );

  /// Cập nhật thông tin cầu thủ trong trận đấu
  ///
  /// [matchPlayerModel]: Thông tin cầu thủ trong trận đấu cần cập nhật
  ///
  /// Trả về Unit nếu cập nhật thành công hoặc Exception nếu thất bại
  Future<Either<Exception, Unit>> updateMatchPlayer(
    MatchPlayerModel matchPlayerModel,
  );

  /// Xóa thông tin cầu thủ trong trận đấu
  ///
  /// [matchPlayerId]: ID của bản ghi cầu thủ trong trận đấu cần xóa
  ///
  /// Trả về Unit nếu xóa thành công hoặc Exception nếu thất bại
  Future<Either<Exception, Unit>> deleteMatchPlayer(int matchPlayerId);

  /// Lấy danh sách cầu thủ của một đội trong một trận đấu
  ///
  /// [matchId]: ID của trận đấu
  /// [teamId]: ID của đội bóng
  ///
  /// Trả về danh sách thông tin cầu thủ trong trận đấu nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<MatchPlayerModel>>> getTeamPlayersInMatch(
    int matchId,
    int teamId,
  );

  /// Lấy danh sách thông tin chi tiết cầu thủ của một đội trong một trận đấu
  ///
  /// [matchId]: ID của trận đấu
  /// [teamId]: ID của đội bóng
  ///
  /// Trả về danh sách thông tin chi tiết cầu thủ trong trận đấu nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, List<MatchPlayerDetailModel>>>
  getTeamPlayersDetailInMatch(int matchId, int teamId);
}
