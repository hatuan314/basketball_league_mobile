import 'package:baseketball_league_mobile/data/datasources/mock/season_mock.dart';
import 'package:baseketball_league_mobile/data/datasources/season_api.dart';
import 'package:baseketball_league_mobile/data/models/season_model.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';

class SeasonRepositoryImpl implements SeasonRepository {
  final SeasonApi seasonApi;

  SeasonRepositoryImpl({required this.seasonApi});

  @override
  Future<bool> createSeason(SeasonEntity season) {
    return seasonApi.createSeason(SeasonModel.fromEntity(season));
  }

  @override
  Future<bool> deleteSeason(int id) {
    return seasonApi.deleteSeason(id);
  }

  @override
  Future<bool> generateSeasons() async {
    final List<SeasonModel> seasonModels = mockSeasonList;
    final result = await Future.wait(
      seasonModels.map((seasonModel) => seasonApi.createSeason(seasonModel)),
    );
    return result.every((value) => value);
  }

  @override
  Future<List<SeasonEntity>> getSeasonByName(String name) async {
    final results = await seasonApi.searchSeason(name);
    return results.map((data) => data.toEntity()).toList();
  }

  @override
  Future<List<SeasonEntity>> getSeasons() async {
    final results = await seasonApi.getSeasonList();
    return results.map((data) => data.toEntity()).toList();
  }

  @override
  Future<bool> updateSeason(SeasonEntity season) async {
    return seasonApi.updateSeason(season.id!, SeasonModel.fromEntity(season));
  }
}
