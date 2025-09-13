import 'package:baseketball_league_mobile/data/models/least_fouls_player_season_model.dart';
import 'package:baseketball_league_mobile/data/models/season_model.dart';
import 'package:baseketball_league_mobile/data/models/top_scores_season_model.dart';
import 'package:dartz/dartz.dart';

abstract class SeasonApi {
  Future<Either<Exception, List<SeasonModel>>> getSeasonList();

  Future<Either<Exception, bool>> createSeason(SeasonModel season);

  Future<Either<Exception, bool>> updateSeason(int id, SeasonModel season);

  Future<Either<Exception, bool>> deleteSeason(int id);

  Future<Either<Exception, List<SeasonModel>>> searchSeason(String name);

  Future<Either<Exception, bool>> createTable();

  Future<Either<Exception, List<TopScoresSeasonModel>>> getTopScoresSeason(
    int seasonId, {
    int limit = 10,
  });

  Future<Either<Exception, List<LeastFoulsPlayerSeasonModel>>>
  getTopLeastFoulsPlayerSeason(int seasonId, {int limit = 10});
}
