import 'package:baseketball_league_mobile/data/models/season_model.dart';

abstract class SeasonApi {
  Future<List<SeasonModel>> getSeasonList();

  Future<bool> createSeason(SeasonModel season);

  Future<bool> updateSeason(int id, SeasonModel season);

  Future<bool> deleteSeason(int id);

  Future<List<SeasonModel>> searchSeason(String name);
}
