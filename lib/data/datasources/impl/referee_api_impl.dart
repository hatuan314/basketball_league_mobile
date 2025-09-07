import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/referee_api.dart';
import 'package:baseketball_league_mobile/data/models/referee_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/referee_model.dart';
import 'package:baseketball_league_mobile/data/models/referee_phone_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

/// Triển khai các phương thức API để quản lý thông tin trọng tài
class RefereeApiImpl implements RefereeApi {
  @override
  Future<Either<Exception, List<RefereeModel>>> getRefereeList() async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để lấy danh sách trọng tài
      final query = '''
        SELECT 
          referee_id, 
          full_name, 
          email
        FROM referee
        ORDER BY referee_id
      ''';

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query));

      // Chuyển đổi kết quả thành danh sách RefereeModel
      final refereeList =
          result.map((row) => RefereeModel.fromPostgres(row)).toList();

      return Right(refereeList);
    } catch (e) {
      // Nếu có lỗi, trả về dữ liệu mock
      return Left(
        Exception('Lỗi khi lấy danh sách trọng tài: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, bool>> createReferee(RefereeModel referee) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để tạo mới trọng tài
      final query = '''
        INSERT INTO referee (
          full_name, 
          email
        ) VALUES (
          @fullName, 
          @email
        )
      ''';

      // Tham số cho câu lệnh SQL
      final params = {'fullName': referee.fullName, 'email': referee.email};

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      return Right(result.affectedRows > 0);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo mới trọng tài: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateReferee(
    int id,
    RefereeModel referee,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để cập nhật thông tin trọng tài
      final query = '''
        UPDATE referee
        SET 
          full_name = @fullName, 
          email = @email
        WHERE referee_id = @id
      ''';

      // Tham số cho câu lệnh SQL
      final params = {
        'id': id,
        'fullName': referee.fullName,
        'email': referee.email,
      };

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      return Right(result.affectedRows > 0);
    } catch (e) {
      return Left(
        Exception('Lỗi khi cập nhật thông tin trọng tài: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, bool>> deleteReferee(int id) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để xóa trọng tài
      final query = '''
        DELETE FROM referee
        WHERE referee_id = @id
      ''';

      // Tham số cho câu lệnh SQL
      final params = {'id': id};

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      return Right(result.affectedRows > 0);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trọng tài: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<RefereeModel>>> searchReferee(
    String name,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Chuẩn bị từ khóa tìm kiếm
      final searchTerm = '%$name%';

      // Câu lệnh SQL để tìm kiếm trọng tài theo tên (cả có dấu và không dấu)
      final query = '''
        SELECT 
          referee_id, 
          full_name, 
          email
        FROM referee
        WHERE 
          full_name ILIKE @name OR
          unaccent(lower(full_name)) ILIKE unaccent(lower(@name))
        ORDER BY referee_id
      ''';

      // Tham số cho câu lệnh SQL
      final params = {'name': searchTerm};

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Chuyển đổi kết quả thành danh sách RefereeModel
      final refereeList =
          result.map((row) => RefereeModel.fromPostgres(row)).toList();

      return Right(refereeList);
    } catch (e) {
      return Left(Exception('Lỗi khi tìm kiếm trọng tài: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, RefereeModel?>> getRefereeById(int refereeId) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để lấy thông tin chi tiết của một trọng tài
      final query = '''
        SELECT 
          referee_id, 
          full_name, 
          email
        FROM referee
        WHERE referee_id = @id
      ''';

      // Tham số cho câu lệnh SQL
      final params = {'id': refereeId};

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      if (result.isEmpty) {
        return const Right(null);
      }

      // Chuyển đổi kết quả thành RefereeModel
      final row = result.first;
      final referee = RefereeModel.fromPostgres(row);

      return Right(referee);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy thông tin chi tiết trọng tài: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, bool>> addRefereePhone(
    RefereePhoneModel refereePhone,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Kiểm tra trọng tài có tồn tại không
      final checkRefereeQuery = '''
        SELECT COUNT(*) FROM referee WHERE referee_id = @refereeId
      ''';

      final checkParams = {'refereeId': refereePhone.refereeId};
      final checkResult = await conn.execute(
        Sql.named(checkRefereeQuery),
        parameters: checkParams,
      );

      final count = checkResult.first[0] as int;
      if (count == 0) {
        return Left(Exception('Trọng tài không tồn tại'));
      }

      // Kiểm tra số điện thoại đã tồn tại chưa
      final checkPhoneQuery = '''
        SELECT COUNT(*) FROM referee_phone 
        WHERE referee_id = @refereeId AND phone = @phone
      ''';

      final checkPhoneParams = {
        'refereeId': refereePhone.refereeId,
        'phone': refereePhone.phoneNumber,
      };

      final checkPhoneResult = await conn.execute(
        Sql.named(checkPhoneQuery),
        parameters: checkPhoneParams,
      );

      final phoneCount = checkPhoneResult.first[0] as int;
      if (phoneCount > 0) {
        return Left(Exception('Số điện thoại đã tồn tại cho trọng tài này'));
      }

      // Câu lệnh SQL để thêm số điện thoại cho trọng tài
      final query = '''
        INSERT INTO referee_phone (
          referee_id, 
          phone,
          phone_type
        ) VALUES (
          @refereeId, 
          @phone,
          @phoneType
        )
      ''';

      // Tham số cho câu lệnh SQL
      final params = {
        'refereeId': refereePhone.refereeId,
        'phone': refereePhone.phoneNumber,
        'phoneType': refereePhone.phoneType?.toString() ?? 'UNKNOWN',
      };

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      return Right(result.affectedRows > 0);
    } catch (e) {
      return Left(Exception('Lỗi khi thêm số điện thoại: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Exception, bool>> updateRefereePhone(
    int refereeId,
    String oldPhone,
    RefereePhoneModel refereePhone,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Kiểm tra trọng tài có tồn tại không
      final checkRefereeQuery = '''
        SELECT COUNT(*) FROM referee WHERE referee_id = @refereeId
      ''';
      
      final checkParams = {'refereeId': refereeId};
      final checkResult = await conn.execute(
        Sql.named(checkRefereeQuery),
        parameters: checkParams,
      );
      
      final count = checkResult.first[0] as int;
      if (count == 0) {
        return Left(Exception('Trọng tài không tồn tại'));
      }
      
      // Kiểm tra số điện thoại cũ có tồn tại không
      final checkOldPhoneQuery = '''
        SELECT COUNT(*) FROM referee_phone 
        WHERE referee_id = @refereeId AND phone = @oldPhone
      ''';
      
      final checkOldPhoneParams = {
        'refereeId': refereeId,
        'oldPhone': oldPhone,
      };
      
      final checkOldPhoneResult = await conn.execute(
        Sql.named(checkOldPhoneQuery),
        parameters: checkOldPhoneParams,
      );
      
      final oldPhoneCount = checkOldPhoneResult.first[0] as int;
      if (oldPhoneCount == 0) {
        return Left(Exception('Số điện thoại cũ không tồn tại'));
      }
      
      // Kiểm tra số điện thoại mới đã tồn tại cho trọng tài khác chưa
      if (oldPhone != refereePhone.phoneNumber) {
        final checkNewPhoneQuery = '''
          SELECT COUNT(*) FROM referee_phone 
          WHERE referee_id = @refereeId AND phone = @newPhone
        ''';
        
        final checkNewPhoneParams = {
          'refereeId': refereeId,
          'newPhone': refereePhone.phoneNumber,
        };
        
        final checkNewPhoneResult = await conn.execute(
          Sql.named(checkNewPhoneQuery),
          parameters: checkNewPhoneParams,
        );
        
        final newPhoneCount = checkNewPhoneResult.first[0] as int;
        if (newPhoneCount > 0) {
          return Left(Exception('Số điện thoại mới đã tồn tại cho trọng tài này'));
        }
      }

      // Câu lệnh SQL để cập nhật số điện thoại
      final query = '''
        UPDATE referee_phone
        SET 
          phone = @newPhone,
          phone_type = @phoneType
        WHERE 
          referee_id = @refereeId AND
          phone = @oldPhone
      ''';

      // Tham số cho câu lệnh SQL
      final params = {
        'refereeId': refereeId,
        'oldPhone': oldPhone,
        'newPhone': refereePhone.phoneNumber,
        'phoneType': refereePhone.phoneType?.toString() ?? 'UNKNOWN',
      };

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      return Right(result.affectedRows > 0);
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật số điện thoại: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Exception, List<RefereeDetailModel>>> getRefereeDetailList() async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để lấy danh sách thông tin chi tiết trọng tài
      final query = '''
        SELECT 
          referee_id, 
          full_name, 
          email, 
          phone
        FROM referee_detail
        ORDER BY referee_id
      ''';

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query));

      // Chuyển đổi kết quả thành danh sách RefereeDetailModel
      final refereeDetailList = result.map((row) => RefereeDetailModel.fromPostgres(row)).toList();

      // Nhóm các số điện thoại theo refereeId
      final Map<int, List<String>> phonesByRefereeId = {};
      for (final detail in refereeDetailList) {
        if (detail.refereeId != null && detail.phone != null) {
          phonesByRefereeId.putIfAbsent(detail.refereeId!, () => []);
          phonesByRefereeId[detail.refereeId!]!.add(detail.phone!);
        }
      }

      // Loại bỏ các bản ghi trùng lặp và tạo danh sách kết quả cuối cùng
      final Map<int, RefereeDetailModel> uniqueReferees = {};
      for (final detail in refereeDetailList) {
        if (detail.refereeId != null && !uniqueReferees.containsKey(detail.refereeId)) {
          uniqueReferees[detail.refereeId!] = detail;
        }
      }

      final List<RefereeDetailModel> finalList = uniqueReferees.values.toList();
      
      return Right(finalList);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách thông tin chi tiết trọng tài: ${e.toString()}'),
      );
    }
  }
  
  @override
  Future<Either<Exception, RefereeDetailModel?>> getRefereeDetailById(int refereeId) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Câu lệnh SQL để lấy thông tin chi tiết của một trọng tài
      final query = '''
        SELECT 
          referee_id, 
          full_name, 
          email, 
          phone
        FROM referee_detail
        WHERE referee_id = @id
      ''';

      // Tham số cho câu lệnh SQL
      final params = {'id': refereeId};

      // Thực thi câu lệnh SQL
      final result = await conn.execute(Sql.named(query), parameters: params);

      // Kiểm tra kết quả
      if (result.isEmpty) {
        return const Right(null);
      }

      // Lấy danh sách số điện thoại
      final List<String> phones = [];
      for (final row in result) {
        final phone = row[3] as String?;
        if (phone != null && phone.isNotEmpty) {
          phones.add(phone);
        }
      }

      // Chuyển đổi kết quả thành RefereeDetailModel
      final row = result.first;
      final referee = RefereeDetailModel.fromPostgres(row);

      return Right(referee);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy thông tin chi tiết trọng tài: ${e.toString()}'),
      );
    }
  }
}
