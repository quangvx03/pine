import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class SidebarController extends GetxController {
  final box = GetStorage();
  final activeItem = "".obs;
  final hoverItem = ''.obs;

  @override
  void onInit() {
    super.onInit();
    activeItem.value = box.read("activeItem") ?? PRoutes.dashboard; // Đọc giá trị từ bộ nhớ
  }

  void changeActiveItem(String route) {
    activeItem.value = route;
    box.write("activeItem", route); // Lưu giá trị vào bộ nhớ
  }

  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (!isActive(route)) {
      changeActiveItem(route);

      if (PDeviceUtils.isMobileScreen(Get.context!)) Get.back();

      Get.toNamed(route);
    }
  }
}
