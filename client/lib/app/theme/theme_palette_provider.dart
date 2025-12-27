import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme_palette.dart';

class ThemePaletteNotifier extends Notifier<AppThemePalette> {
  @override
  AppThemePalette build() {
    return AppThemePalette.zinc;
  }

  void setPalette(AppThemePalette palette) {
    if (state == palette) {
      return;
    }
    state = palette;
  }
}

final themePaletteProvider =
    NotifierProvider<ThemePaletteNotifier, AppThemePalette>(
      ThemePaletteNotifier.new,
    );
