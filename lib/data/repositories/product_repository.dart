import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/exceptions/firebase_exceptions.dart';
import 'package:pine/utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<ProductModel> getProductById(String productId) async {
    try {
      final snapshot = await _db.collection('Products').doc(productId).get();

      if (!snapshot.exists) {
        throw 'Sản phẩm không tồn tại';
      }

      return ProductModel.fromSnapshot(snapshot);
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra khi tải sản phẩm: $e';
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(6)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
      return productList;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getFavoriteProducts(
      List<String> productIds) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getProductsForBrand(
      {required String brandId, int limit = -1}) async {
    try {
      final querySnapshot = limit == -1
          ? await _db
              .collection('Products')
              .where('Brand.Id', isEqualTo: brandId)
              .get()
          : await _db
              .collection('Products')
              .where('Brand.Id', isEqualTo: brandId)
              .limit(limit)
              .get();

      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      return products;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getProductsForCategory(
      {required String categoryId, int limit = 4}) async {
    try {
      QuerySnapshot productCategoryQuery = limit == -1
          ? await _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: categoryId)
              .get()
          : await _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: categoryId)
              .limit(limit)
              .get();

      List<String> productIds = productCategoryQuery.docs
          .map((doc) => doc['productId'] as String)
          .toList();

      final productsQuery = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      List<ProductModel> products = productsQuery.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      return products;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      if (query.isEmpty) return [];

      // Lấy tất cả sản phẩm từ Firestore
      final productsSnapshot = await _db.collection('Products').get();

      // Chuyển đổi thành danh sách ProductModel
      final allProducts = productsSnapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      // Tìm kiếm không phân biệt hoa thường, CHỈ THEO TIÊU ĐỀ
      final queryLower = query.toLowerCase();
      final results = allProducts.where((product) {
        // Chỉ tìm kiếm theo tiêu đề sản phẩm
        final titleMatch = product.title.toLowerCase().contains(queryLower);
        return titleMatch;
      }).toList();

      debugPrint('Tìm thấy ${results.length} kết quả phù hợp');
      return results;
    } catch (e) {
      debugPrint('Lỗi trong quá trình tìm kiếm: $e');
      throw 'Lỗi khi tìm kiếm sản phẩm: $e';
    }
  }

  /// Cập nhật số lượng đã bán (soldQuantity) của sản phẩm
  Future<void> updateProductStock(ProductModel product) async {
    try {
      final productRef = _db.collection('Products').doc(product.id);

      // Cập nhật soldQuantity cho sản phẩm
      final Map<String, dynamic> data = {
        'SoldQuantity': product.soldQuantity,
      };

      // Nếu có biến thể, cập nhật thông tin biến thể
      if (product.productVariations != null &&
          product.productVariations!.isNotEmpty) {
        final variations = product.productVariations!
            .map((variation) => variation.toJson())
            .toList();
        data['ProductVariations'] = variations;
      }

      // Thực hiện cập nhật lên Firestore
      await productRef.update(data);
    } catch (e) {
      throw 'Lỗi khi cập nhật tồn kho: $e';
    }
  }
}
