import 'package:baseketball_league_mobile/domain/entities/match_player_stats_entity.dart';

class MatchPlayerStatsModel {
  int? id;
  int? matchPlayerId;
  int? points;
  int? fouls;

  MatchPlayerStatsModel({this.id, this.matchPlayerId, this.points, this.fouls});

  MatchPlayerStatsEntity toEntity() {
    return MatchPlayerStatsEntity(
      id: id,
      matchPlayerId: matchPlayerId,
      points: points,
      fouls: fouls,
    );
  }
}
