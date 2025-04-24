// lib/widgets/race_button.dart

import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';

class RaceButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const RaceButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RaceSpacings.radius),
      child: Material(
        color: RaceColors.buttonSecondary,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: Text(
              text,
              style: RaceTextStyles.button.copyWith(
                color: RaceColors.buttonPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
