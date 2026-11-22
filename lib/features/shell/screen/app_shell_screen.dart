import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.progress)) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.progress);
          }
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}

class ProgressPlaceholderScreen extends StatelessWidget {
  const ProgressPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Progress'),
      body: Center(
        child: Text(
          'Overall Progress: 0%',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
