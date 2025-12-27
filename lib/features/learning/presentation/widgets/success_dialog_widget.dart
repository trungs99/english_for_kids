import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dialog to show when object is found
class SuccessDialogWidget extends StatelessWidget {
  final String vocabWord;
  final VoidCallback onNext;

  const SuccessDialogWidget({
    super.key,
    required this.vocabWord,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('🎉'),
        content: Text(
          TranslationKeys.correctMessage.trParams({'word': vocabWord}),
        ),
        actions: [
          TextButton(
            onPressed: onNext,
            child: Text(TranslationKeys.nextLesson.tr),
          ),
        ],
      ),
    );
  }
}
