import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../utils/constants/colors.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  const PRoundedImage(
                    padding: 0,
                      backgroundColor: PColors.primaryBackground,
                      image: PImages.user,
                      imageType: ImageType.asset,
                  ),
                  const SizedBox(width: PSizes.spaceBtwItems),
                  Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thao', style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 1),
                          const Text('nguyenthao@gmail.com', overflow: TextOverflow.ellipsis, maxLines: 1),
                        ],
                      )
                  )
                ],
              )
            ],
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
                Text('Thông tin liên hệ', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: PSizes.spaceBtwSections),
                Text('Thao', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: PSizes.spaceBtwSections / 2),
                Text('nguyenthao@gmail.com', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: PSizes.spaceBtwSections / 2),
                Text('093 *** ****', style: Theme.of(context).textTheme.titleSmall),
              ],
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
                Text('Thao', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: PSizes.spaceBtwSections / 2),
                Text('1 Phù Đổng Thiên Vương, phường 8, Đà Lạt, Lâm Đồng', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
      ],
    );
  }
}
