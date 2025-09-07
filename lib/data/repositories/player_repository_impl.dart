import 'package:baseketball_league_mobile/data/datasources/mock/player_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/models/player_model.dart';
import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';
import 'package:dartz/dartz.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerApi playerApi;

  PlayerRepositoryImpl({required this.playerApi});

  @override
  Future<Either<Exception, bool>> createPlayer(PlayerEntity player) async {
    final playerModel = PlayerModel.fromEntity(player);
    final result = await playerApi.createPlayer(playerModel);
    return result.fold(
      (exception) {
        print('Failed to create player: ${playerModel.fullName} - $exception');
        return Left(exception);
      },
      (success) {
        print('Player created successfully');
        return Right(success);
      },
    );
  }

  @override
  Future<Either<Exception, bool>> deletePlayer(int id) async {
    final result = await playerApi.deletePlayer(id);
    return result.fold((exception) {
      print('Failed to delete player: $exception');
      return Left(exception);
    }, (success) => Right(success));
  }

  @override
  Future<Either<Exception, List<PlayerEntity>>> getPlayerList() async {
    final results = await playerApi.getPlayerList();
    return results.fold(
      (exception) {
        print('Failed to get player list: $exception');
        return Left(exception);
      },
      (playerList) => Right(playerList.map((data) => data.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Exception, List<PlayerEntity>>> searchPlayer(
    String name,
  ) async {
    final results = await playerApi.searchPlayer(name);
    return results.fold((exception) {
      print('Failed to search player: $exception');
      return Left(exception);
    }, (playerList) => Right(playerList.map((row) => row.toEntity()).toList()));
  }

  @override
  Future<Either<Exception, bool>> updatePlayer(
    int id,
    PlayerEntity player,
  ) async {
    final playerModel = PlayerModel.fromEntity(player);
    final result = await playerApi.updatePlayer(id, playerModel);
    return result.fold((exception) {
      print('Failed to update player: $exception');
      return Left(exception);
    }, (success) => Right(success));
  }

  @override
  Future<Either<Exception, bool>> createRandomGeneratedPlayerList() async {
    final List<PlayerModel> playerModels = mockPlayerList;
    final results = await Future.wait(
      playerModels.map((playerModel) => playerApi.createPlayer(playerModel)),
    );

    // Kiểm tra kết quả từ mỗi Either
    bool allSuccess = true;
    Exception? firstException;

    for (var result in results) {
      final isSuccess = result.fold((exception) {
        print('Failed to create player: $exception');
        if (firstException == null) {
          firstException = exception;
        }
        return false;
      }, (success) => success);
      if (!isSuccess) {
        allSuccess = false;
      }
    }

    if (!allSuccess && firstException != null) {
      return Left(firstException!);
    }
    return Right(allSuccess);
  }
}
