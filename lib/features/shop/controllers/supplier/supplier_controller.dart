import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/supplier_repository.dart';
import '../../models/supplier_model.dart';

class SupplierController extends PBaseController<SupplierModel> {
  static SupplierController get instance => Get.find();

  final SupplierRepository _repository = Get.put(SupplierRepository());

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }


  @override
  bool containsSearchQuery(SupplierModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(SupplierModel item) async {
    await _repository.deletePurchaseOrder(item.id);
  }

  @override
  Future<List<SupplierModel>> fetchItems() async {
    sortAscending.value = false;
    return await _repository.getAllSuppliers();
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (SupplierModel o) => o.createdAt.toString().toLowerCase());
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (SupplierModel supplier) {
      return supplier.name.toLowerCase();
    });
  }

}
