import 'package:flutter/material.dart';
import 'shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    Key? key,
    required this.child,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;

  @override
  _ShimmerLoadingState createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  final shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    final shimmer = Shimmer.of(context);
    print(shimmer);
    if (shimmer?.isSized == null || shimmer!.isSized == false)
      return const SizedBox();
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinSimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinSimmer.dx,
            -offsetWithinSimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      blendMode: BlendMode.srcATop,
      child: widget.child,
    );
  }
}
