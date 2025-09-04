import 'package:baseketball_league_mobile/domain/entities/match_player_entity.dart';

class MatchPlayerModel {
  int? id;
  int? matchId;
  int? playerId;

  MatchPlayerModel({this.id, this.matchId, this.playerId});

  MatchPlayerEntity toEntity() {
    return MatchPlayerEntity(id: id, matchId: matchId, playerId: playerId);
  }
}
