import 'package:equatable/equatable.dart';

/// Entity class đại diện cho thông tin chi tiết của cầu thủ từ view player_details
class PlayerDetailEntity extends Equatable {
  /// ID của cầu thủ
  final int playerId;

  /// Mã cầu thủ
  final String playerCode;

  /// Họ tên đầy đủ của cầu thủ
  final String fullName;

  /// Ngày sinh của cầu thủ
  final DateTime? dob;

  /// Chiều cao của cầu thủ (cm)
  final double? heightCm;

  /// Cân nặng của cầu thủ (kg)
  final double? weightKg;

  /// ID của đội bóng
  final int teamId;

  /// Tên đội bóng
  final String teamName;

  /// Mã đội bóng
  final String teamCode;

  /// Số áo của cầu thủ trong đội
  final int shirtNumber;

  /// ID của mùa giải
  final int seasonId;

  /// Tên mùa giải
  final String seasonName;

  /// Constructor
  const PlayerDetailEntity({
    required this.playerId,
    required this.playerCode,
    required this.fullName,
    this.dob,
    this.heightCm,
    this.weightKg,
    required this.teamId,
    required this.teamName,
    required this.teamCode,
    required this.shirtNumber,
    required this.seasonId,
    required this.seasonName,
  });

  @override
  List<Object?> get props => [
    playerId,
    playerCode,
    fullName,
    dob,
    heightCm,
    weightKg,
    teamId,
    teamName,
    teamCode,
    shirtNumber,
    seasonId,
    seasonName,
  ];

  /// Tạo bản sao của entity với các giá trị mới
  PlayerDetailEntity copyWith({
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
    return PlayerDetailEntity(
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
}
