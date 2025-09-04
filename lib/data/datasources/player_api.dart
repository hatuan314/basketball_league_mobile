import 'package:baseketball_league_mobile/data/models/player_model.dart';

abstract class PlayerApi {
  Future<List<PlayerModel>> getPlayerList();

  Future<bool> createPlayer(PlayerModel player);

  Future<bool> updatePlayer(int id, PlayerModel player);

  Future<bool> deletePlayer(int id);

  Future<List<PlayerModel>> searchPlayer(String name);
}
