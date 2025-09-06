import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/bloc/round_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/round_list_screen.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_detail/season_detail_screen.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_edit/season_edit_screen.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/bloc/season_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/season_list_screen.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/team_standing_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

RouteBase seasonRouter = GoRoute(
  path: RouterName.seasonList,
  builder:
      (context, state) => BlocProvider(
        create: (context) => GetIt.instance<SeasonListCubit>(),
        child: const SeasonListScreen(),
      ),
  routes: [
    GoRoute(
      path: RouterName.seasonDetail,
      builder: (context, state) {
        final season = state.extra as SeasonEntity;
        return SeasonDetailScreen(season: season);
      },
      routes: [
        GoRoute(
          path: RouterName.teamStanding,
          builder: (context, state) {
            final season = state.extra as SeasonEntity;
            return BlocProvider(
              create: (context) => GetIt.instance<TeamStandingCubit>(),
              child: TeamStandingScreen(
                seasonId: season.id!,
                seasonName: season.name!,
              ),
            );
          },
        ),
        GoRoute(
          path: RouterName.roundList,
          builder: (context, state) {
            final seasonId = state.extra as int;
            return BlocProvider(
              create: (context) => GetIt.instance<RoundListCubit>(),
              child: RoundListScreen(seasonId: seasonId),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouterName.seasonEdit,
      builder: (context, state) {
        final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
        final SeasonEntity? season = params['season'] as SeasonEntity?;
        final bool isEditing = params['isEditing'] as bool;
        return SeasonEditScreen(season: season, isEditing: isEditing);
      },
    ),
  ],
);
