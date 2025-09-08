import 'dart:math' as math;

import 'package:baseketball_league_mobile/data/datasources/match_player_api.dart';
import 'package:baseketball_league_mobile/data/datasources/player_season_api.dart';
import 'package:baseketball_league_mobile/data/models/match_player_model.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_match_repository.dart';
import 'package:dartz/dartz.dart';

/// Triển khai các phương thức repository để quản lý thông tin cầu thủ trong trận đấu
class PlayerMatchRepositoryImpl implements PlayerMatchRepository {
  /// API để quản lý thông tin cầu thủ trong trận đấu
  final MatchPlayerApi _playerMatchApi;

  /// API để quản lý thông tin cầu thủ trong mùa giải
  final PlayerSeasonApi _playerSeasonApi;

  /// Constructor
  PlayerMatchRepositoryImpl(this._playerMatchApi, this._playerSeasonApi);

  @override
  Future<Either<Exception, int>> createPlayerMatch(
    MatchPlayerEntity playerMatchEntity,
  ) async {
    try {
      final result = await _playerMatchApi.createMatchPlayer(
        MatchPlayerModel.fromEntity(playerMatchEntity),
      );
      return result;
    } catch (e) {
      return Left(
        Exception('Lỗi khi tạo thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchPlayerEntity>>> getPlayerMatches({
    int? matchId,
    int? seasonPlayerId,
  }) async {
    try {
      final result = await _playerMatchApi.getMatchPlayers(
        matchId: matchId,
        seasonPlayerId: seasonPlayerId,
      );
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchPlayerEntity>>> getTeamPlayersInMatch(
    int matchId,
    int teamId,
  ) async {
    try {
      final result = await _playerMatchApi.getTeamPlayersInMatch(
        matchId,
        teamId,
      );
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, MatchPlayerEntity?>> getPlayerMatchById(
    int playerMatchId,
  ) async {
    try {
      final result = await _playerMatchApi.getMatchPlayerById(playerMatchId);
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model != null ? model.toEntity() : null),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy thông tin chi tiết của cầu thủ trong trận đấu: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> updatePlayerMatch(
    MatchPlayerEntity playerMatchEntity,
  ) async {
    try {
      final result = await _playerMatchApi.updateMatchPlayer(
        MatchPlayerModel.fromEntity(playerMatchEntity),
      );
      return result;
    } catch (e) {
      return Left(
        Exception('Lỗi khi cập nhật thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deletePlayerMatch(int playerMatchId) async {
    try {
      final result = await _playerMatchApi.deleteMatchPlayer(playerMatchId);
      return result;
    } catch (e) {
      return Left(
        Exception('Lỗi khi xóa thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<int>>> autoRegisterPlayersForMatch(
    int matchId,
    int seasonTeamId,
  ) async {
    int maxPlayersPerTeam = 12;
    try {
      // Lấy danh sách cầu thủ của đội nhà trong mùa giải
      final playersResult = await _playerSeasonApi.getPlayerSeasons(
        seasonTeamId: seasonTeamId,
      );

      // Kiểm tra kết quả lấy danh sách cầu thủ
      final List<String> seasonPlayerIds = [];

      // Xử lý kết quả lấy danh sách cầu thủ đội nhà
      if (playersResult.isLeft()) {
        return Left(Exception('Không thể lấy danh sách cầu thủ của đội nhà'));
      }

      // Lấy danh sách ID cầu thủ của đội nhà
      playersResult.fold((exception) => null, (seasonPlayers) {
        for (final player in seasonPlayers) {
          if (player.id != null) {
            seasonPlayerIds.add(player.id!);
          }
        }
      });

      // Kiểm tra số lượng cầu thủ của đội nhà
      if (seasonPlayerIds.isEmpty) {
        return Left(Exception('Đội nhà không có cầu thủ nào trong mùa giải'));
      }

      // Lấy danh sách cầu thủ đã đăng ký trong trận đấu
      final registeredPlayersResult = await _playerMatchApi.getMatchPlayers(
        matchId: matchId,
      );

      // Kiểm tra kết quả lấy danh sách cầu thủ đã đăng ký
      if (registeredPlayersResult.isLeft()) {
        return Left(
          Exception(
            'Không thể lấy danh sách cầu thủ đã đăng ký trong trận đấu',
          ),
        );
      }

      // Lấy danh sách ID cầu thủ đã đăng ký
      final List<String> registeredPlayerIds = [];

      registeredPlayersResult.fold((exception) => null, (matchPlayers) {
        for (final player in matchPlayers) {
          registeredPlayerIds.add(player.playerSeasonId!);
        }
      });

      // Lọc danh sách cầu thủ chưa đăng ký
      final unregisteredPlayerIds =
          seasonPlayerIds
              .where((id) => !registeredPlayerIds.contains(id))
              .toList();

      // Xáo trộn danh sách cầu thủ chưa đăng ký
      unregisteredPlayerIds.shuffle(math.Random());

      // Tính toán số lượng cầu thủ cần đăng ký thêm
      final int playersToAdd =
          seasonPlayerIds.length - registeredPlayerIds.length;

      // Lấy danh sách cầu thủ cần đăng ký thêm
      final List<String> playersToRegister =
          unregisteredPlayerIds.take(playersToAdd).toList();

      // Danh sách ID của các bản ghi vừa tạo
      final List<int> createdIds = [];
      await Future.forEach(playersToRegister, (seasonPlayerId) async {
        final model = MatchPlayerModel(
          matchId: matchId,
          playerSeasonId: seasonPlayerId,
        );
        final result = await _playerMatchApi.createMatchPlayer(model);
        result.fold((exception) => null, (id) {
          createdIds.add(id);
        });
      });

      return Right(createdIds);
    } catch (e) {
      return Left(
        Exception('Lỗi khi tự động đăng ký cầu thủ cho trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchPlayerDetailEntity>>>
  getTeamPlayersDetailInMatch(int matchId, int teamId) async {
    try {
      final result = await _playerMatchApi.getTeamPlayersDetailInMatch(
        matchId,
        teamId,
      );
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách cầu thủ trong trận đấu: $e'),
      );
    }
  }
}
