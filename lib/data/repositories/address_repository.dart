import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';

import '../../features/personalization/models/address_model.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) {
        throw 'Không tìm thấy thông tin người dùng. Vui lòng thử lại sau vài phút.';
      }

      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();
      return result.docs
          .map((documentSnapshot) =>
              AddressModel.fromDocumentSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Đã xảy ra lỗi khi lấy thông tin địa chỉ. Vui lòng thử lại sau.';
    }
  }

  /// Clear the "selected" field for all addresses
  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
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

  /// Store new user order
  Future<String> addAddress(AddressModel address) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      final currentAddress = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Đã xảy ra lỗi trong quá trình lưu thông tin địa chỉ. Vui lòng thử lại sau.';
    }
  }
}
