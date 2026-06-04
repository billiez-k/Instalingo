# InstaLingo Flutter — Agent Notes

## Project Setup
This is a manually-scaffolded Flutter project (no `flutter create` available on build machine). To initialize properly:

```bash
cd instalingo_flutter
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Dependencies Used
- `flutter_riverpod` + `riverpod_annotation` — State management
- `go_router` — Declarative navigation
- `phosphor_flutter` — Professional icons (ZERO emojis policy)
- `flutter_screenutil` — Responsive design
- `intl` — Date formatting
- `shared_preferences` — Local settings persistence
- `animations` — Material motion transitions
- `shimmer` — Loading skeletons
- `fl_chart` — Charts (stats screen)

## Architecture
- `lib/main.dart` — Entry point with ProviderScope + ScreenUtilInit
- `lib/theme/app_theme.dart` — Light/dark themes, AppThemeExtension
- `lib/router/app_router.dart` — GoRouter configuration
- `lib/models/` — Immutable data classes
- `lib/providers/` — Riverpod state notifiers
- `lib/data/demo_data.dart` — All demo content (English A1)
- `lib/screens/` — Feature screens organized by tab

## Key Conventions
- NO emojis anywhere. Use Phosphor icons exclusively.
- `context.appTheme` extension for accessing custom theme colors.
- All screens use `flutter_screenutil` for responsive sizing (designSize: 390x844).
- Dark mode toggle persisted via SharedPreferences.
- Demo data is const/static — replace with real backend calls.

## Build Commands
```bash
flutter build apk          # Android
flutter build ios          # iOS (requires macOS + Xcode)
flutter build web          # Web
flutter test               # Run tests
flutter analyze            # Static analysis
```

## Missing Assets
The following asset directories are referenced in pubspec.yaml but do not yet contain files:
- `assets/images/`
- `assets/icons/`
- `assets/lottie/`
- `assets/flags/`
- `assets/fonts/Inter-*.ttf`

Add real assets before building for production. Placeholder content uses Phosphor icons and colored containers.
