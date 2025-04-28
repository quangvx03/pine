import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/supplier/supplier_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';
import 'package:pine_admin_panel/utils/helpers/pdf_invoice_generator.dart';
import 'package:printing/printing.dart';

import '../../../../data/repositories/supplier_repository.dart';
import '../../models/supplier_model.dart';
import '../../models/supplier_product_model.dart';

class CreateSupplierController extends GetxController {
  static CreateSupplierController get instance => Get.find();

  final SupplierRepository repository = Get.put(SupplierRepository());

  final loading = false.obs;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final RxList<SupplierProductModel> productList = <SupplierProductModel>[].obs;
  final totalAmount = 0.0.obs;
  final totalQuantity = 0.obs;

  void addProduct(ProductModel product, int quantity, double price) {
    productList.add(SupplierProductModel(product: product, quantity: quantity, price: price));
    _calculateTotal();
  }

  void removeProduct(int index) {
    productList.removeAt(index);
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0;
    int qty = 0;

    for (var item in productList) {
      total += item.total;
      qty += item.quantity;
    }

    totalAmount.value = total;
    totalQuantity.value = qty;
  }

  SupplierModel getSupplierModel() {
    return SupplierModel(
      id: '',
      name: name.text.trim(),
      phone: phone.text.trim(),
      address: address.text.trim(),
      products: productList,
      quantity: totalQuantity.value,
      totalAmount: totalAmount.value,
      createdAt: DateTime.now(),
    );
  }

  Future<void> createPurchaseOrder() async {
    try {
      PFullScreenLoader.popUpCircular();
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(title: 'Mất kết nối', message: 'Vui lòng kiểm tra kết nối mạng.');
        return;
      }

      if (!formKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (productList.isEmpty) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(title: 'Thiếu sản phẩm', message: 'Vui lòng thêm ít nhất 1 sản phẩm.');
        return;
      }

      final newRecord = getSupplierModel();

      newRecord.id = await SupplierRepository.instance.createPurchaseOrder(newRecord);
      SupplierController.instance.addItemToLists(newRecord);

      await exportInvoice();

      resetFields();
      PFullScreenLoader.stopLoading();

      PLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đơn nhập hàng đã được tạo và hóa đơn PDF đã được xuất.',
      );
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  Future<void> exportInvoice() async {
    try {
      final supplier = getSupplierModel();
      final pdfData = await PDFInvoiceGenerator.generateSupplierInvoice(supplier);
      await Printing.sharePdf(bytes: pdfData, filename: 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf');
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi xuất PDF', message: e.toString());
    }
  }

  void resetFields() {
    name.clear();
    phone.clear();
    address.clear();
    productList.clear();
    totalAmount.value = 0;
    totalQuantity.value = 0;
  }
}
