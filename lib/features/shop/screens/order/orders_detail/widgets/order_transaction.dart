import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/p_rounded_image.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class OrderTransaction extends StatelessWidget {
  const OrderTransaction({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giao dịch', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Adjust as per your needs
          Row(
            children: [
              Expanded(
                  flex: PDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Row(
                    children: [
                      const PRoundedImage(
                          imageType: ImageType.asset, image: PImages.googlePay),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${order.paymentMethod.capitalize}',
                              style: Theme.of(context).textTheme.titleLarge),
                          // Adjust your Payment Method Fee if any
                          Text('${order.paymentMethod.capitalize}',
                              style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ))
                    ],
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ngày', style: Theme.of(context).textTheme.labelMedium),
                  Text('12/3/2025',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng', style: Theme.of(context).textTheme.labelMedium),
                  Text('${order.totalAmount}đ',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              )),
            ],
          )
        ],
      ),
    );
  }
}
