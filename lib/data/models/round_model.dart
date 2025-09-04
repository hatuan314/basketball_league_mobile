import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';

class RoundModel {
  int? id;
  int? seasonId;
  int? roundNo;
  DateTime? startDate;
  DateTime? endDate;

  RoundModel({
    this.id,
    this.seasonId,
    this.roundNo,
    this.startDate,
    this.endDate,
  });

  RoundEntity toEntity() {
    return RoundEntity(
      id: id,
      seasonId: seasonId,
      roundNo: roundNo,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
