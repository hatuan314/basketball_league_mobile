import 'package:baseketball_league_mobile/common/constants/router_name.dart'
    show RouterName;
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/bloc/team_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/widget/team_item_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_colors.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamListCubit>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Danh sách đội bóng', style: AppStyle.headline4),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement search functionality
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<TeamListCubit, TeamListState>(
        builder: (context, state) {
          if (state.status == TeamListStatus.loading) {
            return AppLoadingWidget();
          } else if (state.status == TeamListStatus.failure) {
            return Center(
              child: Text(
                'Đã xảy ra lỗi: ${state.errorMessage}',
                style: AppStyle.bodyLarge,
              ),
            );
          } else if (state.teams.isEmpty) {
            return EmptyWidget(
              message: 'Không có đội bóng nào',
              description: 'Bạn có thể tạo đội bóng mới hoặc tạo dữ liệu mẫu',
              buttonText: 'Tạo dữ liệu mẫu',
              onButtonPressed: () async {
                await context.read<TeamListCubit>().generateTeams();
              },
            );
          }
          return _buildTeamList(state.teams);
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          context.push(RouterName.teamEdit.toTeamRoute());
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildTeamList(List<TeamEntity> teams) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TeamListCubit>().initial();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: TeamItemCard(team: team),
          );
        },
      ),
    );
  }
}
