import 'package:flutter/foundation.dart';

/// Centralized Google AdMob configuration for Sword Bible: Drill Trivia (`bible.sword`).
class AdConfig {
  AdConfig._();

  /// Production AdMob IDs active by default. Set to true only when using Google sample test units.
  static const bool useTestAds = false;

  static const String productionAppId =
      'ca-app-pub-6687779687898901~5721835503';
  static const String productionBannerUnitId =
      'ca-app-pub-6687779687898901/4939896016';
  static const String productionInterstitialUnitId =
      'ca-app-pub-6687779687898901/8315054306';
  static const String productionRewardedUnitId =
      'ca-app-pub-6687779687898901/5658256325';

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isMobilePlatform => isAndroid || isIOS;

  // Google Mobile Ads App ID
  static String get appId {
    if (!useTestAds) return productionAppId;
    if (!isMobilePlatform) return productionAppId;
    if (isAndroid) {
      return 'ca-app-pub-3940256099942544~3347511713';
    } else if (isIOS) {
      return 'ca-app-pub-3940256099942544~1458002511';
    }
    return productionAppId;
  }

  // Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (!useTestAds) return productionBannerUnitId;
    if (!isMobilePlatform) return productionBannerUnitId;
    return isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
  }

  // Interstitial Ad Unit ID (shown after Daily 5, Free Play, or Family Mode rounds)
  static String get interstitialAdUnitId {
    if (!useTestAds) return productionInterstitialUnitId;
    if (!isMobilePlatform) return productionInterstitialUnitId;
    return isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
  }

  // Rewarded Ad Unit ID (used for 50/50 Scripture Hint, +200 Bonus Pts, Streak Grace)
  static String get rewardedAdUnitId {
    if (!useTestAds) return productionRewardedUnitId;
    if (!isMobilePlatform) return productionRewardedUnitId;
    return isAndroid
        ? 'ca-app-pub-3940256099942544/5224354917'
        : 'ca-app-pub-3940256099942544/1712485313';
  }
}
