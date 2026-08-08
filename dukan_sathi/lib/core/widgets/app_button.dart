import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum AppButtonType { primary, secondary, outlined, text, danger }

/// Reusable atomic Button widget supporting multiple variants and loading states.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height = 52,
    this.padding,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = (isLoading || isDisabled) ? null : onPressed;

    Widget childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(context),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );

    switch (type) {
      case AppButtonType.primary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryEmerald,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: childContent,
          ),
        );

      case AppButtonType.secondary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentMintLight,
              foregroundColor: AppColors.primaryEmerald,
              elevation: 0,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: childContent,
          ),
        );

      case AppButtonType.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryEmerald,
              side: const BorderSide(color: AppColors.primaryEmerald, width: 1.5),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: childContent,
          ),
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryEmerald,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: childContent,
        );

      case AppButtonType.danger:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: childContent,
          ),
        );
    }
  }

  Color _getLoadingColor(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.secondary:
      case AppButtonType.outlined:
      case AppButtonType.text:
        return AppColors.primaryEmerald;
    }
  }
}
