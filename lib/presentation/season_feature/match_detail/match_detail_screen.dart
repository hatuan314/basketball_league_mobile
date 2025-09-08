import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/tabs/away_players_tab.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/tabs/home_players_tab.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/tabs/info_tab.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/tabs/referees_tab.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/tabs/score_tab.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/tabs/stadium_tab.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchId;
  final int roundId;

  const MatchDetailScreen({
    Key? key,
    required this.matchId,
    required this.roundId,
  }) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchDetailCubit>().initial(
        matchId: widget.matchId,
        roundId: widget.roundId,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết trận đấu', style: AppStyle.headline4),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MatchDetailCubit>().refreshMatchDetail();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.sp),
          child: BlocBuilder<MatchDetailCubit, MatchDetailState>(
            builder: (context, state) {
              if (state.status == MatchDetailStatus.loading ||
                  state.match == null) {
                return Container(height: 48.sp);
              }

              return TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Thông tin trận đấu'),
                  Tab(text: 'Tỉ số trận đấu'),
                  Tab(text: 'Thông tin sân vận động'),
                  Tab(text: 'Danh sách trọng tài'),
                  Tab(text: 'Cầu thủ đội nhà'),
                  Tab(text: 'Cầu thủ đội khách'),
                ],
              );
            },
          ),
        ),
      ),
      body: BlocConsumer<MatchDetailCubit, MatchDetailState>(
        listener: (context, state) {
          if (state.status == MatchDetailStatus.updateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật trận đấu thành công'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == MatchDetailStatus.updateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Cập nhật trận đấu thất bại',
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == MatchDetailStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Lỗi khi tải thông tin trận đấu',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == MatchDetailStatus.loading) {
            return const AppLoading();
          } else if (state.match == null) {
            return const EmptyWidget(
              message: 'Không tìm thấy thông tin trận đấu',
            );
          }

          return _buildMatchDetail(context, state.match!, state.referees);
        },
      ),
    );
  }

  Widget _buildMatchDetail(
    BuildContext context,
    MatchDetailEntity match,
    List<MatchRefereeDetailEntity>? referees,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MatchDetailCubit>().refreshMatchDetail();
      },
      child: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Tab 1: Thông tin trận đấu
          InfoTab(match: match),

          // Tab 2: Tỉ số trận đấu
          ScoreTab(match: match),

          // Tab 3: Thông tin sân vận động
          StadiumTab(match: match),

          // Tab 4: Danh sách trọng tài
          RefereesTab(match: match, referees: referees),

          // Tab 5: Danh sách cầu thủ đội nhà
          HomePlayersTab(match: match),

          // Tab 6: Danh sách cầu thủ đội khách
          AwayPlayersTab(match: match),
        ],
      ),
    );
  }
}
