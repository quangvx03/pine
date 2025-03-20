import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand label
          Text('Thương hiệu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // TypeAheadField for brand selection
          TypeAheadField(
            builder: (context, ctr, focusNode) {
              return TextFormField(
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Chọn thương hiệu',
                  suffixIcon: Icon(Iconsax.box),
                ),
              );
            },
              itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion.name));
              },
              onSelected: (suggestion) {},
              suggestionsCallback: (pattern) {
              // Return filtered brand suggestions based on the search pattern
                return [
                  BrandModel(id: 'id', image: PImages.cocacolaLogo, name: 'Coca Cola'),
                  BrandModel(id: 'id', image: PImages.cocacolaLogo, name: 'Pepsi'),
                ];
              }
          )
        ],
      ),
    );
  }
}
