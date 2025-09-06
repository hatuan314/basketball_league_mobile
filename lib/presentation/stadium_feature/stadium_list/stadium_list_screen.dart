import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/widgets/stadium_list_body.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/widgets/stadium_search_bar.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_colors.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StadiumListScreen extends StatelessWidget {
  const StadiumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StadiumListCubit>()..getStadiums(),
      child: const _StadiumListView(),
    );
  }
}

class _StadiumListView extends StatefulWidget {
  const _StadiumListView();

  @override
  State<_StadiumListView> createState() => _StadiumListViewState();
}

class _StadiumListViewState extends State<_StadiumListView> {
  /// Controller cho text field tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  /// Biến để kiểm soát hiển thị thanh tìm kiếm
  bool _showSearchBar = false;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Xử lý khi nội dung tìm kiếm thay đổi
  void _onSearchChanged() {
    context.read<StadiumListCubit>().searchStadiums(_searchController.text);
  }

  void _loadStadiums() {
    context.read<StadiumListCubit>().getStadiums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _showSearchBar
                ? StadiumSearchBar(
                  searchController: _searchController,
                  onSearch: () {
                    _searchController.clear();
                    setState(() {
                      _showSearchBar = false;
                    });
                    _loadStadiums();
                  },
                )
                : Text('Danh sách sân vận động', style: AppStyle.headline4),
        actions: [
          if (!_showSearchBar) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showSearchBar = true;
                });
              },
              tooltip: 'Tìm kiếm',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadStadiums,
              tooltip: 'Làm mới',
            ),
          ],
        ],
      ),
      body: StadiumListBody(onRefresh: _loadStadiums),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed:
            () => context
                .push(
                  RouterName.stadiumEdit.toStadiumRoute(),
                  extra: {'stadium': null, 'isEditing': false},
                )
                .then((_) => _loadStadiums()),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
