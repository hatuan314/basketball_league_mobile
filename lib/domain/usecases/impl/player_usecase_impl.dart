import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';
import 'package:dartz/dartz.dart';

class PlayerUsecaseImpl implements PlayerUsecase {
  final PlayerRepository playerRepository;

  PlayerUsecaseImpl({required this.playerRepository});

  @override
  Future<Either<Exception, bool>> createPlayer(PlayerEntity player) {
    return playerRepository.createPlayer(player);
  }

  @override
  Future<Either<Exception, bool>> deletePlayer(int id) {
    return playerRepository.deletePlayer(id);
  }

  @override
  Future<Either<Exception, List<PlayerEntity>>> getPlayerList() {
    return playerRepository.getPlayerList();
  }

  @override
  Future<Either<Exception, List<PlayerEntity>>> searchPlayer(String name) {
    return playerRepository.searchPlayer(name);
  }

  @override
  Future<Either<Exception, bool>> updatePlayer(int id, PlayerEntity player) {
    return playerRepository.updatePlayer(id, player);
  }

  @override
  Future<Either<Exception, bool>> createRandomGeneratedPlayerList() {
    return playerRepository.createRandomGeneratedPlayerList();
  }
}
