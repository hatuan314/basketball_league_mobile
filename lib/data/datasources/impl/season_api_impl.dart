import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/season_api.dart';
import 'package:baseketball_league_mobile/data/models/season_model.dart';
import 'package:dartz/dartz.dart';

class SeasonApiImpl implements SeasonApi {
  @override
  Future<Either<Exception, bool>> createSeason(SeasonModel season) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      INSERT INTO season (
        code, 
        name, 
        start_date, 
        end_date
      ) VALUES (
        '${season.code}', 
        '${season.name}', 
        '${season.startDate?.toIso8601String()}', 
        '${season.endDate?.toIso8601String()}'
      )
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi tạo mùa giải: $e');
      return Left(Exception('Lỗi khi tạo mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> createTable() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      CREATE TABLE IF NOT EXISTS season (
        season_id SERIAL PRIMARY KEY,
        code VARCHAR(255) NOT NULL,
        name VARCHAR(255) NOT NULL,
        start_date DATE,
        end_date DATE
      )
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi tạo bảng mùa giải: $e');
      return Left(Exception('Lỗi khi tạo bảng mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteSeason(int id) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''DELETE FROM season WHERE season_id = $id''';
      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi xóa mùa giải: $e');
      return Left(Exception('Lỗi khi xóa mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SeasonModel>>> getSeasonList() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final results = await conn.execute('SELECT * FROM season');
      return Right(results.map((row) => _seasonFromRow(row)).toList());
    } catch (e) {
      print('Lỗi khi lấy danh sách mùa giải: $e');
      return Left(Exception('Lỗi khi lấy danh sách mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SeasonModel>>> searchSeason(String name) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      // Đảm bảo extension unaccent được cài đặt
      await conn.execute('CREATE EXTENSION IF NOT EXISTS unaccent');
      
      // Sử dụng unaccent để tìm kiếm không phân biệt dấu
      final query = '''
        SELECT * FROM season 
        WHERE unaccent(LOWER(name)) LIKE unaccent(LOWER('%$name%'))
      ''';
      
      final results = await conn.execute(query);
      return Right(results.map((row) => _seasonFromRow(row)).toList());
    } catch (e) {
      print('Lỗi khi tìm kiếm mùa giải: $e');
      return Left(Exception('Lỗi khi tìm kiếm mùa giải: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateSeason(int id, SeasonModel season) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      UPDATE season 
      SET 
        code = '${season.code}',
        name = '${season.name}',
        start_date = '${season.startDate?.toIso8601String()}',
        end_date = '${season.endDate?.toIso8601String()}'
      WHERE season_id = $id
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      print('Lỗi khi cập nhật mùa giải: $e');
      return Left(Exception('Lỗi khi cập nhật mùa giải: $e'));
    }
  }

  // Hàm hỗ trợ chuyển đổi từ row database sang SeasonModel
  SeasonModel _seasonFromRow(List<dynamic> row) {
    return SeasonModel(
      id: row[0],
      code: row[1],
      name: row[2],
      startDate: row[3] != null ? DateTime.parse(row[3].toString()) : null,
      endDate: row[4] != null ? DateTime.parse(row[4].toString()) : null,
    );
  }
}
