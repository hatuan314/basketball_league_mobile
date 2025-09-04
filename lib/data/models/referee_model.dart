import 'package:baseketball_league_mobile/domain/entities/referee_entity.dart';

class RefereeModel {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;

  RefereeModel({this.id, this.fullName, this.email, this.phoneNumber});

  RefereeEntity toEntity() {
    return RefereeEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
