import 'package:flutter/material.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/features/shop/screens/order/widgets/orders_list.dart';
import 'package:pine/utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: PAppBar(
          title: Text('Đơn hàng của tôi',
              style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true),
      body: const Padding(
        padding: EdgeInsets.all(PSizes.defaultSpace),

        /// Order
        child: POrderListItems(),
      ),
    );
  }
}
