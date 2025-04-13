import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_desktop.dart';

import '../../../models/product_model.dart';



class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    final product = Get.arguments;
    if (product == null || product is! ProductModel) {
      return Scaffold(
        body: Center(child: Text("Lỗi: Không tìm thấy sản phẩm")),
      );
    }
    Future.microtask(() => controller.initProductData(product));

    return PSiteTemplate(desktop: EditProductDesktopScreen(product: product));
  }
}
