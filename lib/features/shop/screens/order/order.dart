import 'package:flutter/material.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/appbar/tabbar.dart';
import 'package:pine/features/shop/screens/order/widgets/orders_list.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các tab để hiển thị
    final List<String> tabs = [
      'Tất cả',
      'Chờ xử lý',
      'Đang xử lý',
      'Đang giao',
      'Đã giao',
      'Đã hủy',
    ];

    // Danh sách trạng thái đơn hàng tương ứng với các tab
    final List<OrderStatus?> statuses = [
      null, // Tất cả
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PAppBar(
          title: Text('Đơn hàng của tôi',
              style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true,
          bottom: PTabBar(
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),

        // Sử dụng TabBarView với padding ngang
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: List.generate(
              tabs.length,
              (index) => POrderListItems(status: statuses[index]),
            ),
          ),
        ),
      ),
    );
  }
}
