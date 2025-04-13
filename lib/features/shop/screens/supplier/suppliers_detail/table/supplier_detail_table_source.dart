import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/features/shop/models/supplier_product_model.dart';

class SupplierProductsRows extends DataTableSource {
  final List<SupplierProductModel> products;
  final currencyFormatter = NumberFormat("#,###", "vi_VN");

  SupplierProductsRows(this.products);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final productData = products[index];

    return DataRow2(
      cells: [
        DataCell(Text(productData.product.title)),
        DataCell(Text(productData.quantity.toString())),
        DataCell(Text('${currencyFormatter.format(productData.price)}đ')),
        DataCell(Text('${currencyFormatter.format(productData.total)}đ')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
