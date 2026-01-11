// features/home/widgets/home/transaction_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class TransactionCardData {
  final String transactionLabel;
  final String transactionAmount;
  final String timestamp;
  final String iconPath;
  final Color bgColor;
  final Color amountTextColor;

  TransactionCardData({
    required this.transactionLabel,
    required this.transactionAmount,
    required this.timestamp,
    required this.iconPath,
    required this.bgColor,
    required this.amountTextColor,
  });
}

class TransactionCardWidget extends ConsumerWidget {
  final TransactionCardData data;

  const TransactionCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: data.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: _getIconForTransaction(data.iconPath)),
          ),

          const SizedBox(width: 16),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.transactionLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.timestamp,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            data.transactionAmount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: data.amountTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIconForTransaction(String iconPath) {
    // Since we don't have actual SVG assets, we'll use Lucide icons as placeholders
    IconData iconData;
    Color iconColor;

    switch (iconPath) {
      case 'assets/icons/grocery.svg':
        iconData = FIcons.shoppingCart;
        iconColor = const Color(0xFF10B981);
        break;
      case 'assets/icons/salary.svg':
        iconData = FIcons.dollarSign;
        iconColor = const Color(0xFF3B82F6);
        break;
      case 'assets/icons/coffee.svg':
        iconData = FIcons.coffee;
        iconColor = const Color(0xFFF59E0B);
        break;
      case 'assets/icons/gas.svg':
        iconData = FIcons.fuel;
        iconColor = const Color(0xFFEF4444);
        break;
      case 'assets/icons/transfer.svg':
        iconData = FIcons.arrowRightLeft;
        iconColor = const Color(0xFF8B5CF6);
        break;
      default:
        iconData = FIcons.receipt;
        iconColor = const Color(0xFF6B7280);
    }

    return Icon(iconData, size: 24, color: iconColor);
  }
}
