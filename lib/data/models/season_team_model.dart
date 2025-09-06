import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';

class SeasonTeamModel {
  int? id;
  int? seasonId;
  int? teamId;
  int? homeId;

  SeasonTeamModel({this.id, this.seasonId, this.teamId, this.homeId});

  factory SeasonTeamModel.fromRow(List<dynamic> row) {
    return SeasonTeamModel(
      id: row[0],
      seasonId: row[1],
      teamId: row[2],
      homeId: row[3],
    );
  }

  factory SeasonTeamModel.fromEntity(SeasonTeamEntity entity) {
    return SeasonTeamModel(
      id: entity.id,
      seasonId: entity.seasonId,
      teamId: entity.teamId,
      homeId: entity.homeId,
    );
  }

  SeasonTeamEntity toEntity() {
    return SeasonTeamEntity(
      id: id,
      seasonId: seasonId,
      teamId: teamId,
      homeId: homeId,
    );
  }
}
