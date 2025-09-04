part of 'season_list_cubit.dart';

enum SeasonListStatus { loading, loaded, error }

class SeasonListState {
  final SeasonListStatus status;
  final List<SeasonEntity>? seasons;
  final String? errorMessage;

  SeasonListState({required this.status, this.seasons, this.errorMessage});

  SeasonListState copyWith({
    SeasonListStatus? status,
    List<SeasonEntity>? seasons,
    String? errorMessage,
  }) {
    return SeasonListState(
      status: status ?? this.status,
      seasons: seasons ?? this.seasons,
      errorMessage: this.errorMessage,
    );
  }
}
