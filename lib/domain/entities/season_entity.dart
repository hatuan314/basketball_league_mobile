class SeasonEntity {
  int? id;
  String? code;
  String? name;
  DateTime? startDate;
  DateTime? endDate;

  SeasonEntity({this.id, this.code, this.name, this.startDate, this.endDate});
  
  /// Tạo bản sao của đối tượng với các giá trị mới
  SeasonEntity copyWith({
    int? id,
    String? code,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SeasonEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
