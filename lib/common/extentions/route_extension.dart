import 'package:baseketball_league_mobile/common/constants/router_name.dart';

extension RouteExtension on String {
  String toSeasonRoute() => '${RouterName.seasonList}/$this';

  String toSeasonDetailRoute() =>
      '${RouterName.seasonDetail.toSeasonRoute()}/$this';

  String toRoundRoute() =>
      '${RouterName.roundList.toSeasonDetailRoute()}/$this';

  String toRoundDetailRoute() =>
      '${RouterName.roundDetail.toRoundRoute()}/$this';

  String toTeamRoute() => '${RouterName.teamList}/$this';

  String toStadiumRoute() => '${RouterName.stadiumList}/$this';

  String toRefereeRoute() => '${RouterName.refereeList}/$this';

  String toPlayerRoute() => '${RouterName.playerList}/$this';
}
