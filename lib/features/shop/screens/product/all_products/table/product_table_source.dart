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
    controller.updateProductStock(product);
    Color stockColor;
    if (product.stock == 0) {
      stockColor = Colors.red; // Màu đỏ cho hết hàng
    } else if (product.stock <= 5) {
      stockColor = Colors.orange; // Màu cam cho sản phẩm gần hết hàng
    } else {
      stockColor = Colors.black; // Màu đen cho sản phẩm còn nhiều
    }

    return DataRow2(
      onTap: () {
        Get.toNamed(PRoutes.editProduct, arguments: product);
      },
      cells: [
        // Image and Title Cell
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
                      .apply(color: PColors.primary)),
            ),
          ],
        )),

        // Stock Cell
        DataCell(
          Text(
            '${product.stock ?? 0}',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyMedium!
                .apply(color: stockColor), // Áp dụng màu sắc cho Stock
          ),
        ),

        // Sold Quantity Cell
        DataCell(Text(
          '${product.soldQuantity ?? 0}',
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        )),

        // Brand Name Cell
        DataCell(Text(
          product.brand != null ? product.brand!.name : '',
          style: Theme.of(Get.context!)
              .textTheme
              .bodyLarge!
              .apply(color: PColors.primary),
        )),

        // Price Cell
        DataCell(Text(product.formattedCurrency)),

        // Featured Icon Cell (tắt nếu hết hàng)
        DataCell(
          product.isFeatured
              ? const Icon(Iconsax.eye, color: PColors.primary)
              : const Icon(Iconsax.eye_slash),
        ),

        // Date Cell
        DataCell(Text(product.date == null ? '' : product.formattedDate)),

        // Action Buttons (Edit & Delete)
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
