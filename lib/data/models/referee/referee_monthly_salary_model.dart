import 'package:baseketball_league_mobile/domain/entities/referee/referee_monthly_salary_entity.dart';

class RefereeMonthlySalaryModel {
  int? refereeId;
  String? name;
  int? mainRefereeSalary;
  int? tableRefereeSalary;
  int? totalSalary;
  String? year;
  String? month;

  RefereeMonthlySalaryModel({
    this.refereeId,
    this.name,
    this.mainRefereeSalary,
    this.tableRefereeSalary,
    this.totalSalary,
    this.year,
    this.month,
  });

  factory RefereeMonthlySalaryModel.fromPostgres(List<dynamic> row) {
    return RefereeMonthlySalaryModel(
      refereeId: row[0] as int?,
      name: row[1] as String?,
      mainRefereeSalary: row[2] as int?,
      tableRefereeSalary: row[3] as int?,
      totalSalary: row[4] as int?,
      year: row[5] as String?,
      month: row[6] as String?,
    );
  }

  RefereeMonthlySalaryEntity toEntity() {
    return RefereeMonthlySalaryEntity(
      refereeId: refereeId,
      name: name,
      mainRefereeSalary: mainRefereeSalary,
      tableRefereeSalary: tableRefereeSalary,
      totalSalary: totalSalary,
      year: year,
      month: month,
    );
  }
}
