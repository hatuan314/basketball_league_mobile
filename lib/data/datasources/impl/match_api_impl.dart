import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_api.dart';
import 'package:dartz/dartz.dart';

class MatchApiImpl implements MatchApi {
  @override
  Future<Either<Exception, bool>> createTable() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final sql = '''
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
      await conn.execute(sql);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi tạo bảng match: $e');
      return Left(Exception('Lỗi khi tạo bảng match: $e'));
    }
  }
}
