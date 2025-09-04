import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/player_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/season_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/team_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/datasources/season_api.dart';
import 'package:baseketball_league_mobile/data/datasources/team_api.dart';
import 'package:baseketball_league_mobile/data/repositories/player_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/season_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/team_repository_impl.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/player_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/season_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/team_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/team_usecase.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/bloc/season_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/bloc/team_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_edit/bloc/team_edit_cubit.dart';
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
  sl.registerFactory<HomeCubit>(() => HomeCubit());
  sl.registerFactory<SeasonListCubit>(
    () => SeasonListCubit(seasonUsecase: sl<SeasonUsecase>()),
  );
  sl.registerFactory<TeamListCubit>(
    () => TeamListCubit(teamUsecase: sl<TeamUsecase>()),
  );
  sl.registerFactory<TeamEditCubit>(
    () => TeamEditCubit(teamUsecase: sl<TeamUsecase>()),
  );
  sl.registerFactory<PlayerListCubit>(
    () => PlayerListCubit(playerUseCase: sl<PlayerUsecase>()),
  );
}

void usecaseDependencies() {
  sl.registerFactory<SeasonUsecase>(
    () => SeasonUsecaseImpl(seasonRepository: sl<SeasonRepository>()),
  );
  sl.registerFactory<TeamUsecase>(
    () => TeamUsecaseImpl(teamRepository: sl<TeamRepository>()),
  );
  sl.registerFactory<PlayerUsecase>(
    () => PlayerUsecaseImpl(playerRepository: sl<PlayerRepository>()),
  );
}

void repositoryDependencies() {
  sl.registerFactory<SeasonRepository>(
    () => SeasonRepositoryImpl(seasonApi: sl<SeasonApi>()),
  );
  sl.registerFactory<TeamRepository>(
    () => TeamRepositoryImpl(teamApi: sl<TeamApi>()),
  );
  sl.registerFactory<PlayerRepository>(
    () => PlayerRepositoryImpl(playerApi: sl<PlayerApi>()),
  );
}

void apiDependencies() {
  sl.registerLazySingleton<SeasonApi>(() => SeasonApiImpl());
  sl.registerLazySingleton<TeamApi>(() => TeamApiImpl());
  sl.registerLazySingleton<PlayerApi>(() => PlayerApiImpl());
}
