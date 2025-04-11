import 'package:cloud_firestore/cloud_firestore.dart';

class UsedCouponModel {
  final String id;
  final String userId;
  final String couponId;
  final String orderId;
  final DateTime usedAt;
  final String? couponCode;
  final double? discountAmount;
  final String? type;

  UsedCouponModel({
    required this.id,
    required this.userId,
    required this.couponId,
    required this.orderId,
    required this.usedAt,
    this.couponCode,
    this.discountAmount,
    this.type,
  });

  /// Convert từ model sang Map để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'CouponId': couponId,
      'OrderId': orderId,
      'UsedAt': usedAt,
      'CouponCode': couponCode,
      'DiscountAmount': discountAmount,
      'Type': type,
    };
  }

  /// Tạo model từ DocumentSnapshot
  factory UsedCouponModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UsedCouponModel(
      id: snapshot.id,
      userId: data['UserId'] as String? ?? '',
      couponId: data['CouponId'] as String? ?? '',
      orderId: data['OrderId'] as String? ?? '',
      usedAt: data['UsedAt'] is Timestamp
          ? (data['UsedAt'] as Timestamp).toDate()
          : DateTime.now(),
      couponCode: data['CouponCode'] as String?,
      discountAmount: (data['DiscountAmount'] is double)
          ? data['DiscountAmount'] as double
          : (data['DiscountAmount'] as num?)?.toDouble(),
      type: data['Type'] as String?,
    );
  }

  /// Tạo model từ Map
  factory UsedCouponModel.fromMap(Map<String, dynamic> data) {
    return UsedCouponModel(
      id: data['id'] as String? ?? '',
      userId: data['UserId'] as String? ?? '',
      couponId: data['CouponId'] as String? ?? '',
      orderId: data['OrderId'] as String? ?? '',
      usedAt: data['UsedAt'] is Timestamp
          ? (data['UsedAt'] as Timestamp).toDate()
          : DateTime.now(),
      couponCode: data['CouponCode'] as String?,
      discountAmount: (data['DiscountAmount'] is double)
          ? data['DiscountAmount'] as double
          : (data['DiscountAmount'] as num?)?.toDouble(),
      type: data['Type'] as String?,
    );
  }

  /// Tạo một bản sao với các thuộc tính mới
  UsedCouponModel copyWith({
    String? id,
    String? userId,
    String? couponId,
    String? orderId,
    DateTime? usedAt,
    String? couponCode,
    double? discountAmount,
    String? type,
  }) {
    return UsedCouponModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      couponId: couponId ?? this.couponId,
      orderId: orderId ?? this.orderId,
      usedAt: usedAt ?? this.usedAt,
      couponCode: couponCode ?? this.couponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      type: type ?? this.type,
    );
  }
}
