class MatchDetailEntity {
  int? matchId;
  DateTime? matchDate;
  int? roundId;
  int? roundNo;
  int? seasonId;
  String? seasonName;
  int? homeTeamId;
  int? awayTeamId;
  String? homeTeamName;
  String? awayTeamName;
  String? homeColor;
  String? awayColor;
  int? homePoints;
  int? awayPoints;
  int? homeFouls;
  int? awayFouls;
  int? attendance;
  int? stadiumId;
  String? stadiumName;
  double? ticketPrice;
  int? winnerTeamId;
  String? winnerTeamName;

  MatchDetailEntity({
    this.matchId,
    this.matchDate,
    this.roundId,
    this.roundNo,
    this.seasonId,
    this.seasonName,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeColor,
    this.awayColor,
    this.homePoints,
    this.awayPoints,
    this.homeFouls,
    this.awayFouls,
    this.attendance,
    this.stadiumId,
    this.stadiumName,
    this.ticketPrice,
    this.winnerTeamId,
    this.winnerTeamName,
  });
}
