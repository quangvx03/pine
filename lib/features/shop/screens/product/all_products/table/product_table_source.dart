import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';


class ProductsRows extends DataTableSource {
  final controller = ProductController.instance;

  @override
  DataRow? getRow(int index) {
    final product = controller.filteredItems[index];
    return DataRow2(
      onTap: () {
        Get.toNamed(PRoutes.editProduct, arguments: product);
      },
      cells: [
        DataCell(Row(
          children: [
            PRoundedImage(
              width: 50,
              height: 50,
              padding: PSizes.xs,
              image: product.thumbnail,
              imageType: ImageType.network,
              borderRadius: PSizes.borderRadiusMd,
              backgroundColor: PColors.primaryBackground,
            ),
            const SizedBox(width: PSizes.spaceBtwItems),
            Flexible(
                child: Text(product.title,
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyLarge!
                        .apply(color: PColors.primary))),
          ],
        )),
        DataCell(
            Obx(() => Text(controller.getUpdatedStock(product).toString()))
        ),
        DataCell(
            Obx(() => Text(controller.getProductSoldQuantity(product).toString()))
        ),

        DataCell(Text(product.brand != null ? product.brand!.name : '',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: PColors.primary))),
        DataCell(Text(product.formattedCurrency)),
        DataCell(product.isFeatured ? const Icon(Iconsax.eye, color: PColors.primary) : const Icon(Iconsax.eye_slash)),
        DataCell(Text(product.date == null ? '' : product.formattedDate)),
        DataCell(PTableActionButtons(
          onEditPressed: () =>
              Get.toNamed(PRoutes.editProduct, arguments: product),
          onDeletePressed: () => controller.confirmAndDeleteItem(product),
        ))
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
