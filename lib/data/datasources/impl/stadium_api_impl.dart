import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/stadium_api.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

/// Triển khai của StadiumApi sử dụng PostgreSQL
class StadiumApiImpl implements StadiumApi {
  /// Tạo bảng stadium trong database
  @override
  Future<Either<Exception, bool>> createTable() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      CREATE TABLE IF NOT EXISTS stadium (
        stadium_id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        address TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        ticket_price NUMERIC(10, 2) NOT NULL
      )
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo bảng stadium: $e');
      }
      return Left(Exception('Lỗi khi tạo bảng stadium: $e'));
    }
  }

  /// Lấy danh sách tất cả sân vận động
  @override
  Future<Either<Exception, List<StadiumModel>>> getStadiums() async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      SELECT stadium_id, name, address, capacity, ticket_price
      FROM stadium
      ORDER BY stadium_id
      ''';

      final result = await conn.execute(query);
      final stadiums =
          result.map((row) {
            return StadiumModel.fromRow(row);
          }).toList();

      return Right(stadiums);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy danh sách sân vận động: $e');
      }
      return Left(Exception('Lỗi khi lấy danh sách sân vận động: $e'));
    }
  }

  /// Lấy thông tin chi tiết của một sân vận động theo ID
  @override
  Future<Either<Exception, StadiumModel?>> getStadiumById(int id) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      SELECT stadium_id, name, address, capacity, ticket_price
      FROM stadium
      WHERE stadium_id = $id
      ''';

      final result = await conn.execute(query);
      if (result.isEmpty) {
        return const Right(null);
      }

      final row = result.first;
      final stadium = StadiumModel.fromRow(row);

      return Right(stadium);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy thông tin sân vận động: $e');
      }
      return Left(Exception('Lỗi khi lấy thông tin sân vận động: $e'));
    }
  }

  /// Tạo mới một sân vận động
  @override
  Future<Either<Exception, bool>> createStadium(StadiumModel stadium) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      INSERT INTO stadium (
        name, 
        address, 
        capacity, 
        ticket_price
      ) VALUES (
        '${stadium.name}', 
        '${stadium.address}', 
        ${stadium.capacity}, 
        ${stadium.ticketPrice}
      )
      ''';

      await conn.execute(query);
      return const Right(true);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tạo sân vận động: $e');
      }
      return Left(Exception('Lỗi khi tạo sân vận động: $e'));
    }
  }

  /// Cập nhật thông tin sân vận động
  @override
  Future<Either<Exception, bool>> updateStadium(StadiumModel stadium) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      UPDATE stadium
      SET 
        name = '${stadium.name}',
        address = '${stadium.address}',
        capacity = ${stadium.capacity},
        ticket_price = ${stadium.ticketPrice}
      WHERE stadium_id = ${stadium.id}
      ''';

      final result = await conn.execute(query);
      if (result == 'UPDATE 0') {
        return Left(
          Exception('Không tìm thấy sân vận động với ID: ${stadium.id}'),
        );
      }
      return const Right(true);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi cập nhật sân vận động: $e');
      }
      return Left(Exception('Lỗi khi cập nhật sân vận động: $e'));
    }
  }

  /// Xóa sân vận động theo ID
  @override
  Future<Either<Exception, bool>> deleteStadium(int id) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      DELETE FROM stadium
      WHERE stadium_id = $id
      ''';

      final result = await conn.execute(query);
      if (result == 'DELETE 0') {
        return Left(Exception('Không tìm thấy sân vận động với ID: $id'));
      }
      return const Right(true);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi xóa sân vận động: $e');
      }
      return Left(Exception('Lỗi khi xóa sân vận động: $e'));
    }
  }
  
  /// Tìm kiếm sân vận động theo tên
  @override
  Future<Either<Exception, List<StadiumModel>>> searchStadiumsByName(String name) async {
    final conn = sl<PostgresConnection>().conn;
    try {
      final query = '''
      SELECT stadium_id, name, address, capacity, ticket_price
      FROM stadium
      WHERE LOWER(name) LIKE LOWER('%$name%')
      ORDER BY stadium_id
      ''';

      final result = await conn.execute(query);
      final stadiums = result.map((row) {
        return StadiumModel.fromRow(row);
      }).toList();

      return Right(stadiums);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi tìm kiếm sân vận động theo tên: $e');
      }
      return Left(Exception('Lỗi khi tìm kiếm sân vận động theo tên: $e'));
    }
  }
}
