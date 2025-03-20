import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/user_repository.dart';
import 'package:pine_admin_panel/features/authentication/models/user_model.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  
  // Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  /// Fetches user details from the repository
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();
      this.user.value = user;
      loading.value = false;
      return user;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Đã xảy ra lỗi.', message: e.toString());
      return UserModel.empty();
    }
    
  }
}
