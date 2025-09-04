import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';

class PlayerUsecaseImpl implements PlayerUsecase {
  final PlayerRepository playerRepository;

  PlayerUsecaseImpl({required this.playerRepository});

  @override
  Future<bool> createPlayer(PlayerEntity player) {
    return playerRepository.createPlayer(player);
  }

  @override
  Future<bool> deletePlayer(int id) {
    return playerRepository.deletePlayer(id);
  }

  @override
  Future<List<PlayerEntity>> getPlayerList() {
    return playerRepository.getPlayerList();
  }

  @override
  Future<List<PlayerEntity>> searchPlayer(String name) {
    return playerRepository.searchPlayer(name);
  }

  @override
  Future<bool> updatePlayer(int id, PlayerEntity player) {
    return playerRepository.updatePlayer(id, player);
  }

  @override
  Future<bool> createRandomGeneratedPlayerList() {
    return playerRepository.createRandomGeneratedPlayerList();
  }
}
