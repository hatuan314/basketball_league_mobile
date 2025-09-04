import 'package:baseketball_league_mobile/domain/entities/stadium_entity.dart';

class StadiumModel {
  int? id;
  String? name;
  String? address;
  int? capacity;
  int? ticketPrice;

  StadiumModel({
    this.id,
    this.name,
    this.address,
    this.capacity,
    this.ticketPrice,
  });

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
