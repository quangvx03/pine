import 'package:flutter/material.dart';
import 'package:pine/utils/constants/sizes.dart';

class PProfileMenu extends StatelessWidget {
  const PProfileMenu({
    super.key,
    this.onPressed,
    required this.title,
    required this.value,
    this.icon,
  });

  final IconData? icon;
  final VoidCallback? onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: PSizes.spaceBtwItems / 1.5),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text(title,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis)),
              Expanded(
                  flex: 5,
                  child: Text(value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis)),
              Expanded(
                child: Icon(icon, size: 18),
              )
            ],
          )),
    );
  }
}
