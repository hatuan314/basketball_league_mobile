import 'package:baseketball_league_mobile/domain/entities/round/top_scores_by_round_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopScoreByRoundCard extends StatelessWidget {
  final TopScoresByRoundEntity? topScoresByRound;
  const TopScoreByRoundCard({super.key, required this.topScoresByRound});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child:
            topScoresByRound == null
                ? const EmptyWidget(message: 'Không có dữ liệu cầu thủ ghi bàn')
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    Text(
                      'Cầu thủ ghi nhiều điểm nhất',
                      style: AppStyle.headline5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.sp),

                    // Thông tin cầu thủ
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar cầu thủ
                        Container(
                          width: 60.sp,
                          height: 60.sp,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.sports_basketball,
                              size: 30.sp,
                              color: AppColors.orange,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.sp),

                        // Thông tin chi tiết
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tên cầu thủ
                              Text(
                                topScoresByRound?.playerName ?? 'Không có tên',
                                style: AppStyle.headline6.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.sp),

                              // Mã cầu thủ
                              Row(
                                children: [
                                  Icon(
                                    Icons.tag,
                                    size: 16.sp,
                                    color: AppColors.orange,
                                  ),
                                  SizedBox(width: 4.sp),
                                  Text(
                                    topScoresByRound?.playerCode ??
                                        'Không có mã',
                                    style: AppStyle.bodyMedium.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.sp),

                              // Đội bóng
                              Row(
                                children: [
                                  Icon(
                                    Icons.group,
                                    size: 16.sp,
                                    color: AppColors.orange,
                                  ),
                                  SizedBox(width: 4.sp),
                                  Text(
                                    topScoresByRound?.teamName ??
                                        'Không có đội',
                                    style: AppStyle.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Điểm số
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 8.sp,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${topScoresByRound?.totalPoints ?? 0}',
                                style: AppStyle.headline5.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'điểm',
                                style: AppStyle.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
