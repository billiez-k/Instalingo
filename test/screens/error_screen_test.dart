import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instalingo/screens/error_screen.dart';
import 'package:instalingo/theme/app_theme.dart';

Widget _wrap(Widget child) => ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );

void main() {
  group('ErrorScreen', () {
    testWidgets('renders default message', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const ErrorScreen()));

      expect(find.text('Oops!'), findsOneWidget);
      expect(find.text('Page not found'), findsOneWidget);
    });

    testWidgets('renders custom message', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const ErrorScreen(message: 'Not Found')));

      expect(find.text('Oops!'), findsOneWidget);
      expect(find.text('Not Found'), findsOneWidget);
    });

    testWidgets('renders GoRouter-style error string', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const ErrorScreen(message: 'Exception: Route not found')));

      expect(find.textContaining('Route not found'), findsOneWidget);
    });

    testWidgets('renders icon and text content', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const ErrorScreen(message: 'Something broke')));

      expect(find.text('Oops!'), findsOneWidget);
      expect(find.text('Something broke'), findsOneWidget);
    });
  });
}
