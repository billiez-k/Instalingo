import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/locale_provider.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/router/app_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/utils/responsive.dart';

void main() {
  // Catch ALL errors and render them on screen instead of crashing
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Write to a visible area so we can debug
    debugPrint('FLUTTER ERROR: ${details.exception}\n${details.stack}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PLATFORM ERROR: $error\n$stack');
    return true;
  };

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    runApp(
      const ProviderScope(
        child: InstaLingoApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('ZONED ERROR: $error\n$stack');
  });
}

class InstaLingoApp extends ConsumerWidget {
  const InstaLingoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);
    final locale = ref.watch(localeProvider);

    // Wait until locale AND theme preference are loaded from SharedPreferences
    // before showing UI. This prevents ☒ tofu characters, English flash, and
    // light-theme flash for dark-mode users on first load.
    final localeReady = ref.watch(localeReadyProvider);
    final darkModeReady = ref.watch(darkModeReadyProvider);
    if (localeReady.isLoading || darkModeReady.isLoading) {
      return const _AppLoader();
    }

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'InstaLingo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: AppRouter.router,
          builder: (context, child) {
            final brightness = Theme.of(context).brightness;
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    brightness == Brightness.dark ? Brightness.light : Brightness.dark,
              ),
            );
            return ConstrainedContent(child: child!);
          },
        );
      },
    );
  }
}

/// Show a loading screen while SharedPreferences are being read.
/// Uses plain widgets (no ScreenUtilInit .sp extensions) because ScreenUtilInit
/// hasn't executed yet at this point in the widget tree.
class _AppLoader extends StatelessWidget {
  const _AppLoader();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: BusanHarborTokens.navy,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: BusanHarborTokens.orange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'InstaLingo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: BusanHarborTokens.cream.withValues(alpha: 0.5),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
