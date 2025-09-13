class MatchPlayerDetailEntity {
  int? matchPlayerId;
  int? matchId;
  DateTime? matchDatetime;
  int? roundId;
  int? roundNo;
  int? seasonId;
  String? seasonName;
  int? playerId;
  String? playerCode;
  String? playerName;
  int? teamId;
  String? teamName;
  int? shirtNumber;
  int? points;
  int? fouls;

  MatchPlayerDetailEntity({
    this.matchPlayerId,
    this.matchId,
    this.matchDatetime,
    this.roundId,
    this.roundNo,
    this.seasonId,
    this.seasonName,
    this.playerId,
    this.playerCode,
    this.playerName,
    this.teamId,
    this.teamName,
    this.shirtNumber,
    this.points,
    this.fouls,
  });
}
