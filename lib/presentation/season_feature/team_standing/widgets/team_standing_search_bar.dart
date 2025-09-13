import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamStandingSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  const TeamStandingSearchBar({
    super.key,
    required this.searchController,
    required this.seasonId,
    required this.seasonName,
  });

  final int seasonId;
  final String seasonName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm đội bóng',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              context.read<TeamStandingCubit>().initial(seasonId, seasonName);
            },
          ),
        ),
      ),
    );
  }
}
