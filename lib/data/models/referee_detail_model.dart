import 'package:baseketball_league_mobile/domain/entities/referee_detail_entity.dart';

class RefereeDetailModel {
  int? refereeId;
  String? fullName;
  String? email;
  String? phone;

  RefereeDetailModel({this.refereeId, this.fullName, this.email, this.phone});

  RefereeDetailModel.fromPostgres(List<dynamic> row) {
    refereeId = row[0] as int;
    fullName = row[1] as String;
    email = row[2] as String;
    phone = row[3] as String;
  }

  RefereeDetailModel.fromEntity(RefereeDetailEntity row) {
    refereeId = row.refereeId;
    fullName = row.fullName;
    email = row.email;
    phone = row.phones?.first;
  }
}
