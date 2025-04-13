import 'dart:io';
import 'package:url_launcher/link.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/sidebars/sidebar_controller.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PMenuItem extends StatelessWidget {
  const PMenuItem({
    super.key,
    required this.route,
    required this.icon,
    required this.itemName,
  });

  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());
    return InkWell(
        onTap: () => menuController.menuOnTap(route),
        onHover: (value) => value ? menuController.changeHoverItem(route) : menuController.changeHoverItem(''),
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: PSizes.xs),
            child: Container(
              decoration: BoxDecoration(
                color: menuController.isHovering(route) || menuController.isActive(route)
                    ? PColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(PSizes.cardRadiusMd),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Padding(
                    padding: const EdgeInsets.only(left: PSizes.lg, top: PSizes.md, bottom: PSizes.md, right: PSizes.md),
                    child: menuController.isActive(route)
                        ? Icon(icon, size: 22, color: PColors.white)
                        : Icon(icon, size: 22, color: menuController.isHovering(route) ? PColors.white : PColors.darkGrey),
                  ),

                  // Text
                  if (menuController.isHovering(route) || menuController.isActive(route))
                    Flexible(child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: PColors.white)))
                  else
                    Flexible(child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: PColors.darkGrey))),
                ],
              ),
            ),
          );
        }
        ),
      );
  }
}