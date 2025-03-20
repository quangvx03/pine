import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class BrandRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(
            Row(
              children: [
                PRoundedImage(
                  width: 50,
                  height: 50,
                  padding: PSizes.sm,
                  image: PImages.lightAppLogo,
                  imageType: ImageType.asset,
                  borderRadius: PSizes.borderRadiusMd,
                  backgroundColor: PColors.primaryBackground,
                ),
                const SizedBox(width: PSizes.spaceBtwItems),
                Expanded(
                  child: Text(
                    'Coca Cola',
                    style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
        ),

        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: PSizes.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: PSizes.xs,
                direction: PDeviceUtils.isMobileScreen(Get.context!) ? Axis.vertical : Axis.horizontal,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: PDeviceUtils.isMobileScreen(Get.context!) ? 0 : PSizes.xs),
                    child: const Chip(label: Text('Đồ uống'), padding: EdgeInsets.all(PSizes.xs)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: PDeviceUtils.isMobileScreen(Get.context!) ? 0 : PSizes.xs),
                    child: const Chip(label: Text('Đông lạnh'), padding: EdgeInsets.all(PSizes.xs)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: PDeviceUtils.isMobileScreen(Get.context!) ? 0 : PSizes.xs),
                    child: const Chip(label: Text('Rau củ'), padding: EdgeInsets.all(PSizes.xs)),
                  ),
                ],
              ),
            ),
          )
        ),
        const DataCell(Icon(Iconsax.heart5, color: PColors.primary)),
        DataCell(Text(DateTime.now().toString())),
        DataCell(
          PTableActionButtons(
            onEditPressed: () => Get.toNamed(PRoutes.editBrand, arguments: ''),
            onDeletePressed: (){},
          )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 20;

  @override
  int get selectedRowCount => 0;
}
