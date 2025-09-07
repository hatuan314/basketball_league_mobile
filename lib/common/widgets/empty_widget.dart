import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// Widget hiển thị khi không có dữ liệu
class EmptyWidget extends StatelessWidget {
  /// Thông báo chính
  final String message;

  /// Mô tả chi tiết
  final String? description;

  /// Widget con bổ sung (ví dụ: nút thêm mới)
  final Widget? child;

  /// Constructor
  const EmptyWidget({
    super.key,
    required this.message,
    this.description,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/empty.json',
              width: 150.r,
              height: 150.r,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: 8.h),
              Text(
                description!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (child != null) ...[
              SizedBox(height: 24.h),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}
