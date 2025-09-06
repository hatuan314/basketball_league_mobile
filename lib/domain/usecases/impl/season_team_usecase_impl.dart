import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_team_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:dartz/dartz.dart';

/// Implementation của SeasonTeamUseCase
class SeasonTeamUseCaseImpl implements SeasonTeamUseCase {
  final SeasonTeamRepository _repository;

  SeasonTeamUseCaseImpl(this._repository);

  @override
  Future<Either<Exception, SeasonTeamEntity>> createSeasonTeam(
    SeasonTeamEntity seasonTeam,
  ) async {
    // Kiểm tra dữ liệu đầu vào
    if (seasonTeam.seasonId == null || seasonTeam.teamId == null || seasonTeam.homeId == null) {
      return Left(Exception('Thiếu thông tin bắt buộc: seasonId, teamId hoặc homeId'));
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
  }) async {
    // Gọi repository để lấy bảng xếp hạng
    return await _repository.getTeamStandings(seasonId: seasonId);
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
    
    if (seasonTeam.seasonId == null || seasonTeam.teamId == null || seasonTeam.homeId == null) {
      return Left(Exception('Thiếu thông tin bắt buộc: seasonId, teamId hoặc homeId'));
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
    return await _repository.createBulkSeasonTeams(seasonId: seasonId);
  }
}
