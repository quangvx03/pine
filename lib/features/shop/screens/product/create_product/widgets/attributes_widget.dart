import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../utils/constants/colors.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: PColors.primaryBackground),
        const SizedBox(height: PSizes.spaceBtwSections),

        Text('Thêm thuộc tính sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: PSizes.spaceBtwItems),

        // Form to add new attribute
        Form(
            child: PDeviceUtils.isDesktopScreen(context)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAttributeName()),
                      const SizedBox(width: PSizes.spaceBtwItems),
                      Expanded(
                        flex: 2,
                          child: _buildAttributeTextField(),
                      ),
                      const SizedBox(width: PSizes.spaceBtwItems),
                      _buildAddAttributeButton(),
                    ],
            )
                : Column(
              children: [
                _buildAttributeName(),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildAttributeTextField(),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildAddAttributeButton(),
              ],
            ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
        
        // List of added attributes
        Text('Tất cả thuộc tính', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: PSizes.spaceBtwItems),

        // Display added attributes in a rounded container
        PRoundedContainer(
          backgroundColor: PColors.primaryBackground,
          child: Column(
            children: [
              buildAttributesList(context),
              buildEmptyAttributes(),
            ],
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
        
        // Generate Variations Button
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              icon: Icon(Iconsax.activity),
              label: const Text('Tạo'),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }

  Column buildEmptyAttributes() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PRoundedImage(width: 150, height: 80, imageType: ImageType.asset, image: PImages.defaultAttributeColorsImageIcon),
          ],
        ),
        SizedBox(height: PSizes.spaceBtwItems),
        Text('Không có thuộc tính nào được thêm vào sản phẩm'),
      ],
    );
  }
  
  ListView buildAttributesList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
        itemBuilder: (_, index) {
          return Container(
            decoration: BoxDecoration(
              color: PColors.white,
              borderRadius: BorderRadius.circular(PSizes.borderRadiusLg),
            ),
            child: ListTile(
              title: const Text('Kích cỡ'),
              subtitle: const Text('Nhỏ, Lớn'),
              trailing: IconButton(onPressed: () {}, icon: const Icon(Iconsax.trash, color: PColors.error)),
            ),
          );
        }, 
        separatorBuilder: (_, __) => const SizedBox(height: PSizes.spaceBtwItems), 
        itemCount: 3
    );
  }

  SizedBox _buildAddAttributeButton() {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: (){},
        icon: const Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: PColors.black,
          backgroundColor: PColors.secondary,
          side: const BorderSide(color: PColors.secondary),
        ),
        label: const Text('Thêm'),
      ),
    );
  }

  // Build text form field for attribute name
  TextFormField _buildAttributeName() {
    return TextFormField(
      validator: (value) => PValidator.validateEmptyText('Tên thuộc tính', value),
      decoration: const InputDecoration(labelText: 'Tên thuộc tính', hintText: 'Màu sắc, Kích cỡ, Chất liệu'),
    );
  }

  // Build text form field for attribute values
  SizedBox _buildAttributeTextField() {
    return SizedBox(
      height: 80,
      child: TextFormField(
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) => PValidator.validateEmptyText('Trường thuộc tính', value),
        decoration: const InputDecoration(
          labelText: 'Thuộc tính',
          hintText: 'Thêm thuộc tính cách nhau bởi "|" Ví dụ: Xanh | Đỏ | Vàng',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
