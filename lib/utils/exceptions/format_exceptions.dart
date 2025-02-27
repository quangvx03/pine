/// Lớp ngoại lệ tùy chỉnh để xử lý các lỗi liên quan đến định dạng.
class PFormatException implements Exception {
  /// Thông báo lỗi liên quan.
  final String message;

  /// Hàm khởi tạo mặc định với thông báo lỗi chung.
  const PFormatException([this.message = 'Đã xảy ra lỗi định dạng không mong muốn. Vui lòng kiểm tra đầu vào của bạn.']);

  /// Tạo ngoại lệ định dạng từ một thông báo lỗi cụ thể.
  factory PFormatException.fromMessage(String message) {
    return PFormatException(message);
  }

  /// Lấy thông báo lỗi tương ứng.
  String get formattedMessage => message;

  /// Tạo ngoại lệ định dạng từ một mã lỗi cụ thể.
  factory PFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const PFormatException('Định dạng địa chỉ email không hợp lệ. Vui lòng nhập email hợp lệ.');
      case 'invalid-phone-number-format':
        return const PFormatException('Định dạng số điện thoại không hợp lệ. Vui lòng nhập số hợp lệ.');
      case 'invalid-date-format':
        return const PFormatException('Định dạng ngày không hợp lệ. Vui lòng nhập ngày hợp lệ.');
      case 'invalid-url-format':
        return const PFormatException('Định dạng URL không hợp lệ. Vui lòng nhập URL hợp lệ.');
      case 'invalid-credit-card-format':
        return const PFormatException('Định dạng thẻ tín dụng không hợp lệ. Vui lòng nhập số thẻ tín dụng hợp lệ.');
      case 'invalid-numeric-format':
        return const PFormatException('Đầu vào phải là định dạng số hợp lệ.');
    // Thêm các trường hợp khác nếu cần...
      default:
        return const PFormatException();
    }
  }
}