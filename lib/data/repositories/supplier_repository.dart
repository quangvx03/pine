import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:pine_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:pine_admin_panel/utils/exceptions/platform_exceptions.dart';

import '../../features/shop/models/supplier_model.dart';
import '../../features/shop/models/supplier_product_model.dart';

class SupplierRepository extends GetxController {
  static SupplierRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<SupplierModel>> getAllSuppliers() async {
    try {
      final snapshot = await _db.collection("Suppliers").orderBy("createdAt", descending: true).get();
      final result = snapshot.docs.map((doc) => SupplierModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<String> createPurchaseOrder(SupplierModel supplier) async {
    try {
      final data = await _db.collection("Suppliers").add(supplier.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> updatePurchaseOrder(SupplierModel supplier) async {
    try {
      await _db.collection("Suppliers").doc(supplier.id).update(supplier.toJson());
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> deletePurchaseOrder(String id) async {
    try {
      await _db.collection("Suppliers").doc(id).delete();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<List<SupplierProductModel>> fetchSupplierProducts(String supplierId) async {
    try {
      final doc = await _db.collection("Suppliers").doc(supplierId).get();

      if (!doc.exists) throw 'Không tìm thấy nhà cung cấp.';

      final data = doc.data();
      if (data == null || data['products'] == null) return [];

      final productsJson = List<Map<String, dynamic>>.from(data['products']);
      return productsJson.map((item) => SupplierProductModel.fromJson(item)).toList();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra khi tải sản phẩm. Vui lòng thử lại.';
    }
  }
}
