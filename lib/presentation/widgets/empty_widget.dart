import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final String? description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double? imageHeight;
  final double? imageWidth;

  const EmptyWidget({
    Key? key,
    required this.message,
    this.description,
    this.buttonText,
    this.onButtonPressed,
    this.imageHeight,
    this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/empty.json',
            height: imageHeight ?? 150.sp,
            width: imageWidth ?? 150.sp,
          ),
          SizedBox(height: 16.sp),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[  
            SizedBox(height: 8.sp),
            Text(
              description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (buttonText != null && onButtonPressed != null) ...[  
            SizedBox(height: 16.sp),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
              ),
              onPressed: onButtonPressed,
              child: Text(
                buttonText!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
