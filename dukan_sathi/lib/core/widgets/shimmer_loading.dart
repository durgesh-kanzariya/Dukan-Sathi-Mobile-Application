import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable Shimmer Loading placeholder widget for lists, cards, and grid skeletons.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
  });

  /// Factory helper generating skeleton placeholders for list views
  static Widget listTilePlaceholder({int itemCount = 4}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            const ShimmerLoading(width: 56, height: 56, borderRadius: 14),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerLoading(width: double.infinity, height: 16, borderRadius: 6),
                  SizedBox(height: 8),
                  ShimmerLoading(width: 120, height: 12, borderRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Factory helper generating skeleton placeholders for product & shop grids
  static Widget gridPlaceholder({int itemCount = 6}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(child: ShimmerLoading(width: double.infinity, height: double.infinity, borderRadius: 16)),
          SizedBox(height: 8),
          ShimmerLoading(width: 100, height: 14, borderRadius: 4),
          SizedBox(height: 4),
          ShimmerLoading(width: 60, height: 12, borderRadius: 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
