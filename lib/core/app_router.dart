import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/features/about/screen/about_screen.dart';
import 'package:deutschly/features/exercise/screen/exercise_screen.dart';
import 'package:deutschly/features/home/screen/home_screen.dart';
import 'package:deutschly/features/lesson/screen/lesson_detail_screen.dart';
import 'package:deutschly/features/progress/screen/progress_screen.dart';
import 'package:deutschly/features/random_vocabulary/screen/random_vocabulary_screen.dart';
import 'package:deutschly/features/shell/screen/app_shell_screen.dart';
import 'package:deutschly/features/vocabulary/screen/vocabulary_screen.dart';
import 'package:deutschly/data/models/practice_session_item.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';
import 'package:deutschly/features/exam/screen/exam_practice_screen.dart';
import 'package:deutschly/features/exam/screen/exam_section_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String vocabulary = '/vocabulary';
  static const String randomVocabulary = '/random-vocabulary';
  static const String progress = '/progress';
  static const String about = '/about';
  static const String examPractice = '/exam-practice';
  static const String examSectionPath = '/exam-practice/:skill';
  static const String lessonDetailPath = '/lesson/:lessonId';
  static const String lessonExercisesPath = '/lesson/:lessonId/exercises';

  static String lessonDetail(String lessonId) => '/lesson/$lessonId';

  static String lessonExercises(String lessonId, {int initialIndex = 0}) {
    if (initialIndex > 0) {
      return '/lesson/$lessonId/exercises?index=$initialIndex';
    }
    return '/lesson/$lessonId/exercises';
  }

  static String practiceSession(
    String lessonId, {
    required int startIndex,
    required int exerciseCount,
  }) => '/lesson/$lessonId/exercises?index=$startIndex&session=$exerciseCount';

  static String examSection(String skill, {required bool timed}) =>
      '$examPractice/$skill?timed=$timed';
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
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.about,
          builder: (BuildContext context, GoRouterState state) {
            return const AboutScreen();
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.randomVocabulary,
          builder: (BuildContext context, GoRouterState state) {
            return const RandomVocabularyScreen();
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.examSectionPath,
          builder: (BuildContext context, GoRouterState state) {
            final skill = ExamSkill.parse(state.pathParameters['skill'] ?? '');
            final timed = state.uri.queryParameters['timed'] == 'true';
            if (skill == null) {
              return const ExamPracticeScreen();
            }
            return ExamSectionScreen(skill: skill, timed: timed);
          },
        ),
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
              path: AppRoutes.vocabulary,
              builder: (BuildContext context, GoRouterState state) {
                return const VocabularyScreen();
              },
            ),
            GoRoute(
              path: AppRoutes.examPractice,
              builder: (BuildContext context, GoRouterState state) {
                return const ExamPracticeScreen();
              },
            ),
            GoRoute(
              path: AppRoutes.progress,
              builder: (BuildContext context, GoRouterState state) {
                return const ProgressScreen();
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
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.lessonExercisesPath,
          builder: (BuildContext context, GoRouterState state) {
            final lessonId = state.pathParameters['lessonId'] ?? '';
            final indexParam = state.uri.queryParameters['index'];
            final initialIndex = int.tryParse(indexParam ?? '') ?? 0;
            final sessionLength =
                int.tryParse(state.uri.queryParameters['session'] ?? '') ?? 0;
            final practiceItems = state.extra is List<PracticeSessionItem>
                ? state.extra as List<PracticeSessionItem>
                : null;
            return ExerciseScreen(
              lessonId: lessonId,
              initialIndex: initialIndex,
              sessionLength: sessionLength,
              sessionItems: practiceItems,
            );
          },
        ),
      ],
    );
  }

  static final GoRouter router = createRouter();
}
