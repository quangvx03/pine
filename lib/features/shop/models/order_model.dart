import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine/features/personalization/models/address_model.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Thanh toán khi nhận hàng',
    this.address,
    this.deliveryDate,
  });

  String get formattedOrderDate => PHelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? PHelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Đã giao hàng'
      : status == OrderStatus.shipped
          ? 'Đang vận chuyển'
          : 'Đang xử lý';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList()
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    // Xử lý trường hợp address có thể null hoặc không phải Map
    AddressModel? addressModel;
    if (data['address'] != null && data['address'] is Map<String, dynamic>) {
      try {
        addressModel =
            AddressModel.fromMap(data['address'] as Map<String, dynamic>);
      } catch (e) {
        throw ('Lỗi khi chuyển đổi địa chỉ: $e');
      }
    }

    return OrderModel(
      id: data['id'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: (data['totalAmount'] is double)
          ? data['totalAmount'] as double
          : (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: data['orderDate'] is Timestamp
          ? (data['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      paymentMethod:
          data['paymentMethod'] as String? ?? 'Thanh toán khi nhận hàng',
      address: addressModel,
      deliveryDate: data['deliveryDate'] == null
          ? null
          : (data['deliveryDate'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>?)
              ?.map((itemData) =>
                  CartModel.fromJson(itemData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
