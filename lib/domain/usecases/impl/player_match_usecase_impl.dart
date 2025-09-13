import 'package:baseketball_league_mobile/domain/match/match_player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/match/match_player_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_match_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_match_usecase.dart';
import 'package:dartz/dartz.dart';

/// Triển khai các phương thức usecase để quản lý thông tin cầu thủ trong trận đấu
class PlayerMatchUseCaseImpl implements PlayerMatchUseCase {
  /// Repository để quản lý thông tin cầu thủ trong trận đấu
  final PlayerMatchRepository _playerMatchRepository;

  /// Constructor
  PlayerMatchUseCaseImpl(this._playerMatchRepository);

  @override
  Future<Either<Exception, int>> createPlayerMatch(
    MatchPlayerEntity matchPlayerEntity,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (matchPlayerEntity.matchId == null) {
      return Left(Exception('ID trận đấu không được để trống'));
    }

    if (matchPlayerEntity.playerSeasonId == null) {
      return Left(Exception('ID cầu thủ không được để trống'));
    }

    // Gọi repository để tạo thông tin cầu thủ trong trận đấu
    return _playerMatchRepository.createPlayerMatch(matchPlayerEntity);
  }

  @override
  Future<Either<Exception, List<MatchPlayerEntity>>> getPlayerMatches({
    int? matchId,
    int? seasonPlayerId,
  }) async {
    // Gọi repository để lấy danh sách thông tin cầu thủ trong trận đấu
    return _playerMatchRepository.getPlayerMatches(
      matchId: matchId,
      seasonPlayerId: seasonPlayerId,
    );
  }

  @override
  Future<Either<Exception, MatchPlayerEntity?>> getPlayerMatchById(
    int playerMatchId,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (playerMatchId <= 0) {
      return Left(
        Exception('ID thông tin cầu thủ trong trận đấu không hợp lệ'),
      );
    }

    // Gọi repository để lấy thông tin chi tiết của một cầu thủ trong trận đấu
    return _playerMatchRepository.getPlayerMatchById(playerMatchId);
  }

  @override
  Future<Either<Exception, Unit>> updatePlayerMatch(
    MatchPlayerEntity playerMatchEntity,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (playerMatchEntity.id == null) {
      return Left(
        Exception('ID thông tin cầu thủ trong trận đấu không được để trống'),
      );
    }

    // Gọi repository để cập nhật thông tin cầu thủ trong trận đấu
    return _playerMatchRepository.updatePlayerMatch(playerMatchEntity);
  }

  @override
  Future<Either<Exception, Unit>> deletePlayerMatch(int playerMatchId) async {
    // Kiểm tra dữ liệu đầu vào
    if (playerMatchId <= 0) {
      return Left(
        Exception('ID thông tin cầu thủ trong trận đấu không hợp lệ'),
      );
    }

    // Gọi repository để xóa thông tin cầu thủ trong trận đấu
    return _playerMatchRepository.deletePlayerMatch(playerMatchId);
  }

  @override
  Future<Either<Exception, List<MatchPlayerEntity>>> getTeamPlayersInMatch(
    int matchId,
    int teamId,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (matchId <= 0) {
      return Left(Exception('ID trận đấu không hợp lệ'));
    }

    if (teamId <= 0) {
      return Left(Exception('ID đội bóng không hợp lệ'));
    }

    // Gọi repository để lấy danh sách cầu thủ của một đội trong trận đấu
    return _playerMatchRepository.getTeamPlayersInMatch(matchId, teamId);
  }

  @override
  Future<Either<Exception, List<int>>> autoRegisterPlayersForMatch(
    int matchId,
    int matchPlayerId,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (matchId <= 0) {
      return Left(Exception('ID trận đấu không hợp lệ'));
    }

    if (matchPlayerId <= 0) {
      return Left(
        Exception('ID thông tin cầu thủ trong trận đấu không hợp lệ'),
      );
    }

    // Gọi repository để tự động thêm cầu thủ vào trận đấu
    return _playerMatchRepository.autoRegisterPlayersForMatch(
      matchId,
      matchPlayerId,
    );
  }

  @override
  Future<Either<Exception, List<MatchPlayerDetailEntity>>>
  getTeamPlayersDetailInMatch(int matchId, int teamId) {
    return _playerMatchRepository.getTeamPlayersDetailInMatch(matchId, teamId);
  }
}
