import 'package:baseketball_league_mobile/common/constants/router_name.dart';

extension RouteExtension on String {
  String toSeasonRoute() => '${RouterName.seasonList}/$this';

  String toTeamRoute() => '${RouterName.teamList}/$this';

  String toStadiumRoute() => '${RouterName.stadiumList}/$this';
}
