import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:pine_admin_panel/utils/formatters/formatter.dart';

import '../../../utils/constants/enums.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool isFeatured;
  BrandModel? brand;
  String? categoryId;
  String productType;
  String? description;
  List<String>? images;
  int soldQuantity;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.soldQuantity = 0,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0,
    required this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
    this.productVariations,
  });

  String get formattedDate => PFormatter.formatDate(date);
  String get formattedCurrency {
    if (productVariations != null && productVariations!.isNotEmpty) {
      double minPrice = productVariations!.map((variation) => variation.price).reduce((a, b) => a < b ? a : b);
      double maxPrice = productVariations!.map((variation) => variation.price).reduce((a, b) => a > b ? a : b);

      if (salePrice > 0 && salePrice < minPrice) {
        minPrice = salePrice;
      }
      return PFormatter.formatCurrencyRange("${minPrice.toInt()} - ${maxPrice.toInt()}");
    }

    if (salePrice > 0 && salePrice < price) {
      return PFormatter.formatCurrencyRange("${salePrice.toInt()} - ${price.toInt()}");
    }

    return PFormatter.formatCurrencyRange(price.toInt().toString());
  }


  /// Create Empty func for clean code
  static ProductModel empty() => ProductModel(
      id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '', isFeatured: false);

  /// Json Format
  toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand?.toJson(),
      'Date': date,
      'Description': description,
      'ProductType': productType,
      'SoldQuantity': soldQuantity,
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return ProductModel(
      id: document.id,
      sku: data['SKU'],
      title: data['Title'],
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      soldQuantity: data.containsKey('SoldQuantity') ? data['SoldQuantity'] ?? 0 : 0,
      price: double.parse((data['Price'] ?? 0).toString()),
      salePrice:  double.parse((data['SalePrice'] ?? 0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      date: data['Date'] is Timestamp ? (data['Date'] as Timestamp).toDate() : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List<dynamic>)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList()
          : [],
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List<dynamic>)
          .map((e) => ProductVariationModel.fromJson(e))
          .toList()
          : [],
    );
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;

    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      soldQuantity: data.containsKey('SoldQuantity') ? data['SoldQuantity'] ?? 0 : 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.parse((data['Price'] ?? 0).toString()),
      salePrice:  double.parse((data['SalePrice'] ?? 0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      date: data['Date'] is Timestamp ? (data['Date'] as Timestamp).toDate() : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List<dynamic>)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList()
          : [],
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List<dynamic>)
          .map((e) => ProductVariationModel.fromJson(e))
          .toList()
          : [],
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      sku: json['SKU'] ?? '',
      title: json['Title'] ?? '',
      stock: json['Stock'] ?? 0,
      isFeatured: json['IsFeatured'] ?? false,
      soldQuantity: json['SoldQuantity'] ?? 0,
      price: double.tryParse(json['Price']?.toString() ?? '0') ?? 0,
      salePrice: double.tryParse(json['SalePrice']?.toString() ?? '0') ?? 0,
      thumbnail: json['Thumbnail'] ?? '',
      categoryId: json['CategoryId'],
      description: json['Description'] ?? '',
      productType: json['ProductType'] ?? '',
      brand: json['Brand'] != null ? BrandModel.fromJson(json['Brand']) : null,
      date: json['Date'] is Timestamp ? (json['Date'] as Timestamp).toDate() : null,
      images: json['Images'] != null ? List<String>.from(json['Images']) : [],
      productAttributes: json['ProductAttributes'] != null
          ? (json['ProductAttributes'] as List<dynamic>)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList()
          : [],
      productVariations: json['ProductVariations'] != null
          ? (json['ProductVariations'] as List<dynamic>)
          .map((e) => ProductVariationModel.fromJson(e))
          .toList()
          : [],
    );
  }

}
