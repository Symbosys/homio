import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';

class SocialInboxWidget extends StatefulWidget {
  final List<SocialMessageItem> messages;
  final ValueChanged<SocialMessageItem>? onApproveReply;
  final ValueChanged<SocialMessageItem>? onConvertToLead;

  const SocialInboxWidget({
    super.key,
    required this.messages,
    this.onApproveReply,
    this.onConvertToLead,
  });

  @override
  State<SocialInboxWidget> createState() => _SocialInboxWidgetState();
}

class _SocialInboxWidgetState extends State<SocialInboxWidget> {
  SocialPlatform? _selectedPlatform;
  SocialSentiment? _selectedSentiment;
  SocialMessageType? _selectedType;
  bool _autoAiPilot = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = widget.messages.where((m) {
      if (_selectedPlatform != null && m.platform != _selectedPlatform) return false;
      if (_selectedSentiment != null && m.sentiment != _selectedSentiment) return false;
      if (_selectedType != null && m.type != _selectedType) return false;
      return true;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Filters
          Padding(
            padding: const EdgeInsets.all(20),
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
                          'Social Engagement & AI Response Inbox',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.darkTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage Instagram, YouTube & Pinterest comments, DMs, and AI copilot drafts',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    // Auto-AI Pilot Switch
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _autoAiPilot
                            ? const Color(0xFF10B981).withValues(alpha: 0.12)
                            : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _autoAiPilot
                              ? const Color(0xFF10B981).withValues(alpha: 0.3)
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: _autoAiPilot ? const Color(0xFF10B981) : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Auto-Pilot',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _autoAiPilot ? const Color(0xFF10B981) : (isDark ? Colors.white70 : AppColors.darkTextPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _autoAiPilot,
                            activeThumbColor: const Color(0xFF10B981),
                            onChanged: (val) {
                              setState(() => _autoAiPilot = val);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(val ? 'AI Auto-Pilot Enabled: Auto-responding to standard inquiries' : 'AI Auto-Pilot Disabled: All drafts require human review'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Row
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // Platform filter
                    _buildFilterChip<SocialPlatform?>(
                      label: _selectedPlatform?.label ?? 'All Platforms',
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Platforms')),
                        ...SocialPlatform.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label))),
                      ],
                      selectedValue: _selectedPlatform,
                      onChanged: (val) => setState(() => _selectedPlatform = val),
                      isDark: isDark,
                    ),
                    // Sentiment filter
                    _buildFilterChip<SocialSentiment?>(
                      label: _selectedSentiment?.name.toUpperCase() ?? 'All Sentiments',
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Sentiments')),
                        ...SocialSentiment.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))),
                      ],
                      selectedValue: _selectedSentiment,
                      onChanged: (val) => setState(() => _selectedSentiment = val),
                      isDark: isDark,
                    ),
                    // Message type filter
                    _buildFilterChip<SocialMessageType?>(
                      label: _selectedType?.name.toUpperCase() ?? 'All Types',
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Types')),
                        ...SocialMessageType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))),
                      ],
                      selectedValue: _selectedType,
                      onChanged: (val) => setState(() => _selectedType = val),
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Message List
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  'No social messages match the current filters.',
                  style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final msg = filtered[index];
                return _buildMessageItem(msg, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip<T>({
    required String label,
    required List<DropdownMenuItem<T>> items,
    required T selectedValue,
    required ValueChanged<T> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedValue,
          isDense: true,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.darkTextPrimary,
          ),
          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
          items: items,
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildMessageItem(SocialMessageItem msg, bool isDark) {
    final sentimentColor = msg.sentiment == SocialSentiment.positive
        ? const Color(0xFF10B981)
        : (msg.sentiment == SocialSentiment.negative ? const Color(0xFFEF4444) : Colors.orange);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform Icon / Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: msg.platform.color.withValues(alpha: 0.15),
                child: Icon(msg.platform.icon, size: 18, color: msg.platform.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              msg.authorName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isDark ? Colors.white : AppColors.darkTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '@${msg.authorHandle}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: sentimentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                msg.sentiment.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: sentimentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _formatTimeAgo(msg.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      msg.messageText,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : AppColors.darkTextPrimary,
                      ),
                    ),
                    ...[
                    const SizedBox(height: 4),
                    Text(
                      'On post: "${msg.postTitle}"',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ],
                  ],
                ),
              ),
            ],
          ),
          // AI Draft & Actions
          if (msg.aiDraftReply != null && !msg.isReplied) ...[
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.only(left: 48),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: Color(0xFF6366F1)),
                      SizedBox(width: 6),
                      Text(
                        'HOMIO AI Suggested Response (Draft)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    msg.aiDraftReply!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          widget.onApproveReply?.call(msg);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('AI Reply dispatched to @${msg.authorHandle}!')),
                          );
                        },
                        icon: const Icon(Icons.send_rounded, size: 13),
                        label: const Text('Approve & Send', style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _showManualReplyDialog(context, msg),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Edit / Manual Reply', style: TextStyle(fontSize: 11)),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          widget.onConvertToLead?.call(msg);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lead created from @${msg.authorHandle} in CRM!')),
                          );
                        },
                        icon: const Icon(Icons.person_add_alt_1, size: 14),
                        label: const Text('Convert to CRM Lead', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (msg.isReplied) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 48),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                  SizedBox(width: 6),
                  Text('Replied via Agent / AI', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showManualReplyDialog(BuildContext context, SocialMessageItem msg) {
    final controller = TextEditingController(text: msg.aiDraftReply ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reply to @${msg.authorHandle}'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter personalized response...',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onApproveReply?.call(msg);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Custom reply sent to @${msg.authorHandle}!')),
              );
            },
            child: const Text('Send Response'),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
