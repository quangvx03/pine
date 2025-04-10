import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:pine/common/widgets/products/ratings/ratings_indicator.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/models/product_variation_model.dart';
import 'package:pine/features/shop/models/review_model.dart';
import 'package:pine/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:pine/features/shop/screens/product_details/widgets/rating.dart';
import 'package:pine/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final variationController = VariationController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetVariations();
    });
  }

  // Reset hoàn toàn các biến thể
  void _resetVariations() {
    variationController.selectedAttributes.clear();
    variationController.selectedVariation.value = ProductVariationModel.empty();
    variationController.variationStockStatus.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isVariableProduct =
        widget.product.productType == ProductType.variable.toString();

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        actions: [
          PFavoriteIcon(productId: widget.product.id),
          PCartCounterIcon(),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: PBottomAddToCart(product: widget.product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            PProductImageSlider(product: widget.product),

            const SizedBox(height: PSizes.spaceBtwItems),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(
                  right: PSizes.defaultSpace,
                  left: PSizes.defaultSpace,
                  bottom: PSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Rating
                  PRating(productId: widget.product.id),
                  const SizedBox(height: PSizes.spaceBtwItems / 2),

                  /// Price, Title & Brand
                  PProductMetaData(product: widget.product),

                  /// Trạng thái tồn kho cho sản phẩm đơn giản
                  if (!isVariableProduct)
                    _buildStockStatus(context, widget.product.stock,
                        widget.product.soldQuantity),

                  /// Attributes (chỉ hiển thị cho sản phẩm biến thể)
                  if (isVariableProduct) ...[
                    PProductAttributes(product: widget.product),
                    const SizedBox(height: PSizes.spaceBtwItems * 1.5),
                  ],

                  /// Description
                  const PSectionHeading(
                      title: 'Mô tả', showActionButton: false),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  ReadMoreText(
                    widget.product.description ?? '',
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' xem thêm',
                    trimExpandedText: ' thu gọn',
                    moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PColors.primary),
                    lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PColors.primary),
                  ),

                  /// Reviews
                  const Divider(),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  Builder(
                    builder: (context) {
                      final ReviewController reviewController =
                          Get.put(ReviewController(), permanent: true);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<double>(
                            future: reviewController
                                .getAverageRating(widget.product.id),
                            builder: (context, ratingSnapshot) {
                              final rating = ratingSnapshot.data ?? 0.0;

                              return FutureBuilder<int>(
                                future: reviewController
                                    .getReviewCount(widget.product.id),
                                builder: (context, countSnapshot) {
                                  final reviewCount = countSnapshot.data ?? 0;

                                  return InkWell(
                                    onTap: () => Get.to(() =>
                                        ProductReviewsScreen(
                                            productId: widget.product.id)),
                                    borderRadius: BorderRadius.circular(
                                        PSizes.borderRadiusSm),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: PSizes.sm),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Tiêu đề "Đánh giá (số lượng)"
                                          Row(
                                            children: [
                                              Text('Đánh giá',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                              const SizedBox(width: PSizes.xs),
                                              Text(
                                                '($reviewCount)',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),

                                          // Điểm trung bình, sao và mũi tên
                                          Row(
                                            children: [
                                              // Điểm trung bình
                                              Text(
                                                rating.toStringAsFixed(1),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: PColors.primary,
                                                    ),
                                              ),
                                              const SizedBox(width: 4),

                                              // Hiển thị sao
                                              SizedBox(
                                                height: 20,
                                                child: PRatingBarIndicator(
                                                  rating: rating,
                                                ),
                                              ),

                                              // Mũi tên
                                              const Icon(
                                                Iconsax.arrow_right_3,
                                                color: PColors.darkGrey,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(height: PSizes.sm),

                          // Tiếp tục hiển thị các bình luận
                          FutureBuilder<List<ReviewModel>>(
                            future: reviewController
                                .getSortedProductReviews(widget.product.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: PSizes.md),
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.message_question,
                                          size: 18, color: Colors.grey),
                                      const SizedBox(width: PSizes.sm),
                                      Text(
                                        'Chưa có đánh giá nào cho sản phẩm này',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Colors.grey.shade600,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // Lấy tối đa 2 bình luận mới nhất
                              final reviews = snapshot.data!;
                              final displayedReviews = reviews.length > 2
                                  ? reviews.sublist(0, 2)
                                  : reviews;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: displayedReviews
                                    .map((review) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: PSizes.spaceBtwItems),
                                          child: UserReviewCard(review: review),
                                        ))
                                    .toList(),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị trạng thái tồn kho
  Widget _buildStockStatus(BuildContext context, int stock, int soldQuantity) {
    final productController = ProductController.instance;

    // Sử dụng phương thức từ controller để kiểm tra trạng thái tồn kho
    final isInStock = productController.isProductInStock(stock, soldQuantity);
    final stockStatus =
        productController.getFormattedStockStatus(stock, soldQuantity);

    return Container(
      margin: const EdgeInsets.only(bottom: PSizes.spaceBtwSections),
      padding: const EdgeInsets.symmetric(
          horizontal: PSizes.md, vertical: PSizes.sm),
      decoration: BoxDecoration(
        color: isInStock
            ? PColors.info.withValues(alpha: 0.1)
            : PColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PSizes.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon trạng thái
          Icon(
            isInStock ? Icons.check_circle : Icons.cancel,
            color: isInStock ? PColors.info : PColors.error,
            size: 18,
          ),

          const SizedBox(width: PSizes.sm),

          // Văn bản trạng thái
          Text(
            stockStatus,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isInStock ? PColors.info : PColors.error,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
