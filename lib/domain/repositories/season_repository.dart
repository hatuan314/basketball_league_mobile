import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SeasonRepository {
  Future<Either<Exception, bool>> createSeason(SeasonEntity season);
  Future<Either<Exception, bool>> updateSeason(SeasonEntity season);
  Future<Either<Exception, bool>> deleteSeason(int id);
  Future<Either<Exception, List<SeasonEntity>>> getSeasons();
  Future<Either<Exception, List<SeasonEntity>>> getSeasonByName(String name);
  Future<Either<Exception, bool>> generateSeasons();
}
