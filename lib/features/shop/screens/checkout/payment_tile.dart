import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/features/shop/controllers/product/checkout_controller.dart';
import 'package:pine/features/shop/models/payment_method_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PPaymentTile extends StatelessWidget {
  const PPaymentTile({super.key, required this.paymentMethod});
  
  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: (){
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      leading: PRoundedContainer(
        width: 60,
        height: 60,
        backgroundColor: PHelperFunctions.isDarkMode(context) ? PColors.light : PColors.white,
        padding: const EdgeInsets.all(PSizes.sm),
        child: Image(image: AssetImage(paymentMethod.image), fit: BoxFit.contain),
      ),
      title: Text(paymentMethod.name),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}
