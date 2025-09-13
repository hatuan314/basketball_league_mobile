class MatchEntity {
  int? id;
  int? roundId;
  DateTime? matchDate;
  int? homeSeasonTeamId;
  int? awaySeasonTeamId;
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
    this.homeSeasonTeamId,
    this.awaySeasonTeamId,
    this.homeColor,
    this.awayColor,
    this.attendance,
    this.homePoints,
    this.awayPoints,
    this.homeFouls,
    this.awayFouls,
  });
}
