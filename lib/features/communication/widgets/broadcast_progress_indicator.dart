// Homio CRM — Real-Time Broadcast Progress Indicator

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import 'comm_status_badge.dart';

class BroadcastProgressIndicator extends StatelessWidget {
  final Broadcast broadcast;
  final VoidCallback? onPause;
  final VoidCallback? onCancel;

  const BroadcastProgressIndicator({
    super.key,
    required this.broadcast,
    this.onPause,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progressPct = broadcast.targetCount == 0
        ? 0.0
        : (broadcast.sentCount / broadcast.targetCount).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    broadcast.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Audience: ${broadcast.audienceFilter} • Channel: ${broadcast.channel.label}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              CommStatusBadge.fromBroadcastStatus(broadcast.status),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPct,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                broadcast.status == BroadcastStatus.completed
                    ? const Color(0xFF10B981)
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progressPct * 100).toStringAsFixed(1)}% Dispatched (${broadcast.sentCount} / ${broadcast.targetCount})',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              if (broadcast.status == BroadcastStatus.processing)
                const Row(
                  children: [
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Throttling at 45 msg/sec',
                      style: TextStyle(fontSize: 10, color: Color(0xFFF59E0B)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 4 Metric Counters
          Row(
            children: [
              _buildMetric(
                'Delivered',
                '${broadcast.deliveredCount}',
                '${(broadcast.deliveryRate * 100).toStringAsFixed(1)}%',
                const Color(0xFF10B981),
                isDark,
              ),
              const SizedBox(width: 12),
              _buildMetric(
                'Read Receipts',
                '${broadcast.readCount}',
                '${(broadcast.readRate * 100).toStringAsFixed(1)}%',
                const Color(0xFF2563EB),
                isDark,
              ),
              const SizedBox(width: 12),
              _buildMetric(
                'Failed / Undelivered',
                '${broadcast.failedCount}',
                broadcast.targetCount == 0
                    ? '0%'
                    : '${((broadcast.failedCount / broadcast.targetCount) * 100).toStringAsFixed(1)}%',
                const Color(0xFFEF4444),
                isDark,
              ),
              const SizedBox(width: 12),
              _buildMetric(
                'Remaining Queue',
                '${broadcast.targetCount - broadcast.sentCount}',
                '${((1 - progressPct) * 100).toStringAsFixed(1)}%',
                const Color(0xFF64748B),
                isDark,
              ),
            ],
          ),

          if (broadcast.status == BroadcastStatus.processing && (onPause != null || onCancel != null)) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onPause != null)
                  OutlinedButton.icon(
                    onPressed: onPause,
                    icon: const Icon(Icons.pause, size: 14),
                    label: const Text('Pause Broadcast', style: TextStyle(fontSize: 11)),
                  ),
                if (onCancel != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel_outlined, size: 14, color: Color(0xFFEF4444)),
                    label: const Text(
                      'Cancel Campaign',
                      style: TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String count, String rate, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  count,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  rate,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
