class VNPAYConfig {
  // --- THÔNG TIN TEST ---
  static const String tmnCode = '01IP85PV'; // Mã website VNPAY cung cấp
  static const String hashSecret =
      'FTBZLHJUHQI56FBI2N7COXXDU2V81ZYQ'; // Chuỗi bí mật VNPAY cung cấp
  static const String paymentUrl =
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html'; // URL thanh toán TEST

  static const String returnUrl = 'http://pine.test';

  // --- THÔNG TIN KHÁC ---
  static const String version = '2.1.0';
  static const String command = 'pay';
  static const String currencyCode = 'VND';
  static const String locale = 'vn';
  static const String orderType = 'other';
}
