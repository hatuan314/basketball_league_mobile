import 'package:baseketball_league_mobile/domain/entities/team_color_entity.dart';

class TeamColorModel {
  int? seasonTeamId;
  int? seasonId;
  String? colorName;

  TeamColorModel({this.seasonTeamId, this.seasonId, this.colorName});

  TeamColorEntity toEntity() {
    return TeamColorEntity(
      seasonTeamId: seasonTeamId,
      seasonId: seasonId,
      colorName: colorName,
    );
  }
}
