import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class BrandRows extends DataTableSource {
  final controller = BrandController.instance;

  @override
  DataRow? getRow(int index) {
    final brand = controller.filteredItems[index];
    return DataRow2(
      cells: [
        DataCell(
            Row(
              children: [
                PRoundedImage(
                  width: 50,
                  height: 50,
                  padding: PSizes.sm,
                  image: brand.image,
                  imageType: ImageType.network,
                  borderRadius: PSizes.borderRadiusMd,
                  backgroundColor: PColors.primaryBackground,
                ),
                const SizedBox(width: PSizes.spaceBtwItems),
                Expanded(
                  child: Text(
                    brand.name,
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
                children: brand.brandCategories != null
                ? brand.brandCategories!
                .map(
                      (e) => Padding(
                      padding: EdgeInsets.only(bottom: PDeviceUtils.isMobileScreen(Get.context!) ? 0 : PSizes.xs),
                    child: Chip(label: Text(e.name), padding: EdgeInsets.all(PSizes.xs)),
                  ),
                )
                  .toList()
              : [const SizedBox()],
              ),
              )
            ),
          ),

        DataCell(brand.isFeatured ? const Icon(Icons.star_rounded, color: PColors.primary) : const Icon(Icons.star_border_rounded)),
        DataCell(Text('${brand.productsCount ?? 0}')),
        DataCell(Text(brand.createdAt != null ? brand.formattedDate : '')),
        DataCell(
          PTableActionButtons(
            onEditPressed: () => Get.toNamed(PRoutes.editBrand, arguments: brand),
            onDeletePressed: () => controller.confirmAndDeleteItem(brand),
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
