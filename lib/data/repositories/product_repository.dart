import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/models/product_category_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';

import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createProduct(ProductModel product) async {
    try {
      return await _db.runTransaction((transaction) async {
        final newDocRef = _db.collection('Products').doc();
        transaction.set(newDocRef, product.toJson());

        if (product.brand != null && product.brand!.id.isNotEmpty) {
          final brandRef = _db.collection("Brands").doc(product.brand!.id);
          transaction.update(brandRef, {
            'ProductsCount': FieldValue.increment(1),
          });
        }

        return newDocRef.id;
      });
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }


  Future<String> createProductCategory(ProductCategoryModel productCategory) async {
    try{
      final result = await _db.collection("ProductCategory").add(productCategory.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      return await _db.runTransaction((transaction) async {
        final productRef = _db.collection("Products").doc(product.id);
        final snapshot = await transaction.get(productRef);

        if (!snapshot.exists) throw Exception("Không tìm thấy sản phẩm");

        final oldProduct = ProductModel.fromSnapshot(snapshot);

        final oldBrandId = oldProduct.brand?.id;
        final newBrandId = product.brand?.id;

        if (oldBrandId != null && oldBrandId != newBrandId) {
          final oldBrandRef = _db.collection("Brands").doc(oldBrandId);
          transaction.update(oldBrandRef, {
            'ProductsCount': FieldValue.increment(-1),
          });
        }

        if (newBrandId != null && oldBrandId != newBrandId) {
          final newBrandRef = _db.collection("Brands").doc(newBrandId);
          transaction.update(newBrandRef, {
            'ProductsCount': FieldValue.increment(1),
          });
        }

        transaction.update(productRef, product.toJson());
      });
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }


  Future<void> updateProductSpecificValue(id, Map<String, dynamic> data) async {
    try{
      await _db.collection("Products").doc(id).update(data);
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try{
      final snapshot = await _db.collection("Products").get();
      return snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<List<ProductCategoryModel>> getProductCategories(String productId) async {
    try{
      final snapshot = await _db.collection("ProductCategory").where('productId', isEqualTo: productId).get();
      return snapshot.docs.map((querySnapshot) => ProductCategoryModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    try {
      await _db.runTransaction((transaction) async {
        final productRef = _db.collection("Products").doc(product.id);
        final productSnap = await transaction.get(productRef);

        if (!productSnap.exists) {
          throw Exception("Không tìm thấy sản phẩm");
        }

        final productCategoriesSnapshot = await _db
            .collection('ProductCategory')
            .where('productId', isEqualTo: product.id)
            .get();

        final productCategories =
        productCategoriesSnapshot.docs.map((e) => ProductCategoryModel.fromSnapshot(e));

        for (var productCategory in productCategories) {
          transaction.delete(_db.collection('ProductCategory').doc(productCategory.id));
        }

        // 2. Trừ productCount trong brand nếu có
        if (product.brand != null && product.brand!.id.isNotEmpty) {
          final brandRef = _db.collection("Brands").doc(product.brand!.id);
          transaction.update(brandRef, {
            'ProductsCount': FieldValue.increment(-1),
          });
        }

        transaction.delete(productRef);
      });
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }


  Future<void> removeProductCategory(String productId, String categoryId) async {
    try{
      final result = await _db.collection("ProductCategory").where('productId', isEqualTo: productId).where('categoryId', isEqualTo: categoryId).get();
      for (final doc in result.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> deductStockAndIncreaseSold(String productId, int quantitySold) async {
    try {
      await _db.runTransaction((transaction) async {
        final productRef = _db.collection('Products').doc(productId);
        final productSnapshot = await transaction.get(productRef);

        if (!productSnapshot.exists) throw Exception("Không tìm thấy sản phẩm");
        final product = ProductModel.fromSnapshot(productSnapshot);

        if (product.stock < quantitySold) {
          throw Exception("Không đủ hàng trong kho để bán");
        }

        transaction.update(productRef, {
          'Stock': product.stock - quantitySold,
          'SoldQuantity': FieldValue.increment(quantitySold),
        });
      });
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }
}