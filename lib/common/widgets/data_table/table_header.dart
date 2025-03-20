import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class PTableHeader extends StatelessWidget {
  const PTableHeader({
    super.key,
    this.onPressed,
    this.buttonText = 'Thêm',
    this.searchController,
    this.searchOnChanged,
    this.showLeftWidget = true,
  });

  final Function()? onPressed;
  final String buttonText;

  final bool showLeftWidget;
  final TextEditingController? searchController;
  final Function(String)? searchOnChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: PDeviceUtils.isDesktopScreen(context) ? 3 : 1,
            child: showLeftWidget
            ? Row(
              children: [
                SizedBox(
                    width: 200,
                    child: ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
                ),
              ],
            )
        : const SizedBox.shrink()),

        Expanded(
          flex: PDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: searchController,
            onChanged: searchOnChanged,
            decoration: const InputDecoration(hintText: 'Tìm kiếm...', prefixIcon: Icon(Iconsax.search_normal)),
          ),
        )
      ],
    );
  }
}
