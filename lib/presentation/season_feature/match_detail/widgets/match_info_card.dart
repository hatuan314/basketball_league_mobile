import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Widget hiển thị thông tin cơ bản của trận đấu
class MatchInfoCard extends StatelessWidget {
  /// Thông tin chi tiết của trận đấu
  final MatchDetailEntity match;

  /// Constructor
  const MatchInfoCard({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin trận đấu',
              style: AppStyle.headline5,
            ),
            SizedBox(height: 16.sp),
            _buildInfoRow(
              'ID trận đấu:',
              '${match.matchId}',
              theme,
            ),
            _buildInfoRow(
              'Thời gian:',
              dateFormat.format(match.matchDate!),
              theme,
            ),
            _buildInfoRow(
              'Vòng đấu:',
              'Vòng ${match.roundNo}',
              theme,
            ),
            _buildInfoRow(
              'Mùa giải:',
              match.seasonName ?? 'Không xác định',
              theme,
            ),
            _buildInfoRow(
              'Đội nhà:',
              match.homeTeamName ?? 'Không xác định',
              theme,
            ),
            _buildInfoRow(
              'Đội khách:',
              match.awayTeamName ?? 'Không xác định',
              theme,
            ),
            _buildInfoRow(
              'Màu áo đội nhà:',
              match.homeColor ?? 'Không xác định',
              theme,
            ),
            _buildInfoRow(
              'Màu áo đội khách:',
              match.awayColor ?? 'Không xác định',
              theme,
            ),
            if (match.winnerTeamName != null)
              _buildInfoRow(
                'Đội thắng:',
                match.winnerTeamName!,
                theme,
                textColor: Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ThemeData theme, {
    Color? textColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
