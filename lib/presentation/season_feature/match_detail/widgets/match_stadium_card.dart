import 'package:baseketball_league_mobile/domain/match/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Widget hiển thị thông tin sân vận động của trận đấu
class MatchStadiumCard extends StatelessWidget {
  /// Thông tin chi tiết của trận đấu
  final MatchDetailEntity match;

  /// Constructor
  const MatchStadiumCard({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin sân vận động', style: AppStyle.headline5),
            SizedBox(height: 16.sp),
            _buildInfoRow(
              'Tên sân:',
              match.stadiumName ?? 'Không xác định',
              theme,
            ),
            _buildInfoRow('ID sân:', '${match.stadiumId}', theme),
            _buildInfoRow(
              'Giá vé:',
              match.ticketPrice != null
                  ? currencyFormat.format(match.ticketPrice)
                  : 'Không xác định',
              theme,
            ),
            _buildInfoRow(
              'Số người xem:',
              '${match.attendance ?? 0} người',
              theme,
            ),
            _buildInfoRow(
              'Doanh thu:',
              match.ticketPrice != null && match.attendance != null
                  ? currencyFormat.format(
                    match.ticketPrice! * match.attendance!,
                  )
                  : 'Không xác định',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
