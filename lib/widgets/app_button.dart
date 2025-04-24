import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';

enum ButtonType { primary, secondary }

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

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == ButtonType.primary;

    final Color backgroundColor =
        isPrimary ? RaceColors.primary : RaceColors.white;
    final Color borderColor =
        isPrimary ? Colors.transparent : RaceColors.lightGrey;
    final Color textColor = isPrimary ? RaceColors.white : RaceColors.primary;
    final Color iconColor = textColor;

    final BorderSide border = BorderSide(color: borderColor, width: 2);

    List<Widget> children = [];

    if (icon != null) {
      children.add(Icon(icon, size: 20, color: iconColor));
    }

    children.add(
      Text(
        text,
        style: RaceTextStyles.button.copyWith(color: textColor),
      ),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RaceSpacings.radius),
          ),
          side: border,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
