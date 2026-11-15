import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/ads/ad_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/models.dart';
import '../../data/seed/questions_bank.dart';
import '../../shared/widgets/learn_more_sheet.dart';
import '../../state/app_state.dart';

class FamilyModeSetupScreen extends StatefulWidget {
  final AppState appState;

  const FamilyModeSetupScreen({super.key, required this.appState});

  @override
  State<FamilyModeSetupScreen> createState() => _FamilyModeSetupScreenState();
}

class _FamilyModeSetupScreenState extends State<FamilyModeSetupScreen> {
  late String _sublevel; // '1a' = Bible Basics, '1b' = Bible Basics+
  late String _focusType; // 'surprise', 'topic', 'character', 'book'
  String? _focusValue;
  late int _length;

  @override
  void initState() {
    super.initState();
    _sublevel = widget.appState.lastFamilySublevel;
    _focusType = widget.appState.lastFamilyFocusType;
    _focusValue = widget.appState.lastFamilyFocusValue;
    _length = widget.appState.lastFamilyLength;
  }

  void _launchFamilyPlay() {
    widget.appState.saveFamilyPreset(
      sublevel: _sublevel,
      focusType: _focusType,
      focusValue: _focusValue,
      length: _length,
    );
    final questions = QuestionsBank.filterQuestions(
      sublevel: _sublevel,
      filterType: _focusType,
      filterValue: _focusValue,
      count: _length,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FamilyModePlayScreen(
          appState: widget.appState,
          questions: questions,
          sublevelLabel: _sublevel == '1a' ? 'Bible Basics' : 'Bible Basics+',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Family Mode',
          style: AppTypography.display(fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
        children: [
          // Hero Intro Banner
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.gradientFamilyWarm,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.brandShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neon,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'PASS & PLAY • KID SAFE',
                    style: AppTypography.body(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neonInk,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bible Trivia for the Whole Table',
                  style: AppTypography.display(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'No timers, kid-friendly difficulty levels, a 3-second "Hold to Exit" parent lock, and zero impact on your personal streak or stats.',
                  style: AppTypography.body(
                    fontSize: 13.5,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Step 1: Sublevel Picker (Bible Basics vs Bible Basics+)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. CHOOSE AGE / READING LEVEL',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SublevelCard(
                        title: 'Bible Basics',
                        badge: 'Level 1a • Younger Kids',
                        description: 'Creation, Noah, David & Goliath, Jesus\' miracles.',
                        selected: _sublevel == '1a',
                        onTap: () => setState(() => _sublevel = '1a'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SublevelCard(
                        title: 'Bible Basics+',
                        badge: 'Level 1b • Older Kids',
                        description: 'Parables, Esther, Elijah, Ruth, and Acts.',
                        selected: _sublevel == '1b',
                        onTap: () => setState(() => _sublevel = '1b'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Step 2: Focus & Round Length
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2. ROUND LENGTH',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (final len in [5, 10, 15, 20])
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: len == 20 ? 0 : 8),
                          child: ChoiceChip(
                            showCheckmark: false,
                            selected: _length == len,
                            selectedColor: AppColors.primary,
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '$len Qs',
                                textAlign: TextAlign.center,
                                style: AppTypography.display(
                                  fontSize: 14,
                                  color: _length == len
                                      ? Colors.white
                                      : AppColors.foreground,
                                ),
                              ),
                            ),
                            onSelected: (_) => setState(() => _length = len),
                          ),
                        ),
                      ),
                  ],
                ),
                const Divider(height: 26),
                Text(
                  '3. ROUND FOCUS',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('🎲 Surprise Mix'),
                      selected: _focusType == 'surprise',
                      onSelected: (_) => setState(() {
                        _focusType = 'surprise';
                        _focusValue = null;
                      }),
                    ),
                    ChoiceChip(
                      label: const Text('🌊 Miracles'),
                      selected:
                          _focusType == 'topic' && _focusValue == 'Miracles',
                      onSelected: (_) => setState(() {
                        _focusType = 'topic';
                        _focusValue = 'Miracles';
                      }),
                    ),
                    ChoiceChip(
                      label: const Text('🌾 Parables'),
                      selected:
                          _focusType == 'topic' && _focusValue == 'Parables',
                      onSelected: (_) => setState(() {
                        _focusType = 'topic';
                        _focusValue = 'Parables';
                      }),
                    ),
                    ChoiceChip(
                      label: const Text('👑 Heroes (David, Moses, Jesus)'),
                      selected: _focusType == 'character',
                      onSelected: (_) => setState(() {
                        _focusType = 'character';
                        _focusValue = 'David';
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _launchFamilyPlay,
              icon: const Icon(Icons.family_restroom_rounded),
              label: Text(
                'Start Family Round ($_length Questions)',
                style: AppTypography.display(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SublevelCard extends StatelessWidget {
  final String title;
  final String badge;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _SublevelCard({
    required this.title,
    required this.badge,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.10)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badge,
              style: AppTypography.body(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTypography.display(fontSize: 17),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTypography.body(
                fontSize: 12,
                color: AppColors.mutedForeground,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Family Mode Play Screen with the 3-second "Hold to Exit" parent lock (`FamilyModePlayPage-gnK4Ml1u.js`).
class FamilyModePlayScreen extends StatefulWidget {
  final AppState appState;
  final List<BibleQuestion> questions;
  final String sublevelLabel;

  const FamilyModePlayScreen({
    super.key,
    required this.appState,
    required this.questions,
    required this.sublevelLabel,
  });

  @override
  State<FamilyModePlayScreen> createState() => _FamilyModePlayScreenState();
}

class _FamilyModePlayScreenState extends State<FamilyModePlayScreen> {
  int _index = 0;
  int? _selectedOption;
  bool _isLocked = false;
  int _correctCount = 0;

  // 3-second hold-to-exit parent guard
  Timer? _holdExitTimer;
  double _holdProgress = 0.0;

  void _startHoldToExit() {
    _holdExitTimer?.cancel();
    setState(() => _holdProgress = 0.05);
    _holdExitTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _holdProgress += 1 / 30; // 3.0 seconds
      });
      if (_holdProgress >= 1.0) {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  void _cancelHoldToExit() {
    _holdExitTimer?.cancel();
    if (mounted) {
      setState(() => _holdProgress = 0.0);
    }
  }

  void _selectAnswer(int optionIdx) {
    if (_isLocked) return;
    final isCorrect = optionIdx == widget.questions[_index].correctOptionIndex;
    setState(() {
      _selectedOption = optionIdx;
      _isLocked = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextOrFinish() {
    if (_index + 1 < widget.questions.length) {
      setState(() {
        _index++;
        _selectedOption = null;
        _isLocked = false;
      });
    } else {
      widget.appState.recordQuizCompletion(
        mode: QuizMode.familyMode,
        modeSubtitle: 'Family Mode • ${widget.sublevelLabel}',
        answers: [],
      );
      AdService.instance.showInterstitialAfterRound(
        onAdDismissed: () {
          if (!mounted) return;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                '🎉 Family Round Complete!',
                textAlign: TextAlign.center,
                style: AppTypography.display(fontSize: 22),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_correctCount / ${widget.questions.length}',
                    style: AppTypography.display(
                      fontSize: 44,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Awesome teamwork! Your personal streak and stats were kept untouched.',
                    textAlign: TextAlign.center,
                    style: AppTypography.body(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Setup'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _index = 0;
                      _selectedOption = null;
                      _isLocked = false;
                      _correctCount = 0;
                    });
                  },
                  child: const Text('Play Again'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _holdExitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_index];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with 3-second Hold-to-Exit button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTapDown: (_) => _startHoldToExit(),
                    onTapUp: (_) => _cancelHoldToExit(),
                    onTapCancel: _cancelHoldToExit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              value: _holdProgress > 0 ? _holdProgress : 0,
                              strokeWidth: 2.5,
                              backgroundColor: AppColors.muted,
                              color: AppColors.wrong,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _holdProgress > 0
                                ? 'Hold 3s to Exit...'
                                : 'Hold 3s to Exit',
                            style: AppTypography.body(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neon,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Family • ${_index + 1}/${widget.questions.length}',
                      style: AppTypography.display(
                        fontSize: 14,
                        color: AppColors.neonInk,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientFamilyWarm,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.sublevelLabel.toUpperCase()} • ${q.book.toUpperCase()}',
                          style: AppTypography.body(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.neon,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q.questionText,
                          style: AppTypography.display(
                            fontSize: 22,
                            color: Colors.white,
                            height: 1.32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < q.options.length; i++) ...[
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _isLocked ? null : () => _selectAnswer(i),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isLocked && i == q.correctOptionIndex
                              ? AppColors.successLight
                              : _isLocked && i == _selectedOption
                                  ? AppColors.wrongLight
                                  : AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _isLocked && i == q.correctOptionIndex
                                ? AppColors.success
                                : _isLocked && i == _selectedOption
                                    ? AppColors.wrong
                                    : AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                q.options[i],
                                style: AppTypography.body(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (_isLocked && i == q.correctOptionIndex)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (_isLocked) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => showLearnMoreSheet(
                              context,
                              question: q,
                              wasCorrect:
                                  _selectedOption == q.correctOptionIndex,
                            ),
                            icon: const Icon(Icons.menu_book_rounded),
                            label: const Text('Read the Bible Story'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: _nextOrFinish,
                            child: Text(
                              _index + 1 < widget.questions.length
                                  ? 'Next Question →'
                                  : 'See Recap →',
                            ),
                          ),
                        ),
                      ],
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
