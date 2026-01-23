/// GenUI Composable Widget System
///
/// A 4-layer atomic widget architecture following flutter_genui design philosophy:
///
/// - **Atoms**: Smallest, indivisible UI elements (IconBadge, AmountDisplay, etc.)
/// - **Molecules**: Composed components from atoms (AccountCard, TransactionItem, etc.)
/// - **Organisms**: Complex containers managing molecules (AccountSelector, AccountList, etc.)
/// - **Templates**: Full business flows (registered in app_catalog.dart)
///
/// Usage:
/// ```dart
/// import 'package:augo/features/chat/genui/genui_widgets.dart';
///
/// // Use atoms
/// IconBadge(icon: FIcons.wallet, ...);
/// AmountDisplay(amount: 1234.56, currency: 'CNY');
///
/// // Use molecules
/// AccountCard(data: accountData, selected: true);
///
/// // Use organisms
/// AccountSelector(data: selectorData, dispatchEvent: context.dispatchEvent);
/// ```
library;

// Layer 1: Atoms
export 'atoms/atoms.dart';

// Layer 2: Molecules
export 'molecules/molecules.dart';

// Layer 3: Organisms
export 'organisms/organisms.dart';

// Utilities
export 'utils/formatters.dart';
export 'utils/theme_helpers.dart';
export 'utils/genui_data_paths.dart';
