import 'package:baseketball_league_mobile/domain/entities/top_scores_season_entity.dart';

class TopScoresSeasonModel {
  int? seasonId;
  String? seasonName;
  int? playerId;
  String? playerCode;
  String? playerName;
  int? teamId;
  String? teamName;
  int? totalPoint;

  TopScoresSeasonModel({
    this.seasonId,
    this.seasonName,
    this.playerId,
    this.playerCode,
    this.playerName,
    this.teamId,
    this.teamName,
    this.totalPoint,
  });

  TopScoresSeasonModel.fromPostgres(List<dynamic> row) {
    seasonId = row[0];
    seasonName = row[1];
    playerId = row[2];
    playerCode = row[3];
    playerName = row[4];
    teamId = row[5];
    teamName = row[6];
    totalPoint = row[7];
  }

  TopScoresSeasonEntity toEntity() {
    return TopScoresSeasonEntity(
      seasonId: seasonId,
      seasonName: seasonName,
      playerId: playerId,
      playerCode: playerCode,
      playerName: playerName,
      teamId: teamId,
      teamName: teamName,
      totalPoint: totalPoint,
    );
  }
}
