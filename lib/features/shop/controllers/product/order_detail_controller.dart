import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/user_repository.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  Future<void> getCustomerOfCurrentOrder() async {
    try {
      loading.value = true;
      if (order.value.userId.isEmpty) {
        throw 'User ID is empty';
      }

      print('Fetching user details for userId: ${order.value.userId}');
      final user = await UserRepository.instance.fetchUserDetails(order.value.userId);

      customer.value = user;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Ôi không!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

}