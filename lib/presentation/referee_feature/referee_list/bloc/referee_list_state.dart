import 'package:baseketball_league_mobile/domain/entities/referee_entity.dart';
import 'package:equatable/equatable.dart';

/// Các trạng thái của màn hình danh sách trọng tài
enum RefereeListStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu
  loading,

  /// Tải dữ liệu thành công
  success,

  /// Tải dữ liệu thất bại
  failure,

  /// Đang tạo dữ liệu mock
  generating,

  /// Tạo dữ liệu mock thành công
  generateSuccess,

  /// Tạo dữ liệu mock thất bại
  generateFailure,
}

/// Lớp quản lý trạng thái của màn hình danh sách trọng tài
class RefereeListState extends Equatable {
  /// Trạng thái hiện tại của màn hình
  final RefereeListStatus status;

  /// Danh sách trọng tài
  final List<RefereeEntity> referees;

  /// Từ khóa tìm kiếm
  final String searchKeyword;

  /// Thông báo lỗi
  final String? errorMessage;

  /// Số lượng bản ghi đã tạo thành công
  final int? generatedCount;

  /// Constructor
  const RefereeListState({
    this.status = RefereeListStatus.initial,
    this.referees = const [],
    this.searchKeyword = '',
    this.errorMessage,
    this.generatedCount,
  });

  /// Tạo bản sao với các thuộc tính mới
  RefereeListState copyWith({
    RefereeListStatus? status,
    List<RefereeEntity>? referees,
    String? searchKeyword,
    String? errorMessage,
    int? generatedCount,
    bool clearError = false,
    bool clearGeneratedCount = false,
  }) {
    return RefereeListState(
      status: status ?? this.status,
      referees: referees ?? this.referees,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      generatedCount: clearGeneratedCount ? null : generatedCount ?? this.generatedCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        referees,
        searchKeyword,
        errorMessage,
        generatedCount,
      ];
}
