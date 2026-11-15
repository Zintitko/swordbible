import 'package:flutter/material.dart';
import '../../core/ads/ad_config.dart';
import '../../core/ads/ad_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/models/models.dart';
import '../../data/seed/badges_and_avatars_bank.dart';
import '../../data/seed/questions_bank.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';
import '../quiz/question_play_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedAvatarCategory = 'Classic';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.appState, AdService.instance]),
      builder: (context, _) {
        final s = widget.appState;
        final categoryAvatars = BadgesAndAvatarsBank.avatars
            .where((a) => a.category == _selectedAvatarCategory)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'Settings',
              style: AppTypography.display(fontSize: 22),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
            children: [
              // 1. Avatar Icon Picker (29 Icons across 4 Categories)
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
                    Row(
                      children: [
                        UserAvatarCircle(avatarKey: s.avatarKey, size: 52),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CHOOSE YOUR AVATAR (29 ICONS)',
                                style: AppTypography.body(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                BadgesAndAvatarsBank.getAvatarByKey(s.avatarKey).label,
                                style: AppTypography.display(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final cat in ['Classic', 'Faith', 'Signs', 'Creation'])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: _selectedAvatarCategory == cat,
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _selectedAvatarCategory == cat
                                      ? Colors.white
                                      : AppColors.foreground,
                                  fontWeight: FontWeight.w700,
                                ),
                                onSelected: (_) => setState(
                                  () => _selectedAvatarCategory = cat,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final preset in categoryAvatars)
                          GestureDetector(
                            onTap: () =>
                                s.updateProfile(avatarKey: preset.key),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: preset.accentColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: s.avatarKey == preset.key
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: Icon(
                                preset.icon,
                                color: preset.accentColor,
                                size: 28,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Knowledge Level & Placement Quiz
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
                      'BIBLE KNOWLEDGE LEVEL',
                      style: AppTypography.body(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final lvl in [1, 2, 3])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => s.updateProfile(knowledgeLevel: lvl),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: s.knowledgeLevel == lvl
                                  ? AppColors.primary.withValues(alpha: 0.10)
                                  : AppColors.secondary,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: s.knowledgeLevel == lvl
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: s.knowledgeLevel == lvl ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  s.knowledgeLevel == lvl
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: s.knowledgeLevel == lvl
                                      ? AppColors.primary
                                      : AppColors.mutedForeground,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level $lvl • ${ScoringUtils.difficultyTitle(lvl)}',
                                        style: AppTypography.body(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        ScoringUtils.difficultySubtitle(lvl),
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
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => QuestionPlayScreen(
                                appState: s,
                                mode: QuizMode.placement,
                                modeTitle: 'Placement Quiz (Find My Level)',
                                questions: QuestionsBank.getPlacementQuestions(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.compass_calibration_rounded),
                        label: const Text('Not Sure? Take 6-Question Placement Quiz'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Privacy, Family Mode & Reminders
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
                      'EXPERIENCE & PRIVACY',
                      style: AppTypography.body(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show Family Mode on Home'),
                      subtitle: const Text(
                        'Quick access to kid-friendly pass-and-play rounds',
                      ),
                      value: s.familyModeEnabled,
                      onChanged: (v) =>
                          s.updateProfile(familyModeEnabled: v),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hide Knowledge Level on Profile'),
                      value: s.hideKnowledgeLevel,
                      onChanged: (v) =>
                          s.updateProfile(hideKnowledgeLevel: v),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Appear on Friends Leaderboard'),
                      value: s.showOnFriendsLeaderboard,
                      onChanged: (v) =>
                          s.updateProfile(showOnFriendsLeaderboard: v),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Appear on Global Leaderboard'),
                      value: s.showOnGlobalLeaderboard,
                      onChanged: (v) =>
                          s.updateProfile(showOnGlobalLeaderboard: v),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.alarm_rounded,
                        color: AppColors.primary,
                      ),
                      title: const Text('Daily 5 Reminder Time'),
                      subtitle: Text(s.reminderTime),
                      trailing: DropdownButton<String>(
                        value: s.reminderTime,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(
                            value: '07:00 AM',
                            child: Text('07:00 AM'),
                          ),
                          DropdownMenuItem(
                            value: '08:00 AM',
                            child: Text('08:00 AM'),
                          ),
                          DropdownMenuItem(
                            value: '12:00 PM',
                            child: Text('12:00 PM'),
                          ),
                          DropdownMenuItem(
                            value: '08:00 PM',
                            child: Text('08:00 PM'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) s.updateProfile(reminderTime: v);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Google AdMob SDK Integration Console
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.ads_click_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'GOOGLE ADMOB SDK INTEGRATION',
                          style: AppTypography.body(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'App ID: ${AdConfig.appId}\n'
                      'Interstitials Shown: ${AdService.instance.interstitialsShown} • Rewarded Watched: ${AdService.instance.rewardedAdsWatched}',
                      style: AppTypography.body(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable AdMob Ads'),
                      subtitle: const Text('Banner, Interstitial & Rewarded Ads'),
                      value: AdService.instance.adsEnabled,
                      onChanged: (v) => AdService.instance.setAdsEnabled(v),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              AdService.instance.showInterstitialAfterRound(
                                force: true,
                                onAdDismissed: () {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Interstitial Ad triggered!'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Test Interstitial'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              AdService.instance.showRewardedAd(
                                onRewardEarned: (amt, _) {
                                  s.addBonusPointsFromAd(amt);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Rewarded Ad completed! +$amt pts added.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Test Rewarded (+200)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Replay Tour & Onboarding
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        s.setTourOverlayVisible(true);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.explore_outlined),
                      label: const Text('Replay App Tour'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        s.startOnboardingFlow();
                      },
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text('Replay Onboarding'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/csb_mark_black.png',
                      height: 28,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scripture quotations marked CSB have been taken from the Christian Standard Bible®, Copyright © 2017 by Holman Bible Publishers. Used by permission.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body(
                        fontSize: 11.5,
                        color: AppColors.mutedForeground,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'sword drill™ v1.1.0 (3076) • by Flannelgraph',
                      style: AppTypography.body(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mutedForeground,
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

class NotificationsScreen extends StatelessWidget {
  final AppState appState;

  const NotificationsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final items = appState.notifications;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: AppTypography.display(fontSize: 22),
            ),
            actions: [
              TextButton(
                onPressed: appState.markAllNotificationsRead,
                child: const Text('Mark all read'),
              ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final n = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: n.isRead
                      ? AppColors.card
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: n.isRead ? AppColors.border : AppColors.primary,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      n.type == 'h2h'
                          ? Icons.sports_kabaddi_rounded
                          : n.type == 'badge'
                              ? Icons.workspace_premium_rounded
                              : Icons.person_add_alt_1_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.title,
                            style: AppTypography.display(fontSize: 15.5),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            n.body,
                            style: AppTypography.body(
                              fontSize: 13,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
