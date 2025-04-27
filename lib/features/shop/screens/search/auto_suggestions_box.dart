import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/search_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class AutoSuggestionsBox extends StatelessWidget {
  const AutoSuggestionsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductSearchController>();

    return Obx(() {
      final isLoading = controller.isLoadingSuggestions.value;
      final suggestions = controller.autoSuggestions;
      final hasQuery = controller.searchTextController.text.length >= 2;
      final hasSuggestions = suggestions.isNotEmpty;
      final isSearching = controller.isLoading.value;
      final hasSearchResults = controller.searchResults.isNotEmpty;

      // Ẩn gợi ý nếu: không có query, không có gợi ý hoặc đang hiển thị kết quả tìm kiếm
      if (!hasQuery || !hasSuggestions || isSearching || hasSearchResults) {
        return const SizedBox();
      }

      return Container(
        margin: const EdgeInsets.only(top: 8),
        constraints: const BoxConstraints(maxHeight: 300), // Giới hạn chiều cao
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: suggestions.length > 10 ? 10 : suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return InkWell(
                    onTap: () {
                      controller.searchTextController.text = suggestion;
                      controller.searchProducts();
                      controller.autoSuggestions.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          // Icon khác nhau tùy theo loại suggestion
                          _buildSuggestionIcon(suggestion, controller),
                          const SizedBox(width: 12),

                          // Nội dung suggestion
                          Expanded(
                            child: Text(
                              suggestion,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Icon để điền vào ô tìm kiếm
                          IconButton(
                            icon: const Icon(Icons.north_west, size: 16),
                            splashRadius: 20,
                            onPressed: () {
                              controller.searchTextController.text = suggestion;
                              controller.searchTextController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset: controller
                                      .searchTextController.text.length,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }

  Widget _buildSuggestionIcon(
      String suggestion, ProductSearchController controller) {
    if (controller.recentSearches.contains(suggestion)) {
      return const Icon(Iconsax.clock, size: 16, color: Colors.grey);
    } else {
      return const Icon(Iconsax.search_normal, size: 16, color: Colors.grey);
    }
  }
}
