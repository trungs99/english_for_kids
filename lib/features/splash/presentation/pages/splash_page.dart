import 'package:english_for_kids/gen/assets.gen.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends BaseView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.splashLogo.image(
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          Text(
            TranslationKeys.appName.tr,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            TranslationKeys.loading.tr,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }
}
