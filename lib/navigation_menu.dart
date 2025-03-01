import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/personalization/screens/settings/settings.dart';
import 'package:pine/features/shop/screens/home/home.dart';
import 'package:pine/features/shop/screens/store/store.dart';
import 'package:pine/features/shop/screens/wishlist/wishlist.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = PHelperFunctions.isDarkMode(context);

    return Scaffold(
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
                  icon: Icon(Iconsax.heart_circle), label: 'Yêu thích'),
              NavigationDestination(
                  icon: Icon(Iconsax.user_octagon), label: 'Tài khoản'),
            ]),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const FavoriteScreen(),
    const SettingsScreen(),
  ];
}
