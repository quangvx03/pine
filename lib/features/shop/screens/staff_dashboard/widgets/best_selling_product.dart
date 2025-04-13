import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';

class BestSellingProductsTable extends StatelessWidget {
  const BestSellingProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    // Tính toán danh sách sản phẩm và số lượng đã bán
    final topProducts = controller.productController.allItems
        .map((product) => {
      'product': product,
      'sold': controller.productController.getProductSoldQuantity(product),
    })
        .where((entry) => (entry['sold'] as int) > 0)
        .toList()
      ..sort((a, b) => (b['sold'] as int).compareTo(a['sold'] as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sản phẩm bán chạy nhất', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        if (topProducts.isEmpty)
          const Text('Không có dữ liệu sản phẩm bán chạy.')
        else
          DataTable(
            columns: const [
              DataColumn(label: Text('Tên sản phẩm')),
              DataColumn(label: Text('Đã bán')),
            ],
            rows: topProducts.take(5).map((entry) {
              final product = entry['product'] as ProductModel;
              final sold = entry['sold'] as int;

              return DataRow(
                cells: [
                  DataCell(Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.thumbnail,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )),
                  DataCell(Text(sold.toString())),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}
