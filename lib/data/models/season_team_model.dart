import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';

class SeasonTeamModel {
  int? id;
  int? seasonId;
  int? teamId;
  int? homeId;

  SeasonTeamModel({this.id, this.seasonId, this.teamId, this.homeId});

  SeasonTeamEntity toEntity() {
    return SeasonTeamEntity(
      id: id,
      seasonId: seasonId,
      teamId: teamId,
      homeId: homeId,
    );
  }
}
