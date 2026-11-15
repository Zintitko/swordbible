import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';

/// Full-screen multi-slide "Sword Drill™ Wrapped" year-in-review story experience
/// cloned from `WrappedPage-BjVIfhC6.js`.
class WrappedScreen extends StatefulWidget {
  final AppState appState;

  const WrappedScreen({super.key, required this.appState});

  @override
  State<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends State<WrappedScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  static const int _totalSlides = 6;

  void _nextSlide() {
    if (_currentSlide + 1 < _totalSlides) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final slides = <_WrappedSlideData>[
      _WrappedSlideData(
        tag: 'SWORD DRILL™ WRAPPED',
        emoji: '⚔️',
        headline: '${s.displayName},\nYour Year in the Word',
        statBig: '${s.totalPoints}',
        statLabel: 'TOTAL LIFETIME POINTS',
        caption: 'Every drill sharpened your grasp of Scripture.',
        gradient: AppColors.gradientPurpleDeep,
      ),
      _WrappedSlideData(
        tag: 'VERSES DRILLED',
        emoji: '📖',
        headline: 'You Put Truth to the Test',
        statBig: '${s.totalQuestionsAnswered}',
        statLabel: 'QUESTIONS ANSWERED (${s.lifetimeAccuracyPercent}% ACCURACY)',
        caption: 'With ${s.totalCorrectAnswers} correct answers across Old & New Testaments.',
        gradient: AppColors.gradientWarmPurple,
      ),
      _WrappedSlideData(
        tag: 'CONSISTENCY & STREAK',
        emoji: '🔥',
        headline: 'Daily Bread, Daily Drill',
        statBig: '${s.bestStreak} Days',
        statLabel: 'LONGEST DAILY 5 STREAK',
        caption: 'Best Daily 5 Score: ${s.bestDaily5Score} pts.',
        gradient: AppColors.gradientBrand,
      ),
      _WrappedSlideData(
        tag: 'CANON EXPLORER',
        emoji: '🗺️',
        headline: 'Books of the Bible Explored',
        statBig: '${s.booksExplored.length}',
        statLabel: 'BOOKS OF SCRIPTURE STUDIED',
        caption: s.booksExplored.take(8).join(' • '),
        gradient: AppColors.gradientPurpleDeep,
      ),
      _WrappedSlideData(
        tag: 'IRON SHARPENS IRON',
        emoji: '🛡️',
        headline: 'Head-to-Head Duels',
        statBig: '${s.totalH2HWins}W – ${s.totalH2HLosses}L',
        statLabel: 'FRIENDLY RIVALRY RECORD',
        caption: 'Unlocked ${s.unlockedBadgesCount} of ${s.badges.length} Trophy Case Badges.',
        gradient: AppColors.gradientWarmPurple,
      ),
      _WrappedSlideData(
        tag: 'YOUR SUMMARY CARD',
        emoji: '👑',
        headline: ScoringUtils.difficultyTitle(s.knowledgeLevel),
        statBig: '${s.totalPoints} pts',
        statLabel: '🔥 ${s.currentStreak}d Streak • ${s.lifetimeAccuracyPercent}% Accuracy',
        caption: '"For the word of God is living and effective..." — Hebrews 4:12',
        gradient: AppColors.gradientBrand,
      ),
    ];

    return Scaffold(
      body: GestureDetector(
        onTapUp: (_) => _nextSlide(),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              onPageChanged: (idx) => setState(() => _currentSlide = idx),
              itemBuilder: (context, index) {
                final slide = slides[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(gradient: slide.gradient),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            slide.tag,
                            style: AppTypography.body(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.neon,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          slide.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.headline,
                          textAlign: TextAlign.center,
                          style: AppTypography.display(
                            fontSize: 28,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                slide.statBig,
                                textAlign: TextAlign.center,
                                style: AppTypography.display(
                                  fontSize: 48,
                                  color: AppColors.neon,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                slide.statLabel,
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          slide.caption,
                          textAlign: TextAlign.center,
                          style: AppTypography.body(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 36),
                        const BrandWordmark(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Top Story Progress Bars & Close Button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < slides.length; i++)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              height: 4,
                              decoration: BoxDecoration(
                                color: i <= _currentSlide
                                    ? AppColors.neon
                                    : Colors.white.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrappedSlideData {
  final String tag;
  final String emoji;
  final String headline;
  final String statBig;
  final String statLabel;
  final String caption;
  final Gradient gradient;

  const _WrappedSlideData({
    required this.tag,
    required this.emoji,
    required this.headline,
    required this.statBig,
    required this.statLabel,
    required this.caption,
    required this.gradient,
  });
}
