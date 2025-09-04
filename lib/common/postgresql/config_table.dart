import 'package:postgres/postgres.dart';

class ConfigTable {
  final Connection _conn;
  final String _schemaName;

  ConfigTable(this._conn, this._schemaName);

  Future<void> createSeasonTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS season (
                    season_id SERIAL PRIMARY KEY,
                    code TEXT UNIQUE  NOT NULL,
                    name TEXT NOT NULL,
                    start_date DATE NOT NULL,
                    end_date DATE NOT NULL,
                    CHECK ( start_date < end_date )
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createRoundTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS round (
                    round_id SERIAL PRIMARY KEY,
                    season_id INT NOT NULL REFERENCES season(season_id) ON DELETE CASCADE,
                    round_no INT NOT NULL CHECK ( round_no > 0 ),
                    start_date DATE,
                    end_date DATE,
                    CHECK ( start_date < end_date ),
                    UNIQUE (season_id, round_no)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createTeamTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS team (
                    team_id SERIAL PRIMARY KEY,
                    team_code TEXT UNIQUE NOT NULL,
                    team_name TEXT NOT NULL
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createTeamColorTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS team_color (
                    season_id INT NOT NULL REFERENCES season(season_id) ON DELETE CASCADE,
                    team_id   INT NOT NULL REFERENCES team(team_id) ON DELETE CASCADE,
                    color_name TEXT NOT NULL,
                    UNIQUE (season_id, team_id, color_name),
                    PRIMARY KEY (season_id, team_id, color_name)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createStadiumTable() {
    final query = '''
                CREATE TABLE  IF NOT EXISTS stadium (
                    stadium_id SERIAL PRIMARY KEY,
                    name TEXT NOT NULL,
                    address TEXT NOT NULL,
                    capacity INT CHECK (capacity >= 0),
                    ticket_price NUMERIC(12,2) NOT NULL CHECK (ticket_price >= 0)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createSeasonTeamTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS season_team (
                    season_team_id SERIAL PRIMARY KEY,
                    season_id INT NOT NULL REFERENCES season(season_id) ON DELETE CASCADE,
                    team_id INT NOT NULL REFERENCES team(team_id) ON DELETE CASCADE,
                    home_id INT NOT NULL REFERENCES stadium(stadium_id) ON DELETE CASCADE,
                    UNIQUE (season_id, team_id),
                    UNIQUE (season_id, home_id)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createPlayerTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS player (
                    player_id SERIAL PRIMARY KEY,
                    player_code TEXT UNIQUE NOT NULL,
                    full_name TEXT NOT NULL,
                    dob DATE,
                    height_cm INT CHECK (height_cm IS NULL OR height_cm BETWEEN 120 AND 250),
                    weight_kg INT CHECK (weight_kg IS NULL OR weight_kg BETWEEN 30 AND 200)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createPlayerSeasonTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS player_season (
                    player_season_id SERIAL PRIMARY KEY,
                    season_team_id INT NOT NULL REFERENCES season_team(season_team_id) ON DELETE CASCADE,
                    player_id INT NOT NULL REFERENCES player(player_id) ON DELETE CASCADE,
                    shirt_number INT NOT NULL CHECK (shirt_number BETWEEN 0 AND 99),
                    UNIQUE (season_team_id, shirt_number),
                    UNIQUE (season_team_id, player_id)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createMatchTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS match(
                    match_id SERIAL PRIMARY KEY,
                    round_id  INT NOT NULL REFERENCES round(round_id) ON DELETE CASCADE,
                    match_datetime TIMESTAMP NOT NULL,
                    home_team_id INT NOT NULL REFERENCES season_team(season_team_id),
                    away_team_id INT NOT NULL REFERENCES season_team(season_team_id),
                    home_color TEXT NOT NULL,
                    away_color TEXT NOT NULL,
                    attendance INT CHECK (attendance IS NULL OR attendance >= 0),
                    home_points INT DEFAULT 0 CHECK (home_points >= 0),
                    away_points INT DEFAULT 0 CHECK (away_points >= 0),
                    home_fouls  INT DEFAULT 0 CHECK (home_fouls  >= 0),
                    away_fouls  INT DEFAULT 0 CHECK (away_fouls  >= 0),
                    CHECK (home_team_id <> away_team_id),
                    CHECK (home_color <> away_color),
                    UNIQUE (round_id, home_team_id, away_team_id),
                    UNIQUE (round_id, match_id)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createMatchVenueTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS match_venue (
                    match_id INT PRIMARY KEY REFERENCES match(match_id) ON DELETE CASCADE,
                    stadium_id INT NOT NULL REFERENCES stadium(stadium_id),
                    is_home_stadium BOOLEAN NOT NULL DEFAULT TRUE
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createMatchPlayerTable() {
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
    return _conn.execute(query);
  }

  Future<void> createMatchPlayerStatsTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS match_player_stats (
                    match_player_stats_id SERIAL PRIMARY KEY,
                    match_player_id INT NOT NULL REFERENCES match_player(match_player_id) ON DELETE CASCADE,
                    points INT NOT NULL DEFAULT 0 CHECK (points >= 0),
                    fouls INT NOT NULL DEFAULT 0 CHECK (fouls >= 0)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createRefereeTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS referee (
                    referee_id SERIAL PRIMARY KEY,
                    full_name TEXT NOT NULL,
                    phone TEXT,
                    email TEXT
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createRefereePhoneTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS referee_phone (
                    referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE CASCADE,
                    phone TEXT NOT NULL,
                    type $_schemaName.phone_type NOT NULL,
                    PRIMARY KEY (referee_id, phone)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> createMatchRefereeTable() {
    final query = '''
                CREATE TABLE IF NOT EXISTS match_referee (
                    match_referee_id SERIAL PRIMARY KEY,
                    match_id INT NOT NULL REFERENCES match(match_id) ON DELETE CASCADE,
                    referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE CASCADE,
                    role $_schemaName.referee_role NOT NULL,
                    UNIQUE (match_id, referee_id)
                );
                ''';
    return _conn.execute(query);
  }

  Future<void> listDataTable() async {
    final query = '''
SELECT 
    t.table_name,
    t.table_type,
    obj_description(pgc.oid, 'pg_class') as table_comment,
    pg_size_pretty(pg_total_relation_size(quote_ident(t.table_name))) as table_size
FROM 
    information_schema.tables t
JOIN 
    pg_catalog.pg_class pgc ON pgc.relname = t.table_name
WHERE 
    t.table_schema = '$_schemaName'
    AND t.table_type = 'BASE TABLE'
ORDER BY 
    t.table_name;
                ''';
    final results = await _conn.execute(query);
    for (final row in results) {
      print("table: ${row[0]}");
    }
  }
}
