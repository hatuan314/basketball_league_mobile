import 'dart:math';

import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/datasources/player_season_api.dart';
import 'package:baseketball_league_mobile/data/datasources/team_api.dart';
import 'package:baseketball_league_mobile/data/models/player_season_model.dart';
import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_season_repository.dart';
import 'package:dartz/dartz.dart';

/// Triển khai các phương thức repository để quản lý thông tin cầu thủ theo mùa giải
class PlayerSeasonRepositoryImpl implements PlayerSeasonRepository {
  final PlayerSeasonApi _playerSeasonApi;
  final TeamApi _teamApi;
  final PlayerApi _playerApi;

  PlayerSeasonRepositoryImpl({
    required PlayerSeasonApi playerSeasonApi,
    required TeamApi teamApi,
    required PlayerApi playerApi,
  }) : _playerSeasonApi = playerSeasonApi,
       _teamApi = teamApi,
       _playerApi = playerApi;

  @override
  Future<Either<Exception, String>> createPlayerSeason(
    PlayerSeasonEntity playerSeason,
  ) async {
    try {
      // Lấy thông tin đội bóng từ season_team_id
      // Sử dụng phương thức getTeamBySeasonTeamId đã được giữ lại trong TeamApiImpl
      final teamResult = await _teamApi.getTeamBySeasonTeamId(
        playerSeason.seasonTeamId!,
      );

      String teamCode = '';

      teamResult.fold((exception) => Left(exception), (team) {
        if (team == null) {
          return Left(Exception('Không tìm thấy đội bóng'));
        }
        teamCode = team.code!;
      });

      final playerResult = await _playerApi.getPlayerById(
        playerSeason.playerId!,
      );

      String playerCode = '';

      playerResult.fold((exception) => Left(exception), (player) {
        if (player == null) {
          return Left(Exception('Không tìm thấy cầu thủ'));
        }
        playerCode = player.playerCode!;
      });

      final String id = teamCode + playerCode;

      final playerSeasonModel = PlayerSeasonModel(
        id: id,
        seasonTeamId: playerSeason.seasonTeamId,
        playerId: playerSeason.playerId,
        shirtNumber: playerSeason.shirtNumber,
      );

      // Gọi API để tạo mới
      return await _playerSeasonApi.createPlayerSeason(playerSeasonModel);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo thông tin cầu thủ theo mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PlayerSeasonEntity>>> getPlayerSeasons({
    int? seasonTeamId,
    int? playerId,
  }) async {
    try {
      // Gọi API để lấy danh sách
      final result = await _playerSeasonApi.getPlayerSeasons(
        seasonTeamId: seasonTeamId,
        playerId: playerId,
      );

      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách thông tin cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, PlayerSeasonEntity?>> getPlayerSeasonById(
    String playerSeasonId,
  ) async {
    try {
      // Gọi API để lấy thông tin chi tiết
      final result = await _playerSeasonApi.getPlayerSeasonById(playerSeasonId);

      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model?.toEntity()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy thông tin chi tiết cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> updatePlayerSeason(
    PlayerSeasonEntity playerSeasonEntity,
  ) async {
    try {
      // Chuyển đổi từ entity sang model
      final playerSeasonModel = PlayerSeasonModel(
        id: playerSeasonEntity.id,
        seasonTeamId: playerSeasonEntity.seasonTeamId,
        playerId: playerSeasonEntity.playerId,
        shirtNumber: playerSeasonEntity.shirtNumber,
      );

      // Gọi API để cập nhật
      return await _playerSeasonApi.updatePlayerSeason(playerSeasonModel);
    } catch (e) {
      return Left(
        Exception('Lỗi khi cập nhật thông tin cầu thủ theo mùa giải: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deletePlayerSeason(
    String playerSeasonId,
  ) async {
    try {
      // Gọi API để xóa
      return await _playerSeasonApi.deletePlayerSeason(playerSeasonId);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa thông tin cầu thủ theo mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PlayerDetailEntity>>> getPlayerDetailsBySeasonIdAndTeamId(
    int seasonId, {
    int? teamId,
  }) async {
    try {
      // Gọi API để lấy danh sách chi tiết cầu thủ
      final result = await _playerSeasonApi.getPlayerDetailsBySeasonIdAndTeamId(
        seasonId,
        teamId: teamId,
      );
      
      return result;
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách chi tiết cầu thủ: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<PlayerSeasonEntity>>> generatePlayerSeasons({
    required int teamId,
    required int seasonId,
    required int seasonTeamId,
  }) async {
    final int minPlayers = 5;
    final int maxPlayers = 20;
    try {
      // Lấy danh sách cầu thủ hiện có
      final playersResult = await _playerApi.getPlayerList();

      return playersResult.fold((exception) => Left(exception), (
        players,
      ) async {
        // Kiểm tra nếu không có đủ cầu thủ
        if (players.isEmpty) {
          return Left(Exception('Không có cầu thủ nào trong hệ thống'));
        }

        // Lấy danh sách cầu thủ đã được phân công cho các đội trong mùa giải này
        final existingPlayerSeasonsResult = await getPlayerSeasons(
          seasonTeamId: teamId,
        );

        return existingPlayerSeasonsResult.fold((exception) => Left(exception), (
          existingPlayerSeasons,
        ) async {
          // Lấy danh sách số áo đã sử dụng trong đội này
          // Số áo này sẽ được sử dụng ở phần sau
          final usedShirtNumbers =
              existingPlayerSeasons
                  .map((ps) => ps.shirtNumber)
                  .whereType<int>()
                  .toSet();

          // Lấy danh sách tất cả cầu thủ đã được phân công trong mùa giải
          final allPlayerSeasonsResult = await getPlayerSeasons();

          return allPlayerSeasonsResult.fold((exception) => Left(exception), (
            allPlayerSeasons,
          ) async {
            // Lấy danh sách ID cầu thủ đã được phân công cho bất kỳ đội nào trong mùa giải
            final allAssignedPlayerIds =
                allPlayerSeasons
                    .map((ps) => ps.playerId)
                    .whereType<int>()
                    .toSet();

            // Lọc danh sách cầu thủ chưa được phân công cho bất kỳ đội nào
            final availablePlayers =
                players
                    .where(
                      (player) =>
                          player.id != null &&
                          !allAssignedPlayerIds.contains(player.id),
                    )
                    .toList();

            // Kiểm tra nếu không có đủ cầu thủ khả dụng
            if (availablePlayers.isEmpty) {
              return Left(Exception('Không có cầu thủ khả dụng để phân công'));
            }

            // Xác định số lượng cầu thủ cần tạo
            final currentPlayerCount = existingPlayerSeasons.length;
            final targetPlayerCount =
                Random().nextInt(maxPlayers - minPlayers + 1) + minPlayers;
            final playersToAdd = targetPlayerCount - currentPlayerCount;

            if (playersToAdd <= 0) {
              // Đã đủ số lượng cầu thủ tối thiểu
              return Right(existingPlayerSeasons);
            }

            if (availablePlayers.length < playersToAdd) {
              return Left(
                Exception(
                  'Không đủ cầu thủ khả dụng để tạo đủ $targetPlayerCount cầu thủ',
                ),
              );
            }

            // Trộn ngẫu nhiên danh sách cầu thủ khả dụng
            availablePlayers.shuffle();

            // Lấy danh sách cầu thủ cần thêm
            final playersToAssign =
                availablePlayers.take(playersToAdd).toList();

            // Sử dụng danh sách số áo đã được lấy ở trên

            // Tạo danh sách cầu thủ mới
            final newPlayerSeasons = <PlayerSeasonEntity>[];

            // Chuẩn bị danh sách cầu thủ cần tạo
            final playersToCreate = <PlayerSeasonEntity>[];

            // Kiểm tra kết quả từ mỗi Either
            bool allSuccess = true;
            Exception? firstException;

            for (final player in playersToAssign) {
              if (player.id == null) continue;

              // Tạo số áo ngẫu nhiên chưa được sử dụng (0-99)
              int shirtNumber;
              do {
                shirtNumber = Random().nextInt(100);
              } while (usedShirtNumbers.contains(shirtNumber));

              usedShirtNumbers.add(shirtNumber);

              // Tạo entity mới
              final playerSeason = PlayerSeasonEntity(
                seasonTeamId: seasonTeamId,
                playerId: player.id!,
                shirtNumber: shirtNumber,
              );

              // Thêm vào danh sách cần tạo
              playersToCreate.add(playerSeason);
            }

            // Thêm tất cả cầu thủ vào danh sách kết quả trước
            // Và gọi API để tạo mới sau
            newPlayerSeasons.addAll(playersToCreate);

            // Gọi API để tạo mới các cầu thủ (không cần đợi kết quả)
            final results = await Future.wait(
              playersToCreate.map(
                (playerSeason) => createPlayerSeason(playerSeason),
              ),
            );

            for (var result in results) {
              final isSuccess = result.fold((exception) {
                print('Lỗi khi tạo cầu thủ: $exception');
                if (firstException == null) {
                  firstException = exception;
                }
                return false;
              }, (success) => true);
              if (!isSuccess) {
                allSuccess = false;
              }
            }

            if (!allSuccess && firstException != null) {
              return Left(firstException!);
            }

            // Kết hợp danh sách cầu thủ hiện có và mới tạo
            final allTeamPlayerSeasons = [
              ...existingPlayerSeasons,
              ...newPlayerSeasons,
            ];

            return Right(allTeamPlayerSeasons);
          });
        });
      });
    } catch (e) {
      return Left(
        Exception('Lỗi khi tạo danh sách cầu thủ cho đội trong mùa giải: $e'),
      );
    }
  }
}
