class PlayerEntity {
  int? id;
  String? playerCode;
  String? fullName;
  DateTime? dob;
  int? height;
  int? weight;

  PlayerEntity({
    this.id,
    this.playerCode,
    this.fullName,
    this.dob,
    this.height,
    this.weight,
  });
  
  PlayerEntity copyWith({
    int? id,
    String? playerCode,
    String? fullName,
    DateTime? dob,
    int? height,
    int? weight,
  }) {
    return PlayerEntity(
      id: id ?? this.id,
      playerCode: playerCode ?? this.playerCode,
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
