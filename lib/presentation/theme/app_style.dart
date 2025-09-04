import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';

/// Lớp AppStyle chứa các cấu hình font style cho toàn bộ ứng dụng
/// Sử dụng flutter_screenutil để responsive font size
/// Mỗi style được thiết kế cho một mục đích cụ thể và nên được sử dụng nhất quán
/// trong toàn bộ ứng dụng để đảm bảo tính đồng nhất về UI/UX
class AppStyle {
  /// Headline styles - Dùng cho các tiêu đề lớn và quan trọng nhất
  ///
  /// headline1: Dùng cho tiêu đề chính của màn hình, tiêu đề ứng dụng,
  /// hoặc các phần tử cần nhấn mạnh nhất trên giao diện
  /// Ví dụ: Màn hình splash, tiêu đề trang chủ, tên ứng dụng
  static TextStyle headline1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  /// headline2: Dùng cho các tiêu đề phần quan trọng trong ứng dụng
  /// Ví dụ: Tiêu đề của các section chính, tiêu đề màn hình quan trọng
  static TextStyle headline2 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  /// headline3: Dùng cho tiêu đề của các section phụ hoặc các phần tử quan trọng
  /// Ví dụ: Tiêu đề của card lớn, tiêu đề dialog, tiêu đề của danh sách
  static TextStyle headline3 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  /// headline4: Dùng cho tiêu đề của các thành phần nhỏ hơn trong giao diện
  /// Ví dụ: Tiêu đề của card nhỏ, tiêu đề phần thông tin chi tiết
  static TextStyle headline4 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  /// headline5: Dùng cho tiêu đề của các thành phần nhỏ trong giao diện
  /// Ví dụ: Tiêu đề của các mục trong danh sách, tiêu đề của form
  static TextStyle headline5 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// headline6: Dùng cho tiêu đề nhỏ nhất trong hệ thống headline
  /// Ví dụ: Tiêu đề của các item trong list, tiêu đề của các field trong form
  static TextStyle headline6 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// Body styles - Dùng cho nội dung chính của ứng dụng
  ///
  /// bodyLarge: Dùng cho nội dung chính quan trọng cần nhấn mạnh
  /// Ví dụ: Nội dung chính của bài viết, thông tin chi tiết quan trọng,
  /// nội dung mô tả dài trong các màn hình chi tiết
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  /// bodyMedium: Dùng cho hầu hết các nội dung văn bản thông thường trong ứng dụng
  /// Ví dụ: Nội dung thông thường của các màn hình, mô tả ngắn, nội dung trong list item
  /// Đây là style mặc định nên được sử dụng nhiều nhất cho text thông thường
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  /// bodySmall: Dùng cho các nội dung phụ, ít quan trọng hơn
  /// Ví dụ: Thông tin phụ trong list item, ghi chú ngắn, thời gian, metadata
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  /// Button styles - Dùng cho các nút bấm trong ứng dụng
  ///
  /// buttonLarge: Dùng cho các nút chính, nút quan trọng và lớn
  /// Ví dụ: Nút đăng nhập, đăng ký, nút xác nhận trong form, nút CTA (Call-to-Action) chính
  static TextStyle buttonLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// buttonMedium: Dùng cho các nút thông thường trong ứng dụng
  /// Ví dụ: Nút thứ cấp trong form, nút trong dialog, nút trong card
  static TextStyle buttonMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// buttonSmall: Dùng cho các nút nhỏ, ít quan trọng
  /// Ví dụ: Nút trong chip, nút trong badge, nút phụ trong list item
  static TextStyle buttonSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// Caption styles - Dùng cho các chú thích, ghi chú
  /// Ví dụ: Chú thích ảnh, ghi chú dưới form, thông tin phụ, thông báo nhỏ,
  /// label của input field, thông tin copyright
  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  /// Overline styles - Dùng cho các text rất nhỏ, thường là label trên cùng
  /// Ví dụ: Label nhỏ phía trên tiêu đề, nhãn phân loại, badge nhỏ,
  /// thông tin phiên bản, watermark, thông tin pháp lý
  /// Thường được viết hoa và có letter spacing lớn hơn
  static TextStyle overline = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    letterSpacing: 1.5,
  );
}
