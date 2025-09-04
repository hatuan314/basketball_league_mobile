part of 'home_cubit.dart';

enum HomeStatus { loading, loaded, error }

class HomeState {
  final HomeStatus status;
  final List<SeasonEntity>? seasons;
  final String? errorMessage;

  HomeState({required this.status, this.seasons, this.errorMessage});

  HomeState copyWith({
    HomeStatus? status,
    List<SeasonEntity>? seasons,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      seasons: seasons ?? this.seasons,
      errorMessage: this.errorMessage,
    );
  }
}
