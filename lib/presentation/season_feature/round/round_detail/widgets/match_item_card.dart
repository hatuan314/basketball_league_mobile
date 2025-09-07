import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Widget hiển thị thông tin của một trận đấu
class MatchItemCard extends StatelessWidget {
  /// Thông tin trận đấu
  final MatchDetailEntity match;

  /// Constructor
  const MatchItemCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
      child: InkWell(
        onTap: () {
          // Điều hướng đến màn hình chi tiết trận đấu
          context.push(
            RouterName.matchDetail.toRoundDetailRoute(),
            extra: {'matchId': match.matchId, 'roundId': match.roundId},
          );
        },
        borderRadius: BorderRadius.circular(12.sp),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thời gian trận đấu
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16.sp,
                    color: theme.primaryColor,
                  ),
                  SizedBox(width: 8.sp),
                  Text(
                    match.matchDate != null
                        ? dateFormat.format(match.matchDate!)
                        : 'Chưa có lịch',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Thông tin đội bóng
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Đội nhà
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 36.sp,
                          height: 36.sp,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: AppImageWidget(
                            path: Icons.sports_basketball,
                            color: AppColors.orange,
                            width: 24.sp,
                            height: 24.sp,
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          'Đội ${match.homeTeamName}',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Tỷ số
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.sp,
                      vertical: 8.sp,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${match.homePoints ?? 0}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        Text('-', style: theme.textTheme.titleMedium),
                        SizedBox(width: 8.sp),
                        Text(
                          '${match.awayPoints ?? 0}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Đội khách
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 36.sp,
                          height: 36.sp,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: AppImageWidget(
                            path: Icons.sports_basketball,
                            color: AppColors.orange,
                            width: 24.sp,
                            height: 24.sp,
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          'Đội ${match.awayTeamName}',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.sp),

              // Thông tin bổ sung
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, size: 16.sp, color: theme.hintColor),
                      SizedBox(width: 4.sp),
                      Text(
                        'Khán giả: ${match.attendance ?? 0}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.warning, size: 16.sp, color: theme.hintColor),
                      SizedBox(width: 4.sp),
                      Text(
                        'Lỗi: ${match.homeFouls ?? 0} - ${match.awayFouls ?? 0}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
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
