import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../../../personalization/models/address_model.dart';

class PBillingAddressSection extends StatelessWidget {
  const PBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PSectionHeading(
            title: 'Địa chỉ nhận hàng',
            buttonTitle: 'Thay đổi',
            onPressed: () => addressController.selectNewAddressPopup(context)),
        Obx(() {
          final AddressModel selectedAddress =
              addressController.selectedAddress.value;

          if (selectedAddress.id.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedAddress.name,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: PSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.grey, size: 16),
                    const SizedBox(width: PSizes.spaceBtwItems),
                    Text(selectedAddress.phoneNumber,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    const Icon(Icons.location_city_rounded,
                        color: Colors.grey, size: 16),
                    const SizedBox(width: PSizes.spaceBtwItems),
                    Expanded(
                        child: Text(
                            '${selectedAddress.street}, ${selectedAddress.ward}, ${selectedAddress.city}, ${selectedAddress.province}',
                            style: Theme.of(context).textTheme.bodyMedium,
                            softWrap: true))
                  ],
                )
              ],
            );
          } else {
            return Text(
              'Chọn địa chỉ',
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }
        })
      ],
    );
  }
}
