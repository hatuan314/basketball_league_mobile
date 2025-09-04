import 'package:baseketball_league_mobile/data/datasources/mock/season_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/season_api.dart';
import 'package:baseketball_league_mobile/data/models/season_model.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';
import 'package:dartz/dartz.dart';

class SeasonRepositoryImpl implements SeasonRepository {
  final SeasonApi seasonApi;

  SeasonRepositoryImpl({required this.seasonApi});

  @override
  Future<Either<Exception, bool>> createSeason(SeasonEntity season) async {
    final result = await seasonApi.createSeason(SeasonModel.fromEntity(season));
    return result.fold(
      (exception) {
        print('Lỗi khi tạo mùa giải: $exception');
        return Left(exception);
      },
      (success) => Right(success),
    );
  }

  @override
  Future<Either<Exception, bool>> deleteSeason(int id) async {
    final result = await seasonApi.deleteSeason(id);
    return result.fold(
      (exception) {
        print('Lỗi khi xóa mùa giải: $exception');
        return Left(exception);
      },
      (success) => Right(success),
    );
  }

  @override
  Future<Either<Exception, bool>> generateSeasons() async {
    final List<SeasonModel> seasonModels = mockSeasonList;
    final results = await Future.wait(
      seasonModels.map((seasonModel) => seasonApi.createSeason(seasonModel)),
    );
    
    // Kiểm tra kết quả từ mỗi Either
    bool allSuccess = true;
    Exception? firstException;
    
    for (var result in results) {
      final isSuccess = result.fold(
        (exception) {
          print('Lỗi khi tạo mùa giải: $exception');
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

  @override
  Future<Either<Exception, List<SeasonEntity>>> getSeasonByName(String name) async {
    final results = await seasonApi.searchSeason(name);
    return results.fold(
      (exception) {
        print('Lỗi khi tìm kiếm mùa giải: $exception');
        return Left(exception);
      },
      (seasonList) => Right(seasonList.map((data) => data.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Exception, List<SeasonEntity>>> getSeasons() async {
    final results = await seasonApi.getSeasonList();
    return results.fold(
      (exception) {
        print('Lỗi khi lấy danh sách mùa giải: $exception');
        return Left(exception);
      },
      (seasonList) => Right(seasonList.map((data) => data.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Exception, bool>> updateSeason(SeasonEntity season) async {
    final result = await seasonApi.updateSeason(season.id!, SeasonModel.fromEntity(season));
    return result.fold(
      (exception) {
        print('Lỗi khi cập nhật mùa giải: $exception');
        return Left(exception);
      },
      (success) => Right(success),
    );
  }
}
