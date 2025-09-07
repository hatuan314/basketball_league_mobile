import 'package:baseketball_league_mobile/common/enums.dart';
import 'package:baseketball_league_mobile/domain/entities/referee_phone_entity.dart';

class RefereePhoneModel {
  int? refereeId;
  String? phoneNumber;
  PhoneType? phoneType;

  RefereePhoneModel({this.refereeId, this.phoneNumber, this.phoneType});

  RefereePhoneModel.fromPostgres(List<dynamic> row) {
    refereeId = row[0] as int;
    phoneNumber = row[1] as String;
    phoneType = PhoneType.fromString(row[2] as String);
  }

  RefereePhoneModel.fromEntity(RefereePhoneEntity row) {
    refereeId = row.refereeId;
    phoneNumber = row.phoneNumber;
    phoneType = row.phoneType;
  }

  RefereePhoneEntity toEntity() {
    return RefereePhoneEntity(
      refereeId: refereeId,
      phoneNumber: phoneNumber,
      phoneType: phoneType,
    );
  }
}
