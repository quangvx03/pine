import 'package:flutter/material.dart';
import 'package:pine/utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';

class PRatingProgressIndicator extends StatelessWidget {
  const PRatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: PSizes.xs / 2), // Giảm spacing

        Expanded(
          flex: 1,
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: PColors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(PColors.primary),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
