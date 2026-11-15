import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../state/app_state.dart';
import '../free_play/quiz_setup_screen.dart';
import '../friends/friends_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  final AppState appState;

  const MainShell({super.key, required this.appState});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  String _freePlayInitialFilter = 'surprise';

  void _jumpToFreePlayWithFilter(String filterType) {
    setState(() {
      _freePlayInitialFilter = filterType;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        if (!widget.appState.hasCompletedOnboarding) {
          return OnboardingScreen(appState: widget.appState);
        }

        final pages = <Widget>[
          HomeScreen(
            appState: widget.appState,
            onNavigateToFreePlaySetup: _jumpToFreePlayWithFilter,
          ),
          QuizSetupScreen(
            key: ValueKey('setup_$_freePlayInitialFilter'),
            appState: widget.appState,
            initialFilterType: _freePlayInitialFilter,
          ),
          LeaderboardScreen(appState: widget.appState),
          FriendsScreen(appState: widget.appState),
          ProfileScreen(appState: widget.appState),
        ];

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: pages[_selectedIndex],
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: _selectedIndex,
                backgroundColor: AppColors.card,
                indicatorColor: AppColors.primary.withValues(alpha: 0.14),
                onDestinationSelected: (idx) =>
                    setState(() => _selectedIndex = idx),
                destinations: [
                  const NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(
                      Icons.home_rounded,
                      color: AppColors.primary,
                    ),
                    label: 'Home',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.bolt_outlined),
                    selectedIcon: Icon(
                      Icons.bolt_rounded,
                      color: AppColors.primary,
                    ),
                    label: 'Quizzes',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.emoji_events_outlined),
                    selectedIcon: Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.primary,
                    ),
                    label: 'Leaderboard',
                  ),
                  NavigationDestination(
                    icon: Badge(
                      isLabelVisible:
                          widget.appState.pendingFriendRequests.isNotEmpty,
                      label: Text(
                        '${widget.appState.pendingFriendRequests.length}',
                      ),
                      child: const Icon(Icons.group_outlined),
                    ),
                    selectedIcon: const Icon(
                      Icons.group_rounded,
                      color: AppColors.primary,
                    ),
                    label: 'Friends',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),

            // Interactive App Tour Overlay (`zf` in `App-AlODYBux.js`)
            if (widget.appState.showTourOverlay)
              Material(
                color: Colors.black.withValues(alpha: 0.72),
                child: SafeArea(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome to sword drill™!',
                            style: AppTypography.display(fontSize: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '• Daily 5: Everyone gets the same 5 questions each day.\n'
                            '• Free Play: Drill by Testament, Topic, Character, or Book.\n'
                            '• Sharpen Your Sword: Read full CSB Scripture context on every question.\n'
                            '• Head-to-Head & Family Mode: Compete with friends or pass-and-play with kids!',
                            style: AppTypography.body(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () =>
                                  widget.appState.setTourOverlayVisible(false),
                              child: const Text('Start Drilling →'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
