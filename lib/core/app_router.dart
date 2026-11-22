import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/features/home/screen/home_screen.dart';
import 'package:deutschly/features/lesson/screen/lesson_detail_screen.dart';
import 'package:deutschly/features/shell/screen/app_shell_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String progress = '/progress';
  static const String lessonDetailPath = '/lesson/:lessonId';

  static String lessonDetail(String lessonId) => '/lesson/$lessonId';
}

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: AppRoutes.home,
      routes: <RouteBase>[
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return AppShellScreen(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.home,
              builder: (BuildContext context, GoRouterState state) {
                return const HomeScreen();
              },
            ),
            GoRoute(
              path: AppRoutes.progress,
              builder: (BuildContext context, GoRouterState state) {
                return const ProgressPlaceholderScreen();
              },
            ),
          ],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.lessonDetailPath,
          builder: (BuildContext context, GoRouterState state) {
            final lessonId = state.pathParameters['lessonId'] ?? '';
            return LessonDetailScreen(lessonId: lessonId);
          },
        ),
      ],
    );
  }

  static final GoRouter router = createRouter();
}
