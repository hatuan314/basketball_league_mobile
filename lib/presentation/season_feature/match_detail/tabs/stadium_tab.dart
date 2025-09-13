import 'package:baseketball_league_mobile/domain/match/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_stadium_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StadiumTab extends StatelessWidget {
  final MatchDetailEntity match;

  const StadiumTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.sp),
      child: MatchStadiumCard(match: match),
    );
  }
}
