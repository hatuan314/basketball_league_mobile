import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(status: HomeStatus.loading));

  Future<void> initial() async {
    final isConnect = await _checkConnection();
    if (isConnect) {
      await _configDatabase();
      emit(state.copyWith(status: HomeStatus.loaded));
    } else {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: "Kết nối tới database thất bại",
        ),
      );
    }
  }

  Future<bool> _checkConnection() async {
    final isConnect = await sl<PostgresConnection>().connectDb();

    if (isConnect) {
      return true;
    }
    return false;
  }

  Future<void> _configDatabase() async {
    await sl<PostgresConnection>().configDatabase();
  }
}
