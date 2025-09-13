import 'package:baseketball_league_mobile/domain/match/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/match/match_referee_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_referee_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_referee_usecase.dart';
import 'package:dartz/dartz.dart';

/// Triển khai use case để quản lý trọng tài cho trận đấu
class MatchRefereeUseCaseImpl implements MatchRefereeUseCase {
  /// Repository để tương tác với dữ liệu
  final MatchRefereeRepository _matchRefereeRepository;

  /// Constructor
  MatchRefereeUseCaseImpl(this._matchRefereeRepository);

  @override
  Future<Either<Exception, MatchRefereeEntity>> createMatchReferee(
    MatchRefereeEntity matchRefereeEntity,
  ) async {
    try {
      // Kiểm tra tính hợp lệ của dữ liệu đầu vào
      if (matchRefereeEntity.matchId == null) {
        return Left(Exception('ID trận đấu không được để trống'));
      }

      if (matchRefereeEntity.refereeId == null) {
        return Left(Exception('ID trọng tài không được để trống'));
      }

      if (matchRefereeEntity.role == null) {
        return Left(Exception('Vai trò trọng tài không được để trống'));
      }

      // Gọi repository để thêm mới trọng tài cho trận đấu
      return await _matchRefereeRepository.createMatchReferee(
        matchRefereeEntity,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi thêm trọng tài cho trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatchReferee(String id) async {
    try {
      // Kiểm tra tính hợp lệ của dữ liệu đầu vào
      if (id.isEmpty) {
        return Left(Exception('ID không được để trống'));
      }

      // Gọi repository để xóa trọng tài khỏi trận đấu
      return await _matchRefereeRepository.deleteMatchReferee(id);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trọng tài khỏi trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeEntity>>> generateMatchReferees({
    required int roundId,
    required int matchId,
  }) async {
    try {
      // Kiểm tra tính hợp lệ của dữ liệu đầu vào
      if (roundId <= 0) {
        return Left(Exception('ID vòng đấu không hợp lệ'));
      }

      if (matchId <= 0) {
        return Left(Exception('ID trận đấu không hợp lệ'));
      }

      // Gọi repository để tự động phân công trọng tài cho trận đấu
      return await _matchRefereeRepository.generateMatchReferees(
        roundId: roundId,
        matchId: matchId,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi phân công trọng tài cho trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeEntity>>> getMatchReferees({
    int? matchId,
  }) async {
    try {
      // Kiểm tra tính hợp lệ của dữ liệu đầu vào nếu có
      if (matchId != null && matchId <= 0) {
        return Left(Exception('ID trận đấu không hợp lệ'));
      }

      // Gọi repository để lấy danh sách trọng tài cho trận đấu
      return await _matchRefereeRepository.getMatchReferees(matchId: matchId);
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy danh sách trọng tài cho trận đấu: $e'),
      );
    }
  }

  @override
  Future<Either<Exception, List<MatchRefereeDetailEntity>>>
  getMatchRefereeDetailsByMatchId(int matchId) async {
    try {
      // Kiểm tra tính hợp lệ của dữ liệu đầu vào
      if (matchId <= 0) {
        return Left(Exception('ID trận đấu không hợp lệ'));
      }

      // Gọi repository để lấy thông tin chi tiết của trọng tài theo trận đấu
      return await _matchRefereeRepository.getMatchRefereeDetailsByMatchId(
        matchId,
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy thông tin chi tiết của trọng tài theo trận đấu: $e',
        ),
      );
    }
  }
}
