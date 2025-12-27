import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:augo/app/router/app_routes.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/providers/locale_provider.dart';
import 'package:augo/shared/providers/amount_theme_provider.dart';
import 'package:augo/shared/models/currency.dart';
import '../providers/financial_settings_provider.dart';
import '../providers/user_profile_provider.dart';
import '../models/user_info.dart';
import '../../chat/widgets/authenticated_image.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/server_config_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isEditingUsername = false;
  final _usernameController = TextEditingController();
  final _usernameFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final userState = ref.watch(userProfileProvider);

    return FScaffold(
      resizeToAvoidBottomInset: false,
      header: FHeader(title: const SizedBox.shrink()),
      child: GestureDetector(
        onTap: () {
          if (_isEditingUsername) {
            _cancelEditUsername();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 16.0 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // User avatar section - centered
              _buildUserAvatarSection(context, theme, colors, userState),

              const SizedBox(height: 24),

              // Group 1: Shared Spaces
              FTileGroup(
                children: [
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.users),
                    title: Text(t.settings.sharedSpace),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.pushNamed(AppRouteNames.sharedSpaceList),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Group 2: Settings Options
              FTileGroup(
                children: [
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.globe),
                    title: Text(t.settings.language),
                    subtitle: Text(
                      ref
                          .watch(localeProvider.notifier)
                          .currentLocaleDisplayName,
                    ),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.goNamed(AppRouteNames.languageSettings),
                  ),
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.mic),
                    title: Text(t.settings.speechRecognition),
                    subtitle: Text(t.settings.speechRecognitionSubtitle),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.goNamed(AppRouteNames.speechSettings),
                  ),
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.palette),
                    title: Text(t.settings.amountDisplayStyle),
                    subtitle: Text(_getAmountThemeDisplayName(ref)),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.goNamed(AppRouteNames.amountStyleSettings),
                  ),
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.dollarSign),
                    title: Text(t.settings.currency),
                    subtitle: Text(_getCurrencyDisplayName(ref)),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.goNamed(AppRouteNames.currencySettings),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Group 3: Appearance Settings
              FTileGroup(
                children: [
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.sun),
                    title: Text(t.settings.appearance),
                    subtitle: Text(t.settings.appearanceSubtitle),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.goNamed(AppRouteNames.appearanceSettings),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Server Settings Section
              FTileGroup(
                children: [
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.server),
                    title: Text(t.server.serverSettings),
                    subtitle: _buildServerSubtitle(ref),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () =>
                        context.push('/server-setup?reconfigure=true'),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              FTileGroup(
                children: [
                  FTile(
                    prefix: _buildSettingIcon(context, Icons.help_outline),
                    title: Text(t.settings.helpAndFeedback),
                    subtitle: Text(t.settings.helpAndFeedbackSubtitle),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () {
                      // TODO: Implement help functionality
                    },
                  ),
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.info),
                    title: Text(t.settings.aboutApp),
                    subtitle: Text(t.settings.aboutAppSubtitle),
                    suffix: Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    onPress: () {
                      // TODO: Implement about page
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              FTileGroup(
                children: [
                  FTile(
                    prefix: _buildSettingIcon(context, FIcons.logOut),
                    title: Text(t.auth.logout),
                    onPress: () => _handleLogout(context),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the user avatar section
  Widget _buildUserAvatarSection(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    UserProfileState userState,
  ) {
    final user = userState.user;
    final isUploadingAvatar = userState.isUploadingAvatar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar (with edit button)
        GestureDetector(
          onTap: isUploadingAvatar ? null : _pickAndUploadAvatar,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Avatar
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.muted,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border, width: 2),
                ),
                child: ClipOval(
                  child: isUploadingAvatar
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primary,
                          ),
                        )
                      : _buildAvatarContent(user?.avatarUrl, theme, colors),
                ),
              ),
              // Edit icon
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.background, width: 2),
                  ),
                  child: Icon(
                    FIcons.camera,
                    size: 14,
                    color: colors.primaryForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Username (inline editing)
        _buildUsernameSection(user, userState, theme, colors),
      ],
    );
  }

  /// Builds the username section (supports inline editing)
  Widget _buildUsernameSection(
    UserInfo? user,
    UserProfileState userState,
    FThemeData theme,
    FColors colors,
  ) {
    final isSaving = userState.isSaving;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _isEditingUsername
          ? _buildEditingMode(theme, colors, isSaving)
          : _buildDisplayMode(user, userState, theme, colors),
    );
  }

  /// edit mode
  Widget _buildEditingMode(FThemeData theme, FColors colors, bool isSaving) {
    return SizedBox(
      key: const ValueKey('editing'),
      width: 250,
      child: FTextField(
        controller: _usernameController,
        focusNode: _usernameFocusNode,
        autofocus: true,
        hint: t.user.username,
        suffixBuilder: (context, style, child) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: isSaving ? null : _submitUsername,
            child: isSaving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                : Icon(FIcons.check, size: 20, color: colors.primary),
          ),
        ),
      ),
    );
  }

  /// display mode
  Widget _buildDisplayMode(
    UserInfo? user,
    UserProfileState userState,
    FThemeData theme,
    FColors colors,
  ) {
    return GestureDetector(
      key: const ValueKey('display'),
      onTap: () => _startEditUsername(user?.username ?? ''),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (userState.isLoading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.mutedForeground,
              ),
            )
          else
            Text(
              user?.username ?? t.user.username,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
            ),
          const SizedBox(width: 6),
          Icon(FIcons.squarePen, size: 16, color: colors.mutedForeground),
        ],
      ),
    );
  }

  /// start edit username
  void _startEditUsername(String currentUsername) {
    _usernameController.text = currentUsername;
    // set selection
    _usernameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: currentUsername.length,
    );
    setState(() {
      _isEditingUsername = true;
    });
  }

  /// Cancel editing
  void _cancelEditUsername() {
    _usernameFocusNode.unfocus();
    setState(() {
      _isEditingUsername = false;
    });
  }

  /// submit username
  Future<void> _submitUsername() async {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) {
      ToastService.showDestructive(
        description: Text(t.settings.usernameRequired),
      );
      return;
    }

    final success = await ref
        .read(userProfileProvider.notifier)
        .updateUsername(newUsername);

    if (mounted) {
      setState(() {
        _isEditingUsername = false;
      });

      if (success) {
        ToastService.success(description: Text(t.settings.usernameUpdated));
      } else {
        final error = ref.read(userProfileProvider).error;
        ToastService.showDestructive(
          description: Text(error ?? t.common.error),
        );
      }
    }
  }

  /// build avatar content
  Widget _buildAvatarContent(
    String? avatarUrl,
    FThemeData theme,
    FColors colors,
  ) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      // Extract attachmentId from URL (URL format: http://.../view/{id} or /api/v1/files/view/{id})
      final uri = Uri.parse(avatarUrl);
      final pathSegments = uri.pathSegments;
      final attachmentId = pathSegments.isNotEmpty ? pathSegments.last : '';

      if (attachmentId.isNotEmpty) {
        return AuthenticatedImage(
          attachmentId: attachmentId,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            return Container(
              color: colors.muted,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Avatar load error: $error');
            return Container(
              color: colors.muted,
              child: Icon(FIcons.user, size: 40, color: colors.mutedForeground),
            );
          },
        );
      }
    }

    return Container(
      color: colors.muted,
      child: Icon(FIcons.user, size: 40, color: colors.mutedForeground),
    );
  }

  /// Pick and upload avatar
  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image == null) return;

    final success = await ref
        .read(userProfileProvider.notifier)
        .uploadAndUpdateAvatar(image);

    if (mounted) {
      if (success) {
        ToastService.success(description: Text(t.settings.avatarUpdated));
      } else {
        final error = ref.read(userProfileProvider).error;
        ToastService.showDestructive(
          description: Text(error ?? t.common.error),
        );
      }
    }
  }

  /// Builds setting item icon (using unified ThemedIcon component)
  Widget _buildSettingIcon(BuildContext context, IconData icon) {
    return ThemedIcon(icon: icon);
  }

  /// Gets amount theme display name
  String _getAmountThemeDisplayName(WidgetRef ref) {
    final themeId = ref.watch(amountThemeProvider).themeId;
    switch (themeId) {
      case 'chinaMarket':
        return t.amountTheme.chinaMarket;
      case 'international':
        return t.amountTheme.international;
      case 'minimalist':
        return t.amountTheme.minimalist;
      default:
        return t.amountTheme.colorBlind;
    }
  }

  /// Gets currency display name
  String _getCurrencyDisplayName(WidgetRef ref) {
    final currencyCode = ref.watch(financialSettingsProvider).primaryCurrency;
    final currency = Currency.fromCode(currencyCode);
    return currency?.displayName ?? currencyCode;
  }

  /// Handles logout
  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => FDialog(
        title: Text(t.auth.confirmLogoutTitle),
        body: Text(t.auth.confirmLogoutContent),
        actions: [
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () async {
              Navigator.of(context).pop();

              // Send toast message first to avoid context failure after redirection
              ToastService.success(description: Text(t.auth.logoutSuccess));

              await ref.read(authProvider.notifier).logout();
            },
            child: Text(t.auth.logout),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );
  }

  /// Build server subtitle showing current server URL
  Widget _buildServerSubtitle(WidgetRef ref) {
    final serverUrl = ref.watch(serverUrlProvider);
    if (serverUrl != null && serverUrl.isNotEmpty) {
      // Show shortened URL
      final uri = Uri.tryParse(serverUrl);
      final displayUrl = uri?.host ?? serverUrl;
      return Text('${t.server.currentServer}: $displayUrl');
    }
    return Text(t.server.currentServer);
  }
}
