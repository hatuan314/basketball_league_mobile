import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_detail/season_detail_screen.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/bloc/season_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/season_list_screen.dart';
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
    ),
  ],
);
