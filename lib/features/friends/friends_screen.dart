import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';
import '../h2h/h2h_screens.dart';

class FriendsScreen extends StatefulWidget {
  final AppState appState;

  const FriendsScreen({super.key, required this.appState});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  void _showAddFriendDialog() {
    final handleCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Add Friend by @username',
          style: AppTypography.display(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Display Name (e.g. Timothy L.)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: handleCtrl,
              decoration: const InputDecoration(
                labelText: 'Username (e.g. @timothy_ephesus)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (handleCtrl.text.trim().isNotEmpty) {
                widget.appState.addNewFriendByUsername(
                  handleCtrl.text,
                  nameCtrl.text,
                );
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Friend'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = widget.appState.pendingFriendRequests;
    final friends = widget.appState.activeFriends;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friends & Rivals',
                    style: AppTypography.display(fontSize: 26),
                  ),
                  Text(
                    '"Iron sharpens iron, and one person sharpens another."',
                    style: AppTypography.body(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _showAddFriendDialog,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Iron Sharpens Iron H2H Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppColors.gradientBrand,
            borderRadius: BorderRadius.circular(22),
            boxShadow: AppColors.brandShadow,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HEAD-TO-HEAD RECORD',
                      style: AppTypography.body(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.neon,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.appState.totalH2HWins} Wins • ${widget.appState.totalH2HLosses} Losses',
                      style: AppTypography.display(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.appState.activeH2HChallenges.length} active duel waiting for your turn',
                      style: AppTypography.body(
                        fontSize: 12.5,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: AppColors.neonInk,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => H2HHubScreen(appState: widget.appState),
                    ),
                  );
                },
                child: Text(
                  'H2H Hub',
                  style: AppTypography.display(
                    fontSize: 14,
                    color: AppColors.neonInk,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Pending Friend Requests
        if (requests.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'FRIEND REQUESTS (${requests.length})',
            style: AppTypography.body(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          for (final req in requests)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  UserAvatarCircle(avatarKey: req.avatarKey, size: 42),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          req.displayName,
                          style: AppTypography.display(fontSize: 16),
                        ),
                        Text(
                          '@${req.username} • 🔥 ${req.currentStreak}d streak',
                          style: AppTypography.body(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () =>
                        widget.appState.acceptFriendRequest(req.id),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ),
        ],

        const SizedBox(height: 20),
        Text(
          'YOUR FRIENDS (${friends.length})',
          style: AppTypography.body(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.mutedForeground,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),

        for (final f in friends)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: Row(
              children: [
                UserAvatarCircle(avatarKey: f.avatarKey, size: 46),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            f.displayName,
                            style: AppTypography.display(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          KnowledgeLevelPill(
                            level: f.knowledgeLevel,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '@${f.username} • 🔥 ${f.currentStreak}d • H2H: ${f.myWinsAgainst}W–${f.theirWinsAgainstMe}L',
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      if (f.completedDailyToday)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            '✅ Daily 5 Today: ${f.dailyScoreToday} pts (${f.dailyCorrectToday}/5)',
                            style: AppTypography.body(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => H2HHubScreen(
                          appState: widget.appState,
                          preselectedFriend: f,
                        ),
                      ),
                    );
                  },
                  child: const Text('Duel'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
