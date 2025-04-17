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

      final product = ProductModel.fromSnapshot(snapshot);
      if (product.isFeatured != true) {
        throw 'Sản phẩm không khả dụng';
      }

      return product;
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

  Future<List<ProductModel>> getSuggestProducts() async {
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
      debugPrint('Fetching products for brand: $brandId, limit: $limit');

      // Tạo truy vấn cơ bản
      Query query = _db.collection('Products');

      query = query.where('IsFeatured', isEqualTo: true);

      query = query.where('Brand.Id', isEqualTo: brandId);

      // Thêm giới hạn nếu có
      if (limit > 0) {
        query = query.limit(limit);
      }

      // Thực hiện truy vấn
      final querySnapshot = await query.get();
      debugPrint(
          'Found ${querySnapshot.docs.length} products for brand $brandId');

      // Chuyển đổi kết quả thành danh sách sản phẩm
      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();

      return products;
    } on FirebaseException catch (e) {
      debugPrint(
          'Firebase error fetching brand products: ${e.code}, ${e.message}');
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      debugPrint(
          'Platform error fetching brand products: ${e.code}, ${e.message}');
      throw PPlatformException(e.code).message;
    } catch (e) {
      debugPrint('General error fetching brand products: $e');
      throw 'Có lỗi xảy ra khi tải sản phẩm theo thương hiệu: $e';
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

      // Lọc sản phẩm theo IsFeatured sau khi lấy về
      List<ProductModel> products = productsQuery.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .where((product) => product.isFeatured == true)
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
      final productsSnapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();

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

  /// Lấy sản phẩm phân trang với sắp xếp tại Firestore
  Future<Map<String, dynamic>> getPaginatedProducts({
    required String sortOption,
    int limit = 10,
    DocumentSnapshot? lastDocument,
    String? brandId,
    String? categoryId,
  }) async {
    try {
      // Biến để theo dõi xem query có được sửa đổi không
      Query query = _db.collection('Products');

      query = query.where('IsFeatured', isEqualTo: true);

      // Lọc theo thương hiệu nếu có
      if (brandId != null && brandId.isNotEmpty) {
        query = query.where('Brand.Id', isEqualTo: brandId);
      }

      // Lọc theo danh mục nếu có (phức tạp hơn vì phải qua collection ProductCategory)
      if (categoryId != null && categoryId.isNotEmpty) {
        final productCategoryQuery = await _db
            .collection('ProductCategory')
            .where('categoryId', isEqualTo: categoryId)
            .get();

        List<String> productIds = productCategoryQuery.docs
            .map((doc) => doc['productId'] as String)
            .toList();

        if (productIds.isEmpty) {
          return {
            'products': <ProductModel>[],
            'lastDocument': null,
            'isLastPage': true,
          };
        }

        query = query.where(FieldPath.documentId, whereIn: productIds);
      }

      // Xác định trường và chiều sắp xếp dựa trên tùy chọn
      String orderField;
      bool descending;

      switch (sortOption) {
        case 'A-Z':
          orderField = 'Title';
          descending = false;
          break;
        case 'Z-A':
          orderField = 'Title';
          descending = true;
          break;
        case 'Giá cao':
        case 'Giá thấp':
          // Lấy tất cả sản phẩm và xử lý sắp xếp trên ứng dụng theo giá hiển thị
          final querySnapshot = await query.get();
          final products = querySnapshot.docs
              .map((doc) => ProductModel.fromQuerySnapshot(doc))
              .toList();

          // Sắp xếp dựa trên giá hiển thị (salePrice nếu có, nếu không thì dùng price)
          products.sort((a, b) {
            double priceA = a.salePrice > 0 && a.salePrice < a.price
                ? a.salePrice
                : a.price;
            double priceB = b.salePrice > 0 && b.salePrice < b.price
                ? b.salePrice
                : b.price;

            if (sortOption == 'Giá cao') {
              return priceB.compareTo(priceA); // Giá cao nhất trước
            } else {
              return priceA.compareTo(priceB); // Giá thấp nhất trước
            }
          });

          // Thực hiện phân trang thủ công
          int startIndex = 0;
          if (lastDocument != null) {
            // Tìm index của document cuối cùng đã load
            final lastId = lastDocument.id;
            final lastIndex = products.indexWhere((p) => p.id == lastId);
            if (lastIndex != -1) {
              startIndex = lastIndex + 1;
            }
          }

          final int endIndex = startIndex + limit > products.length
              ? products.length
              : startIndex + limit;

          if (startIndex >= products.length) {
            return {
              'products': <ProductModel>[],
              'lastDocument': null,
              'isLastPage': true,
            };
          }

          final paginatedProducts = products.sublist(startIndex, endIndex);

          return {
            'products': paginatedProducts,
            'lastDocument': endIndex < products.length
                ? await _db
                    .collection('Products')
                    .doc(paginatedProducts.last.id)
                    .get()
                : null,
            'isLastPage': endIndex >= products.length,
          };

        case 'Giảm giá':
          // Lấy tất cả sản phẩm và xử lý sắp xếp trên ứng dụng
          final querySnapshot = await query.get();
          final products = querySnapshot.docs
              .map((doc) => ProductModel.fromQuerySnapshot(doc))
              .toList();

          // Tính % giảm giá cho mỗi sản phẩm và sắp xếp
          products.sort((a, b) {
            double discountPercentA = 0;
            double discountPercentB = 0;

            if (a.price > 0 && a.salePrice > 0 && a.salePrice < a.price) {
              discountPercentA = ((a.price - a.salePrice) / a.price) * 100;
            }

            if (b.price > 0 && b.salePrice > 0 && b.salePrice < b.price) {
              discountPercentB = ((b.price - b.salePrice) / b.price) * 100;
            }

            return discountPercentB.compareTo(discountPercentA);
          });

          // Thực hiện phân trang thủ công
          int startIndex = 0;
          if (lastDocument != null) {
            // Tìm index của document cuối cùng đã load
            final lastId = lastDocument.id;
            final lastIndex = products.indexWhere((p) => p.id == lastId);
            if (lastIndex != -1) {
              startIndex = lastIndex + 1;
            }
          }

          final int endIndex = startIndex + limit > products.length
              ? products.length
              : startIndex + limit;

          if (startIndex >= products.length) {
            return {
              'products': <ProductModel>[],
              'lastDocument': null,
              'isLastPage': true,
            };
          }

          final paginatedProducts = products.sublist(startIndex, endIndex);

          return {
            'products': paginatedProducts,
            'lastDocument': endIndex < products.length
                ? await _db
                    .collection('Products')
                    .doc(paginatedProducts.last.id)
                    .get()
                : null,
            'isLastPage': endIndex >= products.length,
          };

        default:
          orderField = 'Title';
          descending = false;
      }

      // Áp dụng sắp xếp
      query = query.orderBy(orderField, descending: descending);

      // Thêm phân trang
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Giới hạn số lượng sản phẩm mỗi lần tải
      query = query.limit(limit);

      // Thực hiện truy vấn
      final querySnapshot = await query.get();
      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();

      // Trả về cả danh sách sản phẩm và document cuối cùng để phân trang tiếp theo
      return {
        'products': productList,
        'lastDocument':
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
        'isLastPage': querySnapshot.docs.length < limit,
      };
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra, vui lòng thử lại';
    }
  }
}
