import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';
import '../settings/settings_screen.dart';
import '../wrapped/wrapped_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  void _showEditNameDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: appState.displayName);
    final handleCtrl = TextEditingController(text: appState.username);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Edit Profile',
          style: AppTypography.display(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: handleCtrl,
              decoration: const InputDecoration(
                labelText: '@username',
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
              appState.updateProfile(
                displayName: nameCtrl.text,
                username: handleCtrl.text,
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetail(BuildContext context, BadgeItem badge) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: badge.isUnlocked
                  ? badge.color.withValues(alpha: 0.16)
                  : AppColors.muted,
              child: Icon(
                badge.icon,
                size: 36,
                color: badge.isUnlocked ? badge.color : AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              badge.name,
              style: AppTypography.display(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: AppTypography.body(
                fontSize: 14.5,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? AppColors.successLight
                    : AppColors.secondary,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                badge.isUnlocked ? 'UNLOCKED' : 'LOCKED • KEEP DRILLING',
                style: AppTypography.body(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: badge.isUnlocked
                      ? AppColors.success
                      : AppColors.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = appState;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
      children: [
        // Profile Header Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              UserAvatarCircle(avatarKey: s.avatarKey, size: 64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            s.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.display(fontSize: 22),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _showEditNameDialog(context),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit Name',
                        ),
                      ],
                    ),
                    Text(
                      '@${s.username}',
                      style: AppTypography.body(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    if (!s.hideKnowledgeLevel) ...[
                      const SizedBox(height: 8),
                      KnowledgeLevelPill(level: s.knowledgeLevel),
                    ],
                  ],
                ),
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
        ),

        const SizedBox(height: 16),

        // Sword Drill™ Wrapped Banner
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WrappedScreen(appState: s),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.gradientWarmPurple,
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppColors.cardShadowLg,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.neon,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.neonInk,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SWORD BIBLE WRAPPED',
                        style: AppTypography.body(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.neon,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        'Tap to Replay Your Year in the Word',
                        style: AppTypography.display(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // 6 Stat Cards Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.65,
          children: [
            _ProfileStatTile(
              icon: Icons.local_fire_department_rounded,
              iconColor: const Color(0xFFEA580C),
              value: '${s.currentStreak} Days',
              label: 'Current Streak',
            ),
            _ProfileStatTile(
              icon: Icons.whatshot_rounded,
              iconColor: const Color(0xFFDC2626),
              value: '${s.bestStreak} Days',
              label: 'Best Streak',
            ),
            _ProfileStatTile(
              icon: Icons.bolt_rounded,
              iconColor: AppColors.primary,
              value: '${s.totalPoints}',
              label: 'Lifetime Points',
            ),
            _ProfileStatTile(
              icon: Icons.gps_fixed_rounded,
              iconColor: AppColors.success,
              value: '${s.lifetimeAccuracyPercent}%',
              label: 'Accuracy (${s.totalCorrectAnswers}/${s.totalQuestionsAnswered})',
            ),
            _ProfileStatTile(
              icon: Icons.workspace_premium_rounded,
              iconColor: const Color(0xFFCA8A04),
              value: '${s.bestDaily5Score} pts',
              label: 'Best Daily 5',
            ),
            _ProfileStatTile(
              icon: Icons.menu_book_rounded,
              iconColor: const Color(0xFF7C3AED),
              value: '${s.booksExplored.length} / 66',
              label: 'Books Explored',
            ),
          ],
        ),

        const SizedBox(height: 22),

        // Trophy Case Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trophy Case',
              style: AppTypography.display(fontSize: 20),
            ),
            Text(
              '${s.unlockedBadgesCount} / ${s.badges.length} Unlocked',
              style: AppTypography.body(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: s.badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final b = s.badges[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _showBadgeDetail(context, b),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: b.isUnlocked ? AppColors.card : AppColors.secondary,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: b.isUnlocked
                        ? b.color.withValues(alpha: 0.45)
                        : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: b.isUnlocked
                          ? b.color.withValues(alpha: 0.14)
                          : AppColors.muted,
                      child: Icon(
                        b.icon,
                        color: b.isUnlocked
                            ? b.color
                            : AppColors.mutedForeground,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      b.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.body(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: b.isUnlocked
                            ? AppColors.foreground
                            : AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _ProfileStatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.display(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body(
              fontSize: 12,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
