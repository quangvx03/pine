import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/images/p_rounded_image.dart';
import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/constants/sizes.dart';


class OrderTransaction extends StatelessWidget {
  const OrderTransaction({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0);

    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giao dịch', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),

          Row(
            children: [
              Expanded(
                flex: PDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Row(
                  children: [
                    const PRoundedImage(
                      imageType: ImageType.asset,
                      image: PImages.cashOnDelivery,
                    ),
                    const SizedBox(width: PSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.paymentMethod.capitalize ?? 'Không xác định',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            order.paymentMethod.capitalize ?? '',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ngày giao hàng', style: Theme.of(context).textTheme.labelMedium),
                    Text(order.formattedDeliveryDate, style: Theme.of(context).textTheme.bodyLarge,),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng', style: Theme.of(context).textTheme.labelMedium),
                    Text(
                      currencyFormatter.format(order.totalAmount),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
