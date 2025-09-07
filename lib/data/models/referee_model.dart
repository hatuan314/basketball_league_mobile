import 'package:baseketball_league_mobile/domain/entities/referee_entity.dart';

class RefereeModel {
  int? id;
  String? fullName;
  String? email;

  RefereeModel({this.id, this.fullName, this.email});

  RefereeModel.fromPostgres(List<dynamic> row) {
    id = row[0] as int;
    fullName = row[1] as String;
    email = row[2] as String;
  }

  RefereeModel.fromEntity(RefereeEntity entity) {
    id = entity.id;
    fullName = entity.fullName;
    email = entity.email;
  }

  RefereeEntity toEntity() {
    return RefereeEntity(id: id, fullName: fullName, email: email);
  }
}
