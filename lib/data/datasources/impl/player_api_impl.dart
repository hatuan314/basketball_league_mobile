import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/models/player_model.dart';

class PlayerApiImpl implements PlayerApi {
  @override
  Future<bool> createPlayer(PlayerModel player) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      INSERT INTO player (
        player_code, 
        full_name, 
        dob, 
        height_cm, 
        weight_kg
      ) VALUES (
        '${player.playerCode}', 
        '${player.fullName}', 
        '${player.dob?.toIso8601String()}', 
        ${player.height}, 
        ${player.weight}
      )
      ''';

      await conn.execute(query);
      return true;
    } catch (e) {
      print('Lỗi khi tạo cầu thủ: $e');
      return false;
    }
  }

  @override
  Future<bool> deletePlayer(int id) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''DELETE FROM player WHERE player_id = $id''';
      await conn.execute(query);
      return true;
    } catch (e) {
      print('Lỗi khi xóa cầu thủ: $e');
      return false;
    }
  }

  @override
  Future<List<PlayerModel>> getPlayerList() async {
    final conn = sl<PostgresConnection>().conn;
    final results = await conn.execute('SELECT * FROM player');
    return results.map((row) => PlayerModel.fromRow(row)).toList();
  }

  @override
  Future<List<PlayerModel>> searchPlayer(String name) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''SELECT * FROM player WHERE full_name ILIKE '%$name%' ''';
      final results = await conn.execute(query);
      return results.map((row) => PlayerModel.fromRow(row)).toList();
    } catch (e) {
      print('Lỗi khi tìm kiếm cầu thủ: $e');
      return [];
    }
  }

  @override
  Future<bool> updatePlayer(int id, PlayerModel player) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      UPDATE player 
      SET 
        player_code = '${player.playerCode}',
        full_name = '${player.fullName}',
        dob = '${player.dob?.toIso8601String()}',
        height_cm = ${player.height},
        weight_kg = ${player.weight}
      WHERE player_id = $id
      ''';

      await conn.execute(query);
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật cầu thủ: $e');
      return false;
    }
  }
}
