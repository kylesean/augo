import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/i18n/strings.g.dart';
import '../molecules/molecules.dart';

/// A complete account selection widget with search functionality
///
/// This is a Layer 3 (Organism) component that provides
/// a full-featured account selection interface. Can dispatch
/// GenUI events for AI interaction.
class AccountSelector extends ConsumerStatefulWidget {
  /// Data map containing accounts, title, and configuration
  final Map<String, dynamic> data;

  /// GenUI event dispatcher for AI communication
  final void Function(UiEvent)? dispatchEvent;

  /// Whether the selector is in read-only historical mode
  final bool isHistorical;

  /// Directly provided accounts (alternative to data map)
  final List<Map<String, dynamic>>? accounts;

  /// Pre-selected account ID
  final String? preselectedId;

  const AccountSelector({
    super.key,
    required this.data,
    this.dispatchEvent,
    this.isHistorical = false,
    this.accounts,
    this.preselectedId,
  });

  /// Show account selection dialog (convenience static method)
  static Future<AccountPickerResult?> showPicker({
    required BuildContext context,
    required List<dynamic> accounts,
    String? title,
    String? selectedId,
    String? cancelText,
    String? confirmText,
    String? clearText,
  }) async {
    if (accounts.isEmpty) return null;

    final theme = context.theme;
    final colors = theme.colors;
    final displayTitle = title ?? t.transaction.selectLinkedAccount;
    final displayCancel = cancelText ?? t.common.cancel;
    final displayConfirm = confirmText ?? t.common.confirm;

    // Find the index of the currently selected account
    int currentIndex = 0;
    for (int i = 0; i < accounts.length; i++) {
      final accMap = accounts[i] as Map<String, dynamic>;
      if (accMap['id'] == selectedId) {
        currentIndex = i;
        break;
      }
    }

    final controller = FPickerController(initialIndexes: [currentIndex]);
    AccountPickerResult? result;

    await showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog.raw(
        style: style.call,
        animation: animation,
        builder: (context, style) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                displayTitle,
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
            ),
            // Picker
            SizedBox(
              height: 160,
              child: FPicker(
                controller: controller,
                children: [
                  FPickerWheel(
                    loop: false,
                    children: accounts.map((acc) {
                      final accMap = acc as Map<String, dynamic>;
                      final accName = accMap['name'] as String;
                      final accType = accMap['type'] as String? ?? '';
                      return Center(
                        child: Text(
                          accType.isNotEmpty ? '$accName ($accType)' : accName,
                          style: theme.typography.base.copyWith(
                            color: colors.foreground,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (clearText != null) ...[
                    Expanded(
                      child: FButton(
                        style: FButtonStyle.outline(),
                        onPress: () {
                          result = AccountPickerResult.cleared();
                          Navigator.pop(context);
                        },
                        child: Text(clearText),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else ...[
                    Expanded(
                      child: FButton(
                        style: FButtonStyle.outline(),
                        onPress: () => Navigator.pop(context),
                        child: Text(displayCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FButton(
                      onPress: () {
                        final selectedIndex = controller.value[0];
                        final safeIndex = selectedIndex.clamp(
                          0,
                          accounts.length - 1,
                        );
                        final selectedAccount =
                            accounts[safeIndex] as Map<String, dynamic>;
                        result = AccountPickerResult(
                          id: selectedAccount['id'] as String,
                          name: selectedAccount['name'] as String,
                          type: selectedAccount['type'] as String?,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(displayConfirm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return result;
  }

  @override
  ConsumerState<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends ConsumerState<AccountSelector> {
  String? _selectedId;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  /// Check if historical mode from data
  bool get _isHistorical =>
      widget.isHistorical || widget.data['_isHistorical'] == true;

  @override
  void initState() {
    super.initState();
    _selectedId =
        widget.preselectedId ?? widget.data['preselected_id'] as String?;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final newQuery = _searchController.text;
    if (newQuery != _searchQuery) {
      if (mounted) {
        setState(() {
          _searchQuery = newQuery;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _accounts {
    final dataAccounts = widget.data['accounts'] as List<dynamic>? ?? [];
    return widget.accounts ??
        dataAccounts.map((e) => e as Map<String, dynamic>).toList();
  }

  List<Map<String, dynamic>> get _filteredAccounts {
    if (_searchQuery.isEmpty) return _accounts;
    return _accounts.where((acc) {
      final name = (acc['name'] as String?)?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final title =
        widget.data['title'] as String? ?? t.transaction.selectLinkedAccount;
    final showSearch =
        widget.data['show_search'] as bool? ?? _accounts.length > 5;
    final enabled = (widget.data['enabled'] as bool? ?? true) && !_isHistorical;

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            // Search box
            if (showSearch && !_isHistorical) ...[
              _buildSearchBox(theme, colors),
              const SizedBox(height: 16),
            ],

            // Account list
            if (_filteredAccounts.isEmpty)
              _buildEmptyState(theme, colors)
            else
              ..._filteredAccounts.map((account) {
                final accountId = account['id'] as String? ?? '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AccountCard(
                    data: account,
                    selected: _selectedId == accountId,
                    enabled: enabled,
                    onTap: enabled
                        ? () => _onAccountSelected(accountId, account)
                        : null,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(FThemeData theme, FColors colors) {
    return FTextField(
      controller: _searchController,
      hint: t.common.search,
      prefixBuilder: (context, style, child) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Icon(FIcons.search, color: colors.mutedForeground, size: 18),
      ),
      suffixBuilder: (context, style, child) => _searchQuery.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FButton.icon(
                style: FButtonStyle.ghost(),
                onPress: () => _searchController.clear(),
                child: Icon(FIcons.x, color: colors.mutedForeground, size: 18),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildEmptyState(FThemeData theme, FColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(FIcons.search, size: 48, color: colors.mutedForeground),
            const SizedBox(height: 16),
            Text(
              t.common.noData,
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAccountSelected(String accountId, Map<String, dynamic> account) {
    if (mounted) {
      setState(() {
        _selectedId = accountId;
      });
    }

    // Dispatch GenUI event
    widget.dispatchEvent?.call(
      UserActionEvent(
        name: 'account_selected',
        sourceComponentId: 'account_selector',
        context: {
          'account_id': accountId,
          'account_name': account['name'],
          'account_type': account['type'],
        },
      ),
    );
  }
}

/// Account selection result
class AccountPickerResult {
  final String? id;
  final String? name;
  final String? type;
  final bool cleared;

  AccountPickerResult({required this.id, required this.name, this.type})
    : cleared = false;

  AccountPickerResult.cleared()
    : id = null,
      name = null,
      type = null,
      cleared = true;
}
