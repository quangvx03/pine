import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../containers/circular_container.dart';

/// A customized choice chip that can act like a radio button.
class PChoiceChip extends StatelessWidget {
  /// Create a chip that acts like a radio button.
  ///
  /// Parameters:
  ///   - text: The label text for the chip.
  ///   - selected: Whether the chip is currently selected.
  ///   - onSelected: Callback function when the chip is selected.
  const PChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Use a transparent canvas color to match the existing styling.
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        // Use this function to get Colors as a Chip
        avatar: PHelperFunctions.getColor(text) != null
            ? PCircularContainer(width: 50, height: 50, backgroundColor: PHelperFunctions.getColor(text)!)
            : null,
        selected: selected,
        onSelected: onSelected,
        backgroundColor: PHelperFunctions.getColor(text),
        labelStyle: TextStyle(color: selected ? PColors.white : null),
        shape: PHelperFunctions.getColor(text) != null ? const CircleBorder() : null,
        label: PHelperFunctions.getColor(text) == null ? Text(text) : const SizedBox(),
        padding: PHelperFunctions.getColor(text) != null ? const EdgeInsets.all(0) : null,
        labelPadding: PHelperFunctions.getColor(text) != null ? const EdgeInsets.all(0) : null,
      ),
    );
  }
}
