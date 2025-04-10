import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine/features/shop/models/review_model.dart';

class ReviewRepository {
  static final ReviewRepository instance = ReviewRepository._internal();

  ReviewRepository._internal();

  factory ReviewRepository() => instance;

  // Tham chiếu đến collection 'Reviews'
  final _reviewsRef = FirebaseFirestore.instance.collection('Reviews');

  // Lưu đánh giá mới vào Firestore
  Future<void> saveReview(ReviewModel review) async {
    await _reviewsRef.doc(review.id).set(review.toJson());
  }

  // Kiểm tra xem người dùng đã đánh giá sản phẩm này trong đơn hàng chưa
  Future<bool> hasUserReviewedProduct(
      String userId, String productId, String orderId) async {
    final querySnapshot = await _reviewsRef
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .where('orderId', isEqualTo: orderId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Lấy các sản phẩm đã được đánh giá trong một đơn hàng
  Future<List<String>> getReviewedProductsInOrder(
      String userId, String orderId) async {
    final querySnapshot = await _reviewsRef
        .where('userId', isEqualTo: userId)
        .where('orderId', isEqualTo: orderId)
        .get();

    return querySnapshot.docs
        .map((doc) => (doc.data())['productId'] as String)
        .toList();
  }

  // Lấy tất cả đánh giá của một sản phẩm
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final querySnapshot = await _reviewsRef
        .where('productId', isEqualTo: productId)
        .orderBy('datetime', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ReviewModel.fromSnapshot(doc))
        .toList();
  }

  // Lấy đánh giá trung bình của sản phẩm
  Future<double> getAverageRating(String productId) async {
    final reviews = await getProductReviews(productId);
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
}
