import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Reusable AppCard widget providing standardized elevation, border, padding, and tap callbacks.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = 16.0,
    this.elevation = 1.0,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: AppColors.border, width: 0.8),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04 * elevation),
                  blurRadius: 10 * elevation,
                  offset: Offset(0, 3 * elevation),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
