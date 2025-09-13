import 'package:baseketball_league_mobile/domain/entities/round/round_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Widget hiển thị thông tin của một vòng đấu
class RoundItemCard extends StatelessWidget {
  /// Thông tin vòng đấu
  final RoundEntity round;

  /// Callback khi nhấn vào card
  final VoidCallback? onTap;

  /// Constructor
  const RoundItemCard({Key? key, required this.round, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format ngày tháng
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDateStr = dateFormat.format(round.startDate ?? DateTime.now());
    final endDateStr = dateFormat.format(round.endDate ?? DateTime.now());

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề vòng đấu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vòng ${round.roundNo ?? '?'}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'ID: ${round.id ?? '?'}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Thời gian diễn ra
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16.r, color: AppColors.grey),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Thời gian: $startDateStr - $endDateStr',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // ID mùa giải
              Row(
                children: [
                  Icon(
                    Icons.sports_basketball,
                    size: 16.r,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Mùa giải ID: ${round.seasonId ?? '?'}',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
