import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:pine/utils/constants/vnpay_config.dart'; // Import file config

class VNPAYHelper {
  /// Tạo URL thanh toán VNPAY
  static String generatePaymentUrl({
    required String orderId,
    required double amount,
    required String orderInfo,
    required String ipAddress,
  }) {
    // Chuyển đổi amount thành integer với đơn vị là VND (nhân 100 vì VNPAY yêu cầu số tiền * 100)
    final amountInt = (amount * 100).toInt();

    // Lấy thời gian hiện tại theo định dạng yyyyMMddHHmmss
    final now = DateTime.now();
    final createDate = DateFormat('yyyyMMddHHmmss').format(now);

    // Tạo map các tham số
    final params = {
      'vnp_Version': VNPAYConfig.version,
      'vnp_Command': VNPAYConfig.command,
      'vnp_TmnCode': VNPAYConfig.tmnCode,
      'vnp_Amount': amountInt.toString(), // Đã nhân với 100
      'vnp_CurrCode': VNPAYConfig.currencyCode,
      'vnp_TxnRef': orderId,
      'vnp_OrderInfo': orderInfo,
      'vnp_OrderType': VNPAYConfig.orderType,
      'vnp_Locale': VNPAYConfig.locale,
      'vnp_ReturnUrl': VNPAYConfig.returnUrl,
      'vnp_IpAddr': ipAddress,
      'vnp_CreateDate': createDate,
    };

    // Sắp xếp các tham số theo thứ tự từ điển (alphabet)
    final sortedParams = Map.fromEntries(
        params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    // Tạo chuỗi truy vấn để tính toán chữ ký
    final queryString = Uri(queryParameters: sortedParams).query;

    // Xử lý đặc biệt: một số ngôn ngữ mã hóa dấu cách thành dấu '+', cần chuyển lại thành dấu '+'
    final hashData = queryString.replaceAll(RegExp(r'%20'), '+');

    // Tạo chữ ký bằng cách kết hợp với chuỗi bí mật
    final secureHash =
        _createHmacSHA512Signature(hashData, VNPAYConfig.hashSecret);

    // Debug log nếu cần
    print('VNPAY Hash Data: $hashData');
    print('VNPAY Secure Hash: $secureHash');

    // Thêm chữ ký vào tham số
    sortedParams['vnp_SecureHash'] = secureHash;

    // Tạo URL thanh toán
    final paymentUrl = Uri.parse(VNPAYConfig.paymentUrl)
        .replace(queryParameters: sortedParams);

    // In URL thanh toán để debug
    print('VNPAY URL: ${paymentUrl.toString()}');

    return paymentUrl.toString();
  }

  // Hàm tạo chữ ký HMAC-SHA512
  static String _createHmacSHA512Signature(String data, String key) {
    final hmacSha512 = Hmac(sha512, utf8.encode(key));
    final digest = hmacSha512.convert(utf8.encode(data));
    return digest.toString();
  }

  /// Xác thực chữ ký (checksum) dữ liệu trả về từ VNPAY
  static bool validateReturnData(Map<String, String> returnParams) {
    // Lấy chữ ký từ VNPAY
    final vnpSecureHash = returnParams['vnp_SecureHash'];
    if (vnpSecureHash == null) {
      print("Lỗi xác thực VNPAY: Thiếu vnp_SecureHash");
      return false;
    }

    // Tạo một bản sao của params để không sửa đổi bản gốc khi xóa key
    final paramsToValidate = Map<String, String>.from(returnParams);

    // Loại bỏ hash và hash type khỏi map
    paramsToValidate.remove('vnp_SecureHash');
    paramsToValidate.remove('vnp_SecureHashType');

    // Sắp xếp params theo key alphabet
    final sortedParams = Map.fromEntries(paramsToValidate.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    // Tạo chuỗi cho tính toán hash
    List<String> query = [];
    sortedParams.forEach((key, value) {
      if (value.isNotEmpty) {
        // SỬA Ở ĐÂY: Cần thay thế dấu cách thành dấu + trong các trường có dấu cách
        String encodedValue = value;
        if (key == 'vnp_OrderInfo') {
          encodedValue = value.replaceAll(' ', '+');
        }
        query.add('$key=$encodedValue');
      }
    });

    // Nối các phần tử với dấu '&'
    final hashData = query.join('&');

    // Debug
    print("HashData Received: $hashData");
    print("Hash Received: $vnpSecureHash");

    // Tạo chữ ký để so sánh
    final calculatedHash =
        _createHmacSHA512Signature(hashData, VNPAYConfig.hashSecret);

    // Debug
    print("Hash Calculated: $calculatedHash");

    // So sánh hash tính toán với hash nhận được từ VNPAY (không phân biệt chữ hoa/thường)
    return calculatedHash.toLowerCase() == vnpSecureHash.toLowerCase();
  }
}
