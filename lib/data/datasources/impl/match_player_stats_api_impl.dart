import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_player_stats_api.dart';

class MatchPlayerStatsApiImpl implements MatchPlayerStatsApi {
  @override
  Future<void> createTable() {
    final conn = sl<PostgresConnection>().conn;
    final query = '''
                CREATE TABLE IF NOT EXISTS match_player_stats (
                    match_player_stats_id SERIAL PRIMARY KEY,
                    match_player_id INT NOT NULL REFERENCES match_player(match_player_id) ON DELETE CASCADE,
                    points INT NOT NULL DEFAULT 0 CHECK (points >= 0),
                    fouls INT NOT NULL DEFAULT 0 CHECK (fouls >= 0)
                );
                ''';
    return conn.execute(query);
  }
}
