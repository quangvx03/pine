import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/data/repositories/review_repository.dart';
import 'package:pine/features/personalization/screens/settings/settings.dart';
import 'package:pine/features/shop/controllers/search_controller.dart';
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

    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.navigateToHome();
          return false;
        } else {
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
  DateTime? _lastBackPressTime;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    () {
      if (!Get.isRegistered<ProductRepository>()) {
        Get.put(ProductRepository(), permanent: true);
      }

      if (!Get.isRegistered<ReviewRepository>()) {
        Get.put(ReviewRepository(), permanent: true);
      }

      if (Get.isRegistered<ProductSearchController>()) {
        final controller = Get.find<ProductSearchController>();
        controller.resetAll();
      } else {
        Get.put(ProductSearchController(), permanent: true);
      }
      return const SearchScreen();
    }(),
    const SettingsScreen(),
  ];

  void navigateToTab(int index) {
    if (selectedIndex.value == 2 && index != 2) {
      if (Get.isRegistered<ProductSearchController>()) {
        final searchController = Get.find<ProductSearchController>();
        searchController.resetAll();
      }
    }

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
