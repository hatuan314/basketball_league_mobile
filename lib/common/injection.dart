import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/match_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/player_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/player_season_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/referee_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/round_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/season_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/season_team_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/stadium_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/team_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/impl/team_color_api_impl.dart';
import 'package:baseketball_league_mobile/data/datasources/match_api.dart';
import 'package:baseketball_league_mobile/data/datasources/player_api.dart';
import 'package:baseketball_league_mobile/data/datasources/player_season_api.dart';
import 'package:baseketball_league_mobile/data/datasources/referee_api.dart';
import 'package:baseketball_league_mobile/data/datasources/round_api.dart';
import 'package:baseketball_league_mobile/data/datasources/season_api.dart';
import 'package:baseketball_league_mobile/data/datasources/season_team_api.dart';
import 'package:baseketball_league_mobile/data/datasources/stadium_api.dart';
import 'package:baseketball_league_mobile/data/datasources/team_api.dart';
import 'package:baseketball_league_mobile/data/datasources/team_color_api.dart';
import 'package:baseketball_league_mobile/data/repositories/match_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/player_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/player_season_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/referee_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/round_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/season_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/season_team_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/stadium_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/team_color_repository_impl.dart';
import 'package:baseketball_league_mobile/data/repositories/team_repository_impl.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/player_season_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/referee_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/round_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/season_team_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/stadium_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_color_repository.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/match_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/player_season_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/player_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/referee_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/round_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/season_team_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/season_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/stadium_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/impl/team_usecase_impl.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_season_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/referee_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/round_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/stadium_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/team_usecase.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/bloc/referee_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_form/bloc/referee_form_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/bloc/referee_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/bloc/round_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/bloc/round_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/bloc/season_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_cubit.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_edit/bloc/team_edit_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/bloc/team_list_cubit.dart';
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
  sl.registerFactory<PlayerListCubit>(
    () => PlayerListCubit(playerUseCase: sl<PlayerUsecase>()),
  );
  sl.registerFactory<RoundListCubit>(
    () => RoundListCubit(roundUseCase: sl<RoundUseCase>()),
  );
  sl.registerFactory<RoundDetailCubit>(
    () => RoundDetailCubit(
      roundUseCase: sl<RoundUseCase>(),
      matchUseCase: sl<MatchUseCase>(),
    ),
  );
  sl.registerFactory<SeasonListCubit>(
    () => SeasonListCubit(seasonUsecase: sl<SeasonUsecase>()),
  );
  sl.registerFactory<StadiumListCubit>(
    () => StadiumListCubit(stadiumUseCase: sl<StadiumUseCase>()),
  );
  sl.registerFactory<TeamListCubit>(
    () => TeamListCubit(teamUsecase: sl<TeamUsecase>()),
  );
  sl.registerFactory<TeamEditCubit>(
    () => TeamEditCubit(teamUsecase: sl<TeamUsecase>()),
  );

  sl.registerFactory<TeamStandingCubit>(
    () => TeamStandingCubit(sl<SeasonTeamUseCase>()),
  );
  sl.registerFactory<SeasonTeamDetailCubit>(
    () => SeasonTeamDetailCubit(
      seasonTeamUseCase: sl<SeasonTeamUseCase>(),
      playerSeasonUsecase: sl<PlayerSeasonUsecase>(),
    ),
  );

  // Đăng ký các cubit cho màn hình quản lý vòng đấu và trận đấu
  sl.registerFactory<MatchDetailCubit>(
    () => MatchDetailCubit(matchUseCase: sl<MatchUseCase>()),
  );

  // Đăng ký các cubit cho màn hình quản lý trọng tài
  sl.registerFactory<RefereeListCubit>(
    () => RefereeListCubit(refereeUsecase: sl<RefereeUsecase>()),
  );
  sl.registerFactory<RefereeDetailCubit>(
    () => RefereeDetailCubit(refereeUsecase: sl<RefereeUsecase>()),
  );
  sl.registerFactory<RefereeFormCubit>(
    () => RefereeFormCubit(refereeUsecase: sl<RefereeUsecase>()),
  );
}

void usecaseDependencies() {
  sl.registerFactory<PlayerUsecase>(
    () => PlayerUsecaseImpl(playerRepository: sl<PlayerRepository>()),
  );
  sl.registerFactory<PlayerSeasonUsecase>(
    () => PlayerSeasonUsecaseImpl(
      playerSeasonRepository: sl<PlayerSeasonRepository>(),
    ),
  );
  sl.registerFactory<RefereeUsecase>(
    () => RefereeUsecaseImpl(refereeRepository: sl<RefereeRepository>()),
  );
  sl.registerFactory<RoundUseCase>(
    () => RoundUseCaseImpl(sl<RoundRepository>()),
  );
  sl.registerFactory<SeasonUsecase>(
    () => SeasonUsecaseImpl(seasonRepository: sl<SeasonRepository>()),
  );
  sl.registerFactory<SeasonTeamUseCase>(
    () => SeasonTeamUseCaseImpl(
      sl<SeasonTeamRepository>(),
      sl<TeamColorRepository>(),
      sl<PlayerSeasonRepository>(),
    ),
  );
  sl.registerFactory<StadiumUseCase>(
    () => StadiumUseCaseImpl(sl<StadiumRepository>()),
  );
  sl.registerFactory<TeamUsecase>(
    () => TeamUsecaseImpl(teamRepository: sl<TeamRepository>()),
  );
  sl.registerFactory<MatchUseCase>(
    () => MatchUseCaseImpl(sl<MatchRepository>()),
  );
}

void repositoryDependencies() {
  sl.registerFactory<PlayerRepository>(
    () => PlayerRepositoryImpl(playerApi: sl<PlayerApi>()),
  );
  sl.registerFactory<RefereeRepository>(
    () => RefereeRepositoryImpl(refereeApi: sl<RefereeApi>()),
  );
  sl.registerFactory<RoundRepository>(
    () => RoundRepositoryImpl(
      roundApi: sl<RoundApi>(),
      seasonRepository: sl<SeasonRepository>(),
      seasonTeamRepository: sl<SeasonTeamRepository>(),
    ),
  );
  sl.registerFactory<SeasonRepository>(
    () => SeasonRepositoryImpl(seasonApi: sl<SeasonApi>()),
  );
  sl.registerFactory<SeasonTeamRepository>(
    () => SeasonTeamRepositoryImpl(
      seasonTeamApi: sl<SeasonTeamApi>(),
      teamRepository: sl<TeamRepository>(),
      stadiumRepository: sl<StadiumRepository>(),
    ),
  );
  sl.registerFactory<StadiumRepository>(
    () => StadiumRepositoryImpl(sl<StadiumApi>()),
  );
  sl.registerFactory<TeamRepository>(
    () => TeamRepositoryImpl(teamApi: sl<TeamApi>()),
  );
  sl.registerFactory<TeamColorRepository>(
    () => TeamColorRepositoryImpl(teamColorApi: sl<TeamColorApi>()),
  );
  sl.registerFactory<PlayerSeasonRepository>(
    () => PlayerSeasonRepositoryImpl(
      playerSeasonApi: sl<PlayerSeasonApi>(),
      teamApi: sl<TeamApi>(),
      playerApi: sl<PlayerApi>(),
    ),
  );
  sl.registerFactory<MatchRepository>(
    () => MatchRepositoryImpl(sl<MatchApi>()),
  );
}

void apiDependencies() {
  sl.registerLazySingleton<PlayerApi>(() => PlayerApiImpl());
  sl.registerLazySingleton<PlayerSeasonApi>(() => PlayerSeasonApiImpl());
  sl.registerLazySingleton<RefereeApi>(() => RefereeApiImpl());
  sl.registerLazySingleton<RoundApi>(() => RoundApiImpl());
  sl.registerLazySingleton<SeasonApi>(() => SeasonApiImpl());
  sl.registerLazySingleton<SeasonTeamApi>(() => SeasonTeamApiImpl());
  sl.registerLazySingleton<StadiumApi>(() => StadiumApiImpl());
  sl.registerLazySingleton<TeamApi>(() => TeamApiImpl());
  sl.registerLazySingleton<TeamColorApi>(() => TeamColorApiImpl());
  sl.registerLazySingleton<MatchApi>(() => MatchApiImpl());
}
