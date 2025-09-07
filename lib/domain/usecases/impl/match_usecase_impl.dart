import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_usecase.dart';
import 'package:dartz/dartz.dart';

/// Triển khai UseCase để quản lý các trận đấu
class MatchUseCaseImpl implements MatchUseCase {
  final MatchRepository _matchRepository;

  MatchUseCaseImpl(this._matchRepository);

  @override
  Future<Either<Exception, MatchEntity>> createMatch(MatchEntity match) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (match.roundId == null) {
        return Left(Exception('ID vòng đấu không được để trống'));
      }
      if (match.matchDate == null) {
        return Left(Exception('Thời gian trận đấu không được để trống'));
      }
      if (match.homeTeamId == null) {
        return Left(Exception('ID đội nhà không được để trống'));
      }
      if (match.awayTeamId == null) {
        return Left(Exception('ID đội khách không được để trống'));
      }
      if (match.homeColor == null || match.homeColor!.isEmpty) {
        return Left(Exception('Màu áo đội nhà không được để trống'));
      }
      if (match.awayColor == null || match.awayColor!.isEmpty) {
        return Left(Exception('Màu áo đội khách không được để trống'));
      }
      if (match.homeTeamId == match.awayTeamId) {
        return Left(Exception('Đội nhà và đội khách không được trùng nhau'));
      }
      if (match.homeColor == match.awayColor) {
        return Left(
          Exception('Màu áo đội nhà và đội khách không được trùng nhau'),
        );
      }

      // Gọi repository để tạo trận đấu
      return await _matchRepository.createMatch(match);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatch(int id) async {
    try {
      // Kiểm tra ID
      if (id <= 0) {
        return Left(Exception('ID trận đấu không hợp lệ'));
      }

      // Gọi repository để xóa trận đấu
      return await _matchRepository.deleteMatch(id);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchEntity>>> generateMatches(
    int roundId,
  ) async {
    try {
      // Kiểm tra ID vòng đấu
      if (roundId <= 0) {
        return Left(Exception('ID vòng đấu không hợp lệ'));
      }

      // Gọi repository để tạo các trận đấu
      return await _matchRepository.generateMatches(roundId);
    } catch (e) {
      return Left(Exception('Lỗi khi tạo các trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchEntity>> getMatchById(int id) async {
    try {
      // Kiểm tra ID
      if (id <= 0) {
        return Left(Exception('ID trận đấu không hợp lệ'));
      }

      // Gọi repository để lấy thông tin trận đấu
      return await _matchRepository.getMatchById(id);
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchEntity>>> getMatches({
    int? roundId,
  }) async {
    try {
      // Kiểm tra ID vòng đấu nếu có
      if (roundId != null && roundId <= 0) {
        return Left(Exception('ID vòng đấu không hợp lệ'));
      }

      // Gọi repository để lấy danh sách trận đấu
      return await _matchRepository.getMatches(roundId: roundId);
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchEntity>> updateMatch(MatchEntity match) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (match.id == null || match.id! <= 0) {
        return Left(Exception('ID trận đấu không hợp lệ'));
      }
      if (match.roundId == null) {
        return Left(Exception('ID vòng đấu không được để trống'));
      }
      if (match.matchDate == null) {
        return Left(Exception('Thời gian trận đấu không được để trống'));
      }
      if (match.homeTeamId == null) {
        return Left(Exception('ID đội nhà không được để trống'));
      }
      if (match.awayTeamId == null) {
        return Left(Exception('ID đội khách không được để trống'));
      }
      if (match.homeColor == null || match.homeColor!.isEmpty) {
        return Left(Exception('Màu áo đội nhà không được để trống'));
      }
      if (match.awayColor == null || match.awayColor!.isEmpty) {
        return Left(Exception('Màu áo đội khách không được để trống'));
      }
      if (match.homeTeamId == match.awayTeamId) {
        return Left(Exception('Đội nhà và đội khách không được trùng nhau'));
      }
      if (match.homeColor == match.awayColor) {
        return Left(
          Exception('Màu áo đội nhà và đội khách không được trùng nhau'),
        );
      }

      // Gọi repository để cập nhật trận đấu
      return await _matchRepository.updateMatch(match);
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchDetailEntity>>> getMatchDetailByRoundId(
    int roundId, {
    int? matchId,
  }) async {
    try {
      // Kiểm tra ID vòng đấu
      if (roundId <= 0) {
        return Left(Exception('ID vòng đấu không hợp lệ'));
      }

      // Gọi repository để lấy chi tiết trận đấu theo vòng đấu
      return await _matchRepository.getMatchDetailByRoundId(
        roundId,
        matchId: matchId,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy chi tiết trận đấu theo vòng đấu: $e'));
    }
  }
}
