import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';

abstract class PlayerUsecase {
  Future<List<PlayerEntity>> getPlayerList();

  Future<List<PlayerEntity>> searchPlayer(String name);

  Future<bool> createPlayer(PlayerEntity player);

  Future<bool> updatePlayer(int id, PlayerEntity player);

  Future<bool> deletePlayer(int id);

  Future<bool> createRandomGeneratedPlayerList();
}
