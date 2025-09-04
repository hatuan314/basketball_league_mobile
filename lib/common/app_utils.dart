import 'package:flutter/material.dart';

class AppUtils {
  static bool isNullEmpty(Object? o) => o == null || "" == o || o == "null";

  static bool isNotNullEmpty(Object? o) => !isNullEmpty(o);

  static bool isNullEmptyOrFalse(Object? o) =>
      o == null || false == o || "" == o;

  static bool isNullEmptyFalseOrZero(Object? o) =>
      o == null || false == o || 0 == o || "" == o || "0" == o;

  static bool isNullEmptyList<T>(List<T>? t) =>
      t == null || [] == t || t.isEmpty;

  static bool isNullEmptyMap<T>(Map<T, T>? t) =>
      t == null || {} == t || t.isEmpty;

  static bool isNumeric(dynamic s) {
    String sConvert = s.toString();
    if (isNullEmpty(sConvert)) {
      return false;
    }
    return (double.tryParse(sConvert) != null ||
        int.tryParse(sConvert) != null);
  }

  static String formatCurrency(dynamic number) {
    if (isNullEmptyOrFalse(number) || !isNumeric(number)) {
      return '';
    }
    if (number is double) {
      number = number.ceil();
    }

    String numberConvert = number.toString();
    // Remove unnecessary zeros after "."
    numberConvert = numberConvert.split('.')[0];

    return numberConvert.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]} ',
    );
  }

  static String formatBankAccountNumber(String number) {
    String formatted = number.replaceAll(
      RegExp(r'\D'),
      '',
    ); // Loại bỏ tất cả các ký tự không phải số
    formatted =
        '${formatted.substring(0, 4)} ${formatted.substring(4, 8)} ${formatted.substring(8)}'; // Tạo định dạng 0000 0000 0134
    return formatted.trim();
  }

  static double toDouble(var value) {
    if (isNullEmpty(value)) {
      return 0;
    }

    if (value is int) {
      return double.parse(value.toString());
    } else if (value is String) {
      return double.parse(value);
    } else if (value is double) {
      return value;
    }
    return 0;
  }

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String formatCurrencyUnit(dynamic number) {
    return '${formatCurrency(number)} VND';
  }

  static String formatHidePhoneNumber(String phoneNumber) {
    if (isNullEmpty(phoneNumber)) {
      return '';
    }
    return phoneNumber.replaceRange(3, 7, '****');
  }

  static String convertToString(dynamic value) {
    if (isNullEmpty(value)) {
      return '';
    }
    return value.toString();
  }

  // static double getScreenRatio() {
  //   return (ScreenUtil().screenHeight / ScreenUtil().screenWidth);
  // }

  static bool isDateNow(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return true;
    }
    return false;
  }

  // static Future<void> checkFirstRunApp() async {
  //   final prefs = LocalStorageFactory.instance;
  //   if (prefs.get('first_run') ?? true) {
  //     final storage = LocalSecureStorageFactory.instance;
  //     await storage.deleteAll();
  //     prefs.set('first_run', false);
  //   }
  // }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input; // Nếu chuỗi rỗng, trả về nguyên trạng
    }

    final firstLetter = input[0].toUpperCase();
    final restOfString = input.substring(1);

    return '$firstLetter$restOfString';
  }

  static bool isKeyboardShowing(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0.0;
  }

  // static void requestReviewStore() async {
  //   final InAppReview inAppReview = InAppReview.instance;
  //
  //   if (await inAppReview.isAvailable()) {
  //     inAppReview.requestReview();
  //   }
  // }

  static String addLeadingZeroIfNeeded(int? number) {
    String numberString = number.toString();
    if (numberString.length < 2) {
      return '0$numberString';
    } else {
      return numberString;
    }
  }

  // static void openappV1Store() {
  //   if (Platform.isIOS) {
  //     launchUrl(
  //       Uri.parse(
  //         AppConstants.appV1AppStore,
  //       ),
  //     );
  //   } else if (Platform.isAndroid) {
  //     launchUrl(
  //       Uri.parse(
  //         AppConstants.appV1PlayStore,
  //       ),
  //     );
  //   }
  // }

  static String? formatNidMask(String? nid) {
    if (nid?.length != 12) {
      return nid;
    }
    return '${nid?.substring(0, 2)}•• •••• ••${nid?.substring(10, 12)}';
  }

  // static List<int> getRewardMileStone({double currentValue = 0}) {
  //   int step = currentValue ~/ AppConstants.rewardMileStoneInterval;
  //   return [
  //     step * AppConstants.rewardMileStoneInterval,
  //     (step + 1) * AppConstants.rewardMileStoneInterval,
  //   ];
  // }

  static int roundDownToNearest(dynamic number, {int roundDownValue = 50000}) {
    if (number is int) {
      return (number ~/ roundDownValue) * roundDownValue;
    } else if (number is double) {
      return ((number ~/ roundDownValue) * roundDownValue).toInt();
    } else if (number is String) {
      return ((int.parse(number) ~/ roundDownValue) * roundDownValue).toInt();
    } else {
      throw ArgumentError(
        'Unsupported data type. Only String, int and double are supported.',
      );
    }
  }

  /// Kiểm tra chuỗi có phải là đường dẫn của ảnh hay không
  ///
  /// Hàm này kiểm tra dựa trên:
  /// 1. Phần mở rộng của URL (.jpg, .png, .jpeg, .gif, .webp, .bmp, .svg)
  /// 2. Các pattern thông dụng của URL ảnh (imgur, cloudinary, etc.)
  /// 3. Kiểm tra URL có hợp lệ không
  ///
  /// Trả về true nếu là đường dẫn ảnh, ngược lại trả về false
  static bool isImageUrl(String? url) {
    // Kiểm tra URL có null hoặc rỗng không
    if (url == null || url.trim().isEmpty) {
      return false;
    }

    // Kiểm tra URL có hợp lệ không
    Uri? uri;
    try {
      uri = Uri.parse(url);
      // Kiểm tra URL có scheme không (http, https)
      if (!uri.hasScheme ||
          !['http', 'https'].contains(uri.scheme.toLowerCase())) {
        return false;
      }
    } catch (e) {
      return false;
    }

    // Kiểm tra phần mở rộng của URL
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.bmp',
      '.svg',
    ];
    if (imageExtensions.any((ext) => url.endsWith(ext))) {
      return true;
    }

    return false;
  }
}
