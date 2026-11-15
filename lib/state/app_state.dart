import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';
import '../data/seed/badges_and_avatars_bank.dart';
import '../data/seed/questions_bank.dart';

class AppState extends ChangeNotifier {
  // User Profile & Preferences
  String _displayName = 'Berean Scholar';
  String _username = 'berean_scholar';
  String _avatarKey = 'sword';
  int _knowledgeLevel = 2; // 1 = New to the Story, 2 = Sunday School Strong, 3 = Seminary Energy
  bool _hideKnowledgeLevel = false;
  bool _showOnFriendsLeaderboard = true;
  bool _showOnGlobalLeaderboard = true;
  bool _familyModeEnabled = true;
  String _reminderTime = '08:00 AM';
  bool _hasCompletedOnboarding = true;
  bool _showTourOverlay = false;

  // Core Stats & Daily 5
  int _totalPoints = 14850;
  int _weeklyPoints = 6420;
  int _totalQuestionsAnswered = 68;
  int _totalCorrectAnswers = 57;
  int _currentStreak = 5;
  int _bestStreak = 12;
  int _bestDaily5Score = 2680;
  bool _daily5CompletedToday = false;
  QuizResultSummary? _daily5TodaySummary;
  bool _streakProtectedByAd = false;

  // Missed Questions ("Sharpen" pool)
  final List<String> _missedQuestionIds = ['q_l3_leviticus_atonement', 'q_l3_josiah_scroll'];

  // Books Explored
  final Set<String> _booksExplored = {
    'Genesis',
    'Exodus',
    '1 Samuel',
    '1 Kings',
    'Psalms',
    'Isaiah',
    'Daniel',
    'Matthew',
    'Luke',
    'John',
    'Acts',
    'Romans',
    'Ephesians',
    'Hebrews',
  };

  // Family Mode Last Session Memory
  String _lastFamilySublevel = '1a'; // '1a' = Bible Basics, '1b' = Bible Basics+
  String _lastFamilyFocusType = 'surprise';
  String? _lastFamilyFocusValue;
  int _lastFamilyLength = 5;

  // Friends, H2H, Badges, Notifications
  late List<FriendProfile> _friends;
  late List<H2HChallenge> _h2hChallenges;
  late List<BadgeItem> _badges;
  late List<AppNotification> _notifications;

  AppState() {
    _friends = List.of(BadgesAndAvatarsBank.initialFriends);
    _badges = List.of(BadgesAndAvatarsBank.allBadges);
    _h2hChallenges = [
      H2HChallenge(
        id: 'h2h_1',
        opponent: _friends[0], // Caleb M.
        difficulty: 2,
        categoryType: 'topic',
        categoryLabel: 'Miracles',
        status: 'your_turn',
        opponentScore: 2140,
        opponentCorrect: 4,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        questions: QuestionsBank.filterQuestions(
          difficulty: 2,
          filterType: 'topic',
          filterValue: 'Miracles',
          count: 5,
        ),
      ),
      H2HChallenge(
        id: 'h2h_2',
        opponent: _friends[1], // Hannah R.
        difficulty: 1,
        categoryType: 'character',
        categoryLabel: 'David',
        status: 'completed',
        myScore: 1780,
        myCorrect: 5,
        opponentScore: 1520,
        opponentCorrect: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        questions: QuestionsBank.filterQuestions(
          difficulty: 1,
          filterType: 'character',
          filterValue: 'David',
          count: 5,
        ),
      ),
      H2HChallenge(
        id: 'h2h_3',
        opponent: _friends[2], // Micah T.
        difficulty: 2,
        categoryType: 'any',
        categoryLabel: 'Surprise Mix',
        status: 'completed',
        myScore: 2210,
        myCorrect: 4,
        opponentScore: 1890,
        opponentCorrect: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        questions: QuestionsBank.filterQuestions(difficulty: 2, count: 5),
      ),
    ];
    _notifications = [
      AppNotification(
        id: 'notif_1',
        type: 'h2h',
        title: 'Caleb M. challenged you!',
        body: '5 questions on Miracles (Level 2). He scored 2,140 pts — your turn!',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_2',
        type: 'friend',
        title: 'New friend request',
        body: 'Apollos D. (@apollos_eloquent) wants to connect on Sword Drill™.',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_3',
        type: 'badge',
        title: 'Badge Unlocked: Sword Drill™ Scholar',
        body: 'You scored a perfect 5/5 round! Check your Trophy Case.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  // Getters
  String get displayName => _displayName;
  String get username => _username;
  String get avatarKey => _avatarKey;
  int get knowledgeLevel => _knowledgeLevel;
  bool get hideKnowledgeLevel => _hideKnowledgeLevel;
  bool get showOnFriendsLeaderboard => _showOnFriendsLeaderboard;
  bool get showOnGlobalLeaderboard => _showOnGlobalLeaderboard;
  bool get familyModeEnabled => _familyModeEnabled;
  String get reminderTime => _reminderTime;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get showTourOverlay => _showTourOverlay;

  int get totalPoints => _totalPoints;
  int get weeklyPoints => _weeklyPoints;
  int get totalQuestionsAnswered => _totalQuestionsAnswered;
  int get totalCorrectAnswers => _totalCorrectAnswers;
  int get lifetimeAccuracyPercent => _totalQuestionsAnswered == 0
      ? 0
      : ((_totalCorrectAnswers / _totalQuestionsAnswered) * 100).round();
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get bestDaily5Score => _bestDaily5Score;
  bool get daily5CompletedToday => _daily5CompletedToday;
  QuizResultSummary? get daily5TodaySummary => _daily5TodaySummary;
  bool get streakProtectedByAd => _streakProtectedByAd;

  List<BibleQuestion> get missedQuestions => QuestionsBank.allQuestions
      .where((q) => _missedQuestionIds.contains(q.id))
      .toList();

  int get missedQuestionsCount => _missedQuestionIds.length;
  Set<String> get booksExplored => _booksExplored;

  String get lastFamilySublevel => _lastFamilySublevel;
  String get lastFamilyFocusType => _lastFamilyFocusType;
  String? get lastFamilyFocusValue => _lastFamilyFocusValue;
  int get lastFamilyLength => _lastFamilyLength;

  List<FriendProfile> get activeFriends =>
      _friends.where((f) => !f.isPendingRequest).toList();
  List<FriendProfile> get pendingFriendRequests =>
      _friends.where((f) => f.isPendingRequest).toList();
  List<H2HChallenge> get h2hChallenges => List.unmodifiable(_h2hChallenges);
  List<H2HChallenge> get activeH2HChallenges =>
      _h2hChallenges.where((c) => c.status != 'completed').toList();
  List<H2HChallenge> get completedH2HChallenges =>
      _h2hChallenges.where((c) => c.status == 'completed').toList();
  List<BadgeItem> get badges => List.unmodifiable(_badges);
  int get unlockedBadgesCount => _badges.where((b) => b.isUnlocked).length;
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  int get totalH2HWins =>
      _friends.fold(0, (sum, f) => sum + f.myWinsAgainst);
  int get totalH2HLosses =>
      _friends.fold(0, (sum, f) => sum + f.theirWinsAgainstMe);

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _displayName = prefs.getString('sd_display_name') ?? _displayName;
      _username = prefs.getString('sd_username') ?? _username;
      _avatarKey = prefs.getString('sd_avatar_key') ?? _avatarKey;
      _knowledgeLevel = prefs.getInt('sd_knowledge_level') ?? _knowledgeLevel;
      _totalPoints = prefs.getInt('sd_total_points') ?? _totalPoints;
      _weeklyPoints = prefs.getInt('sd_weekly_points') ?? _weeklyPoints;
      _currentStreak = prefs.getInt('sd_current_streak') ?? _currentStreak;
      _bestStreak = prefs.getInt('sd_best_streak') ?? _bestStreak;
      _bestDaily5Score = prefs.getInt('sd_best_daily5') ?? _bestDaily5Score;
      _familyModeEnabled =
          prefs.getBool('sd_family_mode_enabled') ?? _familyModeEnabled;
      notifyListeners();
    } catch (_) {
      // Safe fallback in unit tests
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sd_display_name', _displayName);
      await prefs.setString('sd_username', _username);
      await prefs.setString('sd_avatar_key', _avatarKey);
      await prefs.setInt('sd_knowledge_level', _knowledgeLevel);
      await prefs.setInt('sd_total_points', _totalPoints);
      await prefs.setInt('sd_weekly_points', _weeklyPoints);
      await prefs.setInt('sd_current_streak', _currentStreak);
      await prefs.setInt('sd_best_streak', _bestStreak);
      await prefs.setInt('sd_best_daily5', _bestDaily5Score);
      await prefs.setBool('sd_family_mode_enabled', _familyModeEnabled);
    } catch (_) {}
  }

  // Profile & Onboarding Mutations
  void updateProfile({
    String? displayName,
    String? username,
    String? avatarKey,
    int? knowledgeLevel,
    bool? hideKnowledgeLevel,
    bool? showOnFriendsLeaderboard,
    bool? showOnGlobalLeaderboard,
    bool? familyModeEnabled,
    String? reminderTime,
  }) {
    if (displayName != null && displayName.trim().isNotEmpty) {
      _displayName = displayName.trim();
    }
    if (username != null && username.trim().isNotEmpty) {
      _username = username.trim().replaceAll('@', '').toLowerCase();
    }
    if (avatarKey != null) _avatarKey = avatarKey;
    if (knowledgeLevel != null) _knowledgeLevel = knowledgeLevel.clamp(1, 3);
    if (hideKnowledgeLevel != null) _hideKnowledgeLevel = hideKnowledgeLevel;
    if (showOnFriendsLeaderboard != null) {
      _showOnFriendsLeaderboard = showOnFriendsLeaderboard;
    }
    if (showOnGlobalLeaderboard != null) {
      _showOnGlobalLeaderboard = showOnGlobalLeaderboard;
    }
    if (familyModeEnabled != null) _familyModeEnabled = familyModeEnabled;
    if (reminderTime != null) _reminderTime = reminderTime;
    _saveToStorage();
    notifyListeners();
  }

  void startOnboardingFlow() {
    _hasCompletedOnboarding = false;
    notifyListeners();
  }

  void completeOnboarding({
    required String displayName,
    required String username,
    required String avatarKey,
    required int knowledgeLevel,
    required bool familyModeEnabled,
  }) {
    _displayName = displayName.trim().isEmpty ? 'Berean Scholar' : displayName.trim();
    _username = username.trim().isEmpty
        ? 'berean_scholar'
        : username.trim().replaceAll('@', '').toLowerCase();
    _avatarKey = avatarKey;
    _knowledgeLevel = knowledgeLevel.clamp(1, 3);
    _familyModeEnabled = familyModeEnabled;
    _hasCompletedOnboarding = true;
    _saveToStorage();
    notifyListeners();
  }

  void setTourOverlayVisible(bool visible) {
    _showTourOverlay = visible;
    notifyListeners();
  }

  // Recording Quiz Round Results
  QuizResultSummary recordQuizCompletion({
    required QuizMode mode,
    required String modeSubtitle,
    required List<QuizAnswerRecord> answers,
    String? h2hChallengeId,
  }) {
    final totalScore = answers.fold<int>(0, (s, a) => s + a.totalPoints);
    final correctCount = answers.where((a) => a.isCorrect).length;
    final totalElapsedMs = answers.fold<int>(0, (s, a) => s + a.elapsedMs);

    final summary = QuizResultSummary(
      mode: mode,
      modeSubtitle: modeSubtitle,
      answers: answers,
      totalScore: totalScore,
      correctCount: correctCount,
      totalQuestions: answers.length,
      totalElapsedMs: totalElapsedMs,
      completedAt: DateTime.now(),
    );

    // Family Mode explicitly does NOT alter personal streak or personal stats
    if (mode == QuizMode.familyMode) {
      _unlockBadge('family_night');
      notifyListeners();
      return summary;
    }

    if (mode == QuizMode.placement) {
      final ratio = answers.isEmpty ? 0.5 : correctCount / answers.length;
      if (ratio >= 0.8) {
        _knowledgeLevel = 3;
      } else if (ratio >= 0.5) {
        _knowledgeLevel = 2;
      } else {
        _knowledgeLevel = 1;
      }
      _saveToStorage();
      notifyListeners();
      return summary;
    }

    // Update personal stats
    _totalPoints += totalScore;
    _weeklyPoints += totalScore;
    _totalQuestionsAnswered += answers.length;
    _totalCorrectAnswers += correctCount;

    for (final ans in answers) {
      _booksExplored.add(ans.question.book);
      if (!ans.isCorrect) {
        if (!_missedQuestionIds.contains(ans.question.id)) {
          _missedQuestionIds.add(ans.question.id);
        }
      } else if (mode == QuizMode.sharpen) {
        _missedQuestionIds.remove(ans.question.id);
        _unlockBadge('sharpened');
      }
    }

    if (mode == QuizMode.daily5) {
      if (!_daily5CompletedToday) {
        _daily5CompletedToday = true;
        _currentStreak += 1;
        if (_currentStreak > _bestStreak) {
          _bestStreak = _currentStreak;
        }
      }
      if (totalScore > _bestDaily5Score) {
        _bestDaily5Score = totalScore;
      }
      _daily5TodaySummary = summary;
      if (_currentStreak >= 7) {
        _unlockBadge('streak_7');
      }
    }

    if (mode == QuizMode.h2h && h2hChallengeId != null) {
      _completeH2HChallenge(h2hChallengeId, totalScore, correctCount);
    }

    if (answers.length >= 5 && correctCount == answers.length) {
      _unlockBadge('perfect_5');
    }

    _saveToStorage();
    notifyListeners();
    return summary;
  }

  /// Adds Rewarded Ad bonus points (+200 pts) to user total & latest summary.
  void addBonusPointsFromAd(int bonusPoints) {
    _totalPoints += bonusPoints;
    _weeklyPoints += bonusPoints;
    if (_daily5TodaySummary != null) {
      _daily5TodaySummary = QuizResultSummary(
        mode: _daily5TodaySummary!.mode,
        modeSubtitle: _daily5TodaySummary!.modeSubtitle,
        answers: _daily5TodaySummary!.answers,
        totalScore: _daily5TodaySummary!.totalScore + bonusPoints,
        correctCount: _daily5TodaySummary!.correctCount,
        totalQuestions: _daily5TodaySummary!.totalQuestions,
        totalElapsedMs: _daily5TodaySummary!.totalElapsedMs,
        completedAt: _daily5TodaySummary!.completedAt,
        bonusAdPoints: _daily5TodaySummary!.bonusAdPoints + bonusPoints,
      );
      if (_daily5TodaySummary!.totalScore > _bestDaily5Score) {
        _bestDaily5Score = _daily5TodaySummary!.totalScore;
      }
    }
    _saveToStorage();
    notifyListeners();
  }

  void protectStreakWithRewardedAd() {
    _streakProtectedByAd = true;
    notifyListeners();
  }

  void saveFamilyPreset({
    required String sublevel,
    required String focusType,
    String? focusValue,
    required int length,
  }) {
    _lastFamilySublevel = sublevel;
    _lastFamilyFocusType = focusType;
    _lastFamilyFocusValue = focusValue;
    _lastFamilyLength = length;
    notifyListeners();
  }

  // H2H & Friends
  H2HChallenge createH2HChallenge({
    required FriendProfile opponent,
    required int difficulty,
    required String categoryType,
    required String categoryLabel,
    String? filterValue,
  }) {
    final questions = QuestionsBank.filterQuestions(
      difficulty: difficulty == 0 ? null : difficulty,
      filterType: categoryType,
      filterValue: filterValue,
      count: 5,
    );
    // Simulate opponent score for instant competitive satisfaction after you finish
    final simulatedOpponentCorrect = 3 + (DateTime.now().second % 2); // 3 or 4
    final simulatedOpponentScore =
        simulatedOpponentCorrect * (difficulty == 0 ? 400 : difficulty * 200) + 340;

    final challenge = H2HChallenge(
      id: 'h2h_${DateTime.now().millisecondsSinceEpoch}',
      opponent: opponent,
      difficulty: difficulty,
      categoryType: categoryType,
      categoryLabel: categoryLabel,
      status: 'your_turn',
      opponentScore: simulatedOpponentScore,
      opponentCorrect: simulatedOpponentCorrect,
      createdAt: DateTime.now(),
      questions: questions,
    );
    _h2hChallenges.insert(0, challenge);
    _unlockBadge('iron_sharpens');
    notifyListeners();
    return challenge;
  }

  void _completeH2HChallenge(String challengeId, int myScore, int myCorrect) {
    final index = _h2hChallenges.indexWhere((c) => c.id == challengeId);
    if (index == -1) return;
    final old = _h2hChallenges[index];
    final oppScore = old.opponentScore ?? 1650;
    final oppCorrect = old.opponentCorrect ?? 3;

    _h2hChallenges[index] = H2HChallenge(
      id: old.id,
      opponent: old.opponent,
      difficulty: old.difficulty,
      categoryType: old.categoryType,
      categoryLabel: old.categoryLabel,
      status: 'completed',
      myScore: myScore,
      myCorrect: myCorrect,
      opponentScore: oppScore,
      opponentCorrect: oppCorrect,
      createdAt: old.createdAt,
      questions: old.questions,
    );

    final fIdx = _friends.indexWhere((f) => f.id == old.opponent.id);
    if (fIdx != -1) {
      final f = _friends[fIdx];
      if (myScore >= oppScore) {
        _friends[fIdx] = f.copyWith(myWinsAgainst: f.myWinsAgainst + 1);
      } else {
        _friends[fIdx] = f.copyWith(theirWinsAgainstMe: f.theirWinsAgainstMe + 1);
      }
    }
    if (totalH2HWins >= 3) {
      _unlockBadge('h2h_victor');
    }
  }

  void acceptFriendRequest(String friendId) {
    final idx = _friends.indexWhere((f) => f.id == friendId);
    if (idx != -1) {
      _friends[idx] = _friends[idx].copyWith(isPendingRequest: false);
      notifyListeners();
    }
  }

  void addNewFriendByUsername(String handle, String displayName) {
    final cleanHandle = handle.trim().replaceAll('@', '').toLowerCase();
    if (cleanHandle.isEmpty) return;
    if (_friends.any((f) => f.username.toLowerCase() == cleanHandle)) return;

    _friends.insert(
      0,
      FriendProfile(
        id: 'f_${DateTime.now().millisecondsSinceEpoch}',
        username: cleanHandle,
        displayName: displayName.trim().isEmpty ? cleanHandle : displayName.trim(),
        avatarKey: 'compass',
        knowledgeLevel: 2,
        currentStreak: 4,
        totalPoints: 12400,
        accuracyPercent: 80,
        completedDailyToday: true,
        dailyScoreToday: 1820,
        dailyCorrectToday: 4,
      ),
    );
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void _unlockBadge(String key) {
    final idx = _badges.indexWhere((b) => b.key == key);
    if (idx != -1 && !_badges[idx].isUnlocked) {
      _badges[idx] = _badges[idx].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      _notifications.insert(
        0,
        AppNotification(
          id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
          type: 'badge',
          title: 'Badge Unlocked: ${_badges[idx].name}!',
          body: _badges[idx].description,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  // Leaderboard Builders (Weekly, Friends, Hall of Faith)
  List<LeaderboardEntry> getWeeklyLeaderboard() {
    final raw = [
      LeaderboardEntry(
        rank: 0,
        userId: 'u_apollos',
        displayName: 'Apollos D.',
        username: 'apollos_eloquent',
        avatarKey: 'scroll',
        knowledgeLevel: 3,
        score: 8940,
        accuracyPercent: 94,
        streak: 21,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_caleb',
        displayName: 'Caleb M.',
        username: 'caleb_wholeheart',
        avatarKey: 'shield',
        knowledgeLevel: 3,
        score: 7620,
        accuracyPercent: 89,
        streak: 14,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_priscilla',
        displayName: 'Priscilla A.',
        username: 'priscilla_teaches',
        avatarKey: 'lamp',
        knowledgeLevel: 3,
        score: 7110,
        accuracyPercent: 91,
        streak: 18,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'me',
        displayName: _displayName,
        username: _username,
        avatarKey: _avatarKey,
        knowledgeLevel: _knowledgeLevel,
        score: _weeklyPoints,
        accuracyPercent: lifetimeAccuracyPercent,
        streak: _currentStreak,
        isCurrentUser: true,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_hannah',
        displayName: 'Hannah R.',
        username: 'hannah_prays',
        avatarKey: 'olive',
        knowledgeLevel: 2,
        score: 5890,
        accuracyPercent: 84,
        streak: 9,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_micah',
        displayName: 'Micah T.',
        username: 'micah_68',
        avatarKey: 'crown',
        knowledgeLevel: 2,
        score: 5120,
        accuracyPercent: 79,
        streak: 6,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_lydia',
        displayName: 'Lydia K.',
        username: 'lydia_purple',
        avatarKey: 'diamond',
        knowledgeLevel: 1,
        score: 4380,
        accuracyPercent: 81,
        streak: 5,
      ),
    ];
    raw.sort((a, b) => b.score.compareTo(a.score));
    return [
      for (int i = 0; i < raw.length; i++)
        LeaderboardEntry(
          rank: i + 1,
          userId: raw[i].userId,
          displayName: raw[i].displayName,
          username: raw[i].username,
          avatarKey: raw[i].avatarKey,
          knowledgeLevel: raw[i].knowledgeLevel,
          score: raw[i].score,
          accuracyPercent: raw[i].accuracyPercent,
          streak: raw[i].streak,
          isCurrentUser: raw[i].isCurrentUser,
        ),
    ];
  }

  List<LeaderboardEntry> getFriendsLeaderboard() {
    final raw = <LeaderboardEntry>[
      LeaderboardEntry(
        rank: 0,
        userId: 'me',
        displayName: _displayName,
        username: _username,
        avatarKey: _avatarKey,
        knowledgeLevel: _knowledgeLevel,
        score: _totalPoints,
        accuracyPercent: lifetimeAccuracyPercent,
        streak: _currentStreak,
        isCurrentUser: true,
      ),
      for (final f in activeFriends)
        LeaderboardEntry(
          rank: 0,
          userId: f.id,
          displayName: f.displayName,
          username: f.username,
          avatarKey: f.avatarKey,
          knowledgeLevel: f.knowledgeLevel,
          score: f.totalPoints,
          accuracyPercent: f.accuracyPercent,
          streak: f.currentStreak,
        ),
    ];
    raw.sort((a, b) => b.score.compareTo(a.score));
    return [
      for (int i = 0; i < raw.length; i++)
        LeaderboardEntry(
          rank: i + 1,
          userId: raw[i].userId,
          displayName: raw[i].displayName,
          username: raw[i].username,
          avatarKey: raw[i].avatarKey,
          knowledgeLevel: raw[i].knowledgeLevel,
          score: raw[i].score,
          accuracyPercent: raw[i].accuracyPercent,
          streak: raw[i].streak,
          isCurrentUser: raw[i].isCurrentUser,
        ),
    ];
  }

  List<LeaderboardEntry> getHallOfFaithLeaderboard() {
    final raw = <LeaderboardEntry>[
      const LeaderboardEntry(
        rank: 0,
        userId: 'hof_1',
        displayName: 'Ezra the Scribe',
        username: 'ezra_710',
        avatarKey: 'scroll',
        knowledgeLevel: 3,
        score: 48200,
        accuracyPercent: 96,
        streak: 45,
      ),
      const LeaderboardEntry(
        rank: 0,
        userId: 'hof_2',
        displayName: 'Apollos D.',
        username: 'apollos_eloquent',
        avatarKey: 'flame',
        knowledgeLevel: 3,
        score: 34900,
        accuracyPercent: 92,
        streak: 21,
      ),
      const LeaderboardEntry(
        rank: 0,
        userId: 'hof_3',
        displayName: 'Caleb M.',
        username: 'caleb_wholeheart',
        avatarKey: 'shield',
        knowledgeLevel: 3,
        score: 28450,
        accuracyPercent: 88,
        streak: 14,
      ),
      const LeaderboardEntry(
        rank: 0,
        userId: 'hof_4',
        displayName: 'Hannah R.',
        username: 'hannah_prays',
        avatarKey: 'olive',
        knowledgeLevel: 2,
        score: 24120,
        accuracyPercent: 84,
        streak: 9,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'me',
        displayName: _displayName,
        username: _username,
        avatarKey: _avatarKey,
        knowledgeLevel: _knowledgeLevel,
        score: _totalPoints,
        accuracyPercent: lifetimeAccuracyPercent,
        streak: _currentStreak,
        isCurrentUser: true,
      ),
      const LeaderboardEntry(
        rank: 0,
        userId: 'hof_5',
        displayName: 'Micah T.',
        username: 'micah_68',
        avatarKey: 'crown',
        knowledgeLevel: 2,
        score: 19800,
        accuracyPercent: 79,
        streak: 6,
      ),
    ];
    raw.sort((a, b) => b.score.compareTo(a.score));
    return [
      for (int i = 0; i < raw.length; i++)
        LeaderboardEntry(
          rank: i + 1,
          userId: raw[i].userId,
          displayName: raw[i].displayName,
          username: raw[i].username,
          avatarKey: raw[i].avatarKey,
          knowledgeLevel: raw[i].knowledgeLevel,
          score: raw[i].score,
          accuracyPercent: raw[i].accuracyPercent,
          streak: raw[i].streak,
          isCurrentUser: raw[i].isCurrentUser,
        ),
    ];
  }
}
