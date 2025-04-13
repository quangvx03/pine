import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine_admin_panel/features/shop/models/supplier_product_model.dart';

class SupplierModel {
  String id;
  final String name;
  final String phone;
  final String address;
  final List<SupplierProductModel> products;
  final int quantity;
  final double totalAmount;
  final DateTime createdAt;

  SupplierModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.products,
    required this.quantity,
    required this.totalAmount,
    required this.createdAt,
  });

  String get formattedDate => "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  String get formattedCurrency => "${totalAmount.toStringAsFixed(0)}₫";

  static SupplierModel empty() => SupplierModel(
    id: '',
    name: '',
    phone: '',
    address: '',
    products: [],
    quantity: 0,
    totalAmount: 0,
    createdAt: DateTime.now(),
  );

  factory SupplierModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

    return SupplierModel(
      id: document.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      quantity: data['quantity'] ?? 0,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      products: data.containsKey('products')
          ? (data['products'] as List)
          .map((e) => SupplierProductModel.fromJson(e))
          .toList()
          : [],
    );
  }else {
      return SupplierModel.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}
