import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/vocabulary_entity.dart';
import 'animated_magnifying_icon_widget.dart';

/// Widget to display the target word to find with image
class TargetDisplayWidget extends StatelessWidget {
  final VocabularyEntity vocabulary;
  final Function() skipGame;

  const TargetDisplayWidget({
    super.key,
    required this.vocabulary,
    required this.skipGame,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                height: 100,
                width: 100,
                child: const AnimatedMagnifyingIconWidget(
                  width: 100,
                  height: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    TranslationKeys.pointCameraAt.tr,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vocabulary.word.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 20),
                  MButton.text(
                    borderRadius: BorderRadius.circular(100),
                    onPressed: skipGame,
                    child: Text(TranslationKeys.skipButton.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
