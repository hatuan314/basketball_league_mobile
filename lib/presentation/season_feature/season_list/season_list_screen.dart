import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/bloc/season_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/widgets/empty_season_data_widget.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/widgets/season_item_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeasonListScreen extends StatefulWidget {
  const SeasonListScreen({super.key});

  @override
  State<SeasonListScreen> createState() => _SeasonListScreenState();
}

class _SeasonListScreenState extends State<SeasonListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeasonListCubit>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Danh sách giải đấu', style: AppStyle.headline4),
      ),
      body: BlocBuilder<SeasonListCubit, SeasonListState>(
        builder: (context, state) {
          if (state.status == SeasonListStatus.loading) {
            return AppLoading();
          } else if (state.status == SeasonListStatus.error) {
            return _buildErrorView(state.errorMessage ?? 'Đã xảy ra lỗi');
          } else {
            return _buildSeasonListView(state.seasons ?? []);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          // TODO: Implement add new player
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.sp),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.sp),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().initial();
            },
            child: Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonListView(List<SeasonEntity> seasons) {
    if (seasons.isEmpty) {
      return EmptySeasonDataWidget();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.sp),
      itemCount: seasons.length,
      itemBuilder: (context, index) {
        final season = seasons[index];
        return SeasonItemCard(season: season);
      },
    );
  }
}
