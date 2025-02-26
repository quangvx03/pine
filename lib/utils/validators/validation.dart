
class PValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email là bắt buộc.';
    }

    // regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Địa chỉ email không hợp lệ.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu là bắt buộc".';
    }

    // check for minimum password length
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }

    // check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ cái viết hoa.';
    }

    // check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải chứa ít nhất một số.';
    }

    // check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại là bắt buộc.';
    }

    // regular expression for phone number validation (assuming a 10-digit US phone number formar)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Định dạng số điện thoại không hợp lệ (cần 10 chữ số).';
    }

    return null;
  }
}
