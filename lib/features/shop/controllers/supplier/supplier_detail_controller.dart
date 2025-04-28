import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/utils/formatters/formatter.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../../../data/repositories/supplier_repository.dart';
import '../../models/supplier_product_model.dart';
import '../../models/supplier_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierDetailController extends GetxController {
  static SupplierDetailController get instance => Get.find();

  Rx<SupplierModel?> supplier = Rx<SupplierModel?>(null);
  RxBool isLoading = true.obs;
  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;
  final searchTextController = TextEditingController();

  RxList<SupplierProductModel> allSupplierProducts = <SupplierProductModel>[].obs;
  RxList<SupplierProductModel> filteredSupplierProducts = <SupplierProductModel>[].obs;
  RxBool productsLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (supplier.value != null) {
      filteredSupplierProducts.assignAll(supplier.value!.products);
    }
  }

  void setSupplier(SupplierModel newSupplier) {
    supplier.value = newSupplier;
    allSupplierProducts.assignAll(newSupplier.products);
    filteredSupplierProducts.assignAll(newSupplier.products);
    update();
  }

  Future<void> reloadSupplierFromFirestore(String supplierId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Suppliers')
          .doc(supplierId)
          .get();

      if (snapshot.exists) {
        final updatedSupplier = SupplierModel.fromSnapshot(snapshot);
        setSupplier(updatedSupplier);
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi khi load lại', message: e.toString());
    }
  }

  void searchProductQuery(String query) {
    if (supplier.value == null) return;

    final matched = allSupplierProducts.where((e) =>
        e.product.title.toLowerCase().contains(query.toLowerCase())).toList();

    filteredSupplierProducts.assignAll(matched);
    update();
  }

  void sortByName(int columnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredSupplierProducts.sort((a, b) {
      final aTitle = a.product.title.toLowerCase();
      final bTitle = b.product.title.toLowerCase();
      return ascending ? aTitle.compareTo(bTitle) : bTitle.compareTo(aTitle);
    });

    sortColumnIndex.value = columnIndex;
    update();
  }

  void sortByQuantity(int columnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredSupplierProducts.sort((a, b) =>
    ascending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));

    sortColumnIndex.value = columnIndex;
    update();
  }

  String get formattedDate {
    if (supplier.value == null) return '';
    return PFormatter.formatDate(supplier.value!.createdAt);
  }

  String get formattedTotalAmount {
    if (supplier.value == null) return '';

    final totalAmount = supplier.value!.products.fold<double>(
      0.0,
          (sum, item) => sum + item.total,
    );

    return PFormatter.formatCurrencyRange(totalAmount.toStringAsFixed(0));
  }

  Future<void> getSupplierProducts(String supplierId) async {
    try {
      productsLoading.value = true;
      final products = await SupplierRepository.instance.fetchSupplierProducts(supplierId);
      allSupplierProducts.assignAll(products);
      filteredSupplierProducts.assignAll(products);
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      productsLoading.value = false;
      update();
    }
  }
}
