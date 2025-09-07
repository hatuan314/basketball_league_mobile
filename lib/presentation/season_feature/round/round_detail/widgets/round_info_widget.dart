import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RoundInfoWidget extends StatelessWidget {
  final RoundEntity round;

  const RoundInfoWidget({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: EdgeInsets.all(16.sp),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin vòng đấu',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.sp),
            _buildInfoRow(context, 'ID vòng đấu:', '${round.id}'),
            SizedBox(height: 8.sp),
            _buildInfoRow(context, 'Vòng số:', '${round.roundNo}'),
            SizedBox(height: 8.sp),
            _buildInfoRow(context, 'Mùa giải:', '${round.seasonId}'),
            SizedBox(height: 8.sp),
            _buildInfoRow(
              context,
              'Ngày bắt đầu:',
              round.startDate != null
                  ? dateFormat.format(round.startDate!)
                  : 'Chưa có lịch',
            ),
            SizedBox(height: 8.sp),
            _buildInfoRow(
              context,
              'Ngày kết thúc:',
              round.endDate != null
                  ? dateFormat.format(round.endDate!)
                  : 'Chưa có lịch',
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng một hàng thông tin
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
