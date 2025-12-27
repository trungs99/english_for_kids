import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Hero header widget displaying greeting and statistics
class HeroHeaderWidget extends StatelessWidget {
  final String title;
  final int completedLessons;
  final int totalLessons;
  final int currentStreak;

  const HeroHeaderWidget({
    super.key,
    required this.title,
    this.completedLessons = 0,
    this.totalLessons = 0,
    this.currentStreak = 0,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return TranslationKeys.goodMorning.tr;
    } else if (hour < 17) {
      return TranslationKeys.goodAfternoon.tr;
    } else {
      return TranslationKeys.goodEvening.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            _getGreeting(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // Main title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 16),

          // Statistics row
          if (totalLessons > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress stat
                _StatCard(
                  icon: Icons.school_rounded,
                  label: TranslationKeys.progress.tr,
                  value: '$completedLessons/$totalLessons',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),

                // Streak stat
                if (currentStreak > 0)
                  _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    label: TranslationKeys.streak.tr,
                    value: '$currentStreak ${TranslationKeys.days.tr}',
                    color: AppColors.secondary,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
