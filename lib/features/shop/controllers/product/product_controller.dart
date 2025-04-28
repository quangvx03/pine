import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/product_repository.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/features/shop/controllers/order/order_controller.dart';

import '../../../../utils/constants/enums.dart';

class ProductController extends PBaseController<ProductModel> {
  static ProductController get instance => Get.find();

  final _productRepository = Get.put(ProductRepository());
  final _orderController = Get.put(OrderController());
  Rx<int> stock = 0.obs;
  var selectedStockFilter = 'Tất cả'.obs;

  List<String> stockFilterOptions = ['Tất cả', 'Còn hàng', 'Gần hết hàng', 'Hết hàng'];

  void updateProductStock(ProductModel product) {
    stock.value = product.stock;  // Update the stock value
  }

  void filterByStock(String filter) {
    switch (filter) {
      case 'Còn hàng':
        filteredItems.assignAll(allItems.where((item) => item.stock > 10));
        break;
      case 'Gần hết hàng':
        filteredItems.assignAll(allItems.where((item) => item.stock > 0 && item.stock <= 10));
        break;
      case 'Hết hàng':
        filteredItems.assignAll(allItems.where((item) => item.stock == 0));
        break;
      default:
        filteredItems.assignAll(allItems);
    }
  }

  @override
  bool containsSearchQuery(ProductModel item, String query) {
    String lowerCaseQuery = query.trim().toLowerCase();

    return item.title.toLowerCase().contains(lowerCaseQuery) ||
        (item.brand?.name ?? '').toLowerCase().contains(lowerCaseQuery) ||
        item.stock.toString().contains(lowerCaseQuery) ||
        item.price.toString().contains(lowerCaseQuery);
  }


  @override
  Future<void> deleteItem(ProductModel item) async {
    await _productRepository.deleteProduct(item);
  }

  @override
  Future<List<ProductModel>> fetchItems() async {
    return await _productRepository.getAllProducts();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.title.toLowerCase());
  }

  void sortByPrice(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.price);
  }

  void sortByStock(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => getProductStockTotal(product));
  }

  void sortBySoldItems(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.soldQuantity ?? 0);
  }

  String getProductPrice(ProductModel product) {
    if (product.productType == ProductType.single.toString() || product.productVariations == null || product.productVariations!.isEmpty) {
      return (product.salePrice > 0 ? product.salePrice : product.price).toString();
    } else {
      double smallestPrice = double.infinity;
      double largestPrice = 0;

      for (var variation in product.productVariations!) {
        double priceToConsider = variation.salePrice > 0 ? variation.salePrice : variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      if (smallestPrice == largestPrice) {
        return largestPrice.toString();
      } else {
        return '$smallestPrice - $largestPrice đ';
      }
    }
  }

  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0 || originalPrice <= 0) return null;
    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  String getProductStockTotal(ProductModel product) {
    if (product.productVariations != null && product.productVariations!.isNotEmpty) {
      int totalStock = 0;
      for (var variation in product.productVariations!) {
        totalStock += variation.stock ?? 0;
      }
      return totalStock.toString();
    } else {
      return product.stock.toString();
    }
  }


  String getProductStockStatus(ProductModel product) {
    return product.stock > 0 ? 'Còn hàng' : 'Hết hàng';
  }

  int getProductSoldQuantity(ProductModel product) {
    int soldQuantity = 0;

    for (var order in _orderController.allItems) {
      for (var item in order.items) {
        if (item.productId == product.id) {
          soldQuantity += item.quantity;
        }
      }
    }

    return soldQuantity;
  }
}
