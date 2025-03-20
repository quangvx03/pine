import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/authentication/models/user_model.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class CustomerRows extends DataTableSource {
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
                  imageType: ImageType.network,
                borderRadius: PSizes.borderRadiusMd,
                backgroundColor: PColors.primaryBackground,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Expanded(
                  child: Text(
                      'Userpine',
                    style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
              ),
              )
            ],
          )
        ),

        const DataCell(Text('userpine@gmail.com')),
        const DataCell(Text('+84294710294')),
        DataCell(Text(DateTime.now().toString())),
        DataCell(
          PTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(PRoutes.customerDetails, arguments: UserModel.empty()),
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
