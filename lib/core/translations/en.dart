import 'translation_keys.dart';

final Map<String, String> en = {
  // App General
  TranslationKeys.appName: 'Kids English',

  // Splash Screen
  TranslationKeys.loading: 'Loading...',
  TranslationKeys.welcome: 'Welcome to Kids English!',

  // Home Screen
  TranslationKeys.homeTitle: 'Learn English with Fun!',
  TranslationKeys.startLearning: 'Start Learning',
  TranslationKeys.myProgress: 'My Progress',

  // Learning Screen
  TranslationKeys.findTheObject: 'Find the object!',
  TranslationKeys.pointCameraAt: 'Point your camera at a',
  TranslationKeys.greatJob: 'Great Job! 🎉',
  TranslationKeys.tryAgain: 'Try Again',
  TranslationKeys.nextLesson: 'Next Lesson',
  TranslationKeys.backToHome: 'Back to Home',

  // AR Game
  TranslationKeys.arGameTitle: 'AR Game',
  TranslationKeys.findObject: 'Find a @word!',
  TranslationKeys.skipButton: 'Skip',
  TranslationKeys.skipStepMessage:
      'You can skip this step and continue learning',
  TranslationKeys.correctMessage: 'Great job! You found the @word!',
  TranslationKeys.cameraInitError: 'Failed to initialize camera',
  TranslationKeys.testArGame: 'Test AR Game',

  // Speech Game
  TranslationKeys.speechGameTitle: 'Speech Game',
  TranslationKeys.sayTheWord: 'Say the word:',
  TranslationKeys.listening: 'Listening...',
  TranslationKeys.speechSuccess: 'Great job! You said "@word" correctly!',
  TranslationKeys.speechTryAgain: 'Tap the microphone to start',
  TranslationKeys.testSpeechGame: 'Test Speech Game',

  // Lessons
  TranslationKeys.lessonApple: 'Apple',
  TranslationKeys.lessonBottle: 'Bottle',
  TranslationKeys.lessonCup: 'Cup',
  TranslationKeys.lessonDesk: 'Desk',
  TranslationKeys.lessonEar: 'Ear',

  // Common
  TranslationKeys.yes: 'Yes',
  TranslationKeys.no: 'No',
  TranslationKeys.ok: 'OK',
  TranslationKeys.cancel: 'Cancel',

  // Errors
  TranslationKeys.errorCameraPermission:
      'Camera permission is required to play',
  TranslationKeys.errorCameraNotAvailable:
      'Camera is not available on this device',
  TranslationKeys.errorTitle: 'Error',
  TranslationKeys.errorMissingArgs: 'Missing arguments',
  TranslationKeys.errorCameraInitDetail: 'Camera initialization failed: @error',
  TranslationKeys.errorMLKitInitDetail: 'ML Kit initialization failed: @error',
  TranslationKeys.errorMicrophonePermission:
      'Microphone permission is required to play',
  TranslationKeys.errorMicrophoneNotAvailable:
      'Microphone is not available on this device',
  TranslationKeys.errorGeneric: 'Something went wrong. Please try again.',
};
