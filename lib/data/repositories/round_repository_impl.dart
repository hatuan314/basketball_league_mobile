import 'package:baseketball_league_mobile/data/datasources/round_api.dart';
import 'package:baseketball_league_mobile/data/models/round_model.dart';
import 'package:baseketball_league_mobile/domain/entities/round/round_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/round/top_scores_by_round_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/round_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_team_repository.dart';
import 'package:dartz/dartz.dart';

class RoundRepositoryImpl implements RoundRepository {
  final RoundApi _roundApi;
  final SeasonRepository _seasonRepository;
  final SeasonTeamRepository _seasonTeamRepository;

  RoundRepositoryImpl({
    required RoundApi roundApi,
    required SeasonRepository seasonRepository,
    required SeasonTeamRepository seasonTeamRepository,
  }) : _roundApi = roundApi,
       _seasonRepository = seasonRepository,
       _seasonTeamRepository = seasonTeamRepository;

  @override
  Future<Either<Exception, RoundEntity>> createRound(RoundEntity round) async {
    try {
      // Chuyển đổi entity thành model
      final roundModel = RoundModel.fromEntity(round);

      // Gọi API để tạo vòng đấu
      final result = await _roundApi.createRound(roundModel);

      // Xử lý kết quả
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tạo vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteRound(int id) async {
    try {
      // Gọi API để xóa vòng đấu
      final result = await _roundApi.deleteRound(id);

      // Xử lý kết quả
      return result.fold((exception) => Left(exception), (unit) => Right(unit));
    } catch (e) {
      return Left(Exception('Lỗi khi xóa vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<RoundEntity>>> generateRounds({
    required int seasonId,
  }) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (seasonId <= 0) {
        return Left(Exception('ID mùa giải không hợp lệ'));
      }

      // Lấy thông tin mùa giải
      final seasonResult = await _seasonRepository.getSeasons();

      return await seasonResult.fold((exception) => Left(exception), (
        seasons,
      ) async {
        // Tìm mùa giải theo ID
        final season = seasons.firstWhere(
          (s) => s.id == seasonId,
          orElse: () => SeasonEntity(),
        );

        if (season.id == null) {
          return Left(Exception('Không tìm thấy mùa giải với ID: $seasonId'));
        }

        if (season.startDate == null) {
          return Left(Exception('Mùa giải không có ngày bắt đầu'));
        }

        // Lấy danh sách đội tham gia trong mùa giải
        final teamStandingsResult = await _seasonTeamRepository
            .getTeamStandings(seasonId: seasonId);

        return await teamStandingsResult.fold((exception) => Left(exception), (
          teamStandings,
        ) async {
          // Tính số lượng đội tham gia
          final teamCount = teamStandings.length;

          if (teamCount <= 0) {
            return Left(Exception('Không có đội nào tham gia mùa giải này'));
          }

          // Tính số lượng vòng đấu dựa vào số lượng đội
          // Công thức: (n-1)*2 với n là số lượng đội (mỗi đội đấu với tất cả các đội khác, sân nhà và sân khách)
          final numberOfRounds = (teamCount - 1) * 2;

          // Thời gian bắt đầu vòng đầu tiên là thời gian bắt đầu giải
          final startDate = season.startDate!;

          // Thời gian tổ chức giữa 2 vòng đấu là 1 tuần (7 ngày)
          const daysBetweenRounds = 7;

          // Gọi API để tạo nhiều vòng đấu
          final result = await _roundApi.generateRounds(
            seasonId: seasonId,
            numberOfRounds: numberOfRounds,
            startDate: startDate,
            daysBetweenRounds: daysBetweenRounds,
          );

          // Xử lý kết quả
          return result.fold((exception) => Left(exception), (models) {
            // Chuyển đổi danh sách model thành danh sách entity
            final entities = models.map((model) => model.toEntity()).toList();
            return Right(entities);
          });
        });
      });
    } catch (e) {
      return Left(Exception('Lỗi khi tạo nhiều vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, RoundEntity>> getRoundById(int id) async {
    try {
      // Gọi API để lấy thông tin vòng đấu
      final result = await _roundApi.getRoundById(id);

      // Xử lý kết quả
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi lấy thông tin vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<RoundEntity>>> getRounds({
    int? seasonId,
  }) async {
    try {
      // Gọi API để lấy danh sách vòng đấu
      final result = await _roundApi.getRounds(seasonId: seasonId);

      // Xử lý kết quả
      return result.fold((exception) => Left(exception), (models) {
        // Chuyển đổi danh sách model thành danh sách entity
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, RoundEntity>> updateRound(RoundEntity round) async {
    try {
      // Chuyển đổi entity thành model
      final roundModel = RoundModel.fromEntity(round);

      // Gọi API để cập nhật vòng đấu
      final result = await _roundApi.updateRound(roundModel);

      // Xử lý kết quả
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật vòng đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, TopScoresByRoundEntity>> getTopScoresByRound({
    int? seasonId,
    int? roundId,
  }) async {
    try {
      // Gọi API để lấy thông tin vòng đấu
      final result = await _roundApi.getTopScoresByRound(
        seasonId: seasonId,
        roundId: roundId,
      );

      // Xử lý kết quả
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy thông tin cầu thủ ghi nhiều bàn nhất vòng đấu: ${e.toString()}',
        ),
      );
    }
  }
}
