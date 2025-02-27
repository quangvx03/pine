/// Lớp ngoại lệ tùy chỉnh để xử lý các lỗi liên quan đến xác thực Firebase.
class PFirebaseAuthException implements Exception {
  /// Mã lỗi liên quan đến ngoại lệ.
  final String code;

  /// Constructor nhận mã lỗi.
  PFirebaseAuthException(this.code);

  /// Lấy thông báo lỗi tương ứng dựa trên mã lỗi.
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Địa chỉ email đã được đăng ký. Vui lòng sử dụng email khác.';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ. Vui lòng nhập email hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.';
      case 'user-disabled':
        return 'Tài khoản người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ để được trợ giúp.';
      case 'user-not-found':
        return 'Thông tin đăng nhập không hợp lệ. Không tìm thấy người dùng.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác. Vui lòng kiểm tra lại mật khẩu và thử lại.';
      case 'invalid-verification-code':
        return 'Mã xác minh không hợp lệ. Vui lòng nhập mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác minh không hợp lệ. Vui lòng yêu cầu mã xác minh mới.';
      case 'quota-exceeded':
        return 'Đã vượt quá hạn mức. Vui lòng thử lại sau.';
      case 'email-already-exists':
        return 'Địa chỉ email đã tồn tại. Vui lòng sử dụng email khác.';
      case 'provider-already-linked':
        return 'Tài khoản đã được liên kết với nhà cung cấp khác.';
      case 'requires-recent-login':
        return 'Hoạt động này nhạy cảm và yêu cầu xác thực gần đây. Vui lòng đăng nhập lại.';
      case 'credential-already-in-use':
        return 'Thông tin xác thực này đã được liên kết với tài khoản người dùng khác.';
      case 'user-mismatch':
        return 'Thông tin xác thực cung cấp không khớp với người dùng đã đăng nhập trước đó.';
      case 'account-exists-with-different-credential':
        return 'Tài khoản đã tồn tại với cùng email nhưng thông tin đăng nhập khác.';
      case 'operation-not-allowed':
        return 'Hoạt động này không được phép. Liên hệ hỗ trợ để được trợ giúp.';
      case 'expired-action-code':
        return 'Mã hành động đã hết hạn. Vui lòng yêu cầu mã hành động mới.';
      case 'invalid-action-code':
        return 'Mã hành động không hợp lệ. Vui lòng kiểm tra mã và thử lại.';
      case 'missing-action-code':
        return 'Thiếu mã hành động. Vui lòng cung cấp mã hành động hợp lệ.';
      case 'user-token-expired':
        return 'Token của người dùng đã hết hạn, cần xác thực lại. Vui lòng đăng nhập lại.';
      case 'user-not-found':
        return 'Không tìm thấy người dùng với email hoặc UID đã cung cấp.';
      case 'invalid-credential':
        return 'Thông tin xác thực cung cấp không hợp lệ hoặc đã hết hạn.';
      case 'wrong-password':
        return 'Mật khẩu không hợp lệ. Vui lòng kiểm tra lại mật khẩu và thử lại.';
      case 'user-token-revoked':
        return 'Token của người dùng đã bị thu hồi. Vui lòng đăng nhập lại.';
      case 'invalid-message-payload':
        return 'Nội dung thông báo xác minh email không hợp lệ.';
      case 'invalid-sender':
        return 'Người gửi thông báo email không hợp lệ. Vui lòng kiểm tra email của người gửi.';
      case 'invalid-recipient-email':
        return 'Địa chỉ email người nhận không hợp lệ. Vui lòng cung cấp email người nhận hợp lệ.';
      case 'missing-iframe-start':
        return 'Mẫu email thiếu thẻ bắt đầu iframe.';
      case 'missing-iframe-end':
        return 'Mẫu email thiếu thẻ kết thúc iframe.';
      case 'missing-iframe-src':
        return 'Mẫu email thiếu thuộc tính src của iframe.';
      case 'auth-domain-config-required':
        return 'Cấu hình authDomain là bắt buộc cho liên kết xác minh mã hành động.';
      case 'missing-app-credential':
        return 'Thiếu thông tin xác thực ứng dụng. Vui lòng cung cấp thông tin xác thực ứng dụng hợp lệ.';
      case 'invalid-app-credential':
        return 'Thông tin xác thực ứng dụng không hợp lệ. Vui lòng cung cấp thông tin xác thực ứng dụng hợp lệ.';
      case 'session-cookie-expired':
        return 'Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.';
      case 'uid-already-exists':
        return 'ID người dùng đã được sử dụng bởi người dùng khác.';
      case 'invalid-cordova-configuration':
        return 'Cấu hình Cordova không hợp lệ.';
      case 'app-deleted':
        return 'Phiên bản FirebaseApp này đã bị xóa.';
      case 'user-disabled':
        return 'Tài khoản người dùng đã bị vô hiệu hóa.';
      case 'user-token-mismatch':
        return 'Token của người dùng không khớp với ID người dùng đã xác thực.';
      case 'web-storage-unsupported':
        return 'Lưu trữ web không được hỗ trợ hoặc đã bị vô hiệu hóa.';
      case 'invalid-credential':
        return 'Thông tin xác thực cung cấp không hợp lệ. Vui lòng kiểm tra lại thông tin xác thực và thử lại.';
      case 'app-not-authorized':
        return 'Ứng dụng không được phép sử dụng Firebase Authentication với khóa API đã cung cấp.';
      case 'keychain-error':
        return 'Đã xảy ra lỗi keychain. Vui lòng kiểm tra keychain và thử lại.';
      case 'internal-error':
        return 'Đã xảy ra lỗi xác thực nội bộ. Vui lòng thử lại sau.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Thông tin đăng nhập không hợp lệ.';
      default:
        return 'Đã xảy ra lỗi xác thực không mong muốn. Vui lòng thử lại.';
    }
  }
}
