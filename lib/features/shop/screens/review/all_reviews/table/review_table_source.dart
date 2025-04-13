import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/features/shop/controllers/review/review_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/images/p_rounded_image.dart';

class ReviewRows extends DataTableSource {
  final controller = ReviewController.instance;

  @override
  DataRow? getRow(int index) {
    final review = controller.filteredItems[index];

    return DataRow2(
      onTap: () => Get.toNamed(PRoutes.reviewDetails, arguments: review, parameters: {'reviewId': review.id ?? ''}),
      cells: [
        // Khách hàng
        DataCell(Row(
          children: [
            PRoundedImage(
              width: 50,
              height: 50,
              padding: PSizes.sm,
              image: review.profilePicture,
              imageType: ImageType.network,
              borderRadius: PSizes.borderRadiusMd,
              backgroundColor: PColors.primaryBackground,
            ),
            const SizedBox(width: PSizes.spaceBtwItems),
            Expanded(
              child: Text(
                review.username,
                style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        )),


        // Đơn hàng
        DataCell(Text(review.orderId)),
        DataCell(Text(
          review.productTitle ?? 'Không rõ',
          overflow: TextOverflow.ellipsis,
        )),
        DataCell(Row(
          children: List.generate(
            review.rating.toInt(),
                (i) => const Icon(Icons.star, color: Colors.amber, size: 16),
          ),
        )),

        DataCell(Text(
          review.comment,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )),


        DataCell(Text(DateFormat('dd/MM/yyyy – HH:mm').format(review.datetime))),

        // Hành động
        DataCell(
          PTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(PRoutes.reviewDetails, arguments: review),
            onDeletePressed: () {
              controller.confirmAndDeleteItem(review);
              controller.filteredItems.refresh();
            },
          ),
        ),
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

