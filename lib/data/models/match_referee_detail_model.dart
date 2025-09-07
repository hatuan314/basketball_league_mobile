import 'dart:convert';

import 'package:baseketball_league_mobile/common/enums.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:postgres/postgres.dart';

class MatchRefereeDetailModel {
  int? matchRefereeId;
  int? matchId;
  DateTime? matchDate;
  int? roundId;
  int? roundNo;
  int? seasonId;
  String? seasonName;
  int? refereeId;
  String? refereeName;
  String? role;
  int? feePerMatch;

  MatchRefereeDetailModel({
    this.matchRefereeId,
    this.matchId,
    this.matchDate,
    this.roundId,
    this.roundNo,
    this.seasonId,
    this.seasonName,
    this.refereeId,
    this.refereeName,
    this.role,
    this.feePerMatch,
  });

  factory MatchRefereeDetailModel.fromPostgres(List<dynamic> row) {
    String role;
    if (row[9] is UndecodedBytes) {
      role = utf8.decode(row[9].bytes);
    } else {
      role = row[9] as String;
    }
    return MatchRefereeDetailModel(
      matchRefereeId: row[0],
      matchId: row[1],
      matchDate: row[2],
      roundId: row[3],
      roundNo: row[4],
      seasonId: row[5],
      seasonName: row[6],
      refereeId: row[7],
      refereeName: row[8],
      role: role,
      feePerMatch: row[10],
    );
  }

  MatchRefereeDetailEntity toEntity() {
    return MatchRefereeDetailEntity(
      matchRefereeId: matchRefereeId,
      matchId: matchId,
      matchDate: matchDate,
      roundId: roundId,
      roundNo: roundNo,
      seasonId: seasonId,
      seasonName: seasonName,
      refereeId: refereeId,
      refereeName: refereeName,
      role: RefereeType.fromString(role ?? ''),
      feePerMatch: feePerMatch,
    );
  }
}
