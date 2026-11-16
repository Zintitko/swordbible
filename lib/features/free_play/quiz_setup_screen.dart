import 'package:flutter/material.dart';
import '../../core/ads/ad_banner_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/models/models.dart';
import '../../data/seed/questions_bank.dart';
import '../../state/app_state.dart';
import '../quiz/question_play_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  final AppState appState;
  final String initialFilterType;
  final String? initialFilterValue;

  const QuizSetupScreen({
    super.key,
    required this.appState,
    this.initialFilterType = 'surprise',
    this.initialFilterValue,
  });

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int _quizLength = 5;
  bool _mixAllLevels = false;
  bool _timedMode = true;
  late String _filterType; // 'surprise', 'testament', 'topic', 'character', 'book'
  String? _selectedFilterValue;
  String _bookTestamentTab = 'OT';

  @override
  void initState() {
    super.initState();
    _filterType = widget.initialFilterType;
    _selectedFilterValue = widget.initialFilterValue;
  }

  void _startFreePlay() {
    final difficulty = _mixAllLevels ? null : widget.appState.knowledgeLevel;
    final questions = QuestionsBank.filterQuestions(
      difficulty: difficulty,
      filterType: _filterType,
      filterValue: _selectedFilterValue,
      count: _quizLength,
    );

    final subtitle = _filterType == 'surprise' || _selectedFilterValue == null
        ? 'Free Play • Surprise Mix'
        : 'Free Play • $_selectedFilterValue';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuestionPlayScreen(
          appState: widget.appState,
          mode: QuizMode.freePlay,
          modeTitle: subtitle,
          questions: questions,
          timedMode: _timedMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free Play Setup',
                  style: AppTypography.display(fontSize: 26),
                ),
                Text(
                  'Customize your Sword Bible session by length & focus.',
                  style: AppTypography.body(
                    fontSize: 13.5,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Step 1: Length & Difficulty Options Card
        Container(
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
              Text(
                '1. QUIZ LENGTH & DIFFICULTY',
                style: AppTypography.body(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final len in [5, 10, 20])
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: len == 20 ? 0 : 8),
                        child: ChoiceChip(
                          showCheckmark: false,
                          selected: _quizLength == len,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.secondary,
                          label: SizedBox(
                            width: double.infinity,
                            child: Text(
                              '$len Qs',
                              textAlign: TextAlign.center,
                              style: AppTypography.display(
                                fontSize: 14,
                                color: _quizLength == len
                                    ? Colors.white
                                    : AppColors.foreground,
                              ),
                            ),
                          ),
                          onSelected: (_) => setState(() => _quizLength = len),
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(height: 24),
              Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Mix All Difficulty Levels',
                        style: AppTypography.body(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        _mixAllLevels
                            ? 'Pulling from Beginner, Intermediate, and Advanced'
                            : 'Locked to Level ${widget.appState.knowledgeLevel}: ${ScoringUtils.difficultyTitle(widget.appState.knowledgeLevel)}',
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      value: _mixAllLevels,
                      activeTrackColor: AppColors.primary,
                      onChanged: (v) => setState(() => _mixAllLevels = v),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '30s / 60s Speed Bonus Timer',
                        style: AppTypography.body(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        _timedMode
                            ? 'Earn up to +200 extra speed points per question'
                            : 'Relaxed study mode — no countdown clock',
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      value: _timedMode,
                      activeTrackColor: AppColors.primary,
                      onChanged: (v) => setState(() => _timedMode = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Step 2: Category / Filter Type
        Container(
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
              Text(
                '2. CHOOSE YOUR FOCUS',
                style: AppTypography.body(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterTypeChip(
                    label: 'Surprise Me',
                    selected: _filterType == 'surprise',
                    onTap: () => setState(() {
                      _filterType = 'surprise';
                      _selectedFilterValue = null;
                    }),
                  ),
                  _FilterTypeChip(
                    label: 'Testament',
                    selected: _filterType == 'testament',
                    onTap: () => setState(() {
                      _filterType = 'testament';
                      _selectedFilterValue = 'OT';
                    }),
                  ),
                  _FilterTypeChip(
                    label: 'Topic',
                    selected: _filterType == 'topic',
                    onTap: () => setState(() {
                      _filterType = 'topic';
                      _selectedFilterValue = QuestionsBank.topics.first;
                    }),
                  ),
                  _FilterTypeChip(
                    label: 'Character',
                    selected: _filterType == 'character',
                    onTap: () => setState(() {
                      _filterType = 'character';
                      _selectedFilterValue = QuestionsBank.characters.first;
                    }),
                  ),
                  _FilterTypeChip(
                    label: 'Book of the Bible',
                    selected: _filterType == 'book',
                    onTap: () => setState(() {
                      _filterType = 'book';
                      _selectedFilterValue = QuestionsBank.oldTestamentBooks.first;
                    }),
                  ),
                ],
              ),

              if (_filterType != 'surprise') ...[
                const Divider(height: 26),
                Text(
                  '3. SELECT SPECIFIC ${_filterType.toUpperCase()}',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mutedForeground,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                if (_filterType == 'testament')
                  Row(
                    children: [
                      Expanded(
                        child: _SelectionTile(
                          title: 'Old Testament',
                          subtitle: 'Genesis – Malachi',
                          selected: _selectedFilterValue == 'OT',
                          onTap: () => setState(() => _selectedFilterValue = 'OT'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SelectionTile(
                          title: 'New Testament',
                          subtitle: 'Matthew – Revelation',
                          selected: _selectedFilterValue == 'NT',
                          onTap: () => setState(() => _selectedFilterValue = 'NT'),
                        ),
                      ),
                    ],
                  )
                else if (_filterType == 'topic')
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final topic in QuestionsBank.topics)
                        ChoiceChip(
                          label: Text(topic),
                          selected: _selectedFilterValue == topic,
                          selectedColor: AppColors.neon,
                          onSelected: (_) =>
                              setState(() => _selectedFilterValue = topic),
                        ),
                    ],
                  )
                else if (_filterType == 'character')
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final charName in QuestionsBank.characters)
                        ChoiceChip(
                          label: Text(charName),
                          selected: _selectedFilterValue == charName,
                          selectedColor: AppColors.neon,
                          onSelected: (_) =>
                              setState(() => _selectedFilterValue = charName),
                        ),
                    ],
                  )
                else if (_filterType == 'book') ...[
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Old Testament'),
                        selected: _bookTestamentTab == 'OT',
                        onSelected: (_) => setState(() {
                          _bookTestamentTab = 'OT';
                          _selectedFilterValue = QuestionsBank.oldTestamentBooks.first;
                        }),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('New Testament'),
                        selected: _bookTestamentTab == 'NT',
                        onSelected: (_) => setState(() {
                          _bookTestamentTab = 'NT';
                          _selectedFilterValue = QuestionsBank.newTestamentBooks.first;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final b in (_bookTestamentTab == 'OT'
                          ? QuestionsBank.oldTestamentBooks
                          : QuestionsBank.newTestamentBooks))
                        ChoiceChip(
                          label: Text(b),
                          selected: _selectedFilterValue == b,
                          selectedColor: AppColors.neon,
                          onSelected: (_) =>
                              setState(() => _selectedFilterValue = b),
                        ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Launch Button
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.gradientBrand,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.brandShadow,
          ),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _startFreePlay,
            icon: const Icon(Icons.bolt_rounded, color: AppColors.neon),
            label: Text(
              'Start Sword Bible ($_quizLength Questions)',
              style: AppTypography.display(fontSize: 18, color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 14),
        const AdBannerWidget(placementLabel: 'Free Play Setup Banner'),
      ],
    );
  }
}

class _FilterTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: AppTypography.body(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.foreground,
          ),
        ),
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SelectionTile({
    required this.title,
    required this.subtitle,
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
              title,
              style: AppTypography.display(
                fontSize: 15,
                color: selected ? AppColors.primary : AppColors.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.body(
                fontSize: 11.5,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
