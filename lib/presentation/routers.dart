import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/home/home_screen.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_routers.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_routers.dart';
import 'package:baseketball_league_mobile/presentation/splash/splash_screen.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  observers: [NavigatorObserver()],
  initialLocation: RouterName.splash,
  routes: <RouteBase>[
    GoRoute(
      path: RouterName.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouterName.home,
      builder:
          (context, state) => BlocProvider(
            create: (context) => GetIt.instance<HomeCubit>(),
            child: const MyHomePage(),
          ),
    ),
    seasonRouter,
    teamFeatureRoutes,
    playerFeatureRoutes,
  ],
);
