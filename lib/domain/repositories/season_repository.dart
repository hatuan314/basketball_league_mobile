import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';

abstract class SeasonRepository {
  Future<bool> createSeason(SeasonEntity season);
  Future<bool> updateSeason(SeasonEntity season);
  Future<bool> deleteSeason(int id);
  Future<List<SeasonEntity>> getSeasons();
  Future<List<SeasonEntity>> getSeasonByName(String name);
  Future<bool> generateSeasons();
}
