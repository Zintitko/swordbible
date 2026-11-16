import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/seed/badges_and_avatars_bank.dart';
import '../../shared/widgets/brand_wordmark.dart';
import '../../state/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  final AppState appState;

  const OnboardingScreen({super.key, required this.appState});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  int _selectedLevel = 2;
  String _selectedAvatar = 'sword';
  bool _familyMode = true;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.appState.displayName);
    _usernameController = TextEditingController(text: widget.appState.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BrandWordmark(fontSize: 22),
                  TextButton(
                    onPressed: () {
                      widget.appState.completeOnboarding(
                        displayName: _nameController.text,
                        username: _usernameController.text,
                        avatarKey: _selectedAvatar,
                        knowledgeLevel: _selectedLevel,
                        familyModeEnabled: _familyMode,
                      );
                    },
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _step == 0
                    ? _buildWelcomeStep()
                    : _step == 1
                        ? _buildLevelStep()
                        : _buildProfileStep(),
              ),
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
                  onPressed: () {
                    if (_step < 2) {
                      setState(() => _step++);
                    } else {
                      widget.appState.completeOnboarding(
                        displayName: _nameController.text,
                        username: _usernameController.text,
                        avatarKey: _selectedAvatar,
                        knowledgeLevel: _selectedLevel,
                        familyModeEnabled: _familyMode,
                      );
                    }
                  },
                  child: Text(
                    _step < 2 ? 'Continue →' : 'Enter Sword Bible →',
                    style: AppTypography.display(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: AppColors.gradientPurpleDeep,
            borderRadius: BorderRadius.circular(28),
            boxShadow: AppColors.cardShadowLg,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neon,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'HEBREWS 4:12 (CSB)',
                  style: AppTypography.body(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neonInk,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bible Trivia to Learn and Live Truth.',
                textAlign: TextAlign.center,
                style: AppTypography.display(
                  fontSize: 30,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Daily 5 challenges, customizable Free Play drills, Head-to-Head friend duels, and kid-safe Family Mode — all grounded in the Christian Standard Bible®.',
                textAlign: TextAlign.center,
                style: AppTypography.body(
                  fontSize: 14.5,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelStep() {
    return ListView(
      children: [
        Text(
          'Pick Your Starting Level',
          style: AppTypography.display(fontSize: 26),
        ),
        const SizedBox(height: 6),
        Text(
          'You can change this anytime or take the 6-question Placement Quiz.',
          style: AppTypography.body(
            fontSize: 14,
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: 18),
        for (final lvl in [1, 2, 3])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _selectedLevel = lvl),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _selectedLevel == lvl
                      ? AppColors.primary.withValues(alpha: 0.10)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedLevel == lvl
                        ? AppColors.primary
                        : AppColors.border,
                    width: _selectedLevel == lvl ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ScoringUtils.difficultyShortBadge(lvl),
                      style: AppTypography.body(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ScoringUtils.difficultyTitle(lvl),
                      style: AppTypography.display(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ScoringUtils.difficultySubtitle(lvl),
                      style: AppTypography.body(
                        fontSize: 13.5,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileStep() {
    return ListView(
      children: [
        Text(
          'Set Up Your Profile',
          style: AppTypography.display(fontSize: 26),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: '@username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Pick an Avatar',
          style: AppTypography.display(fontSize: 17),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final preset in BadgesAndAvatarsBank.avatars.take(12))
              GestureDetector(
                onTap: () => setState(() => _selectedAvatar = preset.key),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: preset.accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedAvatar == preset.key
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: Icon(preset.icon, color: preset.accentColor),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable Family Mode Card on Home'),
          subtitle: const Text('Kid-safe pass-and-play Bible trivia'),
          value: _familyMode,
          onChanged: (v) => setState(() => _familyMode = v),
        ),
      ],
    );
  }
}
