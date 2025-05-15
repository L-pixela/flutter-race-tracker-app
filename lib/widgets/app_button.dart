import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';

enum ButtonType { primary, secondary, disabled, red }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool fullWidth;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.fullWidth = false,
    this.height,
  });

  bool get isPrimary => type == ButtonType.primary;
  bool get isSecondary => type == ButtonType.secondary;
  bool get isDisabled => type == ButtonType.disabled;
  bool get isRed => type == ButtonType.red;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isPrimary
        ? RaceColors.primary
        : isSecondary
            ? RaceColors.white
            : isRed
                ? Colors.red
                : RaceColors.lightGrey.withOpacity(0.5);

    final Color borderColor = isPrimary || isRed
        ? Colors.transparent
        : isSecondary
            ? RaceColors.lightGrey
            : Colors.transparent;

    final Color textColor = isPrimary || isRed
        ? RaceColors.white
        : isSecondary
            ? RaceColors.primary
            : RaceColors.disabled;

    final BorderSide border =
        BorderSide(color: borderColor, width: isSecondary ? 2 : 0);

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RaceSpacings.radius),
          ),
          side: border,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: RaceTextStyles.button.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
