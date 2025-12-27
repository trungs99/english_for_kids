import 'package:flutter/material.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';

/// Animated page indicator widget for carousel navigation
class PageIndicatorWidget extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color? activeColor;
  final Color? inactiveColor;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;

  const PageIndicatorWidget({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
    this.activeWidth = 24,
    this.inactiveWidth = 8,
    this.height = 8,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => _PageIndicatorDot(
          isActive: currentIndex == index,
          activeColor: activeColor ?? AppColors.primary,
          inactiveColor: inactiveColor ?? AppColors.textSecondary,
          activeWidth: activeWidth,
          inactiveWidth: inactiveWidth,
          height: height,
          spacing: spacing,
        ),
      ),
    );
  }
}

class _PageIndicatorDot extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;

  const _PageIndicatorDot({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeWidth,
    required this.inactiveWidth,
    required this.height,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? activeWidth : inactiveWidth,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: spacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: isActive ? activeColor : inactiveColor,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
