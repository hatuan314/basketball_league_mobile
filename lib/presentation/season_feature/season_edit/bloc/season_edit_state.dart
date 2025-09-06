import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:equatable/equatable.dart';

/// Trạng thái của màn hình chỉnh sửa giải đấu
enum SeasonEditStatus { initial, loading, success, error }

class SeasonEditState extends Equatable {
  final SeasonEntity? season;
  final SeasonEditStatus status;
  final String? errorMessage;
  final bool isEditing;

  const SeasonEditState({
    this.season,
    this.status = SeasonEditStatus.initial,
    this.errorMessage,
    this.isEditing = false,
  });

  /// Tạo bản sao của state với các giá trị mới
  SeasonEditState copyWith({
    SeasonEntity? season,
    SeasonEditStatus? status,
    String? errorMessage,
    bool? isEditing,
  }) {
    return SeasonEditState(
      season: season ?? this.season,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [season, status, errorMessage, isEditing];
}
