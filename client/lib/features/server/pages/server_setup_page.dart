import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../providers/server_config_provider.dart';
import '../../../core/services/server_config_service.dart';
import '../../../i18n/strings.g.dart';

final _logger = Logger('ServerSetupPage');

/// Server setup page for configuring the backend server URL
///
/// This page is shown on first launch or when the user wants to
/// reconfigure the server connection.
class ServerSetupPage extends ConsumerStatefulWidget {
  /// Whether this is a reconfiguration (from settings) vs first-time setup
  final bool isReconfiguring;

  const ServerSetupPage({super.key, this.isReconfiguring = false});

  @override
  ConsumerState<ServerSetupPage> createState() => _ServerSetupPageState();
}

class _ServerSetupPageState extends ConsumerState<ServerSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isScanning = false;
  bool _isConnecting = false;
  ServerHealthResult? _healthResult;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing URL if reconfiguring
    final currentUrl = ref.read(serverUrlProvider);
    if (currentUrl != null) {
      _urlController.text = currentUrl;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isConnecting = true;
      _connectionError = null;
      _healthResult = null;
    });

    final configService = ref.read(serverConfigServiceProvider);
    final result = await configService.checkHealth(_urlController.text);

    if (!mounted) return;

    setState(() {
      _isConnecting = false;
      _healthResult = result;
      if (!result.isHealthy) {
        _connectionError = result.errorMessage;
      }
    });
  }

  Future<void> _saveAndContinue() async {
    if (_healthResult?.isHealthy != true) {
      // Test connection first
      await _testConnection();
      if (_healthResult?.isHealthy != true) return;
    }

    final notifier = ref.read(serverConfigProvider.notifier);
    await notifier.saveServerUrl(_urlController.text);

    if (!mounted) return;

    if (widget.isReconfiguring) {
      // Go back to settings
      context.pop();
    } else {
      // Navigate to login
      context.go('/login');
    }
  }

  void _startQrScan() {
    setState(() {
      _isScanning = true;
    });
  }

  void _stopQrScan() {
    setState(() {
      _isScanning = false;
    });
  }

  void _onQrCodeDetected(String url) {
    _logger.info('QR code detected: $url');
    setState(() {
      _urlController.text = url;
      _isScanning = false;
      _healthResult = null;
      _connectionError = null;
    });
    // Auto-test connection after QR scan
    _testConnection();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    if (_isScanning) {
      return _QrScannerView(
        onDetected: _onQrCodeDetected,
        onCancel: _stopQrScan,
      );
    }

    return FScaffold(
      header: widget.isReconfiguring
          ? AppBar(
              backgroundColor: theme.colors.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(FIcons.chevronLeft, color: theme.colors.foreground),
                onPressed: () => context.pop(),
              ),
              centerTitle: true,
              title: Text(
                t.server.title,
                style: theme.typography.xl.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colors.foreground,
                ),
              ),
            )
          : null,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: widget.isReconfiguring ? 16 : 32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!widget.isReconfiguring) ...[
                  const SizedBox(height: 48),

                  // Icon
                  Icon(
                    Icons.dns_outlined,
                    size: 64,
                    color: theme.colors.primary,
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    t.server.title,
                    style: theme.typography.xl2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    t.server.subtitle,
                    style: theme.typography.sm.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                ],

                // URL Input
                FTextFormField(
                  controller: _urlController,
                  label: Text(t.server.urlLabel),
                  hint: t.server.urlPlaceholder,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.url],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.server.error.urlRequired;
                    }
                    final configService = ref.read(serverConfigServiceProvider);
                    return configService.validateUrl(value);
                  },
                ),
                const SizedBox(height: 16),

                // QR Scan Button
                FButton(
                  style: FButtonStyle.outline(),
                  onPress: _startQrScan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 20),
                      const SizedBox(width: 8),
                      Text(t.server.scanQr),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Connection Status
                if (_isConnecting)
                  _ConnectionStatusCard(
                    icon: Icons.sync,
                    iconColor: theme.colors.primary,
                    title: t.server.connecting,
                    isLoading: true,
                  )
                else if (_healthResult?.isHealthy == true)
                  _ConnectionStatusCard(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: t.server.connected,
                    subtitle: _healthResult?.version != null
                        ? 'v${_healthResult!.version}'
                        : null,
                  )
                else if (_connectionError != null)
                  _ConnectionStatusCard(
                    icon: Icons.error_outline,
                    iconColor: theme.colors.destructive,
                    title: t.server.connectionFailed,
                    subtitle: _connectionError,
                  ),

                const SizedBox(height: 32),

                // Test Connection Button
                FButton(
                  style: FButtonStyle.secondary(),
                  onPress: _isConnecting ? null : _testConnection,
                  child: Text(t.server.testConnection),
                ),
                const SizedBox(height: 12),

                // Continue Button
                FButton(
                  onPress: (_healthResult?.isHealthy == true && !_isConnecting)
                      ? _saveAndContinue
                      : null,
                  child: Text(
                    widget.isReconfiguring
                        ? t.server.saveAndReturn
                        : t.server.continueToLogin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card showing connection status
class _ConnectionStatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool isLoading;

  const _ConnectionStatusCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colors.secondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colors.border),
      ),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: iconColor,
              ),
            )
          else
            Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.typography.xs.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// QR Scanner view
class _QrScannerView extends StatefulWidget {
  final void Function(String url) onDetected;
  final VoidCallback onCancel;

  const _QrScannerView({required this.onDetected, required this.onCancel});

  @override
  State<_QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<_QrScannerView> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        // Check if it looks like a URL
        if (value.contains('.') || value.contains(':')) {
          _hasScanned = true;
          HapticFeedback.mediumImpact();
          widget.onDetected(value);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // Overlay with cutout
          CustomPaint(
            painter: _ScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _controller.toggleTorch(),
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              t.server.scanQrInstruction,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for scanner overlay
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.5);

    final center = Offset(size.width / 2, size.height / 2);
    final cutoutSize = size.width * 0.7;
    final cutoutRect = Rect.fromCenter(
      center: center,
      width: cutoutSize,
      height: cutoutSize,
    );

    // Draw semi-transparent overlay
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw corner accents
    final accentPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;
    final corners = [
      // Top-left
      [
        cutoutRect.topLeft,
        Offset(cutoutRect.left + cornerLength, cutoutRect.top),
      ],
      [
        cutoutRect.topLeft,
        Offset(cutoutRect.left, cutoutRect.top + cornerLength),
      ],
      // Top-right
      [
        cutoutRect.topRight,
        Offset(cutoutRect.right - cornerLength, cutoutRect.top),
      ],
      [
        cutoutRect.topRight,
        Offset(cutoutRect.right, cutoutRect.top + cornerLength),
      ],
      // Bottom-left
      [
        cutoutRect.bottomLeft,
        Offset(cutoutRect.left + cornerLength, cutoutRect.bottom),
      ],
      [
        cutoutRect.bottomLeft,
        Offset(cutoutRect.left, cutoutRect.bottom - cornerLength),
      ],
      // Bottom-right
      [
        cutoutRect.bottomRight,
        Offset(cutoutRect.right - cornerLength, cutoutRect.bottom),
      ],
      [
        cutoutRect.bottomRight,
        Offset(cutoutRect.right, cutoutRect.bottom - cornerLength),
      ],
    ];

    for (final corner in corners) {
      canvas.drawLine(corner[0], corner[1], accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
