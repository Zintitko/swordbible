import 'package:flutter/material.dart';

enum QuizMode {
  daily5,
  freePlay,
  sharpen,
  familyMode,
  h2h,
  placement,
}

class BibleQuestion {
  final String id;
  final String questionText;
  final List<String> options; // 4 options (A, B, C, D)
  final int correctOptionIndex; // 0..3
  final int difficulty; // 1 = New to the Story, 2 = Sunday School Strong, 3 = Seminary Energy
  final String? sublevel; // '1a' (Bible Basics), '1b' (Bible Basics+)
  final String testament; // 'OT' or 'NT'
  final String book;
  final String topic;
  final String? character;
  final String bibleReference;
  final String csbVerseText;
  final String contextExplainer;
  final String whyThisMatters;
  final String? whyThisDiffers;

  const BibleQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.difficulty,
    this.sublevel,
    required this.testament,
    required this.book,
    required this.topic,
    this.character,
    required this.bibleReference,
    required this.csbVerseText,
    required this.contextExplainer,
    required this.whyThisMatters,
    this.whyThisDiffers,
  });

  String get correctAnswer => options[correctOptionIndex];
}

class QuizAnswerRecord {
  final BibleQuestion question;
  final int? selectedOptionIndex; // null if timed out
  final bool isCorrect;
  final int elapsedMs;
  final int basePoints;
  final int speedBonus;
  final int totalPoints;

  const QuizAnswerRecord({
    required this.question,
    required this.selectedOptionIndex,
    required this.isCorrect,
    required this.elapsedMs,
    required this.basePoints,
    required this.speedBonus,
    required this.totalPoints,
  });
}

class QuizResultSummary {
  final QuizMode mode;
  final String modeSubtitle;
  final List<QuizAnswerRecord> answers;
  final int totalScore;
  final int correctCount;
  final int totalQuestions;
  final int totalElapsedMs;
  final DateTime completedAt;
  final int bonusAdPoints;

  const QuizResultSummary({
    required this.mode,
    required this.modeSubtitle,
    required this.answers,
    required this.totalScore,
    required this.correctCount,
    required this.totalQuestions,
    required this.totalElapsedMs,
    required this.completedAt,
    this.bonusAdPoints = 0,
  });

  int get accuracyPercent =>
      totalQuestions == 0 ? 0 : ((correctCount / totalQuestions) * 100).round();

  double get avgSecondsPerQuestion =>
      totalQuestions == 0 ? 0 : (totalElapsedMs / 1000.0) / totalQuestions;

  List<QuizAnswerRecord> get missedAnswers =>
      answers.where((a) => !a.isCorrect).toList();
}

class AvatarPreset {
  final String key;
  final String label;
  final String category; // 'Classic', 'Faith', 'Signs', 'Creation'
  final IconData icon;
  final Color accentColor;

  const AvatarPreset({
    required this.key,
    required this.label,
    required this.category,
    required this.icon,
    required this.accentColor,
  });
}

class BadgeItem {
  final String id;
  final String key;
  final String name;
  final String description;
  final String category; // 'welcome', 'consistency', 'accuracy', 'exploration', 'social', 'competition', 'special'
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeItem({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  BadgeItem copyWith({bool? isUnlocked, DateTime? unlockedAt}) {
    return BadgeItem(
      id: id,
      key: key,
      name: name,
      description: description,
      category: category,
      icon: icon,
      color: color,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

class FriendProfile {
  final String id;
  final String username;
  final String displayName;
  final String avatarKey;
  final int knowledgeLevel;
  final int currentStreak;
  final int totalPoints;
  final int accuracyPercent;
  final int myWinsAgainst;
  final int theirWinsAgainstMe;
  final bool completedDailyToday;
  final int? dailyScoreToday;
  final int? dailyCorrectToday;
  final bool isPendingRequest;

  const FriendProfile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarKey,
    required this.knowledgeLevel,
    required this.currentStreak,
    required this.totalPoints,
    required this.accuracyPercent,
    this.myWinsAgainst = 0,
    this.theirWinsAgainstMe = 0,
    this.completedDailyToday = false,
    this.dailyScoreToday,
    this.dailyCorrectToday,
    this.isPendingRequest = false,
  });

  FriendProfile copyWith({
    int? myWinsAgainst,
    int? theirWinsAgainstMe,
    bool? isPendingRequest,
  }) {
    return FriendProfile(
      id: id,
      username: username,
      displayName: displayName,
      avatarKey: avatarKey,
      knowledgeLevel: knowledgeLevel,
      currentStreak: currentStreak,
      totalPoints: totalPoints,
      accuracyPercent: accuracyPercent,
      myWinsAgainst: myWinsAgainst ?? this.myWinsAgainst,
      theirWinsAgainstMe: theirWinsAgainstMe ?? this.theirWinsAgainstMe,
      completedDailyToday: completedDailyToday,
      dailyScoreToday: dailyScoreToday,
      dailyCorrectToday: dailyCorrectToday,
      isPendingRequest: isPendingRequest ?? this.isPendingRequest,
    );
  }
}

class H2HChallenge {
  final String id;
  final FriendProfile opponent;
  final int difficulty; // 1, 2, 3, or 0 for Mix
  final String categoryType; // 'any', 'topic', 'character', 'book'
  final String categoryLabel;
  final String status; // 'your_turn', 'waiting_opponent', 'completed'
  final int? myScore;
  final int? opponentScore;
  final int? myCorrect;
  final int? opponentCorrect;
  final DateTime createdAt;
  final List<BibleQuestion> questions;

  const H2HChallenge({
    required this.id,
    required this.opponent,
    required this.difficulty,
    required this.categoryType,
    required this.categoryLabel,
    required this.status,
    this.myScore,
    this.opponentScore,
    this.myCorrect,
    this.opponentCorrect,
    required this.createdAt,
    required this.questions,
  });

  bool get didIWin =>
      status == 'completed' &&
      myScore != null &&
      opponentScore != null &&
      myScore! > opponentScore!;
}

class LeaderboardEntry {
  final int rank;
  final String userId;
  final String displayName;
  final String username;
  final String avatarKey;
  final int knowledgeLevel;
  final int score;
  final int accuracyPercent;
  final int streak;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.username,
    required this.avatarKey,
    required this.knowledgeLevel,
    required this.score,
    required this.accuracyPercent,
    required this.streak,
    this.isCurrentUser = false,
  });
}

class AppNotification {
  final String id;
  final String type; // 'h2h', 'friend', 'badge', 'streak'
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
