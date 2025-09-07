import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/bloc/referee_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/widgets/referee_list_view.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Màn hình danh sách trọng tài
class RefereeListScreen extends StatefulWidget {
  /// Constructor
  const RefereeListScreen({super.key});

  @override
  State<RefereeListScreen> createState() => _RefereeListScreenState();
}

class _RefereeListScreenState extends State<RefereeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Lấy danh sách trọng tài khi màn hình được khởi tạo
    context.read<RefereeListCubit>().getReferees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách trọng tài', style: AppStyle.headline4),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          _buildSearchBar(),
          // Nội dung chính
          Expanded(child: RefereeListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          context.push(RouterName.refereeCreate.toRefereeRoute());
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  /// Xây dựng thanh tìm kiếm
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm trọng tài...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _searchFocusNode.unfocus();
              context.read<RefereeListCubit>().getReferees();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        onSubmitted: (value) {
          context.read<RefereeListCubit>().searchReferees(value);
        },
      ),
    );
  }
}
