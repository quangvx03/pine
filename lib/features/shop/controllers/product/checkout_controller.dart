import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/models/payment_method_model.dart';
import 'package:pine/utils/constants/image_strings.dart'; // Đảm bảo import PImages
import 'package:pine/utils/constants/sizes.dart';

import '../../screens/checkout/payment_tile.dart'; // Đảm bảo import PPaymentTile

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    // Đặt phương thức mặc định là COD
    selectedPaymentMethod.value = PaymentMethodModel(
        image: PImages.cod, name: 'Thanh toán khi nhận hàng');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(PSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PSectionHeading(
                        title: 'Chọn phương thức thanh toán',
                        showActionButton: false),
                    const SizedBox(height: PSizes.spaceBtwSections),
                    // Thanh toán khi nhận hàng (COD)
                    PPaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Thanh toán khi nhận hàng',
                            image: PImages.cod)), // Giả sử PImages.cod đã có
                    const SizedBox(height: PSizes.spaceBtwItems / 2),

                    // --- THÊM VNPAY ---
                    PPaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'VNPAY', // Tên hiển thị cho người dùng
                            image: PImages
                                .vnpay)), // <-- Thêm logo VNPAY vào PImages
                    const SizedBox(height: PSizes.spaceBtwItems / 2),
                    // --- KẾT THÚC THÊM VNPAY ---

                    // PPaymentTile( // Bỏ comment nếu muốn giữ lại thẻ ngân hàng
                    //     paymentMethod: PaymentMethodModel(
                    //         name: 'Thẻ ngân hàng', image: PImages.card)),
                    // const SizedBox(height: PSizes.spaceBtwItems / 2),
                  ],
                ),
              ),
            ));
  }
}
