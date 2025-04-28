import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/formatters/formatter.dart';
import '../../personalization/models/address_model.dart';
import 'cart_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartModel> items;
  final String? couponId;
  final String? couponCode;
  final double discountAmount;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    this.shippingCost = 15000,
    required this.orderDate,
    this.paymentMethod = 'Thanh toán khi nhận hàng',
    this.address,
    this.deliveryDate,
    this.couponId,
    this.couponCode,
    this.discountAmount = 0,
  });

  String get formattedOrderDate => PHelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate =>
      deliveryDate != null ? PHelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Đã giao hàng'
      : status == OrderStatus.shipped
      ? 'Đang giao hàng'
      : 'Đang xử lý';

  String get formattedCurrency =>
      PFormatter.formatCurrencyRange(totalAmount.toInt().toString());

  /// Static function to create an empty order model
  static OrderModel empty() => OrderModel(
    id: '',
    items: [],
    status: OrderStatus.pending,
    totalAmount: 0,
    shippingCost: 15000,
    orderDate: DateTime.now(),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'shippingCost': shippingCost,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList(),
      'couponId': couponId,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      docId: snapshot.id,
      id: data.containsKey('id') ? data['id'] as String : '',
      userId: data.containsKey('userId') ? data['userId'] as String : '',
      status: data.containsKey('status')
          ? OrderStatus.values.firstWhere(
            (e) => e.toString() == data['status'],
        orElse: () => OrderStatus.pending,
      )
          : OrderStatus.pending,
      totalAmount: data.containsKey('totalAmount')
          ? (data['totalAmount'] as num).toDouble()
          : 0,
      orderDate: data['orderDate'] != null
          ? (data['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      paymentMethod: data.containsKey('paymentMethod')
          ? data['paymentMethod'] as String
          : 'Thanh toán khi nhận hàng',
      address: data.containsKey('address')
          ? AddressModel.fromMap(data['address'] as Map<String, dynamic>)
          : AddressModel.empty(),
      deliveryDate: data['deliveryDate'] == null
          ? null
          : (data['deliveryDate'] as Timestamp).toDate(),
      items: data.containsKey('items')
          ? (data['items'] as List<dynamic>)
          .map((itemData) => CartModel.fromJson(itemData as Map<String, dynamic>))
          .toList()
          : [],
      shippingCost: data.containsKey('shippingCost')
          ? (data['shippingCost'] as num).toDouble()
          : 15000,
      couponId: data['couponId'] as String?,
      couponCode: data['couponCode'] as String?,
      discountAmount: (data['discountAmount'] is double)
          ? data['discountAmount'] as double
          : (data['discountAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
