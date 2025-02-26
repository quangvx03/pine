import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/authentication/screens/onboarding/onboarding.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: PAppTheme.lightTheme,
      darkTheme: PAppTheme.darkTheme,
      home: const Scaffold(
        backgroundColor: PColors.primary,
        body: Center(
          child: CircularProgressIndicator(
            color: PColors.white,
          ),
        ),
      ),
    );
  }
}
