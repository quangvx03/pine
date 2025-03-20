import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/models/banner_model.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class BannersRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(
          PRoundedImage(
            width: 180,
            height: 100,
            padding: PSizes.sm,
            image: PImages.banner1,
            imageType: ImageType.network,
            borderRadius: PSizes.borderRadiusMd,
            backgroundColor: PColors.primaryBackground,
          ),
        ),
        const DataCell(Text('Cửa hàng')),
        const DataCell(Icon(Iconsax.eye, color: PColors.primary)),
        DataCell(
            PTableActionButtons(
              onEditPressed: () => Get.toNamed(PRoutes.editBanner, arguments: BannerModel(imageUrl: '', targetScreen: '', active: false)),
              onDeletePressed: (){},
            )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 10;

  @override
  int get selectedRowCount => 0;
}
