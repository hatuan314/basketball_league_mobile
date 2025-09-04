import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_edit/bloc/team_edit_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_edit/team_edit_screen.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/bloc/team_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/team_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

RouteBase teamFeatureRoutes = GoRoute(
  path: RouterName.teamList,
  builder:
      (context, state) => BlocProvider(
        create: (context) => GetIt.instance<TeamListCubit>(),
        child: const TeamListScreen(),
      ),
  routes: [
    GoRoute(
      path: RouterName.teamEdit,
      builder: (context, state) {
        TeamEntity? team;
        if (state.extra != null) {
          team = state.extra as TeamEntity;
        }
        return BlocProvider(
          create: (context) => GetIt.instance<TeamEditCubit>(),
          child: TeamEditScreen(team: team),
        );
      },
    ),
  ],
);
