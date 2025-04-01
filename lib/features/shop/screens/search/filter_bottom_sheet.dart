import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/search_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductSearchController.instance;
    final dark = PHelperFunctions.isDarkMode(context);

    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.lg),
      margin: const EdgeInsets.only(bottom: PSizes.defaultSpace),
      backgroundColor: dark ? PColors.darkerGrey : Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bộ lọc & Sắp xếp',
                    style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwItems),

            /// Categories Filter
            const PSectionHeading(title: 'Danh mục', showActionButton: false),
            const SizedBox(height: PSizes.spaceBtwItems / 2),

            Obx(() => SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (_, index) {
                      final category = controller.categories[index];
                      final isSelected =
                          category == controller.selectedCategory.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: PSizes.sm),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedCategory.value = category;
                            }
                          },
                          backgroundColor:
                              dark ? PColors.darkerGrey : Colors.grey.shade200,
                          selectedColor: PColors.primary.withValues(alpha: 0.2),
                        ),
                      );
                    },
                  ),
                )),

            const SizedBox(height: PSizes.spaceBtwItems),

            /// Brands Filter
            const PSectionHeading(
                title: 'Thương hiệu', showActionButton: false),
            const SizedBox(height: PSizes.spaceBtwItems / 2),

            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedBrand.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.shop),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(PSizes.cardRadiusMd),
                    ),
                  ),
                  items: controller.brands
                      .map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedBrand.value = value;
                    }
                  },
                )),

            const SizedBox(height: PSizes.spaceBtwItems),

            /// Price Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PSectionHeading(
                    title: 'Khoảng giá', showActionButton: false),
                Obx(() => Text(
                      '${formatter.format(controller.minPrice.value)}đ - ${formatter.format(controller.maxPrice.value)}đ',
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwItems / 2),

            Obx(() => RangeSlider(
                  min: 0,
                  max: 10000000,
                  divisions: 100,
                  values: RangeValues(
                      controller.minPrice.value, controller.maxPrice.value),
                  onChanged: (values) {
                    controller.minPrice.value = values.start;
                    controller.maxPrice.value = values.end;
                  },
                  activeColor: PColors.primary,
                  inactiveColor: Colors.grey.withValues(alpha: 0.2),
                )),

            const SizedBox(height: PSizes.spaceBtwItems),

            /// Sort Options
            const PSectionHeading(
                title: 'Sắp xếp theo', showActionButton: false),
            const SizedBox(height: PSizes.spaceBtwItems / 2),
            Obx(() => Wrap(
                  spacing: PSizes.spaceBtwItems / 2,
                  runSpacing: PSizes.spaceBtwItems / 2,
                  children: List.generate(
                    controller.sortOptions.length,
                    (index) {
                      final isSelected = controller.selectedSort.value == index;
                      return ChoiceChip(
                        label: Text(controller.sortOptions[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) controller.selectedSort.value = index;
                        },
                        backgroundColor:
                            dark ? PColors.darkerGrey : Colors.grey.shade200,
                        selectedColor: PColors.primary.withValues(alpha: 0.2),
                      );
                    },
                  ),
                )),

            const SizedBox(height: PSizes.spaceBtwSections),

            /// Apply & Reset Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.resetFilters();
                    },
                    child: const Text('Đặt lại'),
                  ),
                ),
                const SizedBox(width: PSizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.searchProducts();
                      Get.back();
                    },
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Format currency
  static final NumberFormat formatter = NumberFormat('#,###', 'vi_VN');
}
