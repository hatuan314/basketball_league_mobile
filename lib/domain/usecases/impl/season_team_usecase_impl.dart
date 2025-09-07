import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_color_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_season_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_team_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_color_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:dartz/dartz.dart';

/// Implementation của SeasonTeamUseCase
class SeasonTeamUseCaseImpl implements SeasonTeamUseCase {
  final SeasonTeamRepository _repository;
  final TeamColorRepository _teamColorRepository;
  final PlayerSeasonRepository _playerSeasonRepository;

  SeasonTeamUseCaseImpl(
    this._repository,
    this._teamColorRepository,
    this._playerSeasonRepository,
  );

  @override
  Future<Either<Exception, SeasonTeamEntity>> createSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonTeam.seasonId == null ||
        seasonTeam.teamId == null ||
        seasonTeam.homeId == null) {
      return Left(
        Exception('Thiếu thông tin bắt buộc: seasonId, teamId hoặc homeId'),
      );
    }

    // Gọi repository để tạo mối quan hệ
    return await _repository.createSeasonTeam(seasonTeam);
  }

  @override
  Future<Either<Exception, Unit>> deleteSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonTeam.id == null) {
      return Left(Exception('Không thể xóa mối quan hệ không có ID'));
    }

    // Gọi repository để xóa mối quan hệ
    return await _repository.deleteSeasonTeam(seasonTeam);
  }

  @override
  Future<Either<Exception, List<SeasonTeamEntity>>> getSeasonTeams() async {
    // Gọi repository để lấy danh sách
    return await _repository.getSeasonTeams();
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>> getTeamStandings({
    int? seasonId,
    int? teamId,
  }) async {
    // Gọi repository để lấy bảng xếp hạng
    return await _repository.getTeamStandings(
      seasonId: seasonId,
      teamId: teamId,
    );
  }

  @override
  Future<Either<Exception, List<TeamStandingEntity>>> searchTeamStandingByName(
    String name,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (name.isEmpty) {
      return Left(Exception('Từ khóa tìm kiếm không được để trống'));
    }

    // Gọi repository để tìm kiếm
    return await _repository.searchSeasonTeamByName(name);
  }

  @override
  Future<Either<Exception, SeasonTeamEntity>> updateSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonTeam.id == null) {
      return Left(Exception('Không thể cập nhật mối quan hệ không có ID'));
    }

    if (seasonTeam.seasonId == null ||
        seasonTeam.teamId == null ||
        seasonTeam.homeId == null) {
      return Left(
        Exception('Thiếu thông tin bắt buộc: seasonId, teamId hoặc homeId'),
      );
    }

    // Gọi repository để cập nhật
    return await _repository.updateSeasonTeam(seasonTeam);
  }

  @override
  Future<Either<Exception, List<SeasonTeamEntity>>> createBulkSeasonTeams({
    required int seasonId,
  }) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonId <= 0) {
      return Left(Exception('ID mùa giải không hợp lệ'));
    }

    // Gọi repository để tạo hàng loạt mối quan hệ
    final result = await _repository.createBulkSeasonTeams(seasonId: seasonId);

    return result.fold((exception) => Left(exception), (seasonTeams) async {
      // Tạo màu áo cho các đội
      final teamColorResults = await _createBulkTeamColors(
        seasonId: seasonId,
        seasonTeams: seasonTeams,
      );

      return teamColorResults.fold((exception) => Left(exception), (
        teamColors,
      ) async {
        return Right(seasonTeams);
      });
    });
  }

  Future<Either<Exception, List<TeamColorEntity>>> _createBulkTeamColors({
    required int seasonId,
    required List<SeasonTeamEntity> seasonTeams,
  }) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonId <= 0) {
      return Left(Exception('ID mùa giải không hợp lệ'));
    }

    final List<int> teamIds = seasonTeams.map((team) => team.teamId!).toList();
    final teamColorResults = await _teamColorRepository
        .generateUniqueTeamColors(seasonId: seasonId, teamIds: teamIds);

    return teamColorResults.fold(
      (exception) => Left(exception),
      (teamColors) => Right(teamColors),
    );
  }

  @override
  Future<Either<Exception, SeasonTeamEntity?>> getSeasonTeamBySeasonAndTeam({
    required int seasonId,
    required int teamId,
  }) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonId <= 0) {
      return Left(Exception('ID mùa giải không hợp lệ'));
    }

    if (teamId <= 0) {
      return Left(Exception('ID đội bóng không hợp lệ'));
    }

    // Gọi repository để lấy thông tin đội bóng trong mùa giải
    return await _repository.getSeasonTeamBySeasonAndTeam(
      seasonId: seasonId,
      teamId: teamId,
    );
  }
}
