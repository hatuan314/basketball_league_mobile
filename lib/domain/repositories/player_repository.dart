import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';

abstract class PlayerRepository {
  Future<List<PlayerEntity>> getPlayerList();

  Future<bool> createPlayer(PlayerEntity player);

  Future<bool> createRandomGeneratedPlayerList();

  Future<bool> updatePlayer(int id, PlayerEntity player);

  Future<bool> deletePlayer(int id);

  Future<List<PlayerEntity>> searchPlayer(String name);
}
