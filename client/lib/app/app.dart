import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'assets/app_vectors.dart';

import '../app/router/app_router.dart';
import '../app/theme/app_font_config.dart';
import '../app/theme/forui_theme_config.dart';
import '../app/theme/theme_palette_provider.dart';
import '../app/theme/theme_provider.dart';
import '../features/auth/providers/auth_provider.dart';
import '../i18n/strings.g.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeProvider);
    final palette = ref.watch(themePaletteProvider);

    final foruiLightTheme = ForuiThemeConfig.resolve(
      palette: palette,
      brightness: Brightness.light,
    );
    final foruiDarkTheme = ForuiThemeConfig.resolve(
      palette: palette,
      brightness: Brightness.dark,
    );

    final materialLightTheme = foruiLightTheme
        .toApproximateMaterialTheme()
        .copyWith(
          textTheme: AppFontConfig.createGlobalTextTheme(
            ThemeData.light().textTheme,
          ),
          // Set SnackBar default style: fixed behavior (no rounded corners, bottom display)
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.fixed,
          ),
        );
    final materialDarkTheme = foruiDarkTheme
        .toApproximateMaterialTheme()
        .copyWith(
          textTheme: AppFontConfig.createGlobalTextTheme(
            ThemeData.dark().textTheme,
          ),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.fixed,
          ),
        );

    return MaterialApp.router(
      title: 'augo',
      theme: materialLightTheme,
      darkTheme: materialDarkTheme,
      themeMode: appThemeMode,
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: [
        ...FLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      builder: (materialContext, navigator) {
        final activeBrightness = Theme.of(materialContext).brightness;
        final activeForuiTheme = activeBrightness == Brightness.dark
            ? foruiDarkTheme
            : foruiLightTheme;

        return FAnimatedTheme(
          data: activeForuiTheme,
          child: FToaster(child: _buildAppContent(ref, navigator!)),
        );
      },
    );
  }

  Widget _buildAppContent(WidgetRef ref, Widget navigator) {
    final authState = ref.watch(authProvider);

    if (authState.status == AuthStatus.loading ||
        authState.status == AuthStatus.initial) {
      return const _SplashScreen();
    }

    return navigator;
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash SVG illustration
            SizedBox(
              width: 150,
              height: 150,
              child: SvgPicture.asset(AppVectors.splash, fit: BoxFit.contain),
            ),
            const SizedBox(height: 24),
            Text(
              t.app.splashTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.app.splashSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
