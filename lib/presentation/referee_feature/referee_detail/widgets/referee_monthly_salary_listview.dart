import 'package:baseketball_league_mobile/domain/entities/referee/referee_monthly_salary_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RefereeMonthlySalaryListview extends StatelessWidget {
  final List<RefereeMonthlySalaryEntity> monthlySalaries;
  const RefereeMonthlySalaryListview({
    super.key,
    required this.monthlySalaries,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlySalaries.isEmpty) {
      return const EmptyWidget(message: 'Không có dữ liệu lương của trọng tài');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          child: Text(
            'Lương theo tháng',
            style: AppStyle.headline5.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: monthlySalaries.length,
          itemBuilder: (context, index) {
            return _buildSalaryCard(monthlySalaries[index]);
          },
        ),
      ],
    );
  }

  Widget _buildSalaryCard(RefereeMonthlySalaryEntity salary) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.sp),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with month/year
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sp,
                    vertical: 6.sp,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    salary.monthYear,
                    style: AppStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Tổng: ${currencyFormat.format(salary.totalSalary ?? 0)}',
                  style: AppStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.sp),
            // Salary details
            _buildSalaryDetailRow(
              title: 'Trọng tài chính:',
              value: currencyFormat.format(salary.mainRefereeSalary ?? 0),
              icon: Icons.sports_basketball,
              iconColor: Colors.orange,
            ),
            SizedBox(height: 8.sp),
            _buildSalaryDetailRow(
              title: 'Trọng tài bàn:',
              value: currencyFormat.format(salary.tableRefereeSalary ?? 0),
              icon: Icons.table_chart,
              iconColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryDetailRow({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20.sp),
        SizedBox(width: 8.sp),
        Text(title, style: AppStyle.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
