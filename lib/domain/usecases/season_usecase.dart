import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';

abstract class SeasonUsecase {
  Future<List<SeasonEntity>> getSeasonList();

  Future<List<SeasonEntity>> searchSeason(String name);

  Future<bool> createSeason(SeasonEntity season);

  Future<bool> updateSeason(SeasonEntity season);

  Future<bool> deleteSeason(int id);

  Future<bool> createRandomGeneratedSeasonList();
}
