import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/data/repositories/review_repository.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/models/review_model.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final reviewRepository = ReviewRepository.instance;
  final formKey = GlobalKey<FormState>();

  // Controller cho form đánh giá
  final commentController = TextEditingController();
  final RxDouble rating = 0.0.obs;

  // Lưu trữ các sản phẩm đã đánh giá trong đơn hàng hiện tại
  final RxList<String> reviewedProductIds = <String>[].obs;

  // Danh sách sản phẩm có thể đánh giá trong đơn hàng
  final RxList<CartModel> reviewableProducts = <CartModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  // Chuẩn bị dữ liệu cho màn hình đánh giá
  Future<void> prepareForReview(OrderModel order) async {
    try {
      // Lấy user ID hiện tại
      final String userId =
          AuthenticationRepository.instance.authUser?.uid ?? '';

      // Lấy danh sách sản phẩm đã đánh giá trong đơn hàng
      final reviewedProducts =
          await reviewRepository.getReviewedProductsInOrder(userId, order.id);
      reviewedProductIds.assignAll(reviewedProducts);

      // Lọc ra các sản phẩm chưa được đánh giá
      reviewableProducts.assignAll(order.items
          .where((item) => !reviewedProductIds.contains(item.productId)));
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  // Đặt lại form đánh giá
  void resetForm() {
    commentController.clear();
    rating.value = 0.0;
  }

  // Đánh giá sản phẩm
  Future<void> submitReview(CartModel product, String orderId) async {
    if (rating.value == 0) {
      PLoaders.warningSnackBar(
          title: 'Chưa đánh giá',
          message: 'Vui lòng đánh giá sản phẩm (1-5 sao)');
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      PFullScreenLoader.openLoadingDiaLog(
          'Đang gửi đánh giá...', PImages.verify);

      // Lấy thông tin người dùng hiện tại
      final userController = UserController.instance;
      final user = userController.user.value;

      // Tạo ID duy nhất cho đánh giá
      final reviewId = DateTime.now().millisecondsSinceEpoch.toString();

      // Tạo đối tượng ReviewModel với biến thể sản phẩm
      final review = ReviewModel(
        id: reviewId,
        userId: user.id,
        username: '${user.lastName} ${user.firstName}',
        profilePicture: user.profilePicture,
        comment: commentController.text.trim(),
        rating: rating.value,
        productId: product.productId,
        datetime: DateTime.now(),
        orderId: orderId,
        selectedVariation: product.selectedVariation,
      );

      // Lưu đánh giá vào Firestore
      await reviewRepository.saveReview(review);

      // Thêm sản phẩm vào danh sách đã đánh giá
      reviewedProductIds.add(product.productId);

      // Xóa sản phẩm khỏi danh sách có thể đánh giá
      reviewableProducts
          .removeWhere((item) => item.productId == product.productId);

      await Future.delayed(const Duration(milliseconds: 1500));

      PFullScreenLoader.stopLoading();

      // Hiển thị thông báo thành công
      PLoaders.successSnackBar(
          title: 'Thành công', message: 'Cảm ơn bạn đã đánh giá sản phẩm!');

      // Đặt lại form
      resetForm();

      Navigator.of(Get.context!).pop();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  // Lấy tất cả đánh giá cho sản phẩm
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      return await reviewRepository.getProductReviews(productId);
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
      return [];
    }
  }

  // Lấy số lượng đánh giá của sản phẩm
  Future<int> getReviewCount(String productId) async {
    try {
      final reviews = await reviewRepository.getProductReviews(productId);
      return reviews.length;
    } catch (e) {
      return 0;
    }
  }

  // Lấy đánh giá trung bình của sản phẩm
  Future<double> getAverageRating(String productId) async {
    try {
      return await reviewRepository.getAverageRating(productId);
    } catch (e) {
      return 0.0;
    }
  }

  /// Lấy thông tin tóm tắt đánh giá của sản phẩm (cả số lượng và trung bình)
  Future<Map<String, dynamic>> getProductRatingSummary(String productId) async {
    try {
      final reviews = await getProductReviews(productId);
      if (reviews.isEmpty) {
        return {
          'count': 0,
          'average': 0.0,
        };
      }

      final totalRating =
          reviews.fold(0.0, (sum, review) => sum + review.rating);
      final averageRating = totalRating / reviews.length;

      return {
        'count': reviews.length,
        'average': averageRating,
      };
    } catch (e) {
      return {
        'count': 0,
        'average': 0.0,
      };
    }
  }

  final RxString sortOption = 'newest'.obs;
  final RxInt selectedStarFilter = 0.obs;

  void resetFilters() {
    selectedStarFilter.value = 0;
    sortOption.value = 'newest';
  }

// Phương thức lọc đánh giá theo số sao
  void filterByStar(int star) {
    selectedStarFilter.value = star;
  }

// Cập nhật phương thức getSortedProductReviews để hỗ trợ lọc theo sao
  Future<List<ReviewModel>> getSortedProductReviews(String productId) async {
    try {
      final reviews = await reviewRepository.getProductReviews(productId);

      // Lọc theo số sao nếu không phải 0 (tất cả)
      List<ReviewModel> filteredReviews = reviews;
      if (selectedStarFilter.value > 0) {
        filteredReviews = reviews.where((review) {
          final roundedRating = review.rating.round();
          return roundedRating == selectedStarFilter.value;
        }).toList();
      }

      // Sắp xếp theo thời gian
      if (sortOption.value == 'newest') {
        filteredReviews
            .sort((a, b) => b.datetime.compareTo(a.datetime)); // Mới nhất trước
      } else {
        filteredReviews
            .sort((a, b) => a.datetime.compareTo(b.datetime)); // Cũ nhất trước
      }

      return filteredReviews;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
      return [];
    }
  }

// Phương thức lấy số lượng đánh giá cho mỗi sao
  Future<Map<int, int>> getStarCounts(String productId) async {
    try {
      final reviews = await reviewRepository.getProductReviews(productId);
      final Map<int, int> starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      for (final review in reviews) {
        final star = review.rating.round();
        if (star >= 1 && star <= 5) {
          starCounts[star] = (starCounts[star] ?? 0) + 1;
        }
      }

      return starCounts;
    } catch (e) {
      return {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    }
  }

  // Phương thức để thay đổi tùy chọn sắp xếp
  void toggleSortOption() {
    sortOption.value = sortOption.value == 'newest' ? 'oldest' : 'newest';
  }

  // Phương thức lọc từ ngữ không phù hợp khi hiển thị
  String filterProfanity(String text) {
    String filteredText = text;

    for (final word in profanityList) {
      final replacement = '*' * word.length;

      if (word.contains(' ')) {
        // Cụm từ có dấu cách: dùng RegExp.escape để tránh lỗi ký tự đặc biệt
        final pattern = RegExp(
          r'(?<!\w)' + RegExp.escape(word) + r'(?!\w)',
          caseSensitive: false,
          unicode: true,
        );
        filteredText = filteredText.replaceAll(pattern, replacement);
      } else {
        final pattern = RegExp(
          r'(?<![a-zA-ZÀ-ỹà-ỹ0-9])' +
              RegExp.escape(word) +
              r'(?![a-zA-ZÀ-ỹà-ỹ0-9])',
          caseSensitive: false,
          unicode: true,
        );
        filteredText = filteredText.replaceAllMapped(pattern, (match) {
          return replacement;
        });
      }
    }

    return filteredText;
  }

  final List<String> profanityList = [
    'đụ',
    'địt',
    'đm',
    'đéo',
    'lồn',
    'lôn',
    'cặc',
    'cu',
    'buồi',
    'dái',
    'vãi',
    'vcl',
    'vkl',
    'vl',
    'clm',
    'clgt',
    'đít',
    'đĩ',
    'cave',
    'điếm',
    'chó',
    'súc vật',
    'ngu',
    'ngu vcl',
    'óc chó',
    'óc lợn',
    'bố mày',
    'mẹ mày',
    'má mày',
    'dcm',
    'dmm',
    'cc',
    'cứt',
    'rác rưởi',
    'cặn bã',
    'khốn nạn',
    'biến thái',
    'bú cu',
    'bú lol',
    'bú lồn',
    'bú mút',
    'chịch',
    'nứng',
    'thủ dâm',
    'quay tay',
    'làm tình',
    'lên đỉnh',
    'xếp hình',
    'địt mẹ',
    'đụ má',
    'shit',
    'fuck',
    'fucking',
    'bitch',
    'asshole',
    'bastard',
    'dick',
    'cock',
    'pussy',
    'cunt',
    'wtf',
    'damn',
    'hell',
    'motherfucker',
    'slut',
    'whore',
    'jerk',
    'dumbass',
    'suck',
    'sex',
    'porn',
    'xxx',
    'nude',
    'nudes',
    'boobs',
    'tits',
    'nipples',
    'dildo',
    'blowjob',
    'cum',
    'jizz',
    'fap',
    'hentai',
    'anal',
    'orgy',
    'rimjob',
    'pegging',
    'creampie',
    'deepthroat',
    'f*ck',
    'sh!t',
    'b!tch',
    'a\$\$',
    'd!ck',
    's3x',
    'p0rn',
    'v@i',
    'l0n',
    'b**i',
    'đ*̣t',
    'c*c',
    'k*m',
    'n*d3',
    'd@mn',
    'h3ll',
  ];
}
