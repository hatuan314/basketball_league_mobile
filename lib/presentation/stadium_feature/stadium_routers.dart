import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_form/stadium_form_screen.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/stadium_list_screen.dart';
import 'package:go_router/go_router.dart';

final RouteBase stadiumRouter = GoRoute(
  path: RouterName.stadiumList,
  builder: (context, state) => const StadiumListScreen(),
  routes: [
    GoRoute(
      path: RouterName.stadiumEdit,
      builder: (context, state) {
        final data = state.extra as Map;
        final isEditing = data['isEditing'] as bool?;
        StadiumModel? stadium;
        if (data['stadium'] != null) {
          stadium = data['stadium'] as StadiumModel;
        }

        return StadiumFormScreen(
          stadium: stadium,
          isEditing: isEditing ?? false,
        );
      },
    ),
  ],
);
