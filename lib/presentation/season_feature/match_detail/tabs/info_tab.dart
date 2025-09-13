import 'package:baseketball_league_mobile/domain/match/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoTab extends StatelessWidget {
  final MatchDetailEntity match;

  const InfoTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.sp),
      child: MatchInfoCard(match: match),
    );
  }
}
