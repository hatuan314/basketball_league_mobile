import 'package:baseketball_league_mobile/data/datasources/match_api.dart';
import 'package:baseketball_league_mobile/data/models/match/match_model.dart';
import 'package:baseketball_league_mobile/domain/match/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/match/match_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_repository.dart';
import 'package:dartz/dartz.dart';

/// Triển khai repository để quản lý các trận đấu
class MatchRepositoryImpl implements MatchRepository {
  final MatchApi _matchApi;

  MatchRepositoryImpl(this._matchApi);

  @override
  Future<Either<Exception, MatchEntity>> createMatch(MatchEntity match) async {
    try {
      final matchModel = MatchModel.fromEntity(match);
      final result = await _matchApi.createMatch(matchModel);

      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tạo trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatch(int id) async {
    try {
      final result = await _matchApi.deleteMatch(id);

      return result.fold((error) => Left(error), (success) => Right(success));
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchEntity>>> generateMatches(
    int roundId,
  ) async {
    try {
      final result = await _matchApi.generateMatches(roundId);

      return result.fold(
        (error) => Left(error),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tạo các trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchEntity>> getMatchById(int id) async {
    try {
      final result = await _matchApi.getMatchById(id);

      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchEntity>>> getMatches({
    int? roundId,
  }) async {
    try {
      final result = await _matchApi.getMatches(roundId: roundId);

      return result.fold(
        (error) => Left(error),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchEntity>> updateMatch(MatchEntity match) async {
    try {
      final matchModel = MatchModel.fromEntity(match);
      final result = await _matchApi.updateMatch(matchModel);

      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
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
      final result = await _matchApi.getMatchDetailByRoundId(
        roundId,
        matchId: matchId,
      );

      return result.fold(
        (error) => Left(error),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy chi tiết trận đấu theo vòng đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchEntity>> updateMatchScore({
    required int matchId,
    required int homeScore,
    required int awayScore,
    int? homeFouls,
    int? awayFouls,
    int? attendance,
  }) async {
    try {
      // Kiểm tra điểm số hợp lệ (không âm)
      if (homeScore < 0 || awayScore < 0) {
        return Left(Exception('Điểm số không được âm'));
      }

      // Kiểm tra số lỗi hợp lệ (không âm) nếu được cung cấp
      if ((homeFouls != null && homeFouls < 0) ||
          (awayFouls != null && awayFouls < 0)) {
        return Left(Exception('Số lỗi không được âm'));
      }

      // Kiểm tra không được hòa (điểm số phải khác nhau)
      if (homeScore == awayScore) {
        return Left(
          Exception('Kết quả trận đấu không được hòa, điểm số phải khác nhau'),
        );
      }

      final result = await _matchApi.updateMatchScore(
        matchId: matchId,
        homeScore: homeScore,
        awayScore: awayScore,
        homeFouls: homeFouls,
        awayFouls: awayFouls,
        attendance: attendance,
      );

      return result.fold(
        (error) => Left(error),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật tỉ số và số lỗi trận đấu: $e'));
    }
  }
}
