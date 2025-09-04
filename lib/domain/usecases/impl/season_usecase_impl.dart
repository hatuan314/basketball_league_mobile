import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:dartz/dartz.dart';

class SeasonUsecaseImpl implements SeasonUsecase {
  final SeasonRepository seasonRepository;

  SeasonUsecaseImpl({required this.seasonRepository});

  @override
  Future<Either<Exception, bool>> createRandomGeneratedSeasonList() {
    return seasonRepository.generateSeasons();
  }

  @override
  Future<Either<Exception, bool>> createSeason(SeasonEntity season) {
    return seasonRepository.createSeason(season);
  }

  @override
  Future<Either<Exception, bool>> deleteSeason(int id) {
    return seasonRepository.deleteSeason(id);
  }

  @override
  Future<Either<Exception, List<SeasonEntity>>> getSeasonList() {
    return seasonRepository.getSeasons();
  }

  @override
  Future<Either<Exception, List<SeasonEntity>>> searchSeason(String name) {
    return seasonRepository.getSeasonByName(name);
  }

  @override
  Future<Either<Exception, bool>> updateSeason(SeasonEntity season) {
    return seasonRepository.updateSeason(season);
  }
}
