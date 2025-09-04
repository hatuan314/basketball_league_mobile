import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';

class PlayerModel {
  int? id;
  String? playerCode;
  String? fullName;
  DateTime? dob;
  int? height;
  int? weight;

  PlayerModel({
    this.id,
    this.playerCode,
    this.fullName,
    this.dob,
    this.height,
    this.weight,
  });

  factory PlayerModel.fromRow(List<dynamic> row) {
    final dobRow = row[3];
    print("Dob dataType: ${dobRow.runtimeType}");
    return PlayerModel(
      id: row[0],
      playerCode: row[1],
      fullName: row[2],
      dob: row[3],
      height: row[4],
      weight: row[5],
    );
  }

  factory PlayerModel.fromEntity(PlayerEntity entity) {
    return PlayerModel(
      id: entity.id,
      playerCode: entity.playerCode,
      fullName: entity.fullName,
      dob: entity.dob,
      height: entity.height,
      weight: entity.weight,
    );
  }

  PlayerEntity toEntity() {
    return PlayerEntity(
      id: id,
      playerCode: playerCode,
      fullName: fullName,
      dob: dob,
      height: height,
      weight: weight,
    );
  }
}
