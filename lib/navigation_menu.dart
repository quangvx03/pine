import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/personalization/screens/settings/settings.dart';
import 'package:pine/features/shop/screens/home/home.dart';
import 'package:pine/features/shop/screens/search/search.dart';
import 'package:pine/features/shop/screens/store/store.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/popups/loaders.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = PHelperFunctions.isDarkMode(context);

    // Sử dụng WillPopScope để bắt sự kiện nút back
    return WillPopScope(
      onWillPop: () async {
        // Nếu không phải đang ở Home, chuyển về Home
        if (controller.selectedIndex.value != 0) {
          controller.navigateToHome();
          return false; // Không thoát ứng dụng
        } else {
          // Xử lý nhấn back hai lần để thoát
          return controller.handleBackButtonPress();
        }
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
              height: 60,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) =>
                  controller.selectedIndex.value = index,
              backgroundColor: darkMode ? PColors.black : PColors.white,
              indicatorColor: darkMode
                  ? PColors.white.withValues(alpha: 0.1)
                  : PColors.primary.withValues(alpha: 0.1),
              destinations: const [
                NavigationDestination(
                    icon: Icon(
                      Iconsax.home_1,
                    ),
                    label: 'Trang chủ'),
                NavigationDestination(
                    icon: Icon(Iconsax.shop), label: 'Cửa hàng'),
                NavigationDestination(
                    icon: Icon(Iconsax.search_normal), label: 'Tìm kiếm'),
                NavigationDestination(
                    icon: Icon(Iconsax.user_octagon), label: 'Tài khoản'),
              ]),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  final Rx<int> selectedIndex = 0.obs;
  // Theo dõi thời gian nhấn back lần cuối
  DateTime? _lastBackPressTime;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  void navigateToTab(int index) {
    selectedIndex.value = index;
    if (Get.currentRoute != '/NavigationMenu') {
      Get.offAll(() => const NavigationMenu());
    }
  }

  void navigateToHome() => navigateToTab(0);
  void navigateToStore() => navigateToTab(1);
  void navigateToSearch() => navigateToTab(2);
  void navigateToAccount() => navigateToTab(3);

  // Xử lý nút back
  Future<bool> handleBackButtonPress() async {
    if (selectedIndex.value != 0) {
      navigateToHome();
      return false;
    }

    final now = DateTime.now();

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) >
            const Duration(milliseconds: 1500)) {
      _lastBackPressTime = now;
      PLoaders.customToast(message: 'Nhấn lần nữa để thoát ứng dụng');
      return false;
    }

    return true;
  }
}
