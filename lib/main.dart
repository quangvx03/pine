import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'data/repositories/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  /// Ràng buộc Widget
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  /// GetX Lưu trữ cục bộ
  await GetStorage.init();

  /// Giữ màn hình Splash cho đến khi các mục khác tải xong
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Khởi tạo Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  /// Tải tất cả Material Design
  runApp(const App());
}
