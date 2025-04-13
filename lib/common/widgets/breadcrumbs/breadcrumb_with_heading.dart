import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/texts/page_heading.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class PBreadcrumbsWithHeading extends StatelessWidget {
  const PBreadcrumbsWithHeading({
    super.key,
    required this.heading,
    required this.breadcrumbItems,
    this.returnToPreviousScreen = false,
  });

  final String heading;
  final List<dynamic> breadcrumbItems;
  final bool returnToPreviousScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: _navigateToDashboard,
              child: Padding(
                padding: const EdgeInsets.all(PSizes.xs),
                child: Text(
                  'Bảng điều khiển',
                  style: Theme.of(context).textTheme.bodySmall!.apply(fontWeightDelta: -1),
                ),
              ),
            ),
            for (int i = 0; i < breadcrumbItems.length; i++)
              Row(
                children: [
                  const Text(' / '),
                  _buildBreadcrumbItem(breadcrumbItems[i], i == breadcrumbItems.length - 1),
                ],
              ),
          ],
        ),
        const SizedBox(height: PSizes.sm),
        Row(
          children: [
            if (returnToPreviousScreen) ...[
              IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
              const SizedBox(width: PSizes.spaceBtwItems),
            ],
            PPageHeading(heading: heading),
          ],
        )
      ],
    );
  }

  void _navigateToDashboard() {
    final role = GetStorage().read('userRole') ?? 'staff';
    final route = role == 'admin' ? PRoutes.dashboard : PRoutes.staffDashboard;
    Get.offAllNamed(route);
  }

  Widget _buildBreadcrumbItem(dynamic item, bool isLast) {
    if (item is String) {
      return Text(
        capitalize(item),
        style: Get.textTheme.bodySmall!.apply(fontWeightDelta: -1),
      );
    } else if (item is Map<String, String> && item.containsKey('label') && item.containsKey('path')) {
      return InkWell(
        onTap: isLast ? null : () => Get.toNamed(item['path']!),
        child: Padding(
          padding: const EdgeInsets.all(PSizes.xs),
          child: Text(
            item['label']!,
            style: Get.textTheme.bodySmall!.apply(fontWeightDelta: -1),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  String capitalize(String s) {
    return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  }
}
