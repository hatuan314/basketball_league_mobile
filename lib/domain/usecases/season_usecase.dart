import 'package:baseketball_league_mobile/domain/entities/least_fouls_player_season_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/top_scores_season_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SeasonUsecase {
  Future<Either<Exception, List<SeasonEntity>>> getSeasonList();

  Future<Either<Exception, List<SeasonEntity>>> searchSeason(String name);

  Future<Either<Exception, bool>> createSeason(SeasonEntity season);

  Future<Either<Exception, bool>> updateSeason(SeasonEntity season);

  Future<Either<Exception, bool>> deleteSeason(int id);

  Future<Either<Exception, bool>> createRandomGeneratedSeasonList();

  Future<Either<Exception, List<LeastFoulsPlayerSeasonEntity>>>
  getTopLeastFoulsPlayerSeason(int seasonId, {int limit = 10});

  Future<Either<Exception, List<TopScoresSeasonEntity>>> getTopScoresSeason(
    int seasonId, {
    int limit = 10,
  });
}
