import 'package:baseketball_league_mobile/data/datasources/mock/player_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/models/player_model.dart';
import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerApi playerApi;

  PlayerRepositoryImpl({required this.playerApi});

  @override
  Future<bool> createPlayer(PlayerEntity player) async {
    final playerModel = PlayerModel.fromEntity(player);
    final result = await playerApi.createPlayer(playerModel);
    if (result) {
      print('Player created successfully');
    } else {
      print('Failed to create player: ${playerModel.fullName}');
    }
    return result;
  }

  @override
  Future<bool> deletePlayer(int id) {
    return playerApi.deletePlayer(id);
  }

  @override
  Future<List<PlayerEntity>> getPlayerList() async {
    final results = await playerApi.getPlayerList();
    return results.map((data) => data.toEntity()).toList();
  }

  @override
  Future<List<PlayerEntity>> searchPlayer(String name) async {
    final results = await playerApi.searchPlayer(name);
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<bool> updatePlayer(int id, PlayerEntity player) {
    final playerModel = PlayerModel.fromEntity(player);
    return playerApi.updatePlayer(id, playerModel);
  }

  @override
  Future<bool> createRandomGeneratedPlayerList() async {
    final List<PlayerModel> playerModels = mockPlayerList;
    final result = await Future.wait(
      playerModels.map((playerModel) => playerApi.createPlayer(playerModel)),
    );
    return result.every((value) => value);
  }
}
