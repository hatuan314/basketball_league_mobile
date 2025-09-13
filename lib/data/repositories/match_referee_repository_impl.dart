import 'dart:math';

import 'package:baseketball_league_mobile/common/enums.dart';
import 'package:baseketball_league_mobile/data/datasources/match_referee_api.dart';
import 'package:baseketball_league_mobile/data/datasources/referee_api.dart';
import 'package:baseketball_league_mobile/data/models/match/match_referee_model.dart';
import 'package:baseketball_league_mobile/data/models/referee/referee_model.dart';
import 'package:baseketball_league_mobile/domain/match/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/match/match_referee_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_referee_repository.dart';
import 'package:dartz/dartz.dart';

/// Triển khai repository để quản lý trọng tài cho trận đấu
class MatchRefereeRepositoryImpl implements MatchRefereeRepository {
  /// API để tương tác với cơ sở dữ liệu
  final MatchRefereeApi _matchRefereeApi;

  /// API để lấy thông tin trọng tài
  final RefereeApi _refereeApi;

  /// Constructor
  MatchRefereeRepositoryImpl(this._matchRefereeApi, this._refereeApi);

  @override
  Future<Either<Exception, MatchRefereeEntity>> createMatchReferee(
    MatchRefereeEntity matchRefereeEntity,
  ) async {
    try {
      // Chuyển đổi từ entity sang model
      final model = MatchRefereeModel.fromEntity(matchRefereeEntity);

      // Gọi API để tạo mới trọng tài cho trận đấu
      final result = await _matchRefereeApi.createMatchReferee(model);

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi thêm trọng tài cho trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeEntity>>> getMatchReferees({
    int? matchId,
  }) async {
    try {
      // Gọi API để lấy danh sách trọng tài
      final result = await _matchRefereeApi.getMatchReferees(matchId: matchId);

      // Xử lý kết quả trả về
      return result.fold((exception) => Left(exception), (models) {
        // Chuyển đổi từ danh sách model sang danh sách entity
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách trọng tài cho trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatchReferee(String id) async {
    try {
      // Gọi API để xóa trọng tài khỏi trận đấu
      final result = await _matchRefereeApi.deleteMatchReferee(id);

      // Xử lý kết quả trả về
      return result;
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trọng tài khỏi trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeDetailEntity>>>
  getMatchRefereeDetailsByMatchId(int matchId) async {
    try {
      // Gọi API để lấy thông tin chi tiết của trọng tài theo trận đấu
      final result = await _matchRefereeApi.getMatchRefereeDetailsByMatchId(
        matchId,
      );

      // Xử lý kết quả trả về
      return result.fold((exception) => Left(exception), (models) {
        // Chuyển đổi từ danh sách model sang danh sách entity
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy thông tin chi tiết của trọng tài theo trận đấu: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeEntity>>> generateMatchReferees({
    required int roundId,
    required int matchId,
  }) async {
    try {
      // 1. Lấy danh sách tất cả các trọng tài hiện có
      final refereesResult = await _refereeApi.getRefereeList();

      if (refereesResult.isLeft()) {
        return Left(Exception('Không thể lấy danh sách trọng tài'));
      }

      final referees = refereesResult.fold(
        (exception) => <RefereeModel>[],
        (models) => models,
      );

      if (referees.isEmpty) {
        return Left(Exception('Không có trọng tài nào trong hệ thống'));
      }

      // 2. Lấy danh sách trọng tài đã được phân công trong vòng đấu này
      final matchesInRoundResult = await _matchRefereeApi.getMatchReferees();

      if (matchesInRoundResult.isLeft()) {
        return Left(
          Exception('Không thể lấy danh sách trọng tài đã phân công'),
        );
      }

      final matchesInRound = matchesInRoundResult.fold(
        (exception) => <MatchRefereeModel>[],
        (models) => models,
      );

      // 3. Lọc danh sách trọng tài đã được phân công trong vòng đấu này
      final assignedRefereeIds =
          matchesInRound
              .where(
                (mr) => mr.matchId != matchId,
              ) // Loại trừ trận đấu hiện tại
              .map((mr) => mr.refereeId)
              .toSet();

      // 4. Lọc danh sách trọng tài chưa được phân công trong vòng đấu này
      final availableReferees =
          referees
              .where((referee) => !assignedRefereeIds.contains(referee.id))
              .toList();

      // Nếu không đủ trọng tài, sử dụng lại các trọng tài đã được phân công
      if (availableReferees.length < 4) {
        // Trộn danh sách trọng tài
        referees.shuffle(Random());
      }

      // 5. Chọn 4 trọng tài: 3 trọng tài chính và 1 trọng tài bàn
      final selectedReferees =
          availableReferees.length >= 4
              ? availableReferees.sublist(0, 4)
              : referees.sublist(0, 4);

      // 6. Phân công vai trò cho các trọng tài
      final matchReferees = <MatchRefereeEntity>[];

      // 3 trọng tài chính
      for (int i = 0; i < 3; i++) {
        final referee = selectedReferees[i];
        final matchReferee = MatchRefereeEntity(
          matchId: matchId,
          refereeId: referee.id,
          role: RefereeType.main,
        );
        // matchReferees.add(matchReferee);
        // Tạo mới trọng tài cho trận đấu
        final result = await createMatchReferee(matchReferee);

        result.fold((exception) => null, (entity) => matchReferees.add(entity));
      }

      // 1 trọng tài bàn
      final tableReferee = selectedReferees[3];
      final tableMatchReferee = MatchRefereeEntity(
        matchId: matchId,
        refereeId: tableReferee.id,
        role: RefereeType.table,
      );
      // matchReferees.add(tableMatchReferee);
      // Tạo mới trọng tài bàn cho trận đấu
      final tableResult = await createMatchReferee(tableMatchReferee);

      tableResult.fold(
        (exception) => null,
        (entity) => matchReferees.add(entity),
      );

      return Right(matchReferees);
    } catch (e) {
      return Left(Exception('Lỗi khi phân công trọng tài cho trận đấu: $e'));
    }
  }
}
