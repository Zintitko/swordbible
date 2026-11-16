import 'package:flutter/material.dart';
import '../../core/ads/ad_banner_widget.dart';
import '../../core/ads/ad_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../shared/widgets/learn_more_sheet.dart';
import '../../state/app_state.dart';
import 'question_play_screen.dart';

class QuizResultsScreen extends StatefulWidget {
  final AppState appState;
  final QuizResultSummary summary;
  final String? h2hChallengeId;

  const QuizResultsScreen({
    super.key,
    required this.appState,
    required this.summary,
    this.h2hChallengeId,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  bool _claimedAdBonus = false;
  int _extraAdPoints = 0;

  void _claimRewardedAdBonus() {
    if (_claimedAdBonus) return;
    AdService.instance.showRewardedAd(
      onRewardEarned: (amount, _) {
        if (!mounted) return;
        widget.appState.addBonusPointsFromAd(200);
        setState(() {
          _claimedAdBonus = true;
          _extraAdPoints = 200;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('+200 Bonus Points added via Google AdMob Rewarded Ad!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.summary;
    final displayedScore = s.totalScore + _extraAdPoints;
    final tier = ScoringUtils.getResultTier(s.correctCount, s.totalQuestions);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '${s.modeSubtitle} Results',
          style: AppTypography.display(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () => showShareResultModal(
              context,
              summary: s,
              displayName: widget.appState.displayName,
              streak: widget.appState.currentStreak,
            ),
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Share Result Card',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        children: [
          // Hero Result Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.gradientWarmPurple,
              borderRadius: BorderRadius.circular(26),
              boxShadow: AppColors.cardShadowLg,
            ),
            child: Column(
              children: [
                Text(tier.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(
                  tier.title,
                  textAlign: TextAlign.center,
                  style: AppTypography.display(
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${tier.subtitle}"',
                  textAlign: TextAlign.center,
                  style: AppTypography.body(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$displayedScore',
                  style: AppTypography.display(
                    fontSize: 52,
                    color: AppColors.neon,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'TOTAL POINTS',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.75),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ResultStatPill(
                      label: 'CORRECT',
                      value: '${s.correctCount}/${s.totalQuestions}',
                    ),
                    _ResultStatPill(
                      label: 'ACCURACY',
                      value: '${s.accuracyPercent}%',
                    ),
                    _ResultStatPill(
                      label: 'AVG TIME',
                      value: '${s.avgSecondsPerQuestion.toStringAsFixed(1)}s',
                    ),
                    _ResultStatPill(
                      label: 'STREAK',
                      value: '🔥 ${widget.appState.currentStreak}d',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Rewarded Ad +200 Points Boost Card
          if (!_claimedAdBonus && s.mode != QuizMode.placement)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.neon.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.neonInk.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.neonInk,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Boost Your Round Score (+200 Pts)',
                          style: AppTypography.display(
                            fontSize: 15,
                            color: AppColors.neonInk,
                          ),
                        ),
                        Text(
                          'Watch a short Rewarded Ad to add +200 bonus points.',
                          style: AppTypography.body(
                            fontSize: 12,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.neonInk,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _claimRewardedAdBonus,
                    child: const Text('+200 Pts'),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 14),

          // Action Buttons (Share Card + Sharpen Missed)
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => showShareResultModal(
                    context,
                    summary: s,
                    displayName: widget.appState.displayName,
                    streak: widget.appState.currentStreak,
                  ),
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: Text(
                    'Share Result',
                    style: AppTypography.display(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (s.missedAnswers.isNotEmpty) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      final missedQs =
                          s.missedAnswers.map((a) => a.question).toList();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => QuestionPlayScreen(
                            appState: widget.appState,
                            mode: QuizMode.sharpen,
                            modeTitle: 'Sharpen Drill',
                            questions: missedQs,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                    label: Text(
                      'Sharpen (${s.missedAnswers.length})',
                      style: AppTypography.display(
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Friends Today Comparison (for Daily 5)
          if (s.mode == QuizMode.daily5) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FRIENDS TODAY • DAILY 5',
                    style: AppTypography.body(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mutedForeground,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final f in widget.appState.activeFriends
                      .where((f) => f.completedDailyToday))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          UserAvatarCircle(avatarKey: f.avatarKey, size: 36),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              f.displayName,
                              style: AppTypography.body(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '${f.dailyCorrectToday}/5 • ${f.dailyScoreToday} pts',
                            style: AppTypography.display(
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          const AdBannerWidget(placementLabel: 'Results Banner'),
          const SizedBox(height: 16),

          // Review Your Answers Section
          Text(
            'Review Your Answers (Tap to Study Scripture)',
            style: AppTypography.display(fontSize: 18),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < s.answers.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => showLearnMoreSheet(
                  context,
                  question: s.answers[i].question,
                  wasCorrect: s.answers[i].isCorrect,
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        s.answers[i].isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: s.answers[i].isCorrect
                            ? AppColors.success
                            : AppColors.wrong,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.answers[i].question.questionText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${s.answers[i].question.correctAnswer} • ${s.answers[i].question.bibleReference}',
                              style: AppTypography.body(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+${s.answers[i].totalPoints}',
                        style: AppTypography.display(
                          fontSize: 14,
                          color: s.answers[i].isCorrect
                              ? AppColors.success
                              : AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.foreground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Back to Sword Bible',
                style: AppTypography.display(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStatPill extends StatelessWidget {
  final String label;
  final String value;

  const _ResultStatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.display(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.body(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.7),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
