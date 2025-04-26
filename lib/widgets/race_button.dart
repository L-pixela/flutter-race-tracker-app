import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';

class RaceButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isSelected;

  const RaceButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSelected ? RaceColors.disabled : RaceColors.buttonSecondary;
    final textColor =
        isSelected ? RaceColors.buttonPrimary : RaceColors.buttonPrimary;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(RaceSpacings.radius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(RaceSpacings.radius),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          alignment: Alignment.center,
          child: Text(
            text,
            style: RaceTextStyles.button.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}