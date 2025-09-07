import 'package:baseketball_league_mobile/data/datasources/match_api.dart';
import 'package:baseketball_league_mobile/data/models/match_model.dart';
import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';
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
}
