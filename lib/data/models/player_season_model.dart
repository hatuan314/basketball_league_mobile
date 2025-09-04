import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';

class PlayerSeasonModel {
  int? id;
  int? seasonId;
  int? playerId;
  int? shirtNumber;

  PlayerSeasonModel({this.id, this.seasonId, this.playerId, this.shirtNumber});

  PlayerSeasonEntity toEntity() {
    return PlayerSeasonEntity(
      id: id,
      seasonId: seasonId,
      playerId: playerId,
      shirtNumber: shirtNumber,
    );
  }
}
