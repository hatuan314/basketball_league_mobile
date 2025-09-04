import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/widgets/player_listview.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({Key? key}) : super(key: key);

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerListCubit>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cầu thủ'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<PlayerListCubit, PlayerListState>(
        builder: (context, state) {
          switch (state.status) {
            case PlayerListStatus.loading:
              return const AppLoading();
            case PlayerListStatus.loaded:
              return PlayerListview(players: state.playerList ?? []);
            case PlayerListStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      'Đã xảy ra lỗi',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.errorMessage ?? 'Không thể tải danh sách cầu thủ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed:
                          () => context.read<PlayerListCubit>().initial(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new player
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
