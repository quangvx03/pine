import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../models/review_model.dart';

class ReviewController extends PBaseController<ReviewModel> {
  static ReviewController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final selectedStar = 0.obs;

  @override
  Future<List<ReviewModel>> fetchItems() async {
    try {
      final snapshot = await _db.collection("Reviews").get();

      List<ReviewModel> reviews = [];

      for (final doc in snapshot.docs) {
        final review = ReviewModel.fromSnapshot(doc);

        String? productTitle;
        try {
          final productDoc = await _db.collection("Products").doc(review.productId).get();
          productTitle = productDoc.data()?['Title'] ?? 'Không rõ';
        } catch (e) {
          productTitle = 'Không rõ';
        }

        final reviewWithTitle = review.copyWith(productTitle: productTitle);

        reviews.add(reviewWithTitle);
      }

      return reviews;
    } catch (e) {
      PLoaders.errorSnackBar(title: "Lỗi", message: "Không thể tải đánh giá");
      return [];
    }
  }

  @override
  bool containsSearchQuery(ReviewModel item, String query) {
    final lowerQuery = query.toLowerCase();
    return item.username.toLowerCase().contains(lowerQuery) ||
        item.comment.toLowerCase().contains(lowerQuery);
  }

  void filterByStar() {
    final query = searchTextController.text.toLowerCase();
    final results = allItems.where((review) {
      final matchesQuery = review.username.toLowerCase().contains(query) ||
          review.comment.toLowerCase().contains(query);
      final matchesStar = selectedStar.value == 0 ||
          review.rating.floor() == selectedStar.value;
      return matchesQuery && matchesStar;
    }).toList();

    filteredItems.assignAll(results);
  }

  @override
  void searchQuery(String query) {
    filterByStar();
  }

  @override
  Future<void> deleteItem(ReviewModel item) async {
    try {
      await _db.collection("Reviews").doc(item.id).delete();
      PLoaders.successSnackBar(title: "Thành công", message: "Đã xóa đánh giá");
    } catch (e) {
      PLoaders.errorSnackBar(title: "Lỗi", message: "Không thể xóa đánh giá");
    }
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ReviewModel o) => o.datetime.toString().toLowerCase());
  }

  void sortByUsername(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ReviewModel review) {
      return review.username.toLowerCase();
    });
  }

}
