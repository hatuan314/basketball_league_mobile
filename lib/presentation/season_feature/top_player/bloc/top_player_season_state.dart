part of 'top_player_season_cubit.dart';

enum TopPlayerSeasonStatus { loading, loaded, error }

class TopPlayerSeasonState {
  final TopPlayerSeasonStatus status;
  final List<TopScoresSeasonEntity> topScoresSeasonList;
  final List<LeastFoulsPlayerSeasonEntity> leastFoulsPlayerSeasonList;
  final String? errorMsg;
  final TopPlayerSeasonSortCriteria sortCriteria;

  TopPlayerSeasonState({
    this.status = TopPlayerSeasonStatus.loading,
    this.topScoresSeasonList = const [],
    this.leastFoulsPlayerSeasonList = const [],
    this.errorMsg,
    this.sortCriteria = TopPlayerSeasonSortCriteria.topScores,
  });

  TopPlayerSeasonState copyWith({
    TopPlayerSeasonStatus? status,
    List<TopScoresSeasonEntity>? topScoresSeasonList,
    List<LeastFoulsPlayerSeasonEntity>? leastFoulsPlayerSeasonList,
    String? errorMsg,
    TopPlayerSeasonSortCriteria? sortCriteria,
  }) {
    return TopPlayerSeasonState(
      status: status ?? this.status,
      topScoresSeasonList: topScoresSeasonList ?? this.topScoresSeasonList,
      leastFoulsPlayerSeasonList:
          leastFoulsPlayerSeasonList ?? this.leastFoulsPlayerSeasonList,
      errorMsg: errorMsg,
      sortCriteria: sortCriteria ?? this.sortCriteria,
    );
  }
}
