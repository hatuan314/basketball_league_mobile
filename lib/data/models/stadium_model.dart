import 'package:baseketball_league_mobile/domain/entities/stadium_entity.dart';

class StadiumModel {
  int? id;
  String? name;
  String? address;
  int? capacity;
  double? ticketPrice;

  StadiumModel({
    this.id,
    this.name,
    this.address,
    this.capacity,
    this.ticketPrice,
  });

  factory StadiumModel.fromRow(dynamic row) {
    return StadiumModel(
      id: row[0] as int,
      name: row[1] as String,
      address: row[2] as String,
      capacity: row[3] as int,
      ticketPrice: double.parse(row[4] as String),
    );
  }

  StadiumEntity toEntity() {
    return StadiumEntity(
      id: id,
      name: name,
      address: address,
      capacity: capacity,
      ticketPrice: ticketPrice,
    );
  }
}
