import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';
import '../quiz/question_play_screen.dart';

class H2HHubScreen extends StatefulWidget {
  final AppState appState;
  final FriendProfile? preselectedFriend;

  const H2HHubScreen({
    super.key,
    required this.appState,
    this.preselectedFriend,
  });

  @override
  State<H2HHubScreen> createState() => _H2HHubScreenState();
}

class _H2HHubScreenState extends State<H2HHubScreen> {
  int _selectedDifficulty = 2; // 0 = Mix, 1, 2, 3
  String _selectedCategoryType = 'any';
  String _selectedCategoryLabel = 'Surprise Mix';
  String? _selectedFilterValue;
  FriendProfile? _selectedOpponent;

  @override
  void initState() {
    super.initState();
    _selectedOpponent = widget.preselectedFriend ??
        (widget.appState.activeFriends.isNotEmpty
            ? widget.appState.activeFriends.first
            : null);
  }

  void _createAndPlayChallenge() {
    final opponent = _selectedOpponent;
    if (opponent == null) return;

    final challenge = widget.appState.createH2HChallenge(
      opponent: opponent,
      difficulty: _selectedDifficulty,
      categoryType: _selectedCategoryType,
      categoryLabel: _selectedCategoryLabel,
      filterValue: _selectedFilterValue,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuestionPlayScreen(
          appState: widget.appState,
          mode: QuizMode.h2h,
          modeTitle: 'H2H vs ${opponent.displayName}',
          questions: challenge.questions,
          showCountdownIntro: true,
          h2hChallengeId: challenge.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final active = widget.appState.activeH2HChallenges;
        final history = widget.appState.completedH2HChallenges;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'Head-to-Head Duels',
              style: AppTypography.display(fontSize: 22),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
            children: [
              // Iron Sharpens Iron Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPurpleDeep,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.cardShadowLg,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.neon,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.sports_kabaddi_rounded,
                        color: AppColors.neonInk,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IRON SHARPENS IRON',
                            style: AppTypography.body(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.neon,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '5 Questions • Same Clock • Best Score Wins',
                            style: AppTypography.display(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Overall Record: ${widget.appState.totalH2HWins}W – ${widget.appState.totalH2HLosses}L (Proverbs 27:17)',
                            style: AppTypography.body(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Active Challenges ("Your Turn")
              if (active.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'YOUR TURN (${active.length})',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                for (final c in active)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        UserAvatarCircle(avatarKey: c.opponent.avatarKey, size: 46),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${c.opponent.displayName} challenged you!',
                                style: AppTypography.display(fontSize: 16),
                              ),
                              Text(
                                '${c.categoryLabel} • ${ScoringUtils.difficultyShortBadge(c.difficulty == 0 ? 2 : c.difficulty)}',
                                style: AppTypography.body(
                                  fontSize: 12.5,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                              if (c.opponentScore != null)
                                Text(
                                  'Their score to beat: ${c.opponentScore} pts',
                                  style: AppTypography.body(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => QuestionPlayScreen(
                                  appState: widget.appState,
                                  mode: QuizMode.h2h,
                                  modeTitle: 'H2H vs ${c.opponent.displayName}',
                                  questions: c.questions,
                                  showCountdownIntro: true,
                                  h2hChallengeId: c.id,
                                ),
                              ),
                            );
                          },
                          child: const Text('Play Duel'),
                        ),
                      ],
                    ),
                  ),
              ],

              const SizedBox(height: 20),

              // 3-Step New Challenge Builder
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
                      'CREATE NEW CHALLENGE',
                      style: AppTypography.body(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Step 1: Choose Difficulty',
                      style: AppTypography.display(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final lvl in [1, 2, 3, 0])
                          ChoiceChip(
                            label: Text(
                              lvl == 0
                                  ? 'Mix All Levels'
                                  : 'Lvl $lvl • ${ScoringUtils.difficultyTitle(lvl)}',
                            ),
                            selected: _selectedDifficulty == lvl,
                            selectedColor: AppColors.neon,
                            onSelected: (_) =>
                                setState(() => _selectedDifficulty = lvl),
                          ),
                      ],
                    ),
                    const Divider(height: 26),
                    Text(
                      'Step 2: Choose Category',
                      style: AppTypography.display(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _CategoryPresetChip(
                          label: '🎲 Surprise Mix',
                          selected: _selectedCategoryLabel == 'Surprise Mix',
                          onTap: () => setState(() {
                            _selectedCategoryType = 'any';
                            _selectedCategoryLabel = 'Surprise Mix';
                            _selectedFilterValue = null;
                          }),
                        ),
                        _CategoryPresetChip(
                          label: '🌊 Miracles',
                          selected: _selectedCategoryLabel == 'Miracles',
                          onTap: () => setState(() {
                            _selectedCategoryType = 'topic';
                            _selectedCategoryLabel = 'Miracles';
                            _selectedFilterValue = 'Miracles';
                          }),
                        ),
                        _CategoryPresetChip(
                          label: '🌾 Parables',
                          selected: _selectedCategoryLabel == 'Parables',
                          onTap: () => setState(() {
                            _selectedCategoryType = 'topic';
                            _selectedCategoryLabel = 'Parables';
                            _selectedFilterValue = 'Parables';
                          }),
                        ),
                        _CategoryPresetChip(
                          label: '👑 King David',
                          selected: _selectedCategoryLabel == 'King David',
                          onTap: () => setState(() {
                            _selectedCategoryType = 'character';
                            _selectedCategoryLabel = 'King David';
                            _selectedFilterValue = 'David';
                          }),
                        ),
                        _CategoryPresetChip(
                          label: '⚡ Apostle Paul',
                          selected: _selectedCategoryLabel == 'Apostle Paul',
                          onTap: () => setState(() {
                            _selectedCategoryType = 'character';
                            _selectedCategoryLabel = 'Apostle Paul';
                            _selectedFilterValue = 'Paul';
                          }),
                        ),
                      ],
                    ),
                    const Divider(height: 26),
                    Text(
                      'Step 3: Pick Opponent',
                      style: AppTypography.display(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    for (final f in widget.appState.activeFriends)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => setState(() => _selectedOpponent = f),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedOpponent?.id == f.id
                                  ? AppColors.primary.withValues(alpha: 0.10)
                                  : AppColors.secondary,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _selectedOpponent?.id == f.id
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: _selectedOpponent?.id == f.id ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                UserAvatarCircle(avatarKey: f.avatarKey, size: 38),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.displayName,
                                        style: AppTypography.body(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '@${f.username} • H2H: ${f.myWinsAgainst}W – ${f.theirWinsAgainstMe}L',
                                        style: AppTypography.body(
                                          fontSize: 12,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedOpponent?.id == f.id)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
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
                        onPressed: _createAndPlayChallenge,
                        icon: const Icon(Icons.bolt_rounded, color: AppColors.neon),
                        label: Text(
                          'Send Challenge & Play My Turn',
                          style: AppTypography.display(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Completed Match History
              if (history.isNotEmpty) ...[
                const SizedBox(height: 22),
                Text(
                  'RECENT H2H RESULTS',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mutedForeground,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                for (final h in history)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        UserAvatarCircle(avatarKey: h.opponent.avatarKey, size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'vs ${h.opponent.displayName}',
                                    style: AppTypography.display(fontSize: 15.5),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: h.didIWin
                                          ? AppColors.successLight
                                          : AppColors.wrongLight,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      h.didIWin ? 'VICTORY' : 'DEFEAT',
                                      style: AppTypography.body(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: h.didIWin
                                            ? AppColors.success
                                            : AppColors.wrong,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${h.categoryLabel} • You: ${h.myScore} pts (${h.myCorrect}/5) vs Them: ${h.opponentScore} pts (${h.opponentCorrect}/5)',
                                style: AppTypography.body(
                                  fontSize: 12,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CategoryPresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryPresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.neon,
      onSelected: (_) => onTap(),
    );
  }
}
