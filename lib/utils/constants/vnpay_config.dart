class VNPAYConfig {
  // --- THÔNG TIN TEST ---
  static const String tmnCode = '01IP85PV';
  static const String hashSecret = 'V261NX2YM8R33A5X1VSVEKS22T2188MW';
  static const String paymentUrl =
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';

  static const String returnUrl = 'http://pine.test';

  // --- THÔNG TIN KHÁC ---
  static const String version = '2.1.0';
  static const String command = 'pay';
  static const String currencyCode = 'VND';
  static const String locale = 'vn';
  static const String orderType = 'other';
}
