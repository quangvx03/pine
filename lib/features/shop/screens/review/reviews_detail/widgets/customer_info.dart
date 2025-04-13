import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/order_detail_controller.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../utils/constants/colors.dart';


class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    controller.order.value = order;
    controller.getCustomerOfCurrentOrder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Info
        PRoundedContainer(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Khách hàng', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),
              Obx(
                () {
                  return Row(
                    children: [
                      PRoundedImage(
                        padding: 0,
                        backgroundColor: PColors.primaryBackground,
                        image: controller.customer.value.profilePicture.isNotEmpty ? controller.customer.value.profilePicture : PImages.user,
                        imageType: controller.customer.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                      ),
                      const SizedBox(width: PSizes.spaceBtwItems),
                      Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.customer.value.fullName, style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              Text(controller.customer.value.email,
                                  overflow: TextOverflow.ellipsis, maxLines: 1),
                            ],
                          )
                      )
                    ],
                  );
                }
              )
            ],
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),

        // Contact Info
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: PRoundedContainer(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thông tin liên hệ', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: PSizes.spaceBtwSections),
                  Text(controller.customer.value.fullName, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: PSizes.spaceBtwSections / 2),
                  Text(controller.customer.value.email, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: PSizes.spaceBtwSections / 2),
                  Text(controller.customer.value.formattedPhoneNo.isNotEmpty
                      ? '${controller.customer.value.formattedPhoneNo.substring(0, 3)} *** ****'
                      : 'Không có số điện thoại',
                      style: Theme.of(context).textTheme.titleSmall),

                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),

        // Contact Info
        SizedBox(
          width: double.infinity,
          child: PRoundedContainer(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Địa chỉ giao hàng', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: PSizes.spaceBtwSections),
                Text(order.address != null ? order.address!.name : '', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: PSizes.spaceBtwSections / 2),
                Text(order.address != null ? order.address!.toString() : '', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
      ],
    );
  }
}
