import 'package:get/get.dart';
import 'package:pine/features/authentication/screens/login/login.dart';
import 'package:pine/features/authentication/screens/onboarding/onboarding.dart';
import 'package:pine/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:pine/features/authentication/screens/signup/signup.dart';
import 'package:pine/features/authentication/screens/signup/verify_email.dart';
import 'package:pine/features/personalization/screens/address/address.dart';
import 'package:pine/features/personalization/screens/coupon/coupons.dart';
import 'package:pine/features/personalization/screens/privacy/privacy_policy.dart';
import 'package:pine/features/personalization/screens/profile/profile.dart';
import 'package:pine/features/shop/screens/cart/cart.dart';
import 'package:pine/features/shop/screens/category/sub_categories.dart';
import 'package:pine/features/shop/screens/checkout/checkout.dart';
import 'package:pine/features/shop/screens/order/order.dart';
import 'package:pine/features/shop/screens/wishlist/wishlist.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/routes/routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(
        name: PRoutes.home,
        page: () {
          final controller = Get.put(NavigationController());
          controller.navigateToHome();
          return const NavigationMenu();
        }),
    GetPage(
        name: PRoutes.store,
        page: () {
          final controller = Get.put(NavigationController());
          controller.navigateToStore();
          return const NavigationMenu();
        }),
    GetPage(
        name: PRoutes.search,
        page: () {
          final controller = Get.put(NavigationController());
          controller.navigateToSearch();
          return const NavigationMenu();
        }),
    GetPage(
        name: PRoutes.settings,
        page: () {
          final controller = Get.put(NavigationController());
          controller.navigateToAccount();
          return const NavigationMenu();
        }),
    GetPage(name: PRoutes.order, page: () => const OrderScreen()),
    GetPage(name: PRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: PRoutes.cart, page: () => const CartScreen()),
    GetPage(name: PRoutes.favorites, page: () => const FavoriteScreen()),
    GetPage(name: PRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: PRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: PRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: PRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: PRoutes.signIn, page: () => const LoginScreen()),
    GetPage(
        name: PRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: PRoutes.onBoarding, page: () => const OnBoardingScreen()),
    GetPage(name: PRoutes.coupon, page: () => const UserCouponsScreen()),
    GetPage(name: PRoutes.privacy, page: () => const PrivacyPolicyScreen()),
  ];
}
