import 'package:baseketball_league_mobile/data/datasources/mock/team_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/team_api.dart';
import 'package:baseketball_league_mobile/data/models/team_model.dart';
import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_repository.dart';
import 'package:dartz/dartz.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamApi teamApi;

  TeamRepositoryImpl({required this.teamApi});

  @override
  Future<Either<Exception, List<TeamEntity>>> getTeams() async {
    final result = await teamApi.getTeams();
    return result.fold(
      (exception) {
        print('Lỗi khi lấy danh sách đội bóng: $exception');
        return Left(exception);
      },
      (teams) => Right(teams.map((team) => team.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Exception, bool>> createTeam(TeamEntity team) async {
    final result = await teamApi.createTeam(TeamModel.fromEntity(team));
    return result.fold(
      (exception) {
        print('Lỗi khi tạo đội bóng: $exception');
        return Left(exception);
      },
      (success) => Right(success),
    );
  }

  @override
  Future<Either<Exception, bool>> updateTeam(TeamEntity team) async {
    final result = await teamApi.updateTeam(TeamModel.fromEntity(team));
    return result.fold(
      (exception) {
        print('Lỗi khi cập nhật đội bóng: $exception');
        return Left(exception);
      },
      (success) => Right(success),
    );
  }

  @override
  Future<Either<Exception, bool>> deleteTeam(int id) async {
    final result = await teamApi.deleteTeam(id);
    return result.fold(
      (exception) {
        print('Lỗi khi xóa đội bóng: $exception');
        return Left(exception);
      },
      (success) => Right(success),
    );
  }

  @override
  Future<Either<Exception, List<TeamEntity>>> getTeamByName(String name) async {
    final result = await teamApi.getTeamByName(name);
    return result.fold(
      (exception) {
        print('Lỗi khi tìm kiếm đội bóng: $exception');
        return Left(exception);
      },
      (teams) => Right(teams.map((team) => team.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Exception, bool>> generateTeams() async {
    final results = await Future.wait(
      teamMock.map((teamModel) => teamApi.createTeam(teamModel)),
    );
    
    // Kiểm tra kết quả từ mỗi Either
    bool allSuccess = true;
    Exception? firstException;
    
    for (var result in results) {
      final isSuccess = result.fold(
        (exception) {
          print('Lỗi khi tạo đội bóng: $exception');
          if (firstException == null) {
            firstException = exception;
          }
          return false;
        },
        (success) => success,
      );
      if (!isSuccess) {
        allSuccess = false;
      }
    }
    
    if (!allSuccess && firstException != null) {
      return Left(firstException!);
    }
    return Right(allSuccess);
  }
}
