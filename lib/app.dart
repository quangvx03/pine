import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/routes/app_routes.dart';
import 'package:pine_admin_panel/routes/routes.dart';

import 'bindings/general_bindings.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: PTexts.appName,
      themeMode: ThemeMode.light,
      theme: PAppTheme.lightTheme,
      darkTheme: PAppTheme.darkTheme,
      getPages: PAppRoute.pages,
      initialBinding: GeneralBindings(),
      initialRoute: PRoutes.dashboard,
      unknownRoute: GetPage(name: '/page-not-found', page: () => const Scaffold(body: Center(child: Text('Page Not Found')))),
    );
  }
}

