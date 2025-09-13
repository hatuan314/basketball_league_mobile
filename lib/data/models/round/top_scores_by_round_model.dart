import 'package:baseketball_league_mobile/domain/entities/round/top_scores_by_round_entity.dart';

class TopScoresByRoundModel {
  int? seasonId;
  String? seasonName;
  int? roundId;
  int? roundNo;
  int? playerId;
  String? playerCode;
  String? playerName;
  int? teamId;
  String? teamName;
  int? totalPoints;

  TopScoresByRoundModel({
    this.seasonId,
    this.seasonName,
    this.roundId,
    this.roundNo,
    this.playerId,
    this.playerCode,
    this.playerName,
    this.teamId,
    this.teamName,
    this.totalPoints,
  });

  factory TopScoresByRoundModel.fromPostgres(List<dynamic> row) {
    return TopScoresByRoundModel(
      seasonId: row[0],
      seasonName: row[1],
      roundId: row[2],
      roundNo: row[3],
      playerId: row[4],
      playerCode: row[5],
      playerName: row[6],
      teamId: row[7],
      teamName: row[8],
      totalPoints: row[9],
    );
  }

  TopScoresByRoundEntity toEntity() {
    return TopScoresByRoundEntity(
      seasonId: seasonId,
      seasonName: seasonName,
      roundId: roundId,
      roundNo: roundNo,
      playerId: playerId,
      playerCode: playerCode,
      playerName: playerName,
      teamId: teamId,
      teamName: teamName,
      totalPoints: totalPoints,
    );
  }
}
