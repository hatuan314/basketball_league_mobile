import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_season_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_season_usecase.dart';
import 'package:dartz/dartz.dart';

/// Triển khai của PlayerSeasonUsecase
class PlayerSeasonUsecaseImpl implements PlayerSeasonUsecase {
  final PlayerSeasonRepository _repository;

  /// Constructor
  PlayerSeasonUsecaseImpl({
    required PlayerSeasonRepository playerSeasonRepository,
  }) : _repository = playerSeasonRepository;

  @override
  Future<Either<Exception, String>> createPlayerSeason(
    PlayerSeasonEntity playerSeason,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (playerSeason.seasonTeamId == null ||
          playerSeason.seasonTeamId! <= 0 ||
          playerSeason.playerId == null ||
          playerSeason.playerId! <= 0) {
        return Left(
          Exception('Thiếu thông tin bắt buộc: seasonTeamId hoặc playerId'),
        );
      }

      // Gọi repository để tạo mới
      return await _repository.createPlayerSeason(playerSeason);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo thông tin cầu thủ theo mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, Unit>> deletePlayerSeason(
    String playerSeasonId,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (playerSeasonId.isEmpty) {
        return Left(Exception('ID thông tin cầu thủ không hợp lệ'));
      }

      // Gọi repository để xóa
      return await _repository.deletePlayerSeason(playerSeasonId);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa thông tin cầu thủ theo mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PlayerSeasonEntity>>> generatePlayerSeasons({
    required int teamId,
    required int seasonId,
    required int seasonTeamId,
  }) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (teamId <= 0) {
        return Left(Exception('ID đội bóng không hợp lệ'));
      }

      if (seasonId <= 0) {
        return Left(Exception('ID mùa giải không hợp lệ'));
      }

      // Gọi repository để tạo cầu thủ tự động
      return await _repository.generatePlayerSeasons(
        teamId: teamId,
        seasonId: seasonId,
        seasonTeamId: seasonTeamId,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tạo tự động danh sách cầu thủ: $e'));
    }
  }

  @override
  Future<Either<Exception, PlayerSeasonEntity?>> getPlayerSeasonById(
    String playerSeasonId,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (playerSeasonId.isEmpty) {
        return Left(Exception('ID thông tin cầu thủ không hợp lệ'));
      }

      // Gọi repository để lấy thông tin chi tiết
      return await _repository.getPlayerSeasonById(playerSeasonId);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy thông tin chi tiết cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<PlayerSeasonEntity>>> getPlayerSeasons({
    int? seasonTeamId,
    int? playerId,
  }) async {
    try {
      // Kiểm tra dữ liệu đầu vào nếu có
      if (seasonTeamId != null && seasonTeamId <= 0) {
        return Left(Exception('ID đội bóng trong mùa giải không hợp lệ'));
      }

      if (playerId != null && playerId <= 0) {
        return Left(Exception('ID cầu thủ không hợp lệ'));
      }

      // Gọi repository để lấy danh sách
      return await _repository.getPlayerSeasons(
        seasonTeamId: seasonTeamId,
        playerId: playerId,
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách thông tin cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> updatePlayerSeason(
    PlayerSeasonEntity playerSeason,
  ) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (playerSeason.id == null || playerSeason.id!.isEmpty) {
        return Left(Exception('ID thông tin cầu thủ không hợp lệ'));
      }

      if (playerSeason.seasonTeamId == null ||
          playerSeason.seasonTeamId! <= 0 ||
          playerSeason.playerId == null ||
          playerSeason.playerId! <= 0) {
        return Left(
          Exception('Thiếu thông tin bắt buộc: seasonTeamId hoặc playerId'),
        );
      }

      // Gọi repository để cập nhật
      return await _repository.updatePlayerSeason(playerSeason);
    } catch (e) {
      return Left(
        Exception('Lỗi khi cập nhật thông tin cầu thủ theo mùa giải: $e'),
      );
    }
  }
}
