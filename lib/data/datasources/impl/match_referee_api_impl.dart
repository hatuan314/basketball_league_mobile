import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_referee_api.dart';
import 'package:baseketball_league_mobile/data/models/match_referee_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match_referee_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

/// Triển khai API để quản lý trọng tài cho trận đấu
class MatchRefereeApiImpl implements MatchRefereeApi {
  @override
  Future<Either<Exception, MatchRefereeModel>> createMatchReferee(
    MatchRefereeModel matchRefereeModel,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      final sql = '''
      INSERT INTO match_referee (match_id, referee_id, role)
      VALUES (@matchId, @refereeId, @role)
      ON CONFLICT (match_id, referee_id) DO UPDATE
      SET role = @role
      RETURNING match_referee_id, match_id, referee_id, role
      ''';

      final params = {
        'matchId': matchRefereeModel.matchId,
        'refereeId': matchRefereeModel.refereeId,
        'role': matchRefereeModel.role,
      };

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isEmpty) {
        return Left(Exception('Không thể thêm trọng tài cho trận đấu'));
      }

      final row = result[0];
      final model = MatchRefereeModel.fromRow(row);

      return Right(model);
    } catch (e) {
      print('Lỗi khi thêm trọng tài cho trận đấu: $e');
      return Left(Exception('Lỗi khi thêm trọng tài cho trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeModel>>> getMatchReferees({
    int? matchId,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      String sql;
      Map<String, dynamic> params = {};

      if (matchId != null) {
        sql = '''
        SELECT mr.match_referee_id, mr.match_id, mr.referee_id, mr.role
        FROM match_referee mr
        WHERE mr.match_id = @matchId
        ORDER BY mr.role
        ''';
        params['matchId'] = matchId;
      } else {
        sql = '''
        SELECT mr.match_referee_id, mr.match_id, mr.referee_id, mr.role
        FROM match_referee mr
        ORDER BY mr.match_id, mr.role
        ''';
      }

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isEmpty) {
        return const Right([]);
      }

      final matchReferees = <MatchRefereeModel>[];
      for (final row in result) {
        matchReferees.add(MatchRefereeModel.fromRow(row));
      }

      return Right(matchReferees);
    } catch (e) {
      print('Lỗi khi lấy danh sách trọng tài cho trận đấu: $e');
      return Left(
        Exception('Lỗi khi lấy danh sách trọng tài cho trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatchReferee(String id) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      final sql = '''
      DELETE FROM match_referee
      WHERE id = @id
      ''';

      await conn.execute(Sql.named(sql), parameters: {'id': id});

      return const Right(true);
    } catch (e) {
      print('Lỗi khi xóa trọng tài khỏi trận đấu: $e');
      return Left(Exception('Lỗi khi xóa trọng tài khỏi trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeDetailModel>>>
  getMatchRefereeDetailsByMatchId(int matchId) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Sử dụng view match_referee_details để lấy thông tin chi tiết của trọng tài theo trận đấu
      final sql = '''
      SELECT 
        match_referee_id,
        match_id,
        match_datetime,
        round_id,
        round_no,
        season_id,
        season_name,
        referee_id,
        referee_name,
        role,
        fee_per_match
      FROM match_referee_details
      WHERE match_id = @matchId
      ORDER BY role
      ''';

      final params = {'matchId': matchId};

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isEmpty) {
        return const Right([]);
      }

      final matchRefereeDetails = <MatchRefereeDetailModel>[];
      for (final row in result) {
        matchRefereeDetails.add(MatchRefereeDetailModel.fromPostgres(row));
      }

      return Right(matchRefereeDetails);
    } catch (e) {
      print('Lỗi khi lấy thông tin chi tiết của trọng tài theo trận đấu: $e');
      return Left(
        Exception(
          'Lỗi khi lấy thông tin chi tiết của trọng tài theo trận đấu: $e',
        ),
      );
    }
  }
}
