import 'package:baseketball_league_mobile/domain/entities/referee_phone_entity.dart';

class RefereePhoneModel {
  int? refereeId;
  String? phoneNumber;

  RefereePhoneModel({this.refereeId, this.phoneNumber});

  RefereePhoneEntity toEntity() {
    return RefereePhoneEntity(refereeId: refereeId, phoneNumber: phoneNumber);
  }
}
