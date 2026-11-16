import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';

/// Singleton service managing the Google Mobile Ads SDK (`google_mobile_ads`).
/// Handles SDK initialization, Interstitial preloading & display,
/// and Rewarded Ads for hints, bonus points, and streak protection.
class AdService extends ChangeNotifier {
  static final AdService instance = AdService._internal();
  AdService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;
  int _completedRoundsCount = 0;

  bool get isInitialized => _isInitialized;
  bool get isInterstitialReady => _interstitialAd != null;
  bool get isRewardedReady => _rewardedAd != null;

  /// Initializes the Google Mobile Ads SDK and preloads Interstitial & Rewarded ads.
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (!AdConfig.isMobilePlatform) {
      _isInitialized = true;
      notifyListeners();
      return;
    }

    try {
      await MobileAds.instance.initialize();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        ),
      );
      _isInitialized = true;
      notifyListeners();
      preloadInterstitialAd();
      preloadRewardedAd();
    } catch (e) {
      debugPrint('AdMob initialization skipped or failed: $e');
      _isInitialized = false;
    }
  }

  /// Preloads an Interstitial Ad into memory for zero-latency display after a quiz round.
  void preloadInterstitialAd() {
    if (!AdConfig.isMobilePlatform) return;
    if (_interstitialAd != null || _isInterstitialLoading) return;

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: ${error.message}');
          _interstitialAd = null;
          _isInterstitialLoading = false;
          notifyListeners();
        },
      ),
    );
  }

  /// Shows an Interstitial Ad after quiz completion.
  Future<void> showInterstitialAfterRound({
    VoidCallback? onAdDismissed,
    bool force = false,
  }) async {
    _completedRoundsCount++;
    if (!force && _completedRoundsCount % 2 != 0) {
      onAdDismissed?.call();
      return;
    }

    if (_interstitialAd != null) {
      final ad = _interstitialAd!;
      _interstitialAd = null;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          preloadInterstitialAd();
          notifyListeners();
          onAdDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          preloadInterstitialAd();
          notifyListeners();
          onAdDismissed?.call();
        },
      );
      await ad.show();
    } else {
      preloadInterstitialAd();
      onAdDismissed?.call();
    }
  }

  /// Preloads a Rewarded Ad for 50/50 hints, +200 bonus points, or Streak Grace.
  void preloadRewardedAd() {
    if (!AdConfig.isMobilePlatform) return;
    if (_rewardedAd != null || _isRewardedLoading) return;

    _isRewardedLoading = true;
    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: ${error.message}');
          _rewardedAd = null;
          _isRewardedLoading = false;
          notifyListeners();
        },
      ),
    );
  }

  /// Displays a Rewarded Ad and triggers [onRewardEarned] only when completed.
  Future<bool> showRewardedAd({
    required void Function(int amount, String type) onRewardEarned,
    VoidCallback? onAdClosed,
  }) async {
    if (_rewardedAd != null) {
      final ad = _rewardedAd!;
      _rewardedAd = null;
      bool earned = false;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          preloadRewardedAd();
          notifyListeners();
          onAdClosed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          preloadRewardedAd();
          notifyListeners();
          onAdClosed?.call();
        },
      );
      await ad.show(
        onUserEarnedReward: (adWithoutView, reward) {
          earned = true;
          notifyListeners();
          onRewardEarned(reward.amount.toInt(), reward.type);
        },
      );
      return earned;
    } else {
      preloadRewardedAd();
      onAdClosed?.call();
      return false;
    }
  }
}
