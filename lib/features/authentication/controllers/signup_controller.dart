import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../data/repositories/authentication_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../personalization/models/user_model.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      // Kiểm tra kết nối internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Dừng loader nếu không có kết nối
        PFullScreenLoader.stopLoading();
        return;
      }

      // Kiểm tra tính hợp lệ của form
      if (!signupFormKey.currentState!.validate()) {
        // Dừng loader nếu form không hợp lệ
        PFullScreenLoader.stopLoading();
        return;
      }

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Tạo người dùng mới
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '', // Có thể thêm ảnh đại diện nếu cần
      );

      // Lưu thông tin người dùng vào database
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Dừng loader
      PFullScreenLoader.stopLoading();

      // Có thể điều hướng hoặc thông báo thành công ở đây
      PLoaders.successSnackBar(title: 'Đăng ký thành công', message: 'Chào mừng bạn, admin!');
    } catch (e) {
      // Dừng loader nếu có lỗi
      PFullScreenLoader.stopLoading();

      // Hiển thị thông báo lỗi
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }
}
