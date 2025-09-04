import 'package:baseketball_league_mobile/data/models/player_model.dart';
import 'package:dartz/dartz.dart';

abstract class PlayerApi {
  Future<Either<Exception, List<PlayerModel>>> getPlayerList();

  Future<Either<Exception, bool>> createPlayer(PlayerModel player);

  Future<Either<Exception, bool>> updatePlayer(int id, PlayerModel player);

  Future<Either<Exception, bool>> deletePlayer(int id);

  Future<Either<Exception, List<PlayerModel>>> searchPlayer(String name);
}
