import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/ads/ad_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/learn_more_sheet.dart';
import '../../state/app_state.dart';
import 'quiz_results_screen.dart';

class QuestionPlayScreen extends StatefulWidget {
  final AppState appState;
  final QuizMode mode;
  final String modeTitle;
  final List<BibleQuestion> questions;
  final bool timedMode;
  final bool showCountdownIntro;
  final String? h2hChallengeId;

  const QuestionPlayScreen({
    super.key,
    required this.appState,
    required this.mode,
    required this.modeTitle,
    required this.questions,
    this.timedMode = true,
    this.showCountdownIntro = false,
    this.h2hChallengeId,
  });

  @override
  State<QuestionPlayScreen> createState() => _QuestionPlayScreenState();
}

class _QuestionPlayScreenState extends State<QuestionPlayScreen> {
  int _countdownValue = 3;
  bool _inCountdown = false;
  Timer? _countdownTimer;

  int _currentIndex = 0;
  int? _selectedOption;
  bool _isLocked = false;
  final Set<int> _eliminatedOptions = {};
  bool _usedHintThisQuestion = false;

  Timer? _questionTimer;
  int _remainingSeconds = 30;
  int _totalQuestionSeconds = 30;
  late DateTime _questionStartTime;

  final List<QuizAnswerRecord> _answers = [];
  int _runningScore = 0;

  BibleQuestion get _currentQuestion => widget.questions[_currentIndex];

  @override
  void initState() {
    super.initState();
    if (widget.showCountdownIntro) {
      _inCountdown = true;
      _countdownTimer = Timer.periodic(const Duration( milliseconds: 750), (timer) {
        if (!mounted) return;
        if (_countdownValue > 1) {
          setState(() => _countdownValue--);
        } else {
          timer.cancel();
          setState(() => _inCountdown = false);
          _startQuestionTimer();
        }
      });
    } else {
      _startQuestionTimer();
    }
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _totalQuestionSeconds =
        ScoringUtils.timerSecondsForDifficulty(_currentQuestion.difficulty);
    _remainingSeconds = _totalQuestionSeconds;
    _questionStartTime = DateTime.now();

    if (!widget.timedMode) return;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isLocked) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 1) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
        _submitAnswer(null); // Time expired
      }
    });
  }

  void _submitAnswer(int? optionIndex) {
    if (_isLocked) return;
    _questionTimer?.cancel();

    final elapsedMs = DateTime.now()
        .difference(_questionStartTime)
        .inMilliseconds
        .clamp(0, _totalQuestionSeconds * 1000);
    final isCorrect = optionIndex != null &&
        optionIndex == _currentQuestion.correctOptionIndex;

    final score = ScoringUtils.calculateQuestionScore(
      isCorrect: isCorrect,
      difficulty: _currentQuestion.difficulty,
      elapsedMs: elapsedMs,
      totalTimeMs: _totalQuestionSeconds * 1000,
      timedMode: widget.timedMode,
    );

    final record = QuizAnswerRecord(
      question: _currentQuestion,
      selectedOptionIndex: optionIndex,
      isCorrect: isCorrect,
      elapsedMs: elapsedMs,
      basePoints: score.base,
      speedBonus: score.speedBonus,
      totalPoints: score.total,
    );

    setState(() {
      _selectedOption = optionIndex;
      _isLocked = true;
      _answers.add(record);
      _runningScore += score.total;
    });

    // Auto-open "Sharpen Your Sword" 800ms after a wrong answer (matching QuestionScreen-UGBMqwes.js)
    if (!isCorrect && widget.mode != QuizMode.placement) {
      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        showLearnMoreSheet(
          context,
          question: _currentQuestion,
          wasCorrect: false,
        );
      });
    }
  }

  void _useRewardedAdFiftyFiftyHint() {
    if (_isLocked || _usedHintThisQuestion) return;
    AdService.instance.showRewardedAd(
      onRewardEarned: (_, _) {
        if (!mounted) return;
        final wrongIndices = <int>[0, 1, 2, 3]
          ..remove(_currentQuestion.correctOptionIndex);
        wrongIndices.shuffle();
        setState(() {
          _usedHintThisQuestion = true;
          _eliminatedOptions.addAll(wrongIndices.take(2));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scripture Hint Unlocked! 2 wrong options eliminated.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }

  void _nextQuestionOrFinish() {
    if (_currentIndex + 1 < widget.questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isLocked = false;
        _eliminatedOptions.clear();
        _usedHintThisQuestion = false;
      });
      _startQuestionTimer();
    } else {
      final summary = widget.appState.recordQuizCompletion(
        mode: widget.mode,
        modeSubtitle: widget.modeTitle,
        answers: _answers,
        h2hChallengeId: widget.h2hChallengeId,
      );

      // Trigger AdMob Interstitial Ad after completing round
      AdService.instance.showInterstitialAfterRound(
        onAdDismissed: () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => QuizResultsScreen(
                appState: widget.appState,
                summary: summary,
                h2hChallengeId: widget.h2hChallengeId,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_inCountdown) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.gradientPurpleDeep,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    widget.modeTitle.toUpperCase(),
                    style: AppTypography.body(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neon,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ready Your Sword...',
                  style: AppTypography.display(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: 128,
                  height: 128,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neon,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neon.withValues(alpha: 0.45),
                        blurRadius: 32,
                      ),
                    ],
                  ),
                  child: Text(
                    '$_countdownValue',
                    style: AppTypography.display(
                      fontSize: 68,
                      color: AppColors.neonInk,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () {
                    _countdownTimer?.cancel();
                    setState(() => _inCountdown = false);
                    _startQuestionTimer();
                  },
                  child: Text(
                    'Tap to start immediately →',
                    style: AppTypography.body(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _currentQuestion;
    final progress = (_currentIndex + 1) / widget.questions.length;
    final timerColor = _remainingSeconds <= 5
        ? AppColors.wrong
        : _remainingSeconds <= 10
            ? const Color(0xFFD97706)
            : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Exit Quiz',
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${_currentIndex + 1} of ${widget.questions.length}',
                              style: AppTypography.body(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            Text(
                              '$_runningScore pts',
                              style: AppTypography.display(
                                fontSize: 15,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: AppColors.muted,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.timedMode) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: timerColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: timerColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: timerColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_remainingSeconds}s',
                            style: AppTypography.display(
                              fontSize: 15,
                              color: timerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Question Body & Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                children: [
                  // Gradient Question Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBrand,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppColors.brandShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
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
                                ScoringUtils.difficultyShortBadge(q.difficulty),
                                style: AppTypography.body(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.neonInk,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${q.book} • ${q.topic}',
                                style: AppTypography.body(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          q.questionText,
                          style: AppTypography.display(
                            fontSize: 21,
                            color: Colors.white,
                            height: 1.32,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // AdMob Rewarded 50/50 Hint Bar
                  if (!_isLocked && !_usedHintThisQuestion) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.35),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                        onPressed: _useRewardedAdFiftyFiftyHint,
                        icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
                        label: Text(
                          '50/50 Scripture Hint (Watch Ad)',
                          style: AppTypography.body(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // 4 Answer Choices (A, B, C, D)
                  for (int i = 0; i < q.options.length; i++) ...[
                    _AnswerOptionCard(
                      index: i,
                      text: q.options[i],
                      isLocked: _isLocked,
                      isSelected: _selectedOption == i,
                      isCorrectOption: q.correctOptionIndex == i,
                      isEliminated: _eliminatedOptions.contains(i),
                      onTap: () => _submitAnswer(i),
                    ),
                    const SizedBox(height: 11),
                  ],

                  // Post-Answer Feedback & Action Bar
                  if (_isLocked) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _answers.last.isCorrect
                            ? AppColors.successLight
                            : AppColors.wrongLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _answers.last.isCorrect
                              ? AppColors.success.withValues(alpha: 0.35)
                              : AppColors.wrong.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _answers.last.isCorrect
                                ? Icons.celebration_rounded
                                : Icons.info_outline_rounded,
                            color: _answers.last.isCorrect
                                ? AppColors.success
                                : AppColors.wrong,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _answers.last.isCorrect
                                      ? '+${_answers.last.totalPoints} pts (${_answers.last.basePoints} base + ${_answers.last.speedBonus} speed)'
                                      : _selectedOption == null
                                          ? 'Time\'s up! (${q.bibleReference})'
                                          : 'Not quite — see ${q.bibleReference}',
                                  style: AppTypography.body(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _answers.last.isCorrect
                                        ? AppColors.success
                                        : AppColors.wrong,
                                  ),
                                ),
                                Text(
                                  q.bibleReference,
                                  style: AppTypography.body(
                                    fontSize: 12,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => showLearnMoreSheet(
                              context,
                              question: q,
                              wasCorrect: _answers.last.isCorrect,
                            ),
                            icon: const Icon(Icons.menu_book_rounded, size: 16),
                            label: const Text('Learn More'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _nextQuestionOrFinish,
                        child: Text(
                          _currentIndex + 1 < widget.questions.length
                              ? 'Next Question'
                              : 'See Final Results',
                          style: AppTypography.display(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOptionCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isLocked;
  final bool isSelected;
  final bool isCorrectOption;
  final bool isEliminated;
  final VoidCallback onTap;

  const _AnswerOptionCard({
    required this.index,
    required this.text,
    required this.isLocked,
    required this.isSelected,
    required this.isCorrectOption,
    required this.isEliminated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const letters = ['A', 'B', 'C', 'D'];
    Color bgColor = AppColors.card;
    Color borderColor = AppColors.border;
    Color badgeColor = AppColors.secondary;
    Color badgeTextColor = AppColors.foreground;

    if (isLocked) {
      if (isCorrectOption) {
        bgColor = AppColors.successLight;
        borderColor = AppColors.success;
        badgeColor = AppColors.success;
        badgeTextColor = Colors.white;
      } else if (isSelected && !isCorrectOption) {
        bgColor = AppColors.wrongLight;
        borderColor = AppColors.wrong;
        badgeColor = AppColors.wrong;
        badgeTextColor = Colors.white;
      }
    }

    if (isEliminated && !isLocked) {
      return Opacity(
        opacity: 0.35,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.muted,
                child: Text(
                  letters[index],
                  style: AppTypography.display(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.body(
                    fontSize: 15,
                    color: AppColors.mutedForeground,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: isLocked && (isCorrectOption || isSelected) ? 2 : 1.2,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeColor,
              ),
              child: Text(
                letters[index],
                style: AppTypography.display(
                  fontSize: 15,
                  color: badgeTextColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: AppTypography.body(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ),
            if (isLocked && isCorrectOption)
              const Icon(Icons.check_circle_rounded, color: AppColors.success)
            else if (isLocked && isSelected && !isCorrectOption)
              const Icon(Icons.cancel_rounded, color: AppColors.wrong),
          ],
        ),
      ),
    );
  }
}
