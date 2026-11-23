import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';
import 'package:deutschly/main.dart';

void main() {
  tearDown(() {
    AppScreenUtil.reset();
    Get.reset();
  });

  test('defaults to 1.0 scale factors before initialization', () {
    AppScreenUtil.reset();
    expect(AppScreenUtil.isInitialized, isFalse);
    expect(AppScreenUtil.scaleFactor, 1.0);
    expect(AppScreenUtil.heightScaleFactor, 1.0);
    expect(AppScreenUtil.textScaleFactor, 1.0);
    expect(16.w, 16.0);
    expect(16.h, 16.0);
    expect(16.sp, 16.0);
    expect(16.r, 16.0);
  });

  testWidgets('initializes 1.0 scale on 390x844 mobile baseline', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            AppScreenUtil.init(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(AppScreenUtil.isInitialized, isTrue);
    expect(AppScreenUtil.isTablet, isFalse);
    expect(AppScreenUtil.orientation, Orientation.portrait);
    expect(AppScreenUtil.scaleFactor, 1.0);
    expect(AppScreenUtil.heightScaleFactor, 1.0);
    expect(AppScreenUtil.textScaleFactor, 1.0);
    expect(getTextStyle(fontSize: 16).fontSize, 16.0);
  });

  testWidgets('clamps scale factors cleanly on compact and tablet screens', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(280, 500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            AppScreenUtil.init(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(AppScreenUtil.scaleFactor, closeTo(320 / 390, 0.0001));
    expect(AppScreenUtil.textScaleFactor, closeTo(320 / 390, 0.0001));

    tester.view.physicalSize = const Size(800, 600);
    await tester.pumpAndSettle();

    expect(AppScreenUtil.isTablet, isTrue);
    expect(AppScreenUtil.orientation, Orientation.landscape);
    expect(AppScreenUtil.scaleFactor, closeTo(450 / 390, 0.0001));
    expect(AppScreenUtil.textScaleFactor, closeTo(430 / 390, 0.0001));
    expect(AppScreenUtil.heightScaleFactor, 0.85);
    expect(getTextStyle(fontSize: 16).fontSize, closeTo(16 * 430 / 390, 0.001));
  });

  testWidgets('DeutschlyApp initializes AppScreenUtil on small mobile viewport without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    const course = Course(
      id: 'test_course',
      title: 'Test German A1.1',
      level: 'A1.1',
      language: 'de',
      description: 'Test course description',
      totalLessons: 1,
      version: '1.0',
      created: '2026-01-01',
      lessons: <Lesson>[
        Lesson(
          id: 'lesson_01',
          number: 1,
          title: 'Guten Tag!',
          titleBn: 'শুভেচ্ছা',
          exercises: <Exercise>[
            Exercise.multipleChoice(
              id: 'ex1',
              question: 'Choose greeting',
              options: <String>['Hallo', 'Tschüs'],
              correctIndex: 0,
            ),
          ],
        ),
      ],
    );

    final courseController = Get.put(CourseController(initialCourse: course));
    final progressController = Get.put(
      ProgressController(
        progressService: ProgressService(),
        courseController: courseController,
      ),
    );
    Get.put(
      HomeController(
        courseController: courseController,
        progressController: progressController,
      ),
    );
    Get.put(VocabularyController(courseController: courseController));

    await tester.pumpWidget(const DeutschlyApp());
    await tester.pumpAndSettle();

    expect(AppScreenUtil.isInitialized, isTrue);
    expect(AppScreenUtil.screenWidth, 320.0);
    expect(AppScreenUtil.screenHeight, 640.0);
    expect(find.text('Test German A1.1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
