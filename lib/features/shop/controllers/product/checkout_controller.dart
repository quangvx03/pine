

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/models/payment_method_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../screens/checkout/payment_tile.dart';

class CheckoutController extends GetxController{
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(image: PImages.cod, name: 'Thanh toán khi nhận hàng');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context){
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(PSizes.lg),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PSectionHeading(title: 'Chọn phương thức thanh toán', showActionButton: false),
              const SizedBox(height: PSizes.spaceBtwSections),
              PPaymentTile(paymentMethod: PaymentMethodModel(name: 'Thanh toán khi nhận hàng', image: PImages.cod)),
              const SizedBox(height: PSizes.spaceBtwItems/2),
              PPaymentTile(paymentMethod: PaymentMethodModel(name: 'Thẻ ngân hàng', image: PImages.card)),
              const SizedBox(height: PSizes.spaceBtwItems/2),
            ],
          ),
        ),
      )
    );
  }
}