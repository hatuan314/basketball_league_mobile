part of 'home_cubit.dart';

enum HomeStatus { loading, loaded, error }

class HomeState {
  final HomeStatus status;
  final String? errorMessage;

  HomeState({required this.status, this.errorMessage});

  HomeState copyWith({HomeStatus? status, String? errorMessage}) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: this.errorMessage,
    );
  }
}
