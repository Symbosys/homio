// Homio CRM — Enterprise WhatsApp Business Workspace & AI Chatbot Config

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_kpi_card.dart';
import '../widgets/comm_status_badge.dart';

class WhatsAppWorkspacePage extends StatefulWidget {
  const WhatsAppWorkspacePage({super.key});

  @override
  State<WhatsAppWorkspacePage> createState() => _WhatsAppWorkspacePageState();
}

class _WhatsAppWorkspacePageState extends State<WhatsAppWorkspacePage> {
  late WhatsAppAccount _account;
  late ChatbotConfig _chatbot;
  bool _isTestingWebhook = false;
  bool _isSyncingTemplates = false;

  @override
  void initState() {
    super.initState();
    _account = CommunicationMockData.whatsappAccount;
    _chatbot = CommunicationMockData.chatbotConfig;
  }

  void _testWebhook() async {
    setState(() => _isTestingWebhook = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isTestingWebhook = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Webhook Ping Successful! Response time: 118ms (HTTP 200 OK)'),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _syncTemplates() async {
    setState(() => _isSyncingTemplates = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isSyncingTemplates = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.sync, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Meta WhatsApp Templates Synced: 24 Approved, 1 Pending Approval.'),
            ],
          ),
          backgroundColor: Color(0xFF2563EB),
        ),
      );
    }
  }

  void _showEditChatbotDialog() {
    final nameCtrl = TextEditingController(text: _chatbot.botName);
    final welcomeCtrl = TextEditingController(text: _chatbot.welcomeMessage);
    final fallbackCtrl = TextEditingController(text: _chatbot.fallbackMessage);
    bool enabled = _chatbot.isEnabled;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.smart_toy_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text('Configure Homio Concierge AI Bot', style: TextStyle(fontSize: 16)),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Enable Automated Lead Qualification', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        subtitle: const Text('Qualify fresh leads and answer routine queries 24/7', style: TextStyle(fontSize: 11)),
                        value: enabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) => setDialogState(() => enabled = val),
                      ),
                      const Divider(height: 16),
                      const Text('Bot Display Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Homio Concierge AI',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Instant Welcome Message (WhatsApp & Web)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: welcomeCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Welcome greeting sent on first user inbound message...',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Fallback & Escalation Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: fallbackCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Sent when bot cannot answer and transfers to human architect...',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _chatbot = ChatbotConfig(
                        botName: nameCtrl.text.trim(),
                        isEnabled: enabled,
                        welcomeMessage: welcomeCtrl.text.trim(),
                        fallbackMessage: fallbackCtrl.text.trim(),
                        faqsCount: _chatbot.faqsCount,
                        qualificationQuestionsCount: _chatbot.qualificationQuestionsCount,
                        escalateToRole: _chatbot.escalateToRole,
                        workingHoursOnly: _chatbot.workingHoursOnly,
                        activeConversationsCount: _chatbot.activeConversationsCount,
                        escalatedTodayCount: _chatbot.escalatedTodayCount,
                        handoverKeywords: _chatbot.handoverKeywords,
                      );
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chatbot configuration saved successfully.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Settings'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CommPageHeader(
            title: 'WhatsApp Business API & Automation Workspace',
            subtitle: 'Meta Cloud API connection management, messaging quotas, webhooks & AI Concierge setup',
            icon: Icons.chat_rounded,
            primaryActionLabel: 'Configure Chatbot',
            primaryActionIcon: Icons.smart_toy_outlined,
            onPrimaryAction: _showEditChatbotDialog,
            customActions: [
              OutlinedButton.icon(
                onPressed: _isTestingWebhook ? null : _testWebhook,
                icon: _isTestingWebhook
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.network_ping, size: 16),
                label: const Text('Test Webhook Ping', style: TextStyle(fontSize: 12)),
              ),
              OutlinedButton.icon(
                onPressed: _isSyncingTemplates ? null : _syncTemplates,
                icon: _isSyncingTemplates
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.sync, size: 16),
                label: const Text('Sync Meta Templates', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          // Scrollable Workspace Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // 1. Connection Status Banner
                _buildConnectionBanner(isDark),
                const SizedBox(height: 20),

                // 2. Operational KPIs
                Row(
                  children: [
                    Expanded(
                      child: CommKpiCard(
                        title: 'Active WhatsApp Sessions',
                        value: '${_account.currentUsage}',
                        subtitle: 'Last 24 hours rolling window',
                        icon: Icons.chat_bubble_outline,
                        color: const Color(0xFF25D366),
                        trendText: '+14% vs yesterday',
                        isTrendPositive: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Daily Meta Message Quota',
                        value: '${(_account.currentUsage / 1000).toStringAsFixed(1)}K / 100K',
                        subtitle: 'Tier 3 (100,000 / 24 hrs)',
                        icon: Icons.speed_outlined,
                        color: const Color(0xFF3B82F6),
                        trendText: '14.2% consumed',
                        isTrendPositive: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Delivery Rate',
                        value: '98.4%',
                        subtitle: '0.6% failed or throttled',
                        icon: Icons.check_circle_outline,
                        color: const Color(0xFF10B981),
                        trendText: '+0.2% optimal',
                        isTrendPositive: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'AI Bot Handled Today',
                        value: '${_chatbot.activeConversationsCount + _chatbot.escalatedTodayCount}',
                        subtitle: '${_chatbot.escalatedTodayCount} escalated to architects',
                        icon: Icons.smart_toy_outlined,
                        color: const Color(0xFF8B5CF6),
                        trendText: '64% resolution',
                        isTrendPositive: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Technical Specs & Webhook Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Meta WABA Credentials
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                            const Row(
                              children: [
                                Icon(Icons.verified, color: Color(0xFF25D366), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Meta Business Account Credentials',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildConfigRow('Business Name', _account.businessName, isDark),
                            _buildConfigRow('Official Phone Number', _account.phoneNumber, isDark),
                            _buildConfigRow('Display Phone Number', _account.displayPhoneNumber, isDark),
                            _buildConfigRow('WABA Account ID', _account.wabaId, isDark),
                            _buildConfigRow('Phone Quality Rating', _account.qualityRating, isDark),
                            _buildConfigRow('Messaging Tier Limit', _account.messagingTier, isDark),
                            _buildConfigRow('Webhook Ingestion', _account.webhookStatus, isDark),
                            _buildConfigRow('Last Synced', _account.lastSyncTime.toString().substring(0, 19), isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Right: AI Concierge & Chatbot Overview
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                                const Row(
                                  children: [
                                    Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Homio Concierge AI',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _chatbot.isEnabled
                                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                        : const Color(0xFF64748B).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _chatbot.isEnabled ? 'ACTIVE' : 'DISABLED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _chatbot.isEnabled ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Welcome Message:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              ),
                              child: Text(
                                _chatbot.welcomeMessage,
                                style: const TextStyle(fontSize: 12, height: 1.3),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Handover Escalation Keywords:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _chatbot.handoverKeywords.map((kw) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                    kw,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF25D366).withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF25D366).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Meta WhatsApp Cloud API v19.0 — Operational',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                    CommStatusBadge.fromWhatsAppConnection(_account.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Connected to WABA ID: ${_account.wabaId}. Verified Meta Green Badge Active. Webhook live on production endpoint.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
