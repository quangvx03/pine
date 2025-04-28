import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/formatters/formatter.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../controllers/supplier/create_supplier_controller.dart';
import '../../../../models/product_model.dart';

class CreateSupplierForm extends StatelessWidget {
  const CreateSupplierForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateSupplierController());
    final productNameController = TextEditingController();
    final productQtyController = TextEditingController();
    final productPriceController = TextEditingController();

    return PRoundedContainer(
      width: 900,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tạo đơn nhập hàng', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),

            TextFormField(
              controller: createController.name,
              validator: (value) => PValidator.validateEmptyText('Tên nhà cung cấp', value),
              decoration: const InputDecoration(
                labelText: 'Tên nhà cung cấp',
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),

            TextFormField(
              controller: createController.address,
              validator: (value) => PValidator.validateEmptyText('Địa chỉ', value),
              decoration: const InputDecoration(
                labelText: 'Địa chỉ nhà cung cấp',
                prefixIcon: Icon(Iconsax.location),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),

            TextFormField(
              controller: createController.phone,
              validator: (value) => PValidator.validatePhoneNumber(value),
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                prefixIcon: Icon(Iconsax.call),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: PSizes.spaceBtwSections),

            Text('Sản phẩm', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: PSizes.sm),

            Padding(
              padding: const EdgeInsets.only(bottom: PSizes.sm),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: productNameController,
                      decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: productQtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Số lượng'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: productPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Đơn giá'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.add_circle, color: Colors.green),
                    onPressed: () {
                      final name = productNameController.text.trim();
                      final qty = int.tryParse(productQtyController.text) ?? 0;
                      final price = double.tryParse(productPriceController.text) ?? 0;

                      if (name.isEmpty || qty <= 0 || price <= 0) return;

                      final product = ProductModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: name,
                        thumbnail: '',
                        price: price,
                        stock: qty,
                        productType: 'single',
                        isFeatured: false,
                      );

                      createController.addProduct(product, qty, price);

                      // Clear inputs
                      productNameController.clear();
                      productQtyController.clear();
                      productPriceController.clear();
                    },
                  ),
                ],
              ),
            ),

            Obx(() => Column(
              children: List.generate(createController.productList.length, (index) {
                final item = createController.productList[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: PSizes.sm),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(item.product.title),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text('${item.quantity}'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text('${item.price}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => createController.removeProduct(index),
                      )
                    ],
                  ),
                );
              }),
            )),

            const SizedBox(height: PSizes.spaceBtwSections),

            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng tiền:', style: TextStyle(fontSize: 18)),
                Text(
                  PFormatter.formatCurrency(createController.totalAmount.value),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            )),

            const SizedBox(height: PSizes.spaceBtwSections),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => createController.createPurchaseOrder(),
                    icon: const Icon(Iconsax.document), // optional icon
                    label: const Text('Tạo đơn'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
                const SizedBox(width: PSizes.spaceBtwInputFields),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => createController.exportInvoice(),
                    icon: const Icon(Iconsax.export),
                    label: const Text('Xuất hóa đơn'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
