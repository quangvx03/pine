import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/screens/sub_category/sub_categories.dart';
import 'package:pine/utils/constants/colors.dart';
import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class PHomeCategories extends StatelessWidget {
  const PHomeCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: PSizes.spaceBtwItems),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: PSizes.spaceBtwItems,
        crossAxisSpacing: PSizes.spaceBtwItems / 2,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (_, index) {
        return PVerticalImageText(
          backgroundColor: PColors.primary.withValues(alpha: 0.125),
          image: PImages.shoeIcon,
          title: 'Mã giảm giá ádajfkhyaskdanjskhduiahsjdkasndkjah',
          textColor: PColors.textPrimary,
          onTap: () => Get.to(() => const SubCategoriesScreen()),
        );
      },
    );
  }
}