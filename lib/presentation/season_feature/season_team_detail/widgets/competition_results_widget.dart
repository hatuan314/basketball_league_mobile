import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart'
    show AppStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompetitionResultsWidget extends StatelessWidget {
  final TeamStandingEntity teamStanding;
  const CompetitionResultsWidget({super.key, required this.teamStanding});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thành tích thi đấu', style: AppStyle.headline6),
            SizedBox(height: 16.sp),
            // _buildStandingInfoRow('Xếp hạng', '${teamStanding.rank ?? "N/A"}'),
            _buildStandingInfoRow(
              'Số trận thắng',
              '${teamStanding.totalWins ?? 0}',
            ),
            _buildStandingInfoRow(
              'Số trận thua',
              '${teamStanding.totalLosses ?? 0}',
            ),
            _buildStandingInfoRow(
              'Điểm ghi được',
              '${teamStanding.totalPointsScored ?? 0}',
            ),
            _buildStandingInfoRow(
              'Điểm để thua',
              '${teamStanding.totalPointsConceded ?? 0}',
            ),
            _buildStandingInfoRow(
              'Hiệu số',
              '${teamStanding.pointDifference ?? 0}',
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị một dòng thông tin xếp hạng
  Widget _buildStandingInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyle.bodyMedium),
          Text(value, style: AppStyle.bodyMedium),
        ],
      ),
    );
  }
}
