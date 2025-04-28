import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../features/personalization/models/address_model.dart';
import 'authentication_repository.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try {
      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      throw 'Đã xảy ra lỗi khi lấy thông tin địa chỉ. Vui lòng thử lại sau.';
    }
  }

  Future<void> updateSelectedField(String userId, String addressId, bool selected) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .update({'SelectedAddress': selected});
    } catch (e) {
      throw 'Cập nhật địa chỉ không thành công. Vui lòng thử lại sau.';
    }
  }

  Future<void> addAddress(String userId, AddressModel address) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toJson());
    } catch (e) {
      throw 'Đã xảy ra lỗi trong quá trình lưu thông tin địa chỉ. Vui lòng thử lại sau.';
    }
  }
}
