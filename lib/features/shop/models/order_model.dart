import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard_controller.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../utils/constants/enums.dart';
import 'address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  //final double shippingCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
  required this.id,
  this.userId = '',
  this.docId = '',
  required this.status,
  required this.items,
  required this.totalAmount,
  //required this.shippingCost,
  required this.orderDate,
  this.paymentMethod = 'Thanh toán khi nhận hàng',
  this.shippingAddress,
  this.deliveryDate,
});
  String get formattedOrderDate => PHelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null ? PHelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Đã giao hàng'
      : status == OrderStatus.shipped
        ? 'Đơn hàng đang trên đường'
        : 'Đang xử lý';

  /// Static function to create an empty user model
  static OrderModel empty() => OrderModel(
      id: '',
      items: [],
      status: OrderStatus.pending,
      totalAmount: 0,
      //shippingCost: 0,
      orderDate: DateTime.now()
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      //'shippingCost': shippingCost,
      'shippingAddress': shippingAddress?.toJson(),
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      status: OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      totalAmount: data['totalAmount'] as double,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
      shippingAddress: AddressModel.fromMap(data['address'] as Map<String, dynamic>),
      deliveryDate: data['deliveryDate'] == null ? null : (data['deliveryDate'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>)).toList(),
      //shippingCost: data['shippingCost'] as double,
    );
  }
}