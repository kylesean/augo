import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:share_plus/share_plus.dart';
import '../models/shared_space_models.dart';
import '../../../shared/services/toast_service.dart';

class InviteCodeCard extends StatelessWidget {
  final InviteCode inviteCode;
  final String appScheme;

  const InviteCodeCard({
    super.key,
    required this.inviteCode,
    this.appScheme = 'yourapp', // 可以从配置中获取
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 邀请码标题
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    FIcons.qrCode,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '邀请码',
                        style: theme.typography.lg.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '分享给朋友加入空间',
                        style: theme.typography.sm.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 邀请码显示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.border, width: 1),
              ),
              child: Column(
                children: [
                  // 邀请码
                  Text(
                    inviteCode.code,
                    style: theme.typography.xl2.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 有效期
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FIcons.clock,
                        size: 14,
                        color: colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatExpiryTime(inviteCode.expiresAt),
                        style: theme.typography.sm.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: FButton(
                    style: FButtonStyle.outline(),
                    onPress: () => _copyInviteCode(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FIcons.copy, size: 16),
                        const SizedBox(width: 8),
                        const Text('复制邀请码'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FButton(
                    onPress: () => _shareInviteLink(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FIcons.share, size: 16),
                        const SizedBox(width: 8),
                        const Text('分享邀请链接'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatExpiryTime(DateTime? expiresAt) {
    if (expiresAt == null) return '长期有效';
    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.isNegative) {
      return '已过期';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}天后过期';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时后过期';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟后过期';
    } else {
      return '即将过期';
    }
  }

  void _copyInviteCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: inviteCode.code));
    ToastService.show(description: const Text('邀请码已复制'));
  }

  void _shareInviteLink(BuildContext context) {
    final inviteLink = '$appScheme://join-space?code=${inviteCode.code}';
    final shareText =
        '邀请你加入共享空间"${inviteCode.spaceName}"\n\n'
        '邀请码：${inviteCode.code}\n'
        '或点击链接直接加入：$inviteLink\n\n'
        '邀请码将于${_formatExpiryTime(inviteCode.expiresAt)}';

    // ignore: deprecated_member_use
    Share.share(shareText);
  }
}
