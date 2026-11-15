import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/models/models.dart';
import 'brand_wordmark.dart';

/// "Sharpen your sword" (Learn More) Bottom Sheet cloned from `LearnMoreSheet-BZQLwpd5.js`.
/// Auto-opens 800ms after a wrong answer or manually when the user taps "Sharpen your sword".
Future<void> showLearnMoreSheet(
  BuildContext context, {
  required BibleQuestion question,
  required bool wasCorrect,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => LearnMoreSheet(
      question: question,
      wasCorrect: wasCorrect,
    ),
  );
}

class LearnMoreSheet extends StatelessWidget {
  final BibleQuestion question;
  final bool wasCorrect;

  const LearnMoreSheet({
    super.key,
    required this.question,
    required this.wasCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.76,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientBrand,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.neon,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sharpen Your Sword',
                                style: AppTypography.display(fontSize: 22),
                              ),
                              Text(
                                wasCorrect
                                    ? 'You nailed it! Dive deeper into the text.'
                                    : 'Every missed question is a chance to learn truth.',
                                style: AppTypography.body(
                                  fontSize: 13,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Correct Answer Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CORRECT ANSWER',
                                  style: AppTypography.body(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.success,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  question.correctAnswer,
                                  style: AppTypography.body(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.foreground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Scripture Reference & CSB Quote Box
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPurpleDeep,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                  question.bibleReference,
                                  style: AppTypography.body(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.neonInk,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${question.testament} • ${question.book}',
                                style: AppTypography.body(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '"${question.csbVerseText}"',
                            style: AppTypography.body(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Christian Standard Bible® (CSB)',
                            style: AppTypography.body(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Context Explainer
                    _InfoSectionCard(
                      icon: Icons.auto_stories_rounded,
                      title: 'The Biblical Context',
                      body: question.contextExplainer,
                      accentColor: AppColors.primary,
                    ),
                    const SizedBox(height: 12),

                    // Why This Matters
                    _InfoSectionCard(
                      icon: Icons.lightbulb_rounded,
                      title: 'Why This Matters',
                      body: question.whyThisMatters,
                      accentColor: const Color(0xFFD97706),
                    ),

                    if (question.whyThisDiffers != null) ...[
                      const SizedBox(height: 12),
                      _InfoSectionCard(
                        icon: Icons.alt_route_rounded,
                        title: 'Different Perspectives',
                        body: question.whyThisDiffers!,
                        accentColor: const Color(0xFF7C3AED),
                      ),
                    ],

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Got It — Keep Drilling',
                          style: AppTypography.display(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color accentColor;

  const _InfoSectionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: AppTypography.body(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTypography.body(
              fontSize: 14.5,
              color: AppColors.foreground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shareable 9:16 Result Card Modal (`$f` in `App-AlODYBux.js`).
Future<void> showShareResultModal(
  BuildContext context, {
  required QuizResultSummary summary,
  required String displayName,
  required int streak,
}) {
  final tier = ScoringUtils.getResultTier(
    summary.correctCount,
    summary.totalQuestions,
  );
  final emojiGrid = summary.answers
      .map((a) => a.isCorrect ? '🟩' : '🟥')
      .join(' ');
  final shareText =
      'sword drill™ • ${summary.modeSubtitle}\n'
      '${tier.emoji} ${tier.title}\n'
      '$emojiGrid (${summary.correctCount}/${summary.totalQuestions})\n'
      'Score: ${summary.totalScore} pts • 🔥 $streak day streak\n'
      'Can you beat my score? #SwordDrill';

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 16),
          // 9:16 Shareable Story Card Preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.gradientWarmPurple,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadowLg,
            ),
            child: Column(
              children: [
                const BrandWordmark(
                  fontSize: 22,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    summary.modeSubtitle.toUpperCase(),
                    style: AppTypography.body(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neon,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  tier.emoji,
                  style: const TextStyle(fontSize: 42),
                ),
                const SizedBox(height: 6),
                Text(
                  tier.title,
                  textAlign: TextAlign.center,
                  style: AppTypography.display(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${tier.subtitle}"',
                  textAlign: TextAlign.center,
                  style: AppTypography.body(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${summary.totalScore}',
                  style: AppTypography.display(
                    fontSize: 44,
                    color: AppColors.neon,
                    height: 1.0,
                  ),
                ),
                Text(
                  'POINTS • ${summary.correctCount}/${summary.totalQuestions} CORRECT (${summary.accuracyPercent}%)',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  emojiGrid,
                  style: const TextStyle(fontSize: 20, letterSpacing: 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: shareText));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Result card copied to clipboard! Ready to share.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(
                'Copy & Share Result Card',
                style: AppTypography.display(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
