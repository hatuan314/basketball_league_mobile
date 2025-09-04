import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';

class SeasonModel {
  int? id;
  String? code;
  String? name;
  DateTime? startDate;
  DateTime? endDate;

  SeasonModel({this.id, this.code, this.name, this.startDate, this.endDate});

  SeasonModel.fromEntity(SeasonEntity entity)
    : id = entity.id,
      code = entity.code,
      name = entity.name,
      startDate = entity.startDate,
      endDate = entity.endDate;

  SeasonEntity toEntity() {
    return SeasonEntity(
      id: id,
      code: code,
      name: name,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
