import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.vocabulary)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.examPractice)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.progress)) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: colorScheme.surface,
            indicatorColor: colorScheme.primaryContainer,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) => getTextStyle(
                fontSize: 12,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: states.contains(WidgetState.selected)
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            height: 66.h,
            elevation: 0,
            onDestinationSelected: (int index) {
              switch (index) {
                case 0:
                  context.go(AppRoutes.home);
                case 1:
                  context.go(AppRoutes.vocabulary);
                case 2:
                  context.go(AppRoutes.examPractice);
                case 3:
                  context.go(AppRoutes.progress);
              }
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.style_outlined),
                selectedIcon: Icon(Icons.style_rounded),
                label: 'Vocabulary',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school_rounded),
                label: 'Exam Prep',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights_rounded),
                label: 'Progress',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
