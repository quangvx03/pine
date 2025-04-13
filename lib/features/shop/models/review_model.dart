import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String username;
  final String profilePicture;
  final String comment;
  final double rating;
  final String productId;
  final DateTime datetime;
  final String orderId;
  final Map<String, String>? selectedVariation;
  String? productTitle;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.profilePicture,
    required this.comment,
    required this.rating,
    required this.productId,
    required this.datetime,
    required this.orderId,
    this.selectedVariation,
    this.productTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'profilePicture': profilePicture,
      'comment': comment,
      'rating': rating,
      'productId': productId,
      'datetime': datetime,
      'orderId': orderId,
      'selectedVariation': selectedVariation,
    };
  }

  factory ReviewModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ReviewModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      comment: data['comment'] ?? '',
      rating: (data['rating'] is double)
          ? data['rating']
          : (data['rating'] as num?)?.toDouble() ?? 0.0,
      productId: data['productId'] ?? '',
      datetime: data['datetime'] is Timestamp
          ? (data['datetime'] as Timestamp).toDate()
          : DateTime.now(),
      orderId: data['orderId'] ?? '',
      selectedVariation: data['selectedVariation'] != null
          ? Map<String, String>.from(data['selectedVariation'])
          : null,
    );
  }

  // Tạo một bản sao của ReviewModel với các thuộc tính mới
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? profilePicture,
    String? comment,
    double? rating,
    String? productId,
    DateTime? datetime,
    String? orderId,
    Map<String, String>? selectedVariation,
    String? productTitle,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      productId: productId ?? this.productId,
      datetime: datetime ?? this.datetime,
      orderId: orderId ?? this.orderId,
      selectedVariation: selectedVariation ?? this.selectedVariation,
      productTitle: productTitle ?? this.productTitle,
    );
  }
}