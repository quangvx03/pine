import 'package:intl/intl.dart';

class PFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date); // Định dạng ngày tháng kiểu Việt Nam
    // Hoặc sử dụng DateFormat('dd/MM/yyyy') cho định dạng dd/MM/yyyy
  }

  static String formatCurrencyRange(String priceRange) {
    if (priceRange.isEmpty) return '0₫'; // Trả về 0₫ nếu chuỗi rỗng

    try {
      // Loại bỏ ký tự không phải số (vd: "đ") và tách khoảng giá theo "-"
      List<String> prices = priceRange.replaceAll(RegExp(r'[^0-9\-]'), '').split('-');

      NumberFormat format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

      if (prices.length == 1) {
        return format.format(double.parse(prices[0].trim()));
      } else if (prices.length == 2) {
        return '${format.format(double.parse(prices[0].trim()))} - ${format.format(double.parse(prices[1].trim()))}';
      }
    } catch (e) {
      return '0₫'; // Xử lý lỗi khi không thể định dạng
    }

    return priceRange; // Trả về nguyên chuỗi nếu không thể xử lý
  }

  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(value);
  }


  static String formatPhoneNumber(String phoneNumber) {
    // Loại bỏ các ký tự không phải là số
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Định dạng số điện thoại Việt Nam
    if (cleanedPhoneNumber.length == 10) {
      return '0${cleanedPhoneNumber.substring(1, 4)} ${cleanedPhoneNumber.substring(4, 7)} ${cleanedPhoneNumber.substring(7)}';
    }
    // Nếu không đúng định dạng, trả về số gốc
    return phoneNumber;
  }


  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Nếu số điện thoại bắt đầu bằng '0', giữ nguyên
    if (digitsOnly.startsWith('0')) {
      return digitsOnly;
    }
    // Nếu số điện thoại có 9 hoặc 10 chữ số (không có '0' ở đầu), thêm '0' vào đầu
    else if (digitsOnly.length == 9 || digitsOnly.length == 10) {
      return '0$digitsOnly';
    }
    // Trường hợp còn lại, trả về số điện thoại đã làm sạch (có thể là số không hợp lệ)
    else {
      return digitsOnly;
    }
  }
}