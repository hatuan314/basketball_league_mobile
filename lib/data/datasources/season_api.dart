import 'package:baseketball_league_mobile/data/models/season_model.dart';
import 'package:dartz/dartz.dart';

abstract class SeasonApi {
  Future<Either<Exception, List<SeasonModel>>> getSeasonList();

  Future<Either<Exception, bool>> createSeason(SeasonModel season);

  Future<Either<Exception, bool>> updateSeason(int id, SeasonModel season);

  Future<Either<Exception, bool>> deleteSeason(int id);

  Future<Either<Exception, List<SeasonModel>>> searchSeason(String name);

  Future<Either<Exception, bool>> createTable();
}
