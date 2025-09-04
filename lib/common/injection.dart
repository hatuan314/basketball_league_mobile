import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/player_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/season_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/datasources/season_api.dart';
import 'package:baseketball_league_mobile/data/repositories/player_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/season_repository_impl.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/player_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/season_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void configureDependencies() {
  sl.registerLazySingleton<PostgresConnection>(() => PostgresConnection());
  blocDependencies();
  usecaseDependencies();
  repositoryDependencies();
  apiDependencies();
}

void blocDependencies() {
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(seasonUsecase: sl<SeasonUsecase>()),
  );
  sl.registerFactory<PlayerListCubit>(
    () => PlayerListCubit(playerUseCase: sl<PlayerUsecase>()),
  );
}

void usecaseDependencies() {
  sl.registerFactory<SeasonUsecase>(
    () => SeasonUsecaseImpl(seasonRepository: sl<SeasonRepository>()),
  );
  sl.registerFactory<PlayerUsecase>(
    () => PlayerUsecaseImpl(playerRepository: sl<PlayerRepository>()),
  );
}

void repositoryDependencies() {
  sl.registerFactory<SeasonRepository>(
    () => SeasonRepositoryImpl(seasonApi: sl<SeasonApi>()),
  );
  sl.registerFactory<PlayerRepository>(
    () => PlayerRepositoryImpl(playerApi: sl<PlayerApi>()),
  );
}

void apiDependencies() {
  sl.registerLazySingleton<SeasonApi>(() => SeasonApiImpl());
  sl.registerLazySingleton<PlayerApi>(() => PlayerApiImpl());
}
