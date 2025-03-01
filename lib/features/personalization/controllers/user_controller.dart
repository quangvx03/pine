import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/user_repository.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // Convert Name to First and Last Name
        final nameParts =
            UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final username =
            UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map Data
        final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: username,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '');

        //   Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      PLoaders.warningSnackBar(
          title: 'Dữ liệu chưa được lưu',
          message:
              'Có gì đó không ổn trong khi lưu thông tin của bạn. Bạn có thể lưu lại dữ liệu của mình trong hồ sơ của mình');
    }
  }
}
