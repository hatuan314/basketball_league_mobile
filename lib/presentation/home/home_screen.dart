import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/home/widgets/empty_season_data_widget.dart';
import 'package:baseketball_league_mobile/presentation/home/widgets/season_iteam_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _schemas = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // _getSchemas();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return AppLoading();
          } else if (state.status == HomeStatus.error) {
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

    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh sách mùa giải',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.sp),
          Expanded(
            child: ListView.builder(
              itemCount: seasons.length,
              itemBuilder: (context, index) {
                final season = seasons[index];
                return SeasonIteamCard(season: season);
              },
            ),
          ),
        ],
      ),
    );
  }
}
