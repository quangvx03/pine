

import 'dart:convert';

import 'package:get/get.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/local_storage/storage_utility.dart';
import 'package:pine/utils/popups/loaders.dart';

class FavoritesController extends GetxController{
  static FavoritesController get instance => Get.find();

  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  /// Method to initialize favorites by reading from storage
  Future<void> initFavorites() async{
    final json = PLocalStorage.instance().readData('favorites');
    if(json != null){
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavorite(String productId){
    return favorites[productId] ?? false;
  }

  void toggleFavoriteProduct(String productId){
    if(!favorites.containsKey(productId)){
      favorites[productId] = true;
      saveFavoritesToStorage();
      PLoaders.customToast(message: 'Đã thêm sản phẩm vào Yêu thích.');
    } else{
      PLocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      PLoaders.customToast(message: 'Đã xoá sản phẩm khỏi Yêu thích.');
    }
  }

  void saveFavoritesToStorage(){
    final encodedFavorites = json.encode(favorites);
    PLocalStorage.instance().saveData('favorites', encodedFavorites);
  }

  Future<List<ProductModel>> favoriteProducts() async{
    return await ProductRepository.instance.getFavoriteProducts(favorites.keys.toList());
  }
}