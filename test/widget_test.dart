import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sword_bible/core/theme/app_typography.dart';
import 'package:sword_bible/core/utils/scoring_utils.dart';
import 'package:sword_bible/main.dart';
import 'package:sword_bible/state/app_state.dart';

void main() {
  setUpAll(() {
    AppTypography.useSystemFontsForTesting = true;
  });

  test('Scoring formula matches sword drill™ base + speed bonus spec', () {
    // Level 1 base = 200, 50% time remaining = +100 speed bonus -> 300 total
    final l1Score = ScoringUtils.calculateQuestionScore(
      isCorrect: true,
      difficulty: 1,
      elapsedMs: 15000,
      totalTimeMs: 30000,
    );
    expect(l1Score.base, 200);
    expect(l1Score.speedBonus, 100);
    expect(l1Score.total, 300);

    // Wrong answer = 0 points
    final wrongScore = ScoringUtils.calculateQuestionScore(
      isCorrect: false,
      difficulty: 3,
      elapsedMs: 5000,
      totalTimeMs: 60000,
    );
    expect(wrongScore.total, 0);
  });

  testWidgets('SwordDrillApp renders Onboarding, Home, tabs, Daily 5', (
    WidgetTester tester,
  ) async {
    final appState = AppState();
    await tester.pumpWidget(SwordDrillApp(appState: appState));
    await tester.pumpAndSettle();

    // First launch shows Onboarding; tap Skip to enter Home
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Verify Home screen cards
    expect(find.textContaining('Today\'s Daily 5'), findsOneWidget);
    expect(find.textContaining('FREE PLAY'), findsOneWidget);
    expect(find.textContaining('Sword Bible: Drill Trivia'), findsOneWidget);

    // Navigate to Quizzes tab
    await tester.tap(find.text('Quizzes'));
    await tester.pumpAndSettle();
    expect(find.text('Free Play Setup'), findsOneWidget);

    // Navigate to Leaderboard tab
    await tester.tap(find.text('Leaderboard'));
    await tester.pumpAndSettle();
    expect(find.text('Hall of Faith'), findsOneWidget);

    // Navigate to Friends tab
    await tester.tap(find.byIcon(Icons.group_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Friends & Rivals'), findsOneWidget);

    // Navigate to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('SWORD BIBLE WRAPPED'), findsOneWidget);
    expect(find.text('Current Streak'), findsOneWidget);
  });
}
