import 'package:flutter/material.dart';
import '../../core/ads/ad_banner_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';

class LeaderboardScreen extends StatefulWidget {
  final AppState appState;

  const LeaderboardScreen({super.key, required this.appState});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0; // 0 = Weekly, 1 = Friends, 2 = Hall of Faith

  void _showScoringModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How Scores Are Calculated',
              style: AppTypography.display(fontSize: 22),
            ),
            const SizedBox(height: 12),
            _ScoringRow(
              badge: 'Level 1',
              title: 'New to the Story',
              detail: '200 Base Pts + up to 200 Speed Bonus (Max 400)',
            ),
            const SizedBox(height: 8),
            _ScoringRow(
              badge: 'Level 2',
              title: 'Sunday School Strong',
              detail: '400 Base Pts + up to 200 Speed Bonus (Max 600)',
            ),
            const SizedBox(height: 8),
            _ScoringRow(
              badge: 'Level 3',
              title: 'Seminary Energy',
              detail: '600 Base Pts + up to 200 Speed Bonus (Max 800)',
            ),
            const SizedBox(height: 14),
            Text(
              'Weekly Leaderboards reset every Sunday at midnight. Hall of Faith tracks lifetime points across Daily 5, Free Play, and H2H duels.',
              style: AppTypography.body(
                fontSize: 13,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Got It'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _selectedTab == 0
        ? widget.appState.getWeeklyLeaderboard()
        : _selectedTab == 1
            ? widget.appState.getFriendsLeaderboard()
            : widget.appState.getHallOfFaithLeaderboard();

    final myEntry = entries.firstWhere(
      (e) => e.isCurrentUser,
      orElse: () => entries.first,
    );

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
                  'Leaderboard',
                  style: AppTypography.display(fontSize: 26),
                ),
                Text(
                  'See who is sharpening their sword this week.',
                  style: AppTypography.body(
                    fontSize: 13.5,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: _showScoringModal,
              icon: const Icon(Icons.help_outline_rounded),
              tooltip: 'How scoring works',
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 3-Tab Switcher
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _TabPill(
                label: 'Weekly',
                selected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
              _TabPill(
                label: 'Friends',
                selected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
              _TabPill(
                label: 'Hall of Faith',
                selected: _selectedTab == 2,
                onTap: () => setState(() => _selectedTab = 2),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Podium (#2, #1, #3)
        if (entries.length >= 3)
          Container(
            padding: const EdgeInsets.fromLTRB(14, 20, 14, 18),
            decoration: BoxDecoration(
              gradient: AppColors.gradientPurpleDeep,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadowLg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _PodiumColumn(
                    entry: entries[1],
                    place: 2,
                    medalColor: AppColors.silver,
                    height: 76,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PodiumColumn(
                    entry: entries[0],
                    place: 1,
                    medalColor: AppColors.gold,
                    height: 102,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PodiumColumn(
                    entry: entries[2],
                    place: 3,
                    medalColor: AppColors.bronze,
                    height: 62,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 14),

        // Your Rank Summary Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.neon.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.neonInk.withValues(alpha: 0.28)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.neonInk,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '#${myEntry.rank}',
                  style: AppTypography.display(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Standing • ${myEntry.accuracyPercent}% Accuracy • ${myEntry.streak}d Streak',
                  style: AppTypography.body(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
              ),
              Text(
                '${myEntry.score} pts',
                style: AppTypography.display(
                  fontSize: 16,
                  color: AppColors.neonInk,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        const AdBannerWidget(placementLabel: 'Leaderboard Banner'),
        const SizedBox(height: 8),

        // Ranked List
        for (final item in entries)
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: item.isCurrentUser
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: item.isCurrentUser ? AppColors.primary : AppColors.border,
                width: item.isCurrentUser ? 1.8 : 1.0,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '#${item.rank}',
                    style: AppTypography.display(
                      fontSize: 15,
                      color: item.rank <= 3
                          ? AppColors.primary
                          : AppColors.mutedForeground,
                    ),
                  ),
                ),
                UserAvatarCircle(avatarKey: item.avatarKey, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.isCurrentUser
                                  ? '${item.displayName} (You)'
                                  : item.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          KnowledgeLevelPill(
                            level: item.knowledgeLevel,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.accuracyPercent}% accuracy • ${item.streak}d streak',
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${item.score}',
                  style: AppTypography.display(
                    fontSize: 17,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected ? AppColors.cardShadow : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.display(
              fontSize: 14,
              color: selected ? AppColors.primary : AppColors.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardEntry entry;
  final int place;
  final Color medalColor;
  final double height;

  const _PodiumColumn({
    required this.entry,
    required this.place,
    required this.medalColor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (place == 1)
          const Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.gold,
            size: 26,
          ),
        UserAvatarCircle(avatarKey: entry.avatarKey, size: place == 1 ? 54 : 44),
        const SizedBox(height: 6),
        Text(
          entry.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.body(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          '${entry.score} pts',
          style: AppTypography.display(
            fontSize: 13,
            color: AppColors.neon,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: place == 1 ? 0.22 : 0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border: Border.all(
              color: medalColor.withValues(alpha: 0.65),
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: 13,
            backgroundColor: medalColor,
            child: Text(
              '$place',
              style: AppTypography.display(
                fontSize: 13,
                color: AppColors.navy,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoringRow extends StatelessWidget {
  final String badge;
  final String title;
  final String detail;

  const _ScoringRow({
    required this.badge,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            badge,
            style: AppTypography.body(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.body(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                detail,
                style: AppTypography.body(
                  fontSize: 12,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
