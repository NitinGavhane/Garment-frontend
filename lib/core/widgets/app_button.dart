import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
    this.color,
    this.textColor,
    this.width,
    this.height = 52,
    this.icon,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;
    final foregroundColor = textColor ?? (isOutline ? buttonColor : AppColors.white);

    Widget child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            ),
          if (isLoading && (icon != null || label.isNotEmpty))
            const SizedBox(width: 12),
          if (icon != null && !isLoading) ...[
            Icon(icon, size: 20),
            if (label.isNotEmpty) const SizedBox(width: 8),
          ],
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: foregroundColor,
              ),
            ),
        ],
      ),
    );

    if (isOutline) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            side: BorderSide(color: buttonColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color ?? AppColors.divider,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: size * 0.45,
          ),
        ),
      ),
    );
  }
}
