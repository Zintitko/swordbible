/// Exact scoring engine and level metadata cloned from `quiz-scoring-CZeHuncL.js`
/// and `sublevels-Ctzub16i.js`.
class ScoringUtils {
  ScoringUtils._();

  static const int maxSpeedBonus = 200;

  static int basePointsForDifficulty(int difficulty) {
    final clamped = difficulty.clamp(1, 3);
    return clamped * 200; // Level 1 = 200, Level 2 = 400, Level 3 = 600
  }

  static int timerSecondsForDifficulty(int difficulty) {
    return difficulty >= 3 ? 60 : 30;
  }

  /// Calculates points earned for a single question:
  /// - Wrong or timed out: 0 pts
  /// - Correct without timer: basePoints (200/400/600)
  /// - Correct with timer: basePoints + linear speed bonus up to +200 pts
  static ({int base, int speedBonus, int total}) calculateQuestionScore({
    required bool isCorrect,
    required int difficulty,
    required int elapsedMs,
    required int totalTimeMs,
    bool timedMode = true,
  }) {
    if (!isCorrect) {
      return (base: 0, speedBonus: 0, total: 0);
    }
    final base = basePointsForDifficulty(difficulty);
    if (!timedMode || totalTimeMs <= 0) {
      return (base: base, speedBonus: 0, total: base);
    }
    final remainingRatio = ((totalTimeMs - elapsedMs) / totalTimeMs).clamp(0.0, 1.0);
    final speedBonus = (maxSpeedBonus * remainingRatio).round();
    return (base: base, speedBonus: speedBonus, total: base + speedBonus);
  }

  static String difficultyTitle(int level) {
    switch (level) {
      case 1:
        return 'New to the Story';
      case 2:
        return 'Sunday School Strong';
      case 3:
        return 'Seminary Energy';
      default:
        return 'Sunday School Strong';
    }
  }

  static String difficultySubtitle(int level) {
    switch (level) {
      case 1:
        return 'Core stories, big moments, and famous heroes of faith.';
      case 2:
        return 'Deeper connections, parables, prophets, and epistles.';
      case 3:
        return 'Theological precision, minor prophets, genealogies, and deep cuts.';
      default:
        return 'Deeper connections, parables, prophets, and epistles.';
    }
  }

  static String difficultyShortBadge(int level) {
    switch (level) {
      case 1:
        return 'Level 1 • Beginner';
      case 2:
        return 'Level 2 • Intermediate';
      case 3:
        return 'Level 3 • Advanced';
      default:
        return 'Level $level';
    }
  }

  /// Result tier title & subtitle from `quiz-scoring-CZeHuncL.js`
  static ({String title, String subtitle, String emoji}) getResultTier(
    int correctCount,
    int totalQuestions,
  ) {
    if (totalQuestions <= 0) {
      return (
        title: 'Back to Genesis',
        subtitle: 'A humbling round. Very biblical, honestly.',
        emoji: '📜',
      );
    }
    final pct = (correctCount / totalQuestions) * 100;
    if (pct >= 100) {
      return (
        title: 'Sword Drill™ Scholar',
        subtitle: 'Perfect round. No notes.',
        emoji: '👑',
      );
    }
    if (pct >= 80) {
      return (
        title: 'Almost Canonized',
        subtitle: 'One question away from glory.',
        emoji: '⚔️',
      );
    }
    if (pct >= 60) {
      return (
        title: 'Respectably Berean',
        subtitle: 'Solid work. Still checking the scrolls.',
        emoji: '📖',
      );
    }
    if (pct >= 40) {
      return (
        title: 'Wandering in the Wilderness',
        subtitle: 'Some progress. Some wandering.',
        emoji: '🏜️',
      );
    }
    if (pct >= 20) {
      return (
        title: 'The Ark Has Not Been Located',
        subtitle: 'Not my finest hour. Can you beat me?',
        emoji: '🕊️',
      );
    }
    return (
      title: 'Back to Genesis',
      subtitle: 'A humbling round. Very biblical, honestly.',
      emoji: '🌱',
    );
  }
}
