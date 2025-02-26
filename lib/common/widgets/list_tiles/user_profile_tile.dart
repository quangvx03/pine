import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/circular_image.dart';

class PUserProfileTile extends StatelessWidget {
  const PUserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PCircularImage(
        image: PImages.user,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text('Người dùng Pine',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: PColors.white)),
      subtitle: Text(
        'userpine@gmail.com',
        style:
            Theme.of(context).textTheme.bodyMedium!.apply(color: PColors.white),
      ),
      trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Iconsax.edit,
            color: PColors.white,
          )),
    );
  }
}
