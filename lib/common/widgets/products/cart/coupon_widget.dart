import 'package:flutter/material.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class PCouponCode extends StatelessWidget {
  const PCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return PRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? PColors.dark : PColors.white,
      padding: const EdgeInsets.only(
          top: PSizes.sm, bottom: PSizes.sm, right: PSizes.sm, left: PSizes.md),
      child: Row(
        children: [
          /// TextField
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Nhập mã giảm giá của bạn',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),

          /// Button
          SizedBox(
              width: 80,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: dark
                        ? PColors.white.withValues(alpha: 0.5)
                        : PColors.dark.withValues(alpha: 0.5),
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                  ),
                  child: const Text('Áp dụng')))
        ],
      ),
    );
  }
}
