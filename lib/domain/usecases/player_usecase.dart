import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PlayerUsecase {
  Future<Either<Exception, List<PlayerEntity>>> getPlayerList();

  Future<Either<Exception, List<PlayerEntity>>> searchPlayer(String name);

  Future<Either<Exception, bool>> createPlayer(PlayerEntity player);

  Future<Either<Exception, bool>> updatePlayer(int id, PlayerEntity player);

  Future<Either<Exception, bool>> deletePlayer(int id);

  Future<Either<Exception, bool>> createRandomGeneratedPlayerList();
}
