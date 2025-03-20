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

import '../../../../models/product_model.dart';

class ProductsRows extends DataTableSource {
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
                  padding: PSizes.xs,
                  image: PImages.banner1,
                  imageType: ImageType.asset,
                borderRadius: PSizes.borderRadiusMd,
                backgroundColor: PColors.primaryBackground,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Flexible(child: Text('Tiêu đề sản phẩm', style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary))),
            ],
          )
        ),
        const DataCell(Text('256')),

        // Brand
        DataCell(
          Row(
            children: [
              const PRoundedImage(
                width: 35,
                  height: 35,
                  padding: PSizes.xs,
                  image: PImages.lightAppLogo,
                  imageType: ImageType.asset,
                borderRadius: PSizes.borderRadiusMd,
                backgroundColor: PColors.primaryBackground,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Flexible(child: Text('Coca Cola', style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary))),
            ],
          )
        ),
        const DataCell(Text('150,000đ')),

        DataCell(Text(DateTime.now().toString())),

        DataCell(
          PTableActionButtons(
            onEditPressed: () => Get.toNamed(PRoutes.editProduct, arguments: ProductModel.empty()),
            onDeletePressed: (){},
          )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 100;

  @override
  int get selectedRowCount => 0;
}
