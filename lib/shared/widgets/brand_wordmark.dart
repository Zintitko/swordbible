import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/scoring_utils.dart';
import '../../data/seed/badges_and_avatars_bank.dart';

/// Official `sword drill™` wordmark + `BY FLANNELGRAPH` subtitle.
class BrandWordmark extends StatelessWidget {
  final double fontSize;
  final Color color;
  final bool showByline;
  final bool showIcon;

  const BrandWordmark({
    super.key,
    this.fontSize = 26,
    this.color = AppColors.primary,
    this.showByline = true,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Container(
            width: fontSize * 1.38,
            height: fontSize * 1.38,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: AppColors.gradientBrand,
              borderRadius: BorderRadius.circular(fontSize * 0.36),
              boxShadow: AppColors.brandShadow,
            ),
            child: Image.asset(
              'assets/images/sword_bible_icon.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Icon(
                Icons.bolt_rounded,
                color: AppColors.neon,
                size: fontSize * 0.85,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sword Bible: Drill Trivia',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.display(
                  fontSize: fontSize * 0.82,
                  fontWeight: FontWeight.w700,
                  color: color,
                  height: 1.1,
                ),
              ),
              if (showByline)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'LEARN & LIVE TRUTH • HEBREWS 4:12',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body(
                      fontSize: (fontSize * 0.34).clamp(8.5, 10.5),
                      fontWeight: FontWeight.w800,
                      color: color == Colors.white
                          ? Colors.white.withValues(alpha: 0.75)
                          : AppColors.mutedForeground,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Avatar circle widget rendering any of the 29 preset avatars.
class UserAvatarCircle extends StatelessWidget {
  final String avatarKey;
  final double size;
  final bool showBorder;

  const UserAvatarCircle({
    super.key,
    required this.avatarKey,
    this.size = 44,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final preset = BadgesAndAvatarsBank.getAvatarByKey(avatarKey);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: preset.accentColor.withValues(alpha: 0.14),
        border: showBorder
            ? Border.all(
                color: preset.accentColor.withValues(alpha: 0.40),
                width: 2,
              )
            : null,
      ),
      child: Icon(
        preset.icon,
        color: preset.accentColor,
        size: size * 0.54,
      ),
    );
  }
}

/// Knowledge Level Pill ("Level 2 • Sunday School Strong").
class KnowledgeLevelPill extends StatelessWidget {
  final int level;
  final bool compact;

  const KnowledgeLevelPill({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 11,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_graph_rounded,
            size: compact ? 12 : 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              compact
                  ? 'Lvl $level'
                  : 'Lvl $level • ${ScoringUtils.difficultyTitle(level)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hebrews 4:12 CSB Footer used on Home & About screens.
class HebrewsFooter extends StatelessWidget {
  const HebrewsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Text(
            '"For the word of God is living and effective and sharper than any double-edged sword..."',
            textAlign: TextAlign.center,
            style: AppTypography.body(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.mutedForeground,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '— HEBREWS 4:12 (CSB)',
            style: AppTypography.body(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.mutedForeground,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
