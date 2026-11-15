import 'package:flutter/material.dart';
import 'core/ads/ad_service.dart';
import 'core/theme/app_theme.dart';
import 'features/home/main_shell.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google AdMob SDK (Banner, Interstitial & Rewarded Ads)
  await AdService.instance.initialize();

  // Load persisted user profile, streak, and stats
  final appState = AppState();
  await appState.loadFromStorage();

  runApp(SwordDrillApp(appState: appState));
}

class SwordDrillApp extends StatelessWidget {
  final AppState appState;

  const SwordDrillApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sword Bible: Drill Trivia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainShell(appState: appState),
    );
  }
}
