import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Busan Harbor design language — a maritime editorial style.
///
/// The palette pairs a deep harbor navy with a sunrise orange accent, set
/// against a warm cream paper background. It is sharp, professional, and
/// content-first — meant for headlines, dense stats, and confident CTAs.
class BusanHarborTokens {
  // Core harbor palette
  static const Color navy = Color(0xFF0F1F2E); // deep harbor water
  static const Color navyDeep = Color(0xFF081421); // night harbor
  static const Color navyMid = Color(0xFF1B3349); // mast shadow
  static const Color navySoft = Color(0xFF233E58); // dock blue

  // Sunrise orange — primary brand accent
  static const Color orange = Color(0xFFEE6C2C); // harbor sunrise
  static const Color orangeDeep = Color(0xFFC9520F); // rusted iron
  static const Color orangeLight = Color(0xFFF89B5C); // sunlit copper
  static const Color orangeWash = Color(0xFFFCEBDD); // pale ember

  // Paper / surface
  static const Color cream = Color(0xFFF2EFE9); // weathered linen
  static const Color creamSoft = Color(0xFFF7F5F0); // morning fog
  static const Color paperWhite = Color(0xFFFFFFFF);

  // Ink (text)
  static const Color ink = Color(0xFF0F1F2E); // primary text on light
  static const Color inkMuted = Color(0xFF6B7785); // secondary text
  static const Color inkFaint = Color(0xFFA3ABB4);

  // Borders
  static const Color border = Color(0xFFE2DED2); // warm gray
  static const Color borderSoft = Color(0xFFEFECE4);
  static const Color borderStrong = Color(0xFFCFCABC);

  // Functional accents
  static const Color sea = Color(0xFF3E7CB1); // XP / info
  static const Color coral = Color(0xFFD04B43); // streak / error / hearts
  static const Color brass = Color(0xFFC9A227); // premium / gold
  static const Color mint = Color(0xFF2D9C5A); // success
  static const Color amber = Color(0xFFE89A22); // warning
}

/// Legacy semantic color names — preserved so existing widget code continues
/// to compile, but the underlying values are rewired to the Busan Harbor
/// palette.
class AppColors {
  // Primary (sunrise orange)
  static const Color primary = BusanHarborTokens.orange;
  static const Color primaryDark = BusanHarborTokens.orangeDeep;
  static const Color primaryLight = BusanHarborTokens.orangeLight;

  // Secondary (harbor navy)
  static const Color secondary = BusanHarborTokens.navy;
  static const Color secondaryDark = BusanHarborTokens.navyDeep;
  static const Color secondaryLight = BusanHarborTokens.navySoft;

  // Accent (kept as the orange family for emphasis)
  static const Color accent = BusanHarborTokens.orange;
  static const Color accentLight = BusanHarborTokens.orangeLight;

  // Chill (post / social) — a sea-bound coral so it harmonises with harbor
  static const Color chillPrimary = BusanHarborTokens.coral;
  static const Color chillSecondary = Color(0xFFE08077);

  // Gamification
  static const Color xp = BusanHarborTokens.sea;
  static const Color streak = BusanHarborTokens.orange;
  static const Color gems = BusanHarborTokens.sea;
  static const Color gold = BusanHarborTokens.brass;

  // Language flags (kept distinct for course identity)
  static const Color english = BusanHarborTokens.sea;
  static const Color korean = BusanHarborTokens.coral;
  static const Color japanese = Color(0xFFB04A5C);
  static const Color french = Color(0xFF4A5E8C);
  static const Color spanish = BusanHarborTokens.orangeDeep;

  // Semantic
  static const Color success = BusanHarborTokens.mint;
  static const Color successLight = Color(0xFFD6EFDD);
  static const Color error = BusanHarborTokens.coral;
  static const Color errorLight = Color(0xFFF7DEDB);
}

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        background: BusanHarborTokens.cream,
        surface: BusanHarborTokens.paperWhite,
        surfaceVariant: BusanHarborTokens.creamSoft,
        onBackground: BusanHarborTokens.ink,
        onSurface: BusanHarborTokens.ink,
        onSurfaceVariant: BusanHarborTokens.inkMuted,
        border: BusanHarborTokens.border,
        borderLight: BusanHarborTokens.borderSoft,
        error: BusanHarborTokens.coral,
        errorLight: const Color(0xFFF7DEDB),
        success: BusanHarborTokens.mint,
        successLight: const Color(0xFFD6EFDD),
        warning: BusanHarborTokens.amber,
        skeleton: const Color(0xFFE6E2D7),
        skeletonHighlight: const Color(0xFFF2EFE9),
        cardShadow: const Color(0x140F1F2E),
        harborNavy: BusanHarborTokens.navy,
        harborNavyDeep: BusanHarborTokens.navyDeep,
        harborInkOnNavy: const Color(0xFFF2EFE9),
        harborInkOnNavyMuted: const Color(0xFF9AA8B6),
        harborIconFill: BusanHarborTokens.navy,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        background: BusanHarborTokens.navyDeep,
        surface: BusanHarborTokens.navy,
        surfaceVariant: BusanHarborTokens.navyMid,
        onBackground: BusanHarborTokens.cream,
        onSurface: const Color(0xFFE6E1D7),
        onSurfaceVariant: const Color(0xFF9AA8B6),
        border: BusanHarborTokens.navyMid,
        borderLight: BusanHarborTokens.navySoft,
        error: const Color(0xFFE8716A),
        errorLight: const Color(0xFF3A1F1D),
        success: const Color(0xFF54B779),
        successLight: const Color(0xFF1A3326),
        warning: const Color(0xFFE89A22),
        skeleton: BusanHarborTokens.navyMid,
        skeletonHighlight: BusanHarborTokens.navySoft,
        cardShadow: const Color(0x40000000),
        harborNavy: BusanHarborTokens.navy,
        harborNavyDeep: BusanHarborTokens.navyDeep,
        harborInkOnNavy: const Color(0xFFF2EFE9),
        harborInkOnNavyMuted: const Color(0xFF9AA8B6),
        harborIconFill: const Color(0xFFF2EFE9),
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceVariant,
    required Color onBackground,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color border,
    required Color borderLight,
    required Color error,
    required Color errorLight,
    required Color success,
    required Color successLight,
    required Color warning,
    required Color skeleton,
    required Color skeletonHighlight,
    required Color cardShadow,
    required Color harborNavy,
    required Color harborNavyDeep,
    required Color harborInkOnNavy,
    required Color harborInkOnNavyMuted,
    required Color harborIconFill,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      // System font fallback chain ensures CJK characters render immediately
      // without ☒ tofu glyphs. Browser natively handles these fonts with zero
      // download delay — no more async font loading flash.
      fontFamilyFallback: const [
        'Noto Sans CJK SC',
        'Noto Sans CJK TC',
        'Noto Sans CJK JP',
        'Noto Sans CJK KR',
        'PingFang SC',
        'PingFang TC',
        'PingFang HK',
        'Hiragino Sans',
        'Hiragino Kaku Gothic ProN',
        'Apple SD Gothic Neo',
        'Malgun Gothic',
        'Microsoft YaHei',
        'Microsoft JhengHei',
        'Meiryo',
        'sans-serif',
      ],
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: harborNavy,
        background: background,
        surface: surface,
        onBackground: onBackground,
        onSurface: onSurface,
        error: error,
      ),
      // fontFamily: 'Inter', // Uncomment after adding assets/fonts/Inter-*.ttf
      textTheme: _buildTextTheme(onBackground, onSurface, onSurfaceVariant),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: onBackground,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          color: onBackground,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
          side: BorderSide(color: border, width: 1),
        ),
        color: surface,
        shadowColor: cardShadow,
      ),
      dividerTheme: DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white,
          minimumSize: Size(double.infinity, 54.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: onSurface,
          minimumSize: Size(double.infinity, 54.h),
          side: BorderSide(color: isDark ? borderLight : harborNavy, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          textStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.3,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        hintStyle: TextStyle(color: onSurfaceVariant, fontSize: 15.sp),
        labelStyle: TextStyle(color: onSurfaceVariant, fontSize: 14.sp),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return isDark ? const Color(0xFF9AA8B6) : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return isDark ? BusanHarborTokens.navyMid : BusanHarborTokens.borderStrong;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: isDark ? BusanHarborTokens.navyMid : BusanHarborTokens.border,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        side: BorderSide(color: border),
        labelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: onSurface,
          letterSpacing: 1.2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      extensions: [
        AppThemeExtension(
          surfaceVariant: surfaceVariant,
          onSurfaceVariant: onSurfaceVariant,
          border: border,
          borderLight: borderLight,
          errorLight: errorLight,
          successLight: successLight,
          warning: warning,
          skeleton: skeleton,
          skeletonHighlight: skeletonHighlight,
          cardShadow: cardShadow,
          isDark: isDark,
          harborNavy: harborNavy,
          harborNavyDeep: harborNavyDeep,
          harborInkOnNavy: harborInkOnNavy,
          harborInkOnNavyMuted: harborInkOnNavyMuted,
          harborOrange: AppColors.primary,
          harborOrangeWash: BusanHarborTokens.orangeWash,
          harborCream: BusanHarborTokens.cream,
          harborIconFill: harborIconFill,
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(Color onBackground, Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w800, color: onBackground, letterSpacing: -1.2, height: 1.05),
      displayMedium: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800, color: onBackground, letterSpacing: -0.8, height: 1.1),
      displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: onBackground, letterSpacing: -0.6, height: 1.15),
      headlineLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: onBackground, letterSpacing: -0.4),
      headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: onBackground, letterSpacing: -0.3),
      headlineSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: onBackground, letterSpacing: -0.2),
      titleLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.1),
      titleMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: onSurface),
      titleSmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: onSurface, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: onSurface, height: 1.5),
      bodySmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: onSurfaceVariant, height: 1.45),
      labelLarge: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.6),
      labelMedium: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.4),
      labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.2),
    );
  }
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color border;
  final Color borderLight;
  final Color errorLight;
  final Color successLight;
  final Color warning;
  final Color skeleton;
  final Color skeletonHighlight;
  final Color cardShadow;
  final bool isDark;

  // Busan Harbor tokens
  final Color harborNavy;
  final Color harborNavyDeep;
  final Color harborInkOnNavy;
  final Color harborInkOnNavyMuted;
  final Color harborOrange;
  final Color harborOrangeWash;
  final Color harborCream;

  /// Icon/tint color that adapts to theme brightness.
  /// Navy on light surfaces, cream on dark surfaces — ensures icons are always visible.
  final Color harborIconFill;

  AppThemeExtension({
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.border,
    required this.borderLight,
    required this.errorLight,
    required this.successLight,
    required this.warning,
    required this.skeleton,
    required this.skeletonHighlight,
    required this.cardShadow,
    required this.isDark,
    required this.harborNavy,
    required this.harborNavyDeep,
    required this.harborInkOnNavy,
    required this.harborInkOnNavyMuted,
    required this.harborOrange,
    required this.harborOrangeWash,
    required this.harborCream,
    required this.harborIconFill,
  });


  @override
  AppThemeExtension copyWith({
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? border,
    Color? borderLight,
    Color? errorLight,
    Color? successLight,
    Color? warning,
    Color? skeleton,
    Color? skeletonHighlight,
    Color? cardShadow,
    bool? isDark,
    Color? harborNavy,
    Color? harborNavyDeep,
    Color? harborInkOnNavy,
    Color? harborInkOnNavyMuted,
    Color? harborOrange,
    Color? harborOrangeWash,
    Color? harborCream,
    Color? harborIconFill,
  }) {
    return AppThemeExtension(
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      errorLight: errorLight ?? this.errorLight,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      skeleton: skeleton ?? this.skeleton,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      cardShadow: cardShadow ?? this.cardShadow,
      isDark: isDark ?? this.isDark,
      harborNavy: harborNavy ?? this.harborNavy,
      harborNavyDeep: harborNavyDeep ?? this.harborNavyDeep,
      harborInkOnNavy: harborInkOnNavy ?? this.harborInkOnNavy,
      harborInkOnNavyMuted: harborInkOnNavyMuted ?? this.harborInkOnNavyMuted,
      harborOrange: harborOrange ?? this.harborOrange,
      harborOrangeWash: harborOrangeWash ?? this.harborOrangeWash,
      harborCream: harborCream ?? this.harborCream,
      harborIconFill: harborIconFill ?? this.harborIconFill,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      skeletonHighlight: Color.lerp(skeletonHighlight, other.skeletonHighlight, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
      harborNavy: Color.lerp(harborNavy, other.harborNavy, t)!,
      harborNavyDeep: Color.lerp(harborNavyDeep, other.harborNavyDeep, t)!,
      harborInkOnNavy: Color.lerp(harborInkOnNavy, other.harborInkOnNavy, t)!,
      harborInkOnNavyMuted: Color.lerp(harborInkOnNavyMuted, other.harborInkOnNavyMuted, t)!,
      harborOrange: Color.lerp(harborOrange, other.harborOrange, t)!,
      harborOrangeWash: Color.lerp(harborOrangeWash, other.harborOrangeWash, t)!,
      harborCream: Color.lerp(harborCream, other.harborCream, t)!,
      harborIconFill: Color.lerp(harborIconFill, other.harborIconFill, t)!,
    );
  }
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme => Theme.of(this).extension<AppThemeExtension>()!;
}
