import 'package:flutter/material.dart';
import '../../core/ads/ad_banner_widget.dart';
import '../../core/ads/ad_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/models.dart';
import '../../data/seed/fun_facts_bank.dart';
import '../../data/seed/questions_bank.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';
import '../family_mode/family_mode_screens.dart';
import '../h2h/h2h_screens.dart';
import '../quiz/question_play_screen.dart';
import '../quiz/quiz_results_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final void Function(String filterType) onNavigateToFreePlaySetup;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigateToFreePlaySetup,
  });

  String _greetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _startDaily5(BuildContext context) {
    final questions = QuestionsBank.getDaily5Questions();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuestionPlayScreen(
          appState: appState,
          mode: QuizMode.daily5,
          modeTitle: 'Daily 5 Challenge',
          questions: questions,
          showCountdownIntro: true,
        ),
      ),
    );
  }

  void _startSurpriseFreePlay(BuildContext context) {
    final questions = QuestionsBank.filterQuestions(
      difficulty: appState.knowledgeLevel,
      filterType: 'surprise',
      count: 5,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuestionPlayScreen(
          appState: appState,
          mode: QuizMode.freePlay,
          modeTitle: 'Free Play • Surprise Me',
          questions: questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = appState;
    final factOfTheDay = FunFactsBank.getFactOfTheDay();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
      children: [
        // Top Brand Header Bar
        Row(
          children: [
            const Expanded(
              child: BrandWordmark(fontSize: 22),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(appState: s),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_none_rounded),
                  tooltip: 'Notifications',
                ),
                if (s.unreadNotificationsCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.wrong,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${s.unreadNotificationsCount}',
                        style: AppTypography.body(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(appState: s),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
            ),
          ],
        ),
        const SizedBox(height: 14),

        // User Greeting + Neon Streak Pill Row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              UserAvatarCircle(avatarKey: s.avatarKey, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greetingText()}, ${s.displayName}',
                      style: AppTypography.display(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: s.daily5CompletedToday
                                ? AppColors.successLight
                                : AppColors.neon,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            s.daily5CompletedToday
                                ? 'Daily 5 Done ✓'
                                : 'Daily 5 Ready',
                            style: AppTypography.body(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: s.daily5CompletedToday
                                  ? AppColors.success
                                  : AppColors.neonInk,
                            ),
                          ),
                        ),
                        Text(
                          '• ${s.lifetimeAccuracyPercent}% Accuracy',
                          style: AppTypography.body(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Signature Neon Streak Box
              GestureDetector(
                onTap: () {
                  if (s.streakProtectedByAd) return;
                  AdService.instance.showRewardedAd(
                    onRewardEarned: (_, _) {
                      s.protectStreakWithRewardedAd();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Streak Grace Day Activated via Rewarded Ad!',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neon,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            size: 18,
                            color: AppColors.neonInk,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${s.currentStreak}',
                            style: AppTypography.display(
                              fontSize: 19,
                              color: AppColors.neonInk,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        s.streakProtectedByAd ? 'PROTECTED' : 'STREAK',
                        style: AppTypography.body(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.neonInk,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Google AdMob Banner Ad + CSB Sponsor Slot
        const AdBannerWidget(placementLabel: 'Home Top Banner'),

        const SizedBox(height: 12),

        // 1. DAILY CHALLENGE ("DAILY 5") HERO CARD
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: AppColors.gradientPurpleDeep,
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppColors.cardShadowLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neon,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'DAILY CHALLENGE • 5 Qs',
                      style: AppTypography.body(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.neonInk,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '2×L1 • 2×L2 • 1×L3',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                s.daily5CompletedToday
                    ? 'Today\'s Daily 5 Complete!'
                    : 'Today\'s Daily 5',
                style: AppTypography.display(
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                s.daily5CompletedToday && s.daily5TodaySummary != null
                    ? 'You scored ${s.daily5TodaySummary!.totalScore} pts (${s.daily5TodaySummary!.correctCount}/5 correct). Come back tomorrow for a fresh set!'
                    : 'Everyone gets the exact same 5 Bible questions today. Beat the clock and compare with friends!',
                style: AppTypography.body(
                  fontSize: 13.5,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.neon,
                        foregroundColor: AppColors.neonInk,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _startDaily5(context),
                      icon: const Icon(Icons.bolt_rounded),
                      label: Text(
                        s.daily5CompletedToday
                            ? 'Replay Daily 5'
                            : 'Play Daily 5 Now',
                        style: AppTypography.display(
                          fontSize: 16,
                          color: AppColors.neonInk,
                        ),
                      ),
                    ),
                  ),
                  if (s.daily5CompletedToday && s.daily5TodaySummary != null) ...[
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizResultsScreen(
                              appState: s,
                              summary: s.daily5TodaySummary!,
                            ),
                          ),
                        );
                      },
                      child: const Text('Results'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. FREE PLAY CARD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FREE PLAY',
                          style: AppTypography.body(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'Drill Any Part of Scripture',
                          style: AppTypography.display(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: () => _startSurpriseFreePlay(context),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: const Text('Surprise Me'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _QuickBrowseButton(
                      icon: Icons.history_edu_rounded,
                      label: 'Testament',
                      onTap: () => onNavigateToFreePlaySetup('testament'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickBrowseButton(
                      icon: Icons.explore_rounded,
                      label: 'Topic',
                      onTap: () => onNavigateToFreePlaySetup('topic'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickBrowseButton(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Character',
                      onTap: () => onNavigateToFreePlaySetup('character'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickBrowseButton(
                      icon: Icons.menu_book_rounded,
                      label: 'Book',
                      onTap: () => onNavigateToFreePlaySetup('book'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 3. SHARPEN MISSED QUESTIONS CARD
        if (s.missedQuestionsCount > 0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_fix_high_rounded,
                    color: Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sharpen Your Sword (${s.missedQuestionsCount} Missed)',
                        style: AppTypography.display(fontSize: 16.5),
                      ),
                      Text(
                        'Re-drill questions you missed until you master them.',
                        style: AppTypography.body(
                          fontSize: 12.5,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuestionPlayScreen(
                          appState: s,
                          mode: QuizMode.sharpen,
                          modeTitle: 'Sharpen Drill',
                          questions: s.missedQuestions,
                        ),
                      ),
                    );
                  },
                  child: const Text('Sharpen'),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // 4. HEAD-TO-HEAD & FAMILY MODE CARDS
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => H2HHubScreen(appState: s),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.sports_kabaddi_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          if (s.activeH2HChallenges.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neon,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                '${s.activeH2HChallenges.length} Turn',
                                style: AppTypography.body(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.neonInk,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Head-to-Head',
                        style: AppTypography.display(fontSize: 17),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Challenge a friend to a 5-question duel',
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (s.familyModeEnabled) ...[
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FamilyModeSetupScreen(appState: s),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.family_restroom_rounded,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Family Mode',
                          style: AppTypography.display(fontSize: 17),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Pass & play Bible Basics for all ages',
                          style: AppTypography.body(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 16),

        // 5. LIFETIME STATS ROW
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStatColumn(
                label: 'LIFETIME PTS',
                value: '${s.totalPoints}',
              ),
              Container(width: 1, height: 28, color: AppColors.border),
              _MiniStatColumn(
                label: 'ACCURACY',
                value: '${s.lifetimeAccuracyPercent}%',
              ),
              Container(width: 1, height: 28, color: AppColors.border),
              _MiniStatColumn(
                label: 'BEST DAILY 5',
                value: '${s.bestDaily5Score}',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 6. "DID YOU KNOW?" DAILY BIBLE FUN FACT CARD
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'DID YOU KNOW? • DAILY BIBLE FACT',
                    style: AppTypography.body(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                factOfTheDay,
                style: AppTypography.body(
                  fontSize: 13.5,
                  color: AppColors.foreground,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),

        // 7. HEBREWS 4:12 FOOTER
        const HebrewsFooter(),
      ],
    );
  }
}

class _QuickBrowseButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickBrowseButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.display(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.body(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.mutedForeground,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
