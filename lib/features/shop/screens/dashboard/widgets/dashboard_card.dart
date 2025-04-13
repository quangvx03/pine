import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/icons/p_circular_icon.dart';
import 'package:pine_admin_panel/common/widgets/texts/section_heading.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';


class PDashboardCard extends StatelessWidget {
  const PDashboardCard(
      {super.key,
      required this.title,
      required this.subTitle,
      this.icon = Iconsax.arrow_up_3,
      this.color = PColors.success,
      required this.stats,
      this.onTap,
      required this.context,
      required this.headingIcon,
      required this.headingIconColor,
      required this.headingIconBgColor});

  final BuildContext context;
  final String title, subTitle;
  final IconData icon, headingIcon;
  final Color color, headingIconColor, headingIconBgColor;
  final int stats;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(PSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PCircularIcon(
                icon: headingIcon,
                backgroundColor: headingIconBgColor,
                color: headingIconColor,
                size: PSizes.md,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              PSectionHeading(title: title, textColor: PColors.textSecondary),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwSections),

          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
