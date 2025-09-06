import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';

class PlayerSeasonModel {
  String? id;
  int? seasonTeamId;
  int? playerId;
  int? shirtNumber;

  PlayerSeasonModel({
    this.id,
    this.seasonTeamId,
    this.playerId,
    this.shirtNumber,
  });

  PlayerSeasonEntity toEntity() {
    return PlayerSeasonEntity(
      id: id,
      seasonTeamId: seasonTeamId,
      playerId: playerId,
      shirtNumber: shirtNumber,
    );
  }
}
