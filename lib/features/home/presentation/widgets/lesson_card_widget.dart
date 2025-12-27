import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:english_for_kids/features/learning/domain/entities/topic_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'locked_overlay_widget.dart';
import 'progress_ring_widget.dart';

/// Beautiful, modern lesson card with glassmorphism and lock states
class LessonCardWidget extends StatefulWidget {
  final TopicEntity topic;
  final int index;
  final VoidCallback? onTap;

  const LessonCardWidget({super.key, required this.topic, required this.index, this.onTap});

  @override
  State<LessonCardWidget> createState() => _LessonCardWidgetState();
}

class _LessonCardWidgetState extends State<LessonCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isLocked = widget.topic.isLocked;
    final isCompleted = widget.topic.isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main card with animation
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(scale: _scaleAnimation.value, child: child);
            },
            child: GestureDetector(
              onTap: !isLocked ? widget.onTap : null,
              child: MouseRegion(
                onEnter: (_) => !isLocked ? _onHoverChanged(true) : null,
                onExit: (_) => !isLocked ? _onHoverChanged(false) : null,
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isLocked
                            ? AppColors.grey.withValues(alpha: 0.2)
                            : AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: _isHovered ? 30 : 20,
                        offset: Offset(0, _isHovered ? 12 : 8),
                        spreadRadius: _isHovered ? 4 : 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background image
                      _buildCardBackground(),

                      // Gradient overlay
                      _buildGradientOverlay(),

                      // Content (title, description)
                      _buildContent(context),

                      // Completed badge
                      if (isCompleted && !isLocked) _buildCompletedBadge(),

                      // Lock icon badge
                      if (isLocked) _buildLockBadge(),

                      // Progress indicator for completed lessons
                      if (isCompleted && !isLocked) _buildProgressIndicator(),

                      // Locked overlay (blur + message)
                      if (isLocked) Positioned.fill(child: LockedOverlayWidget()),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lesson number indicator
          _buildLessonNumber(context),
        ],
      ),
    );
  }

  Widget _buildCardBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: widget.topic.thumbnailPath.isNotEmpty
          ? Image.asset(
              widget.topic.thumbnailPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic name
          Text(
            widget.topic.name,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              fontSize: 36,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            widget.topic.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white.withValues(alpha: 0.95),
              fontSize: 16,
              height: 1.4,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              TranslationKeys.completed.tr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockBadge() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.lock_rounded, color: AppColors.grey, size: 20),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Positioned(
      top: 16,
      left: 16,
      child: ProgressRingWidget(progress: 1.0, size: 60, strokeWidth: 6, showPercentage: false),
    );
  }

  Widget _buildLessonNumber(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.topic.isLocked
            ? AppColors.greyLight
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.topic.isLocked
              ? AppColors.grey.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_lesson_rounded,
            color: widget.topic.isLocked ? AppColors.grey : AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${TranslationKeys.lesson.tr} ${widget.index + 1}',
            style: TextStyle(
              color: widget.topic.isLocked ? AppColors.grey : AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.3),
            AppColors.secondaryLight.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: const Center(child: Icon(Icons.school_rounded, size: 100, color: AppColors.primary)),
    );
  }
}
