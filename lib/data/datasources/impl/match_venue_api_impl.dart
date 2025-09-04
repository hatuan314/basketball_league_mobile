import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_venue_api.dart';

class MatchVenueApiImpl implements MatchVenueApi {
  @override
  Future<void> createTable() {
    final conn = sl<PostgresConnection>().conn;
    final query = '''
                CREATE TABLE IF NOT EXISTS match_venue (
                    match_id INT PRIMARY KEY REFERENCES match(match_id) ON DELETE CASCADE,
                    stadium_id INT NOT NULL REFERENCES stadium(stadium_id),
                    is_home_stadium BOOLEAN NOT NULL DEFAULT TRUE
                );
                ''';
    return conn.execute(query);
  }
}
