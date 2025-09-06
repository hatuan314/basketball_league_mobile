import 'package:baseketball_league_mobile/domain/entities/team_color_entity.dart';

class TeamColorModel {
  int? teamId;
  int? seasonId;
  String? colorName;

  TeamColorModel({this.teamId, this.seasonId, this.colorName});

  TeamColorModel.fromPostgres(List<dynamic> row) {
    teamId = row[0] as int;
    seasonId = row[1] as int;
    colorName = row[2] as String;
  }

  TeamColorModel.fromEntity(TeamColorEntity entity) {
    teamId = entity.teamId;
    seasonId = entity.seasonId;
    colorName = entity.colorName;
  }

  TeamColorEntity toEntity() {
    return TeamColorEntity(
      teamId: teamId,
      seasonId: seasonId,
      colorName: colorName,
    );
  }
}
