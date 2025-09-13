class RefereeMonthlySalaryEntity {
  int? refereeId;
  String? name;
  int? mainRefereeSalary;
  int? tableRefereeSalary;
  int? totalSalary;
  String? year;
  String? month;

  RefereeMonthlySalaryEntity({
    this.refereeId,
    this.name,
    this.mainRefereeSalary,
    this.tableRefereeSalary,
    this.totalSalary,
    this.year,
    this.month,
  });

  String get monthYear => '$month/$year';
}
