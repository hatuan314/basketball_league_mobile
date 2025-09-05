import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:equatable/equatable.dart';

/// Trạng thái của màn hình danh sách sân vận động
abstract class StadiumListState extends Equatable {
  const StadiumListState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class StadiumListInitial extends StadiumListState {
  const StadiumListInitial();
}

/// Trạng thái đang tải dữ liệu
class StadiumListLoading extends StadiumListState {
  const StadiumListLoading();
}

/// Trạng thái tải dữ liệu thành công
class StadiumListLoaded extends StadiumListState {
  final List<StadiumModel> stadiums;

  const StadiumListLoaded(this.stadiums);

  @override
  List<Object?> get props => [stadiums];
}

/// Trạng thái tải dữ liệu thất bại
class StadiumListError extends StadiumListState {
  final String message;

  const StadiumListError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái tạo bảng thành công
class StadiumTableCreated extends StadiumListState {
  const StadiumTableCreated();
}

/// Trạng thái tạo bảng thất bại
class StadiumTableError extends StadiumListState {
  final String message;

  const StadiumTableError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái xóa sân vận động thành công
class StadiumDeleted extends StadiumListState {
  const StadiumDeleted();
}

/// Trạng thái xóa sân vận động thất bại
class StadiumDeleteError extends StadiumListState {
  final String message;

  const StadiumDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái tạo danh sách sân vận động ngẫu nhiên thành công
class StadiumRandomCreated extends StadiumListState {
  final List<StadiumModel> stadiums;

  const StadiumRandomCreated(this.stadiums);

  @override
  List<Object?> get props => [stadiums];
}

/// Trạng thái tạo danh sách sân vận động ngẫu nhiên thất bại
class StadiumRandomError extends StadiumListState {
  final String message;

  const StadiumRandomError(this.message);

  @override
  List<Object?> get props => [message];
}
