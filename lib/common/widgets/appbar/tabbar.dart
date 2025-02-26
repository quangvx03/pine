import 'package:flutter/material.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/device/device_utility.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark  = PHelperFunctions.isDarkMode(context);

    return Material(
      color: dark ? PColors.black : PColors.white,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: PColors.primary,
        labelColor: dark ? PColors.white : PColors.primary,
        unselectedLabelColor: PColors.darkGrey,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(PDeviceUtils.getAppBarHeight());
}
