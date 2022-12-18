import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({
    super.key,
    required this.controller,
    this.child,
  })  : opacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: controller, curve: const Interval(0, 0.1)),
        ),
        width = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: controller, curve: const Interval(0, 0.1)),
        ),
        height = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: controller, curve: const Interval(0, 0.1)),
        ),
        padding = Tween<EdgeInsets>(
          begin: EdgeInsets.zero,
          end: const EdgeInsets.only(bottom: 50),
        ).animate(
          CurvedAnimation(parent: controller, curve: const Interval(0, 0.1)),
        );

  final Widget? child;
  final AnimationController controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Container(
        padding: padding.value,
        child: Opacity(
          opacity: opacity.value,
          child: SizedBox(
            width: width.value,
            height: height.value,
            child: child,
          ),
        ),
      ),
      child: child,
    );
  }
}
