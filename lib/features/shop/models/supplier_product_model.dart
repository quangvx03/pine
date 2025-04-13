import 'product_model.dart';

class SupplierProductModel {
  final ProductModel product;
  final int quantity;
  final double price;

  SupplierProductModel({
    required this.product,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }

  factory SupplierProductModel.fromJson(Map<String, dynamic> json) {
    return SupplierProductModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
