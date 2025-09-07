import '../../domain/entities/player_detail_entity.dart';

/// Model class đại diện cho thông tin chi tiết của cầu thủ từ view player_details
class PlayerDetailModel extends PlayerDetailEntity {
  /// Constructor
  const PlayerDetailModel({
    required super.playerId,
    required super.playerCode,
    required super.fullName,
    super.dob,
    super.heightCm,
    super.weightKg,
    required super.teamId,
    required super.teamName,
    required super.teamCode,
    required super.shirtNumber,
    required super.seasonId,
    required super.seasonName,
  });

  /// Tạo bản sao của model với các giá trị mới
  PlayerDetailModel copyWith({
    int? playerId,
    String? playerCode,
    String? fullName,
    DateTime? dob,
    double? heightCm,
    double? weightKg,
    int? teamId,
    String? teamName,
    String? teamCode,
    int? shirtNumber,
    int? seasonId,
    String? seasonName,
  }) {
    return PlayerDetailModel(
      playerId: playerId ?? this.playerId,
      playerCode: playerCode ?? this.playerCode,
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamCode: teamCode ?? this.teamCode,
      shirtNumber: shirtNumber ?? this.shirtNumber,
      seasonId: seasonId ?? this.seasonId,
      seasonName: seasonName ?? this.seasonName,
    );
  }

  /// Chuyển đổi từ entity sang model
  factory PlayerDetailModel.fromEntity(PlayerDetailEntity entity) {
    return PlayerDetailModel(
      playerId: entity.playerId,
      playerCode: entity.playerCode,
      fullName: entity.fullName,
      dob: entity.dob,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      teamId: entity.teamId,
      teamName: entity.teamName,
      teamCode: entity.teamCode,
      shirtNumber: entity.shirtNumber,
      seasonId: entity.seasonId,
      seasonName: entity.seasonName,
    );
  }

  /// Tạo model từ kết quả truy vấn PostgreSQL
  factory PlayerDetailModel.fromPostgres(List<dynamic> row) {
    return PlayerDetailModel(
      playerId: row[0] as int,
      playerCode: row[1] as String,
      fullName: row[2] as String,
      dob: row[3] != null ? DateTime.parse(row[3].toString()) : null,
      heightCm: row[4] != null ? (row[4] as num).toDouble() : null,
      weightKg: row[5] != null ? (row[5] as num).toDouble() : null,
      teamId: row[6] as int,
      teamName: row[7] as String,
      teamCode: row[8] as String,
      shirtNumber: row[9] as int,
      seasonId: row[10] as int,
      seasonName: row[11] as String,
    );
  }
}
