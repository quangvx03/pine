import 'package:get/get.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/shop/controllers/product/checkout_controller.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart';
import 'package:pine/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(AddressController());
    Get.put(CheckoutController());
  }
}
