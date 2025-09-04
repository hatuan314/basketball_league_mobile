import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/player_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

RouteBase playerFeatureRoutes = GoRoute(
  path: RouterName.playerList,
  builder:
      (context, state) => BlocProvider(
        create: (context) => GetIt.instance<PlayerListCubit>(),
        child: PlayerListScreen(),
      ),
);
