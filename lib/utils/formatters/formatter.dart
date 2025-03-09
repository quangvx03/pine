import 'package:intl/intl.dart';

class PFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date); // Định dạng ngày tháng kiểu Việt Nam
    // Hoặc sử dụng DateFormat('dd/MM/yyyy') cho định dạng dd/MM/yyyy
  }

  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫'); // Định dạng tiền tệ Việt Nam
    return format.format(amount);
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