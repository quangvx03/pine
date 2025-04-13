import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class CategoryRows extends DataTableSource {
  final controller = CategoryController.instance;
  @override
  DataRow? getRow(int index) {
    final category = controller.filteredItems[index];
    final parentCategory = controller.allItems.firstWhereOrNull((item) => item.id == category.parentId);
    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              PRoundedImage(
                width: 50,
                  height: 50,
                  padding: PSizes.sm,
                  image: category.image,
                  imageType: ImageType.network,
                borderRadius: PSizes.borderRadiusMd,
                backgroundColor: PColors.primaryBackground,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Expanded(
                  child: Text(
                      category.name,
                    style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
              ),
              )
            ],
          )
        ),

        DataCell(Text(parentCategory != null ? parentCategory.name : '')),
        DataCell(category.isFeatured ? const Icon(Iconsax.star1, color: PColors.primary) : const Icon(Iconsax.star)),
        DataCell(Text(category.createdAt == null ? '' : category.formattedDate)),
        DataCell(
          PTableActionButtons(
            onEditPressed: () => Get.toNamed(PRoutes.editCategory, arguments: category),
            onDeletePressed: () => controller.confirmAndDeleteItem(category),
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
