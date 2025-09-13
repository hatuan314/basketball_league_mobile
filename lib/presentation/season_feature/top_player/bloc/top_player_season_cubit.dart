import 'package:baseketball_league_mobile/domain/entities/least_fouls_player_season_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/top_scores_season_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_player_season_state.dart';

class TopPlayerSeasonCubit extends Cubit<TopPlayerSeasonState> {
  late final SeasonUsecase _seasonUsecase;
  TopPlayerSeasonCubit({required SeasonUsecase seasonUsecase})
    : super(TopPlayerSeasonState()) {
    _seasonUsecase = seasonUsecase;
  }

  Future<void> initial(int seasonId) async {
    emit(state.copyWith(status: TopPlayerSeasonStatus.loading));
    final topScoresSeasonList = await getTopScoresSeasonList(seasonId);
    final leastFoulsPlayerSeasonList = await getLeastFoulsPlayerSeasonList(
      seasonId,
    );
    emit(
      state.copyWith(
        status: TopPlayerSeasonStatus.loaded,
        topScoresSeasonList: topScoresSeasonList,
        leastFoulsPlayerSeasonList: leastFoulsPlayerSeasonList,
      ),
    );
  }

  Future<List<TopScoresSeasonEntity>> getTopScoresSeasonList(
    int seasonId,
  ) async {
    final result = await _seasonUsecase.getTopScoresSeason(seasonId);
    return result.fold((l) {
      emit(
        state.copyWith(
          status: TopPlayerSeasonStatus.error,
          errorMsg: l.toString(),
        ),
      );
      return [];
    }, (r) => r);
  }

  Future<List<LeastFoulsPlayerSeasonEntity>> getLeastFoulsPlayerSeasonList(
    int seasonId,
  ) async {
    final result = await _seasonUsecase.getTopLeastFoulsPlayerSeason(seasonId);
    return result.fold((l) {
      emit(
        state.copyWith(
          status: TopPlayerSeasonStatus.error,
          errorMsg: l.toString(),
        ),
      );
      return [];
    }, (r) => r);
  }

  void sortTopPlayerSeason(TopPlayerSeasonSortCriteria criteria) {
    emit(state.copyWith(sortCriteria: criteria));
  }
}

enum TopPlayerSeasonSortCriteria { topScores, leastFouls }
