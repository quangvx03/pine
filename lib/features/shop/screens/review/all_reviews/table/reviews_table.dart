import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/review/all_reviews/table/review_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import '../../../../controllers/review/review_controller.dart';

class ReviewTable extends StatelessWidget {
  const ReviewTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    return Obx(() {
      Text(controller.filteredItems.length.toString());
      return PPaginatedDataTable(
        minWidth: 900,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(label: Text('Khách hàng'), fixedWidth: 200, onSort: (columnIndex, ascending) =>
              controller.sortByUsername(columnIndex, ascending)),
          const DataColumn2(label: Text('Đơn hàng'), fixedWidth: 150),
          const DataColumn2(label: Text('Sản phẩm')),
          const DataColumn2(label: Text('Số sao'), fixedWidth: 150),
          const DataColumn2(label: Text('Nội dung đánh giá'), fixedWidth: 400),
          DataColumn2(label: Text('Ngày đánh giá'),onSort: (columnIndex, ascending) =>
              controller.sortByDate(columnIndex, ascending)),
          const DataColumn2(label: Text('Hành động'), fixedWidth: 120),
        ],
        source: ReviewRows(),
      );
    });
  }
}

