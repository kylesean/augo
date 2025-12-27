import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/features/chat/services/speech_recognition_service.dart';
import 'package:augo/features/chat/config/speech_config.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/services/toast_service.dart';
import '../models/speech_settings.dart';
import '../providers/speech_settings_provider.dart';

/// Speech recognition settings page
class SpeechSettingsPage extends ConsumerStatefulWidget {
  const SpeechSettingsPage({super.key});

  @override
  ConsumerState<SpeechSettingsPage> createState() => _SpeechSettingsPageState();
}

class _SpeechSettingsPageState extends ConsumerState<SpeechSettingsPage> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _pathController;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController();
    _portController = TextEditingController();
    _pathController = TextEditingController();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  void _initControllers() {
    final settings = ref.read(speechSettingsProvider).settings;
    if (settings != null) {
      // Use saved settings first, fallback to env config, then empty/default
      _hostController.text =
          settings.websocketHost ??
          (SpeechConfig.host.isNotEmpty ? SpeechConfig.host : '');
      _portController.text = (settings.websocketPort ?? SpeechConfig.port)
          .toString();
      _pathController.text = settings.websocketPath ?? SpeechConfig.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(speechSettingsProvider);

    // Initialize controllers (only after settings are loaded)
    if (state.settings != null && _hostController.text.isEmpty) {
      _initControllers();
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.chevronLeft, color: colors.foreground),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t.speech.title,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Service Selection Section
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      t.speech.service,
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FTileGroup(
                    children: [
                      _buildServiceTile(
                        context,
                        SpeechServiceType.system,
                        t.speech.systemVoice,
                        t.speech.systemVoiceSubtitle,
                        FIcons.smartphone,
                        state,
                      ),
                      _buildServiceTile(
                        context,
                        SpeechServiceType.websocket,
                        t.speech.selfHostedASR,
                        t.speech.selfHostedASRSubtitle,
                        FIcons.network,
                        state,
                      ),
                    ],
                  ),

                  // WebSocket Configuration Section
                  if (state.settings?.serviceType ==
                      SpeechServiceType.websocket) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                      child: Text(
                        t.speech.serverConfig,
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.muted.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(
                          theme.style.borderRadius.bottomLeft.x,
                        ),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        children: [
                          FTextField(
                            controller: _hostController,
                            label: Text(t.speech.serverAddress),
                            hint: '192.168.1.100',
                          ),
                          const SizedBox(height: 16),
                          FTextField(
                            controller: _portController,
                            label: Text(t.speech.port),
                            hint: '8080',
                          ),
                          const SizedBox(height: 16),
                          FTextField(
                            controller: _pathController,
                            label: Text(t.speech.path),
                            hint: '/ws',
                          ),
                          const SizedBox(height: 20),
                          FButton(
                            onPress: state.isSaving
                                ? null
                                : () => _saveWebsocketConfig(),
                            child: state.isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(t.speech.saveConfig),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Information section
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          FIcons.info,
                          size: 14,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t.speech.info,
                          style: theme.typography.sm.copyWith(
                            color: colors.mutedForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      t.speech.infoContent,
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  FTile _buildServiceTile(
    BuildContext context,
    SpeechServiceType type,
    String title,
    String subtitle,
    IconData icon,
    SpeechSettingsState state,
  ) {
    final theme = context.theme;
    final colors = theme.colors;
    final isSelected = state.settings?.serviceType == type;

    return FTile(
      prefix: Icon(
        icon,
        color: isSelected ? colors.primary : colors.mutedForeground,
      ),
      title: Text(
        title,
        style: theme.typography.base.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? colors.primary : colors.foreground,
        ),
      ),
      subtitle: Text(subtitle),
      suffix: isSelected
          ? Icon(FIcons.check, size: 20, color: colors.primary)
          : null,
      onPress: state.isSaving
          ? null
          : () async {
              await ref
                  .read(speechSettingsProvider.notifier)
                  .updateServiceType(type);
              if (context.mounted) {
                ToastService.success(
                  description: Text(t.settings.appearanceUpdated),
                );
              }
            },
    );
  }

  void _saveWebsocketConfig() {
    final host = _hostController.text.trim();
    final portText = _portController.text.trim();
    final path = _pathController.text.trim();

    if (host.isEmpty) {
      ToastService.showWarning(description: Text(t.speech.enterAddress));
      return;
    }

    final port = int.tryParse(portText);
    if (port == null || port <= 0 || port > 65535) {
      ToastService.showWarning(description: Text(t.speech.enterValidPort));
      return;
    }

    ref
        .read(speechSettingsProvider.notifier)
        .updateWebsocketConfig(
          host: host,
          port: port,
          path: path.isEmpty ? '/ws' : path,
        );

    ToastService.success(description: Text(t.speech.configSaved));
  }
}
