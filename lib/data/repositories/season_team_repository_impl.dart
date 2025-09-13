import 'dart:math';

import 'package:baseketball_league_mobile/data/datasources/season_team_api.dart';
import 'package:baseketball_league_mobile/data/models/season_team_model.dart';
import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_team_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/stadium_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation của SeasonTeamRepository
class SeasonTeamRepositoryImpl implements SeasonTeamRepository {
  final SeasonTeamApi seasonTeamApi;
  final TeamRepository teamRepository;
  final StadiumRepository stadiumRepository;

  SeasonTeamRepositoryImpl({
    required this.seasonTeamApi,
    required this.teamRepository,
    required this.stadiumRepository,
  });

  @override
  Future<Either<Exception, SeasonTeamEntity>> createSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    try {
      // Chuyển đổi entity thành model
      final seasonTeamModel = SeasonTeamModel.fromEntity(seasonTeam);

      // Gọi API để tạo mới
      final result = await seasonTeamApi.createSeasonTeam(seasonTeamModel);

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi tạo mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    try {
      // Chuyển đổi entity thành model
      final seasonTeamModel = SeasonTeamModel.fromEntity(seasonTeam);

      // Gọi API để xóa
      final result = await seasonTeamApi.deleteSeasonTeam(seasonTeamModel);

      // Xử lý kết quả trả về
      return result.fold((exception) => Left(exception), (unit) => Right(unit));
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi xóa mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<SeasonTeamEntity>>> getSeasonTeams() async {
    try {
      // Gọi API để lấy danh sách
      final result = await seasonTeamApi.getSeasonTeams();

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy danh sách mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>> getTeamStandings({
    int? seasonId,
    int? teamId,
  }) async {
    try {
      // Gọi API để lấy bảng xếp hạng
      final result = await seasonTeamApi.getTeamStandings(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy bảng xếp hạng đội bóng: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>> searchSeasonTeamByName(
    String name,
  ) async {
    try {
      // Gọi API để tìm kiếm
      final result = await seasonTeamApi.searchSeasonTeamByName(name);

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi tìm kiếm bảng xếp hạng đội bóng theo tên: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, SeasonTeamEntity>> updateSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    try {
      // Chuyển đổi entity thành model
      final seasonTeamModel = SeasonTeamModel.fromEntity(seasonTeam);

      // Gọi API để cập nhật
      final result = await seasonTeamApi.updateSeasonTeam(seasonTeamModel);

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi cập nhật mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<SeasonTeamEntity>>> createBulkSeasonTeams({
    required int seasonId,
  }) async {
    try {
      // Lấy danh sách đội bóng từ cơ sở dữ liệu nếu không được cung cấp
      List<int> finalTeamIds = [];
      List<int> finalStadiumIds = [];

      // Lấy danh sách đội bóng từ cơ sở dữ liệu
      final teamsResult = await teamRepository.getTeams();

      // Xử lý kết quả
      final teams = teamsResult.fold(
        (exception) => throw exception,
        (teams) => teams,
      );

      // Kiểm tra số lượng đội bóng
      if (teams.isEmpty) {
        return Left(Exception('Không có đội bóng nào trong cơ sở dữ liệu'));
      }

      // Nếu có ít hơn 8 đội, sử dụng tất cả
      if (teams.length <= 8) {
        finalTeamIds = teams.map((team) => team.id!).cast<int>().toList();
      } else {
        // Chọn ngẫu nhiên 8 đội từ danh sách
        final random = Random();
        final shuffledTeams = List.from(teams)..shuffle(random);
        finalTeamIds =
            shuffledTeams.take(8).map((team) => team.id!).cast<int>().toList();
      }

      // Đảm bảo có ít nhất 8 đội
      if (finalTeamIds.length < 8) {
        return Left(Exception('Cần có ít nhất 8 đội bóng để tạo giải đấu'));
      }

      // Xử lý stadiumIds
      final stadiumsResult = await stadiumRepository.getStadiums();

      // Xử lý kết quả
      final stadiums = stadiumsResult.fold(
        (exception) => throw exception,
        (stadiums) => stadiums,
      );

      // Nếu có ít hơn 8 sân vận động, sử dụng tất cả
      if (stadiums.length <= 8) {
        finalStadiumIds =
            stadiums.map((stadium) => stadium.id!).cast<int>().toList();
      } else {
        // Chọn ngẫu nhiên 8 sân vận động từ danh sách
        final random = Random();
        final shuffledStadiums = List.from(stadiums)..shuffle(random);
        finalStadiumIds =
            shuffledStadiums
                .take(8)
                .map((stadium) => stadium.id!)
                .cast<int>()
                .toList();
      }

      // Đảm bảo có ít nhất 8 sân vận động
      if (finalStadiumIds.length < 8) {
        return Left(Exception('Cần có ít nhất 8 sân vận động để tạo giải đấu'));
      }

      // Tạo danh sách các mối quan hệ giữa giải đấu và đội bóng
      final List<SeasonTeamEntity> createdEntities = [];
      final List<Exception> errors = [];

      // Tạo từng mối quan hệ một
      for (int i = 0; i < finalTeamIds.length; i++) {
        final seasonTeam = SeasonTeamEntity(
          seasonId: seasonId,
          teamId: finalTeamIds[i],
          homeId: finalStadiumIds[i],
        );

        // Gọi hàm createSeasonTeam để tạo mối quan hệ
        final result = await createSeasonTeam(seasonTeam);

        // Xử lý kết quả
        result.fold(
          (exception) => errors.add(exception),
          (entity) => createdEntities.add(entity),
        );
      }

      // Kiểm tra kết quả
      if (errors.isNotEmpty) {
        // Nếu có lỗi, trả về lỗi đầu tiên
        return Left(errors.first);
      } else {
        // Nếu không có lỗi, trả về danh sách các mối quan hệ đã được tạo
        return Right(createdEntities);
      }
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi tạo hàng loạt mối quan hệ giữa giải đấu và đội bóng: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, SeasonTeamEntity?>> getSeasonTeamBySeasonAndTeam({
    required int seasonId,
    required int teamId,
  }) async {
    try {
      // Gọi API để lấy thông tin đội bóng trong một mùa giải
      final result = await seasonTeamApi.getSeasonTeamBySeasonAndTeam(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (model) => model != null ? Right(model.toEntity()) : const Right(null),
      );
    } catch (e) {
      return Left(
        Exception(
          'Lỗi khi lấy thông tin đội bóng trong mùa giải: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>>
  getTeamStandingsByAwayWins({int? seasonId, int? teamId}) async {
    try {
      // Gọi API để lấy bảng xếp hạng
      final result = await seasonTeamApi.getTeamStandingsByAwayWins(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy bảng xếp hạng đội bóng: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>>
  getTeamStandingsByPointDifference({int? seasonId, int? teamId}) async {
    try {
      // Gọi API để lấy bảng xếp hạng
      final result = await seasonTeamApi.getTeamStandingsByPointDifference(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy bảng xếp hạng đội bóng: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>>
  getTeamStandingsByTotalFouls({int? seasonId, int? teamId}) async {
    try {
      // Gọi API để lấy bảng xếp hạng
      final result = await seasonTeamApi.getTeamStandingsByTotalFouls(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy bảng xếp hạng đội bóng: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>>
  getTeamStandingsByTotalPointsScored({int? seasonId, int? teamId}) async {
    try {
      // Gọi API để lấy bảng xếp hạng
      final result = await seasonTeamApi.getTeamStandingsByTotalPointsScored(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả trả về
      return result.fold(
        (exception) => Left(exception),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi lấy bảng xếp hạng đội bóng: ${e.toString()}'),
      );
    }
  }
}
