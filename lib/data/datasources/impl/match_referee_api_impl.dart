import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_referee_api.dart';

class MatchRefereeApiImpl implements MatchRefereeApi {
  @override
  Future<void> createTable() {
    final conn = sl<PostgresConnection>().conn;
    final query = '''
                CREATE TABLE IF NOT EXISTS match_referee (
                    match_referee_id SERIAL PRIMARY KEY,
                    match_id INT NOT NULL REFERENCES match(match_id) ON DELETE CASCADE,
                    referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE CASCADE,
                    role referee_role NOT NULL,
                    UNIQUE (match_id, referee_id)
                );
                ''';
    return conn.execute(query);
  }
}
