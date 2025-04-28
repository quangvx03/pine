class CartModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, String>? selectedVariation;

  /// Constructor
  CartModel({
    required this.productId,
    required this.quantity,
    this.variationId = '',
    this.image,
    this.price = 0,
    this.title = '',
    this.brandName,
    this.selectedVariation,
  });

  /// Calculate Total Amount
  double get totalAmount => price * quantity;

  static CartModel empty() => CartModel(productId: '', quantity: 0);

  /// Convert a CartItem to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'brandName': brandName,
      'selectedVariation': selectedVariation,
    };
  }

  /// Create a CartItem form a JSON Map
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'],
      title: json['title'],
      price: json['price']?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      variationId: json['variationId'],
      brandName: json['brandName'],
      selectedVariation: json['selectedVariation'] != null
          ? Map<String, String>.from(json['selectedVariation'])
          : null,
    );
  }
}
