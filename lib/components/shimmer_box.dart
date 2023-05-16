import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final double margin;
  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 10.0,
    this.margin = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.all(margin),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }
}
