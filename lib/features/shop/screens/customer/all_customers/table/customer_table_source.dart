import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class CustomerRows extends DataTableSource {
  final controller = CustomerController.instance;
  
  @override
  DataRow? getRow(int index) {
    final customer = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(PRoutes.customerDetails, arguments: customer, parameters: {'customerId': customer.id ?? ''}),
      cells: [
        DataCell(
          Row(
            children: [
              PRoundedImage(
                width: 50,
                  height: 50,
                  padding: PSizes.sm,
                  image: customer.profilePicture,
                  imageType: ImageType.network,
                borderRadius: PSizes.borderRadiusMd,
                backgroundColor: PColors.primaryBackground,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Expanded(
                  child: Text(
                      customer.fullName,
                    style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
              ),
              )
            ],
          )
        ),

        DataCell(Text(customer.email)),
        DataCell(Text(customer.phoneNumber)),
        DataCell(Text(customer.createdAt == null ? '' : customer.formattedDate)),
        DataCell(
          PTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(PRoutes.customerDetails, arguments: customer, parameters: {'customerId': customer.id ?? ''}),
            onDeletePressed: () => controller.confirmAndDeleteItem(customer),
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
