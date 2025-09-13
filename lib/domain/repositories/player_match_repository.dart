import 'package:baseketball_league_mobile/domain/match/match_player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/match/match_player_entity.dart';
import 'package:dartz/dartz.dart';

/// Interface định nghĩa các phương thức repository để quản lý thông tin cầu thủ trong trận đấu
abstract class PlayerMatchRepository {
  /// Tạo thông tin cầu thủ trong trận đấu mới
  ///
  /// [playerMatchEntity] Thông tin cầu thủ trong trận đấu cần tạo
  /// Trả về ID của bản ghi vừa tạo hoặc Exception nếu có lỗi
  Future<Either<Exception, int>> createPlayerMatch(
    MatchPlayerEntity playerMatchEntity,
  );

  /// Lấy danh sách thông tin cầu thủ trong trận đấu
  ///
  /// [matchId] ID của trận đấu (tùy chọn)
  /// [seasonPlayerId] ID của cầu thủ (tùy chọn)
  /// Trả về danh sách thông tin cầu thủ trong trận đấu hoặc Exception nếu có lỗi
  Future<Either<Exception, List<MatchPlayerEntity>>> getPlayerMatches({
    int? matchId,
    int? seasonPlayerId,
  });

  /// Lấy danh sách thông tin cầu thủ của một đội trong trận đấu
  ///
  /// [matchId] ID của trận đấu
  /// [teamId] ID của đội bóng
  /// Trả về danh sách thông tin cầu thủ trong trận đấu hoặc Exception nếu có lỗi
  Future<Either<Exception, List<MatchPlayerEntity>>> getTeamPlayersInMatch(
    int matchId,
    int teamId,
  );

  /// Lấy thông tin chi tiết của một cầu thủ trong trận đấu
  ///
  /// [playerMatchId] ID của thông tin cầu thủ trong trận đấu
  /// Trả về thông tin chi tiết của cầu thủ trong trận đấu hoặc Exception nếu có lỗi
  Future<Either<Exception, MatchPlayerEntity?>> getPlayerMatchById(
    int playerMatchId,
  );

  /// Cập nhật thông tin cầu thủ trong trận đấu
  ///
  /// [playerMatchEntity] Thông tin cầu thủ trong trận đấu cần cập nhật
  /// Trả về Unit nếu thành công hoặc Exception nếu có lỗi
  Future<Either<Exception, Unit>> updatePlayerMatch(
    MatchPlayerEntity playerMatchEntity,
  );

  /// Xóa thông tin cầu thủ trong trận đấu
  ///
  /// [playerMatchId] ID của thông tin cầu thủ trong trận đấu cần xóa
  /// Trả về Unit nếu thành công hoặc Exception nếu có lỗi
  Future<Either<Exception, Unit>> deletePlayerMatch(int playerMatchId);

  /// Tự động thêm cầu thủ vào trận đấu
  ///
  /// [matchId] ID của trận đấu
  /// [seasonPlayerId] ID của cầu thủ trong mùa giải
  /// Trả về danh sách ID của các bản ghi vừa tạo hoặc Exception nếu có lỗi
  Future<Either<Exception, List<int>>> autoRegisterPlayersForMatch(
    int matchId,
    int seasonPlayerId,
  );

  /// Lấy danh sách thông tin chi tiết cầu thủ của một đội trong một trận đấu
  ///
  /// [matchId] ID của trận đấu
  /// [teamId] ID của đội bóng
  /// Trả về danh sách thông tin chi tiết cầu thủ trong trận đấu hoặc Exception nếu có lỗi
  Future<Either<Exception, List<MatchPlayerDetailEntity>>>
  getTeamPlayersDetailInMatch(int matchId, int teamId);
}
