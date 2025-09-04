import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';

class TeamModel {
  int? id;
  String? name;
  String? code;

  TeamModel({this.id, this.name, this.code});

  TeamEntity toEntity() {
    return TeamEntity(id: id, name: name, code: code);
  }
}
