import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../controllers/supplier/supplier_detail_controller.dart';
import '../../../../models/supplier_model.dart';

class SupplierInfo extends StatelessWidget {
  const SupplierInfo({super.key, required this.supplier});

  final SupplierModel supplier;

  @override
  Widget build(BuildContext context) {
    final controller = SupplierDetailController.instance;

    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin nhà cung cấp',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),

          Row(
            children: [
              const SizedBox(width: 120, child: Text('Tên nhà cung cấp')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(supplier.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1))
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),

          Row(
            children: [
              const SizedBox(width: 120, child: Text('Địa chỉ')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(supplier.address ?? 'Chưa có',
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Số điện thoại')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(supplier.phone,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwSections),
          const Divider(),
          const SizedBox(height: PSizes.spaceBtwItems),

          Row(
            children: [
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tổng giá trị nhập hàng',
                          style: Theme.of(context).textTheme.titleLarge),
                      Obx(() => Text(controller.formattedTotalAmount,
                          style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                  )),
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày tạo',
                          style: Theme.of(context).textTheme.titleLarge),
                      Obx(() => Text(controller.formattedDate,
                          style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
