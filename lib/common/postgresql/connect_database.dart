import 'package:baseketball_league_mobile/common/postgresql/config_table.dart';
import 'package:baseketball_league_mobile/common/postgresql/config_trigger.dart';
import 'package:baseketball_league_mobile/common/postgresql/config_type.dart';
import 'package:baseketball_league_mobile/common/postgresql/config_view.dart';
import 'package:postgres/postgres.dart';

class PostgresConnection {
  late Connection _conn;

  Connection get conn => _conn;

  final String _schemaName = 'basketball_league_dev';

  Future<bool> connectDb() async {
    _conn = await Connection.open(
      Endpoint(
        host: '127.0.0.1',
        database: 'postgres',
        username: 'postgres',
        password: "123456",
        port: 5432,
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    return _conn.isOpen;
  }

  Future<void> configDatabase() async {
    final configTable = ConfigTable(_conn, _schemaName);
    final configType = ConfigType(_conn, _schemaName);
    final configTrigger = ConfigTrigger(_conn);
    final configView = ConfigView(_conn);

    await _createSchema();
    // Type
    await configType.createRefereeRoleType();
    await configType.createPhoneType();
    await configType.listMyType();
    // Table
    await configTable.createSeasonTable();
    await configTable.createRoundTable();
    await configTable.createTeamTable();
    await configTable.createTeamColorTable();
    await configTable.createStadiumTable();
    await configTable.createSeasonTeamTable();
    await configTable.createPlayerTable();
    await configTable.createPlayerSeasonTable();
    await configTable.createMatchTable();
    await configTable.createMatchVenueTable();
    await configTable.createMatchPlayerTable();
    await configTable.createMatchPlayerStatsTable();
    await configTable.createRefereeTable();
    await configTable.createRefereePhoneTable();
    await configTable.createMatchRefereeTable();
    await configTable.listDataTable();
    // Trigger
    await configTrigger.enforceMinTeamsPerSeason();
    await configTrigger.checkPlayerCodeFormat();
    await configTrigger.checkMaxPlayersPerTeam();
    await configTrigger.enforceTeamColorRegistration();
    await configTrigger.enforceMaxPlayersPerMatch();
    await configTrigger.updateMatchStats();
    await configTrigger.enforceMatchLimitBetweenTeams();
    await configTrigger.enforceRefereeCountPerMatch();
    await configTrigger.enforceRefereeMatchLimitPerRound();
    await configTrigger.enforceMinTeamColors();
    await configTrigger.createMatchVenue();
    await configTrigger.createCheckShirtNumber();
    await configTrigger.listTrigger();
    // View
    await configView.createPlayerDetails();
    await configView.createMatchDetails();
    await configView.createMatchPlayerDetails();
    await configView.createMatchRefereeDetails();
    await configView.createTeamStandings();
    await configView.createPlayerStatistics();
    await configView.createTopScores();
    await configView.createTopFoulsPlayers();
    await configView.createRefereeDetail();
    await configView.createRefereeMonthlySalary();
    await configView.createStadiumRevenue();
    await configView.createRoundMatches();
    await configView.createTopScorersByRound();
    await configView.createTeamHeadToHead();
    await configView.createTeamPlayerCount();
    await configView.listView();
  }

  Future<void> _createSchema() async {
    // String dropSchemaQuery = r'''
    // DROP SCHEMA IF EXISTS basketball_league_dev CASCADE;
    // ''';
    // await conn.execute(dropSchemaQuery);

    // String existsSchemaQuery = r'''
    // SELECT EXISTS (
    //     SELECT 1
    //     FROM information_schema.schemata
    //     WHERE schema_name = 'basketball_league_dev'
    // );
    // ''';
    // final result = await conn.execute(existsSchemaQuery);
    // print(result.toString());

    String query = '''CREATE SCHEMA IF NOT EXISTS $_schemaName;''';
    await _conn.execute(query);
    final results = await _conn.execute(
      'SELECT schema_name FROM information_schema.schemata ORDER BY schema_name;',
    );

    for (final row in results) {
      print("schema: ${row[0]}");
    }
    await _conn.execute('SET search_path TO $_schemaName, public;');
  }
}
