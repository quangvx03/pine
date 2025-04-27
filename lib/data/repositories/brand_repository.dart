import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/models/brand_model.dart';

import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      final result =
          snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra trong quá trình tải thương hiệu';
    }
  }

  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      QuerySnapshot brandCategoryQuery = await _db
          .collection('BrandCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      List<String> brandIds = brandCategoryQuery.docs
          .map((doc) => doc['brandId'] as String)
          .toList();

      final brandsQuery = await _db
          .collection('Brands')
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(2)
          .get();

      List<BrandModel> brands =
          brandsQuery.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();

      return brands;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra trong quá trình tải thương hiệu';
    }
  }

  final Map<String, List<BrandModel>> _topBrandsCache = {};
  final Map<String, DateTime> _topBrandsCacheTime = {};

  Future<List<BrandModel>> getTopSellingBrandsForCategory(String categoryId,
      {int limit = 2}) async {
    try {
      // Kiểm tra cache
      final cacheKey = 'top_brands_$categoryId';
      if (_topBrandsCache.containsKey(cacheKey)) {
        final cacheTime = _topBrandsCacheTime[cacheKey];
        if (cacheTime != null &&
            DateTime.now().difference(cacheTime).inMinutes < 30) {
          return _topBrandsCache[cacheKey]!;
        }
      }

      // Bước 1: Lấy tất cả danh mục con của danh mục này
      final subCategoriesQuery = await _db
          .collection('Categories')
          .where('ParentId', isEqualTo: categoryId)
          .get();

      // Tạo danh sách chứa ID của danh mục chính và tất cả danh mục con
      List<String> allCategoryIds = [categoryId];
      allCategoryIds
          .addAll(subCategoriesQuery.docs.map((doc) => doc.id).toList());

      // Bước 2: Lấy tất cả ID sản phẩm thuộc các danh mục này
      List<String> productIds = [];
      for (var catId in allCategoryIds) {
        final productCategoryQuery = await _db
            .collection('ProductCategory')
            .where('categoryId', isEqualTo: catId)
            .get();

        productIds.addAll(productCategoryQuery.docs
            .map((doc) => doc['productId'] as String)
            .toList());
      }

      if (productIds.isEmpty) return [];

      // Loại bỏ các ID trùng lặp
      productIds = productIds.toSet().toList();

      // Bước 3: Lấy tất cả thương hiệu từ sản phẩm và tính số lượng bán
      Map<String, int> brandSalesMap =
          {}; // Lưu tổng số lượng bán của mỗi thương hiệu
      Set<String> allBrandIds = {}; // Lưu tất cả brandId để kiểm tra sau

      // Chia thành các batch nhỏ hơn
      for (var i = 0; i < productIds.length; i += 10) {
        final end = (i + 10 < productIds.length) ? i + 10 : productIds.length;
        final batch = productIds.sublist(i, end);

        final productsQuery = await _db
            .collection('Products')
            .where(FieldPath.documentId, whereIn: batch)
            .where('IsFeatured', isEqualTo: true)
            .get();

        // Phân tích dữ liệu thương hiệu và tổng số lượng bán
        for (var doc in productsQuery.docs) {
          final data = doc.data();

          if (data.containsKey('Brand') && data['Brand'] is Map) {
            final brandData = data['Brand'] as Map<String, dynamic>;

            if (brandData.containsKey('Id')) {
              final brandId = brandData['Id'] as String;
              final soldQuantity = data['SoldQuantity'] as int? ?? 0;

              // Thêm vào danh sách tất cả brandId
              allBrandIds.add(brandId);

              // Cập nhật tổng số lượng bán cho thương hiệu
              brandSalesMap[brandId] =
                  (brandSalesMap[brandId] ?? 0) + soldQuantity;
            }
          }
        }
      }

      if (allBrandIds.isEmpty) return [];

      // Bước 4: Lấy thông tin chi tiết của tất cả thương hiệu và lọc theo isFeatured
      final featuredBrands = <BrandModel>[];

      // Xử lý theo batch vì giới hạn whereIn của Firestore
      for (var i = 0; i < allBrandIds.length; i += 10) {
        final end = (i + 10 < allBrandIds.length) ? i + 10 : allBrandIds.length;
        final batch = allBrandIds.toList().sublist(i, end);

        final brandsQuery = await _db
            .collection('Brands')
            .where(FieldPath.documentId, whereIn: batch)
            .where('IsFeatured', isEqualTo: true) // Lọc theo isFeatured = true
            .get();

        // Thêm thương hiệu vào danh sách kết quả
        featuredBrands.addAll(
            brandsQuery.docs.map((doc) => BrandModel.fromSnapshot(doc)));
      }

      if (featuredBrands.isEmpty) return [];

      // Bước 5: Sắp xếp theo số lượng bán và lấy top N
      featuredBrands.sort((a, b) {
        final salesA = brandSalesMap[a.id] ?? 0;
        final salesB = brandSalesMap[b.id] ?? 0;
        return salesB.compareTo(salesA);
      });

      // Lấy theo limit
      final results = featuredBrands.take(limit).toList();

      // Lưu vào cache
      _topBrandsCache[cacheKey] = results;
      _topBrandsCacheTime[cacheKey] = DateTime.now();

      return results;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra trong quá trình tải thương hiệu bán chạy: $e';
    }
  }

  // Thêm phương thức này vào BrandRepository
  Future<List<BrandModel>> getAllBrandsForCategoryWithSales(
      String categoryId) async {
    try {
      // Bước 1: Lấy tất cả danh mục con của danh mục chính
      final subCategoriesQuery = await _db
          .collection('Categories')
          .where('ParentId', isEqualTo: categoryId)
          .get();

      // Tạo danh sách chứa ID của danh mục chính và tất cả danh mục con
      List<String> allCategoryIds = [categoryId];
      allCategoryIds
          .addAll(subCategoriesQuery.docs.map((doc) => doc.id).toList());

      // Bước 2: Lấy tất cả ID sản phẩm thuộc các danh mục này
      final List<String> productIds = [];

      // Xử lý song song các truy vấn để tối ưu hiệu suất
      final categoryQueries = allCategoryIds
          .map((catId) => _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: catId)
              .get())
          .toList();

      final categoryResults = await Future.wait(categoryQueries);

      for (var result in categoryResults) {
        for (var doc in result.docs) {
          productIds.add(doc['productId'] as String);
        }
      }

      if (productIds.isEmpty) return [];

      // Bước 3: Tính tổng số lượng bán của mỗi thương hiệu từ các sản phẩm
      final Map<String, int> brandSales = {};
      final Map<String, BrandModel> brandDetails = {};

      // Xử lý theo batch vì giới hạn whereIn là 10
      for (var i = 0; i < productIds.length; i += 10) {
        final end = (i + 10 < productIds.length) ? i + 10 : productIds.length;
        final batch = productIds.sublist(i, end);

        final productsQuery = await _db
            .collection('Products')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (var doc in productsQuery.docs) {
          final data = doc.data();

          if (data.containsKey('Brand') && data['Brand'] is Map) {
            final brandInfo = data['Brand'] as Map<String, dynamic>;

            if (brandInfo.containsKey('Id')) {
              final brandId = brandInfo['Id'] as String;
              final soldQuantity = data['SoldQuantity'] as int? ?? 0;

              // Cộng dồn số lượng bán cho thương hiệu
              brandSales[brandId] = (brandSales[brandId] ?? 0) + soldQuantity;

              // Lưu thông tin thương hiệu nếu chưa có
              if (!brandDetails.containsKey(brandId)) {
                brandDetails[brandId] = BrandModel(
                  id: brandId,
                  name: brandInfo['Name'] as String? ?? 'Unknown',
                  image: brandInfo['Image'] as String? ?? '',
                  isFeatured: brandInfo['IsFeatured'] as bool? ?? false,
                );
              }
            }
          }
        }
      }

      // Bước 4: Sắp xếp thương hiệu theo số lượng bán
      final sortedBrands = brandDetails.values.toList()
        ..sort(
            (a, b) => (brandSales[b.id] ?? 0).compareTo(brandSales[a.id] ?? 0));

      // Bước 5: Lấy thông tin đầy đủ từ collection Brands
      final List<String> brandIds =
          sortedBrands.map((b) => b.id).take(10).toList();

      if (brandIds.isEmpty) return [];

      // Xử lý theo batch nếu cần
      final List<BrandModel> result = [];

      for (var i = 0; i < brandIds.length; i += 10) {
        final end = (i + 10 < brandIds.length) ? i + 10 : brandIds.length;
        final idBatch = brandIds.sublist(i, end);

        final brandsQuery = await _db
            .collection('Brands')
            .where(FieldPath.documentId, whereIn: idBatch)
            .get();

        final brandModels = brandsQuery.docs
            .map((doc) => BrandModel.fromSnapshot(doc))
            .toList();

        // Sắp xếp theo thứ tự ban đầu từ brandIds
        for (var id in idBatch) {
          final brand = brandModels.firstWhere(
            (b) => b.id == id,
            orElse: () => brandDetails[id]!,
          );
          result.add(brand);
        }
      }

      return result;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra trong quá trình tải thương hiệu: $e';
    }
  }
}
