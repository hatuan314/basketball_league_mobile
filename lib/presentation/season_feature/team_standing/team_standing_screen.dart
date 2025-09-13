import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/widgets/team_standing_search_bar.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/widgets/team_standing_sort_button.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/widgets/team_standing_table.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamStandingScreen extends StatefulWidget {
  final int seasonId;
  final String seasonName;

  const TeamStandingScreen({
    super.key,
    required this.seasonId,
    required this.seasonName,
  });

  @override
  State<TeamStandingScreen> createState() => _TeamStandingScreenState();
}

class _TeamStandingScreenState extends State<TeamStandingScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Lấy bảng xếp hạng khi màn hình được khởi tạo
    context.read<TeamStandingCubit>().initial(
      widget.seasonId,
      widget.seasonName,
    );
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TeamStandingCubit>().searchTeamStandingByName(
      _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bảng xếp hạng', style: AppStyle.headline4),
        actions: [TeamStandingSortButton()],
      ),
      body: Column(
        children: [
          TeamStandingSearchBar(
            searchController: _searchController,
            seasonId: widget.seasonId,
            seasonName: widget.seasonName,
          ),
          Expanded(
            child: TeamStandingTable(
              seasonId: widget.seasonId,
              seasonName: widget.seasonName,
            ),
          ),
        ],
      ),
    );
  }
}
