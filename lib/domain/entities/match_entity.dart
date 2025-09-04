class MatchEntity {
  int? id;
  int? roundId;
  DateTime? matchDate;
  int? homeTeamId;
  int? awayTeamId;
  String? homeColor;
  String? awayColor;
  int? attendance;
  int? homePoints;
  int? awayPoints;
  int? homeFouls;
  int? awayFouls;

  MatchEntity({
    this.id,
    this.roundId,
    this.matchDate,
    this.homeTeamId,
    this.awayTeamId,
    this.homeColor,
    this.awayColor,
    this.attendance,
    this.homePoints,
    this.awayPoints,
    this.homeFouls,
    this.awayFouls,
  });
}
