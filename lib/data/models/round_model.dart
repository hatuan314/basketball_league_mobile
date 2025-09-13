import 'package:baseketball_league_mobile/domain/entities/round/round_entity.dart';

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

  factory RoundModel.fromPostgres(dynamic row) {
    return RoundModel(
      id: row[0],
      seasonId: row[1],
      roundNo: row[2],
      startDate: row[3],
      endDate: row[4],
    );
  }

  factory RoundModel.fromEntity(RoundEntity entity) {
    return RoundModel(
      id: entity.id,
      seasonId: entity.seasonId,
      roundNo: entity.roundNo,
      startDate: entity.startDate,
      endDate: entity.endDate,
    );
  }

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
