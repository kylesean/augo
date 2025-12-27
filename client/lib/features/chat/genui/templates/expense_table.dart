import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 数据表格 Widget 实现
class ExpenseTable extends StatelessWidget {
  final Map<String, dynamic> data;

  const ExpenseTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final headers = data['headers'] as List<dynamic>;
    final rows = data['rows'] as List<dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] as String,
            style: theme.typography.base.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: headers
                  .map(
                    (h) => DataColumn(
                      label: Text(
                        h as String,
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: rows.map((row) {
                final cells = row as List<dynamic>;
                return DataRow(
                  cells: cells
                      .map(
                        (cell) => DataCell(
                          Text(cell as String, style: theme.typography.sm),
                        ),
                      )
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
