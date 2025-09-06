import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StadiumSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function() onSearch;

  const StadiumSearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm sân vận động...',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: AppColors.primary),
          padding: EdgeInsets.all(8.r),
          onPressed: onSearch,
        ),
      ),
      style: AppStyle.bodyLarge,
      autofocus: true,
    );
  }
}
