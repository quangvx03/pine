/// Lớp ngoại lệ để xử lý các lỗi khác nhau.
class PExceptions implements Exception {
  /// Thông báo lỗi liên quan.
  final String message;

  /// Hàm khởi tạo mặc định với thông báo lỗi chung.
  const PExceptions([this.message = 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.']);

  /// Tạo ngoại lệ xác thực từ mã ngoại lệ xác thực Firebase.
  factory PExceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const PExceptions('Địa chỉ email đã được đăng ký. Vui lòng sử dụng email khác.');
      case 'invalid-email':
        return const PExceptions('Địa chỉ email không hợp lệ. Vui lòng nhập email hợp lệ.');
      case 'weak-password':
        return const PExceptions('Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.');
      case 'user-disabled':
        return const PExceptions('Tài khoản người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ để được trợ giúp.');
      case 'user-not-found':
        return const PExceptions('Thông tin đăng nhập không hợp lệ. Không tìm thấy người dùng.');
      case 'wrong-password':
        return const PExceptions('Mật khẩu không chính xác. Vui lòng kiểm tra lại mật khẩu và thử lại.');
      case 'INVALID_LOGIN_CREDENTIALS':
        return const PExceptions('Thông tin đăng nhập không hợp lệ. Vui lòng kiểm tra lại thông tin của bạn.');
      case 'too-many-requests':
        return const PExceptions('Quá nhiều yêu cầu. Vui lòng thử lại sau.');
      case 'invalid-argument':
        return const PExceptions('Đối số không hợp lệ được cung cấp cho phương thức xác thực.');
      case 'invalid-password':
        return const PExceptions('Mật khẩu không chính xác. Vui lòng thử lại.');
      case 'invalid-phone-number':
        return const PExceptions('Số điện thoại không hợp lệ.');
      case 'operation-not-allowed':
        return const PExceptions('Nhà cung cấp đăng nhập bị vô hiệu hóa cho dự án Firebase của bạn.');
      case 'session-cookie-expired':
        return const PExceptions('Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.');
      case 'uid-already-exists':
        return const PExceptions('ID người dùng đã được sử dụng bởi người dùng khác.');
      case 'sign_in_failed':
        return const PExceptions('Đăng nhập thất bại. Vui lòng thử lại.');
      case 'network-request-failed':
        return const PExceptions('Yêu cầu mạng thất bại. Vui lòng kiểm tra kết nối internet của bạn.');
      case 'internal-error':
        return const PExceptions('Lỗi nội bộ. Vui lòng thử lại sau.');
      case 'invalid-verification-code':
        return const PExceptions('Mã xác minh không hợp lệ. Vui lòng nhập mã hợp lệ.');
      case 'invalid-verification-id':
        return const PExceptions('ID xác minh không hợp lệ. Vui lòng yêu cầu mã xác minh mới.');
      case 'quota-exceeded':
        return const PExceptions('Vượt quá hạn mức. Vui lòng thử lại sau.');
      default:
        return const PExceptions();
    }
  }
}
