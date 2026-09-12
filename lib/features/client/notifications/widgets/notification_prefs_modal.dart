import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/notification_models.dart';

/// Notification channel & event preferences modal sheet or dialog
class NotificationPreferencesModal extends StatefulWidget {
  const NotificationPreferencesModal({super.key});

  static Future<void> show(BuildContext context) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.90,
          child: const NotificationPreferencesModal(),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
          child: const NotificationPreferencesModal(),
        ),
      ),
    );
  }

  @override
  State<NotificationPreferencesModal> createState() =>
      _NotificationPreferencesModalState();
}

class _NotificationPreferencesModalState
    extends State<NotificationPreferencesModal> {
  final _prefs = NotificationRepository.instance.channelPreferences;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tune_rounded, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Preferences',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Manage channels for project alerts, billing & updates',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ],
            ),
          ),

          // Scrollable Toggles
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Project Progress & Site Logs', isDark),
                  _buildToggleTile('In-App Notification Feed', _prefs.projectUpdatesInApp, (v) => setState(() => _prefs.projectUpdatesInApp = v), isDark),
                  _buildToggleTile('Mobile Push Notification', _prefs.projectUpdatesPush, (v) => setState(() => _prefs.projectUpdatesPush = v), isDark),
                  _buildToggleTile('WhatsApp Daily Site Digest', _prefs.projectUpdatesWhatsApp, (v) => setState(() => _prefs.projectUpdatesWhatsApp = v), isDark),
                  _buildToggleTile('Email Milestone Summary', _prefs.projectUpdatesEmail, (v) => setState(() => _prefs.projectUpdatesEmail = v), isDark),
                  const Divider(height: 28),

                  _buildSectionHeader('Billing & Tranche Payments', isDark),
                  _buildToggleTile('In-App Payment Alerts', _prefs.billingInApp, (v) => setState(() => _prefs.billingInApp = v), isDark),
                  _buildToggleTile('Push Reminders for Due Invoices', _prefs.billingPush, (v) => setState(() => _prefs.billingPush = v), isDark),
                  _buildToggleTile('WhatsApp Payment Receipts', _prefs.billingWhatsApp, (v) => setState(() => _prefs.billingWhatsApp = v), isDark),
                  _buildToggleTile('SMS Tranche Alerts', _prefs.billingSms, (v) => setState(() => _prefs.billingSms = v), isDark),
                  _buildToggleTile('Email Tax Invoices (PDF)', _prefs.billingEmail, (v) => setState(() => _prefs.billingEmail = v), isDark),
                  const Divider(height: 28),

                  _buildSectionHeader('3D Designs & Sign-Offs', isDark),
                  _buildToggleTile('In-App Approval Prompts', _prefs.designInApp, (v) => setState(() => _prefs.designInApp = v), isDark),
                  _buildToggleTile('Push Alerts for New CAD / 3D Renders', _prefs.designPush, (v) => setState(() => _prefs.designPush = v), isDark),
                  _buildToggleTile('WhatsApp Design Preview Links', _prefs.designWhatsApp, (v) => setState(() => _prefs.designWhatsApp = v), isDark),
                  const Divider(height: 28),

                  _buildSectionHeader('Services & Labour Bookings', isDark),
                  _buildToggleTile('In-App Technician Arrival Alerts', _prefs.serviceUpdatesInApp, (v) => setState(() => _prefs.serviceUpdatesInApp = v), isDark),
                  _buildToggleTile('WhatsApp Check-in & Completion Proof', _prefs.serviceUpdatesWhatsApp, (v) => setState(() => _prefs.serviceUpdatesWhatsApp = v), isDark),
                  const Divider(height: 28),

                  _buildSectionHeader('Promotional & Marketplace', isDark),
                  _buildToggleTile('Email Styling Trends & Vastu Guides', _prefs.promotionalEmail, (v) => setState(() => _prefs.promotionalEmail = v), isDark),
                  _buildToggleTile('WhatsApp Seasonal Offers', _prefs.promotionalWhatsApp, (v) => setState(() => _prefs.promotionalWhatsApp = v), isDark),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification preferences saved successfully.'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                  elevation: 0,
                ),
                child: Text(
                  'Save Preferences',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    bool isDark,
  ) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}
