import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/popups/loaders.dart';

abstract class PBaseController<P> extends GetxController {
  RxBool isLoading = false.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<P> allItems = <P>[].obs;
  RxList<P> filteredItems = <P>[].obs;
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<List<P>> fetchItems();

  Future<void> deleteItem(P item);

  bool containsSearchQuery(P item, String query);

  Future<void> fetchData() async {
    try{
      isLoading.value = true;
      List<P> fetchedItems = [];
      fetchedItems = await fetchItems();
      allItems.assignAll(fetchedItems);
      filteredItems.assignAll(allItems);

    }catch(e){
      isLoading.value = false;
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredItems.assignAll(
        allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  void sortByProperty(int sortColumnIndex, bool ascending, Function(P) property) {
    sortAscending.value = ascending;
    this.sortColumnIndex.value = sortColumnIndex;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
  }

  void addItemToLists(P item) {
    allItems.add(item);
    filteredItems.add(item);
  }

  void updateItemFromLists(P item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if(itemIndex != -1) allItems[itemIndex] = item;
    if(filteredItemIndex != -1) filteredItems[itemIndex] = item;
  }

  void removeItemFromLists(P item) {
    allItems.remove(item);
    filteredItems.remove(item);
  }

  Future<void> confirmAndDeleteItem(P item) async {
    Get.defaultDialog(
        title: 'Xóa mục',
        content: const Text('Bạn có chắc muốn xóa mục này không?'),
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () async => await deleteOnConfirm(item),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius * 5)),
            ),
            child: const Text('Xóa'),
          ),
        ),
        cancel: SizedBox(
          width: 80,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius * 5)),
            ),
            child: const Text('Thoát'),
          ),
        )
    );
  }

  Future<void> deleteOnConfirm(P item) async {
    try{
      PFullScreenLoader.stopLoading();

      PFullScreenLoader.popUpCircular();

      await deleteItem(item);

      removeItemFromLists(item);
      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Đã xóa mục', message: 'Đã xóa mục');
    }catch(e){
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không!', message: e.toString());
    }

  }
}