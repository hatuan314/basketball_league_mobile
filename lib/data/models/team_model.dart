import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';

class TeamModel {
  int? id;
  String? name;
  String? code;

  TeamModel({this.id, this.name, this.code});

  factory TeamModel.fromRow(List<dynamic> row) {
    return TeamModel(
      id: row[0] as int,
      code: row[1] as String?,
      name: row[2] as String?,
    );
  }

  factory TeamModel.fromEntity(TeamEntity entity) {
    return TeamModel(id: entity.id, name: entity.name, code: entity.code);
  }

  TeamEntity toEntity() {
    return TeamEntity(id: id, name: name, code: code);
  }
}
