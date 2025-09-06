import 'package:baseketball_league_mobile/data/models/player_model.dart';
import 'package:dartz/dartz.dart';

abstract class PlayerApi {
  Future<Either<Exception, List<PlayerModel>>> getPlayerList();

  Future<Either<Exception, bool>> createPlayer(PlayerModel player);

  Future<Either<Exception, bool>> updatePlayer(int id, PlayerModel player);

  Future<Either<Exception, bool>> deletePlayer(int id);

  Future<Either<Exception, List<PlayerModel>>> searchPlayer(String name);
  
  /// Lấy thông tin chi tiết của một cầu thủ theo ID
  ///
  /// [playerId]: ID của cầu thủ cần lấy thông tin
  ///
  /// Trả về thông tin cầu thủ nếu thành công hoặc Exception nếu thất bại
  Future<Either<Exception, PlayerModel?>> getPlayerById(int playerId);
}
