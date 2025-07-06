import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class BouncingActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color? iconColor;
  final IconData icon;
  final double? iconSize;
  final double? radius;
  final bool useLiquidGlass;
  final double opacity;

  const BouncingActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
    this.iconSize,
    this.radius,
    this.useLiquidGlass = false,
    this.opacity = 0.7,
  });

  @override
  State<BouncingActionButton> createState() => _BouncingActionButtonState();
}

class _BouncingActionButtonState extends State<BouncingActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.7,
      upperBound: 1.0,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.value = 1.0;
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = widget.radius ?? 60.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.useLiquidGlass ? liquidButton(radius) : button(radius),
      ),
    );
  }

  Widget liquidButton(double radius) {
    return LiquidGlass(
      //blur: 10,
      settings: const LiquidGlassSettings(
        ambientStrength: 2,
        lightAngle: 0.4 * math.pi,
        glassColor: Colors.black12,
        thickness: 30,
      ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: Radius.circular(radius),
      ),
      glassContainsChild: false,
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.iconSize ?? 20,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }

  Widget button(double radius) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: widget.opacity),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.iconSize ?? 20,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}