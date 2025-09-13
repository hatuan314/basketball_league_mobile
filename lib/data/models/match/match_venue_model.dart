import 'package:baseketball_league_mobile/domain/match/match_venue_entity.dart';

class MatchVenueModel {
  int? matchId;
  int? stadiumId;
  bool? isHomeStadium;

  MatchVenueModel({this.matchId, this.stadiumId, this.isHomeStadium});

  MatchVenueEntity toEntity() {
    return MatchVenueEntity(
      matchId: matchId,
      stadiumId: stadiumId,
      isHomeStadium: isHomeStadium,
    );
  }
}
