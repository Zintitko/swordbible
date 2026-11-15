import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sword_drill/core/theme/app_colors.dart';
import 'package:sword_drill/core/theme/app_theme.dart';
import 'package:sword_drill/core/theme/app_typography.dart';
import 'package:sword_drill/data/models/models.dart';
import 'package:sword_drill/data/seed/questions_bank.dart';
import 'package:sword_drill/features/home/main_shell.dart';
import 'package:sword_drill/features/quiz/question_play_screen.dart';
import 'package:sword_drill/state/app_state.dart';

Future<void> _loadRealFonts() async {
  final projectRoot = '/Users/macbookpro/Documents/Bibble jesus/sword_drill';

  Future<ByteData> readFont(String path) async {
    final bytes = await File(path).readAsBytes();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }

  final displayLoader = FontLoader('DisplayRounded')
    ..addFont(readFont('$projectRoot/assets/fonts/DisplayRoundedBold.ttf'));
  await displayLoader.load();

  final robotoLoader = FontLoader('Roboto')
    ..addFont(readFont('$projectRoot/assets/fonts/BodyRegular.ttf'))
    ..addFont(readFont('$projectRoot/assets/fonts/BodyBold.ttf'))
    ..addFont(readFont('$projectRoot/assets/fonts/BodyItalic.ttf'));
  await robotoLoader.load();

  final iconLoader = FontLoader('MaterialIcons')
    ..addFont(
      readFont(
        '$projectRoot/build/unit_test_assets/fonts/MaterialIcons-Regular.otf',
      ),
    );
  await iconLoader.load();
}

Future<void> captureScreen({
  required WidgetTester tester,
  required Widget child,
  required Size logicalSize,
  required double pixelRatio,
  required String outputPath,
  Future<void> Function(WidgetTester)? afterPump,
}) async {
  final key = GlobalKey();
  tester.view.physicalSize = Size(
    logicalSize.width * pixelRatio,
    logicalSize.height * pixelRatio,
  );
  tester.view.devicePixelRatio = pixelRatio;

  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: ColoredBox(
        color: AppColors.background,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: logicalSize,
              devicePixelRatio: pixelRatio,
              padding: const EdgeInsets.only(top: 48, bottom: 24),
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  if (afterPump != null) {
    await afterPump(tester);
    await tester.pumpAndSettle();
  }

  late Uint8List bytes;
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    bytes = byteData!.buffer.asUint8List();
    final file = File(outputPath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    AppTypography.useSystemFontsForTesting = true;
    await _loadRealFonts();
  });

  testWidgets('Render App Store screenshots for iPhone 6.1, iPad 12.9, and iPhone Duo', (
    WidgetTester tester,
  ) async {
    final baseDir = '/Users/macbookpro/Documents/Bibble jesus/screenshots';
    final appState = AppState();

    // Target configurations:
    // 1. iPhone 6.1" -> 390x844 @ 3x = 1170x2532
    // 2. iPad 12.9" -> 1024x1366 @ 2x = 2048x2732
    // 3. iPhone Duo (2007x2853) -> 669x951 @ 3x = 2007x2853
    final configs = [
      (
        folder: 'iphone_6_1',
        size: const Size(390, 844),
        ratio: 3.0,
      ),
      (
        folder: 'ipad_12_9',
        size: const Size(1024, 1366),
        ratio: 2.0,
      ),
      (
        folder: 'iphone_duo_2007x2853',
        size: const Size(669, 951),
        ratio: 3.0,
      ),
    ];

    for (final cfg in configs) {
      // Screen 1: Home Screen (Daily 5, Free Play, H2H, Family Mode)
      await captureScreen(
        tester: tester,
        logicalSize: cfg.size,
        pixelRatio: cfg.ratio,
        outputPath: '$baseDir/${cfg.folder}/01_home_daily5.png',
        child: MainShell(appState: appState),
      );

      // Screen 2: Active Quiz Question Screen (with answered state & Scripture feedback)
      await captureScreen(
        tester: tester,
        logicalSize: cfg.size,
        pixelRatio: cfg.ratio,
        outputPath: '$baseDir/${cfg.folder}/02_quiz_play.png',
        child: QuestionPlayScreen(
          appState: appState,
          mode: QuizMode.daily5,
          modeTitle: 'Daily 5 Challenge',
          questions: QuestionsBank.getDaily5Questions(),
          showCountdownIntro: false,
        ),
        afterPump: (t) async {
          final optionB = find.text('B');
          if (optionB.evaluate().isNotEmpty) {
            await t.tap(optionB.first);
            await t.pump(const Duration(milliseconds: 250));
          }
        },
      );

      // Screen 3: Free Play Setup (Quizzes Tab with Topic filter open)
      await captureScreen(
        tester: tester,
        logicalSize: cfg.size,
        pixelRatio: cfg.ratio,
        outputPath: '$baseDir/${cfg.folder}/03_free_play_setup.png',
        child: MainShell(appState: appState),
        afterPump: (t) async {
          await t.tap(find.text('Quizzes'));
          await t.pumpAndSettle();
          final topicChip = find.textContaining('Topic');
          if (topicChip.evaluate().isNotEmpty) {
            await t.tap(topicChip.first);
          }
        },
      );

      // Screen 4: Leaderboard (Podium #1, #2, #3 + Standings)
      await captureScreen(
        tester: tester,
        logicalSize: cfg.size,
        pixelRatio: cfg.ratio,
        outputPath: '$baseDir/${cfg.folder}/04_leaderboard.png',
        child: MainShell(appState: appState),
        afterPump: (t) async {
          await t.tap(find.text('Leaderboard'));
        },
      );

      // Screen 5: Profile & Trophy Case
      await captureScreen(
        tester: tester,
        logicalSize: cfg.size,
        pixelRatio: cfg.ratio,
        outputPath: '$baseDir/${cfg.folder}/05_profile_trophies.png',
        child: MainShell(appState: appState),
        afterPump: (t) async {
          await t.tap(find.text('Profile'));
        },
      );
    }
  });
}
