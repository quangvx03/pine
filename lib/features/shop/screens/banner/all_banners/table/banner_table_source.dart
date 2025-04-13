import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class BannersRows extends DataTableSource {
  final controller = BannerController.instance;
  
  @override
  DataRow? getRow(int index) {
    final banner = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(PRoutes.editBanner, arguments: banner),
      cells: [
        DataCell(
          PRoundedImage(
            width: 180,
            height: 100,
            padding: PSizes.sm,
            image: banner.imageUrl,
            imageType: ImageType.network,
            borderRadius: PSizes.borderRadiusMd,
            backgroundColor: PColors.primaryBackground,
          ),
        ),
        DataCell(Text(controller.formatRoute(banner.targetScreen))),
        DataCell(banner.active ? const Icon(Iconsax.eye, color: PColors.primary) : const Icon(Iconsax.eye_slash)),
        DataCell(
            PTableActionButtons(
              onEditPressed: () => Get.toNamed(PRoutes.editBanner, arguments: banner),
              onDeletePressed: () => controller.confirmAndDeleteItem(banner),
            )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => 0;
}
