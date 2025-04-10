import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/shimmers/product_detail_shimmer.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/controllers/product/order_controller.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/screens/product_details/product_detail.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/product_select_review.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    final refreshValue = false.obs;

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: Row(
          children: [
            Expanded(
              child: Text('Chi tiết đơn hàng',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Text(
              orderId,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: PColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        refreshValue.value;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
            child: FutureBuilder<List<OrderModel>>(
              future: controller.fetchUserOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.warning_2,
                            size: 50, color: Colors.red),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        Text(
                          'Có lỗi xảy ra khi tải đơn hàng',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        ElevatedButton(
                          onPressed: () => refreshValue.toggle(),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                final order = snapshot.data?.firstWhere(
                  (order) => order.id == orderId,
                  orElse: () => OrderModel(
                    id: '',
                    status: OrderStatus.pending,
                    items: [],
                    totalAmount: 0,
                    orderDate: DateTime.now(),
                  ),
                );

                if (order == null || order.id.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.document_filter,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        Text(
                          'Không tìm thấy thông tin đơn hàng',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                final dateFormat = DateFormat('dd/MM/yyyy');
                final timeFormat = DateFormat('HH:mm');
                final orderDate = dateFormat.format(order.orderDate);
                final orderTime = timeFormat.format(order.orderDate);
                String? deliveryDateTime;
                if ((order.status == OrderStatus.delivered ||
                        order.status == OrderStatus.cancelled) &&
                    order.deliveryDate != null) {
                  deliveryDateTime =
                      '${dateFormat.format(order.deliveryDate!)}, ${timeFormat.format(order.deliveryDate!)}';
                }

                const shippingFee = 15000.0;
                final subtotal = order.totalAmount - shippingFee;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thẻ trạng thái đơn hàng với Bo tròn 4 góc
                    _buildStatusCard(context, order, dark),
                    const SizedBox(height: PSizes.spaceBtwSections),

                    // Tiêu đề theo dõi đơn hàng
                    _buildSectionHeader(context, 'Theo dõi đơn hàng'),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Timeline theo dõi đơn hàng
                    PRoundedContainer(
                      backgroundColor: Colors.transparent,
                      child: _buildTimelineSteps(
                        context: context,
                        status: order.status,
                        dark: dark,
                        orderDateTime: '$orderDate, $orderTime',
                        deliveryDateTime: deliveryDateTime,
                      ),
                    ),

                    // Địa chỉ giao hàng
                    if (order.address != null) ...[
                      _buildSectionHeader(context, 'Địa chỉ giao hàng'),
                      const SizedBox(height: PSizes.spaceBtwItems),
                      PRoundedContainer(
                        backgroundColor: Colors.transparent,
                        child: _buildDeliveryAddress(context, order, dark),
                      ),
                      const SizedBox(height: PSizes.spaceBtwSections),
                    ],

                    // Thông tin đơn hàng
                    _buildSectionHeader(context, 'Thông tin đơn hàng'),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    _buildOrderInfoCard(context, order, orderDate, orderTime,
                        dark, subtotal, shippingFee),
                    const SizedBox(height: PSizes.spaceBtwSections),

                    // Các nút hành động
                    if (order.status == OrderStatus.delivered)
                      _buildReviewButton(context, order),
                    if (order.status == OrderStatus.delivered)
                      const SizedBox(height: PSizes.spaceBtwItems),

                    if (_canCancelOrder(order.status))
                      _buildCancelButton(context, order, refreshValue),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }

  // Kiểm tra đơn hàng có thể hủy hay không
  bool _canCancelOrder(OrderStatus status) {
    return status == OrderStatus.pending || status == OrderStatus.processing;
  }

  // Tiêu đề section với đường viền bên trái
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: PColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: PSizes.sm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // Thẻ trạng thái đơn hàng - thu nhỏ lại
  Widget _buildStatusCard(BuildContext context, OrderModel order, bool dark) {
    final statusInfo = _getStatusInfo(order.status);

    return PRoundedContainer(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: PSizes.xs, horizontal: PSizes.sm),
        decoration: BoxDecoration(
          color: statusInfo.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(PSizes.sm),
              decoration: BoxDecoration(
                color: statusInfo.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusInfo.icon,
                color: statusInfo.color,
                size: 22, // Tăng kích thước icon
              ),
            ),
            const SizedBox(width: PSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusInfo.text,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusInfo.color,
                        ),
                  ),
                  const SizedBox(height: PSizes.xs),
                  Text(
                    statusInfo.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nút đánh giá sản phẩm
  Widget _buildReviewButton(BuildContext context, OrderModel order) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.amber.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: PSizes.md),
          foregroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PSizes.buttonRadius),
          ),
        ),
        onPressed: () => Get.to(() => ProductSelectReviewScreen(order: order)),
        icon: const Icon(Iconsax.star1, color: Colors.amber),
        label: Text(
          'Đánh giá sản phẩm',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Nút hủy đơn hàng
  Widget _buildCancelButton(
      BuildContext context, OrderModel order, RxBool refreshValue) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: PSizes.md),
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PSizes.buttonRadius),
          ),
        ),
        onPressed: () {
          Get.defaultDialog(
            contentPadding: const EdgeInsets.all(PSizes.md),
            title: 'Xác nhận hủy đơn',
            content: Column(
              children: [
                const Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
                const SizedBox(height: PSizes.sm),
                Text(
                  'Mã đơn: ${order.id}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            confirm: ElevatedButton(
              onPressed: () async {
                Get.back();

                final controller = Get.find<OrderController>();
                final success = await controller.cancelOrder(order.id);

                if (success) {
                  refreshValue.toggle();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PColors.error,
                side: const BorderSide(color: PColors.error),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: PSizes.lg),
                child: Text('Hủy'),
              ),
            ),
            cancel: OutlinedButton(
              child: const Text('Giữ lại'),
              onPressed: () => Get.back(),
            ),
          );
        },
        icon: const Icon(Iconsax.close_circle, color: Colors.red),
        label: Text(
          'Hủy đơn hàng',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Timeline theo dõi đơn hàng - cố định kích thước và cải tiến
  Widget _buildTimelineSteps({
    required BuildContext context,
    required OrderStatus status,
    required bool dark,
    String? orderDateTime,
    String? deliveryDateTime,
  }) {
    // Cấu trúc thông tin cho mỗi bước
    final steps = [
      {
        'title': 'Đơn hàng đã đặt',
        'subtitle': 'Đơn hàng của bạn đã được tiếp nhận\n$orderDateTime',
        'icon': Iconsax.receipt_item,
        'color': Colors.orange,
        'status': OrderStatus.pending,
        'isActive': true,
        'isCompleted': true,
      },
      {
        'title': 'Đang xử lý',
        'subtitle': 'Đơn hàng của bạn đang được chuẩn bị',
        'icon': Iconsax.box_1,
        'color': Colors.blue,
        'status': OrderStatus.processing,
        'isActive': _isStatusActiveOrCompleted(status, OrderStatus.processing),
        'isCompleted': _isStatusCompleted(status, OrderStatus.processing),
      },
      {
        'title': 'Đang giao hàng',
        'subtitle': 'Đơn hàng của bạn đang được vận chuyển',
        'icon': Iconsax.truck_fast,
        'color': Colors.purple,
        'status': OrderStatus.shipped,
        'isActive': _isStatusActiveOrCompleted(status, OrderStatus.shipped),
        'isCompleted': _isStatusCompleted(status, OrderStatus.shipped),
      },
      {
        'title': 'Đã giao hàng',
        'subtitle': status == OrderStatus.delivered
            ? 'Đơn hàng của bạn đã được giao thành công${deliveryDateTime != null ? '\n$deliveryDateTime' : ''}'
            : 'Đơn hàng của bạn sẽ được giao',
        'icon': Iconsax.tick_circle,
        'color': Colors.green,
        'status': OrderStatus.delivered,
        'isActive': _isStatusActiveOrCompleted(status, OrderStatus.delivered),
        'isCompleted': _isStatusCompleted(status, OrderStatus.delivered),
      },
    ];

    if (status == OrderStatus.cancelled) {
      final cancelledTime =
          deliveryDateTime != null ? '\n$deliveryDateTime' : '';

      steps.add({
        'title': 'Đã hủy',
        'subtitle': 'Đơn hàng của bạn đã bị hủy$cancelledTime',
        'icon': Iconsax.close_circle,
        'color': Colors.red,
        'status': OrderStatus.cancelled,
        'isActive': true,
        'isCompleted': true,
        'isError': true,
      });
    }

    return Padding(
      padding: const EdgeInsets.all(PSizes.sm),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          final isError = step['isError'] == true;

          return _buildTimelineStepItem(
            context: context,
            title: step['title'] as String,
            subtitle: step['subtitle'] as String,
            icon: step['icon'] as IconData,
            color: step['color'] as Color,
            isActive: step['isActive'] as bool,
            isCompleted: step['isCompleted'] as bool,
            isLast: isLast,
            isError: isError,
            dark: dark,
          );
        },
      ),
    );
  }

  // Widget cho mỗi bước trong timeline - cố định kích thước
  Widget _buildTimelineStepItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isActive,
    required bool isCompleted,
    required bool isLast,
    required bool dark,
    bool isError = false,
  }) {
    final statusColor = isError
        ? Colors.red
        : isCompleted
            ? Colors.green
            : isActive
                ? color
                : Colors.grey.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần icon và đường kết nối - cố định width và căn chỉnh
          SizedBox(
            width: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon bước
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: statusColor,
                      size: 14,
                    ),
                  ),
                ),

                // Đường kết nối với chiều cao cố định và căn giữa
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40, // Chiều cao cố định cho đường kết nối
                    color: isActive
                        ? statusColor
                        : Colors.grey.withValues(alpha: 0.3),
                    // Đặt margin ở giữa để căn đều
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
              ],
            ),
          ),

          const SizedBox(width: PSizes.sm),

          // Nội dung bước với chiều cao cố định
          Expanded(
            child: SizedBox(
              height: isLast ? 80 : 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề và icon trạng thái
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isActive || isCompleted
                                        ? (isError ? Colors.red : null)
                                        : Colors.grey,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCompleted && !isError)
                        Icon(
                          Iconsax.tick_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Mô tả - giới hạn số dòng
                  Expanded(
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: isActive || isCompleted
                                ? (isError
                                    ? Colors.red.withValues(alpha: 0.7)
                                    : Colors.grey)
                                : Colors.grey.withValues(alpha: 0.7),
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Địa chỉ giao hàng
  Widget _buildDeliveryAddress(
      BuildContext context, OrderModel order, bool dark) {
    final address = order.address!;
    final textColor = dark ? Colors.white70 : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.all(PSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên người nhận
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100, // Chiều rộng cố định cho phần label
                child: Text(
                  'Người nhận:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  address.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : PColors.dark,
                      ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),

          // Số điện thoại
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100, // Chiều rộng cố định cho phần label
                child: Text(
                  'Điện thoại:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  address.phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),

          // Địa chỉ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100, // Chiều rộng cố định cho phần label
                child: Text(
                  'Địa chỉ:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  '${address.street}, ${address.ward}, ${address.city}, ${address.province}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Thông tin đơn hàng - sử dụng thanh ngang để ngăn cách
  Widget _buildOrderInfoCard(
    BuildContext context,
    OrderModel order,
    String orderDate,
    String orderTime,
    bool dark,
    double subtotal,
    double shippingFee,
  ) {
    return PRoundedContainer(
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(PSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mã đơn hàng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mã đơn hàng',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                order.id,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PColors.primary,
                    ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: Colors.grey.shade200,
          ),

          // Ngày đặt hàng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngày đặt hàng',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                '$orderDate, $orderTime',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: Colors.grey.shade200,
          ),

          // Phương thức thanh toán
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phương thức thanh toán',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: PSizes.lg),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: PSizes.md, vertical: 4),
                  decoration: BoxDecoration(
                    color: PColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(PSizes.xs),
                  ),
                  child: Text(
                    order.paymentMethod,
                    style: TextStyle(
                      color: PColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true, // Cho phép xuống dòng
                  ),
                ),
              ),
            ],
          ),

          // Separator giữa thông tin và sản phẩm
          const SizedBox(height: PSizes.spaceBtwItems),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            decoration: BoxDecoration(
              color: dark
                  ? PColors.black.withValues(alpha: 0.7)
                  : PColors.darkGrey,
              borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
            ),
          ),
          const SizedBox(height: PSizes.sm),

          // Tiêu đề sản phẩm với count badge
          Row(
            children: [
              Text(
                'Sản phẩm đã đặt',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: PSizes.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: PColors.grey.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${order.items.length}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: PColors.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PSizes.sm),

          // Danh sách sản phẩm
          // Thay thế phần hiển thị danh sách sản phẩm trong _buildOrderInfoCard
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, __) => Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
              color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            itemBuilder: (_, index) {
              final item = order.items[index];

              // Danh sách thứ tự ưu tiên các thuộc tính
              final attributeOrder = [
                'Thể loại',
                'Kích cỡ',
                'Màu sắc',
                'Chất liệu'
              ];

              // Tạo danh sách các thuộc tính đã được sắp xếp
              final Map<String, String> variations =
                  item.selectedVariation ?? {};
              final orderedVariations = attributeOrder
                  .where((attr) => variations.containsKey(attr))
                  .map((key) => MapEntry(key, variations[key]!))
                  .toList();

              // Thêm các thuộc tính khác không nằm trong danh sách ưu tiên
              for (final entry in variations.entries) {
                if (!attributeOrder.contains(entry.key)) {
                  orderedVariations.add(entry);
                }
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductDetailShimmer(),
                      ));
                  _loadProductDetails(context, item.productId);
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hình ảnh sản phẩm
                        PRoundedImage(
                          imageUrl: item.image ?? '',
                          width: 65,
                          height: 65,
                          isNetworkImage: true,
                          padding: const EdgeInsets.all(PSizes.xs),
                          backgroundColor:
                              dark ? PColors.darkerGrey : PColors.light,
                        ),

                        const SizedBox(width: PSizes.sm),

                        // Thông tin sản phẩm
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tên sản phẩm
                              Text(
                                item.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.visible,
                              ),

                              // Hiển thị các biến thể theo thứ tự ưu tiên
                              if (orderedVariations.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: orderedVariations
                                      .map((e) => Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${e.key}: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                                TextSpan(
                                                  text: e.value,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),

                              const SizedBox(height: 4),

                              // Giá và số lượng
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${PHelperFunctions.formatCurrency(item.price)} × ${item.quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: dark
                                              ? Colors.white70
                                              : Colors.grey.shade600,
                                        ),
                                  ),
                                  Text(
                                    PHelperFunctions.formatCurrency(
                                        item.price * item.quantity),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: PColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Separator giữa sản phẩm và tổng kết
          const SizedBox(height: PSizes.spaceBtwItems),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            decoration: BoxDecoration(
              color: dark
                  ? PColors.black.withValues(alpha: 0.7)
                  : PColors.darkGrey,
              borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
            ),
          ),
          const SizedBox(height: PSizes.sm),

          // Tổng kết
          _buildOrderSummary(
            context: context,
            subtotal: subtotal,
            shippingFee: shippingFee,
            total: order.totalAmount,
          ),
        ],
      ),
    );
  }

  // Tổng kết đơn hàng
  Widget _buildOrderSummary({
    required BuildContext context,
    required double subtotal,
    required double shippingFee,
    required double total,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tạm tính', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              PHelperFunctions.formatCurrency(subtotal),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: PSizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí vận chuyển',
                style: Theme.of(context).textTheme.bodyMedium),
            Text(
              PHelperFunctions.formatCurrency(shippingFee),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
          height: 1,
          color: Colors.grey.shade200,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng thanh toán',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              PHelperFunctions.formatCurrency(total),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PColors.primary,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  // Kiểm tra trạng thái đơn hàng
  bool _isStatusActiveOrCompleted(
      OrderStatus currentStatus, OrderStatus checkStatus) {
    if (currentStatus == OrderStatus.cancelled) {
      return false;
    }
    return currentStatus.index >= checkStatus.index;
  }

  bool _isStatusCompleted(OrderStatus currentStatus, OrderStatus checkStatus) {
    if (currentStatus == OrderStatus.cancelled) {
      return false;
    }
    return currentStatus.index > checkStatus.index;
  }

  // Lấy thông tin hiển thị cho trạng thái
  _StatusInfo _getStatusInfo(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusInfo(
          text: 'Chờ xử lý',
          description: 'Đơn hàng của bạn đã được xác nhận và đang chờ xử lý',
          color: Colors.orange,
          icon: Iconsax.timer_1,
        );
      case OrderStatus.processing:
        return _StatusInfo(
          text: 'Đang xử lý',
          description: 'Đơn hàng của bạn đang được chuẩn bị',
          color: Colors.blue,
          icon: Iconsax.box_1,
        );
      case OrderStatus.shipped:
        return _StatusInfo(
          text: 'Đang giao hàng',
          description: 'Đơn hàng của bạn đang được vận chuyển',
          color: Colors.purple,
          icon: Iconsax.truck_fast,
        );
      case OrderStatus.delivered:
        return _StatusInfo(
          text: 'Đã giao hàng',
          description: 'Đơn hàng của bạn đã được giao thành công',
          color: Colors.green,
          icon: Iconsax.tick_circle,
        );
      case OrderStatus.cancelled:
        return _StatusInfo(
          text: 'Đã hủy',
          description: 'Đơn hàng của bạn đã bị hủy',
          color: Colors.red,
          icon: Iconsax.close_circle,
        );
    }
  }
}

/// Class lưu trữ thông tin hiển thị theo trạng thái
class _StatusInfo {
  final String text;
  final String description;
  final Color color;
  final IconData icon;

  _StatusInfo({
    required this.text,
    required this.description,
    required this.color,
    required this.icon,
  });
}

// Thêm phương thức này vào lớp OrderDetailsScreen
Future<void> _loadProductDetails(BuildContext context, String productId) async {
  try {
    final productRepository = ProductRepository.instance;
    final product = await productRepository.getProductById(productId);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Không thể tải thông tin sản phẩm: $e'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
        ),
      ),
    );
    Navigator.pop(context);
  }
}
