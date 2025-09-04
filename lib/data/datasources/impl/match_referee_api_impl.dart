import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_referee_api.dart';
import 'package:dartz/dartz.dart';

class MatchRefereeApiImpl implements MatchRefereeApi {
  @override
  Future<Either<Exception, bool>> createTable() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
                CREATE TABLE IF NOT EXISTS match_referee (
                    match_referee_id SERIAL PRIMARY KEY,
                    match_id INT NOT NULL REFERENCES match(match_id) ON DELETE CASCADE,
                    referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE CASCADE,
                    role referee_role NOT NULL,
                    UNIQUE (match_id, referee_id)
                );
                ''';
      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi tạo bảng match_referee: $e');
      return Left(Exception('Lỗi khi tạo bảng match_referee: $e'));
    }
  }
}
