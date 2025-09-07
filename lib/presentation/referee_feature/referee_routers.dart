import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/bloc/referee_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/referee_detail_screen.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_form/bloc/referee_form_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_form/referee_form_screen.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/bloc/referee_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/referee_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final RouteBase refereeFeatureRoutes = GoRoute(
  path: RouterName.refereeList,
  builder:
      (context, state) => BlocProvider(
        create: (context) => GetIt.instance<RefereeListCubit>(),
        child: const RefereeListScreen(),
      ),
  routes: [
    GoRoute(
      path: RouterName.refereeDetail,
      builder: (context, state) {
        final refereeId = state.extra as int;
        return BlocProvider(
          create: (context) => GetIt.instance<RefereeDetailCubit>(),
          child: RefereeDetailScreen(refereeId: refereeId),
        );
      },
    ),
    GoRoute(
      path: RouterName.refereeEdit,
      builder: (context, state) {
        final refereeId = state.extra as int;
        return BlocProvider(
          create: (context) => GetIt.instance<RefereeFormCubit>(),
          child: RefereeFormScreen(refereeId: refereeId),
        );
      },
    ),
    GoRoute(
      path: RouterName.refereeCreate,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => GetIt.instance<RefereeFormCubit>(),
          child: const RefereeFormScreen(),
        );
      },
    ),
  ],
);
