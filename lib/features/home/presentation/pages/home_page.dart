import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class HomePage extends BaseView<HomeController> {
  const HomePage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(titleText: TranslationKeys.homeTitle.tr);
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: AppColors.primary),
            const SizedBox(height: 32),
            Text(
              TranslationKeys.homeTitle.tr,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            MButton.elevated(
              onPressed: controller.navigateToLearning,
              child: Text(TranslationKeys.startLearning.tr),
            ),
            const SizedBox(height: 16),
            MButton.elevated(
              onPressed: () {
                // Progress feature will be implemented later
              },
              child: Text(TranslationKeys.myProgress.tr),
            ),
          ],
        ),
      ),
    );
  }
}
