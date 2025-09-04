import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_player_api.dart';

class MatchPlayerApiImpl implements MatchPlayerApi {
  @override
  Future<void> createTable() {
    final conn = sl<PostgresConnection>().conn;
    final query = '''
                CREATE TABLE IF NOT EXISTS match_player (
                    match_player_id SERIAL PRIMARY KEY,
                    match_id INT NOT NULL REFERENCES match(match_id) ON DELETE CASCADE,
                    player_id INT NOT NULL REFERENCES player_season(player_season_id) ON DELETE CASCADE,
                    fouls INT DEFAULT 0 CHECK (fouls >= 0),
                    points INT DEFAULT 0 CHECK (points >= 0),
                    UNIQUE (match_id, player_id)
                );
                ''';
    return conn.execute(query);
  }
}
