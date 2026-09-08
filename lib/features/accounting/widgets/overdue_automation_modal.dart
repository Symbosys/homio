// Homio CRM — Overdue Escalation Automation Engine Modal

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class OverdueAutomationModal extends StatefulWidget {
  final OverdueAutomationConfig initialConfig;
  final ValueChanged<OverdueAutomationConfig>? onSaved;

  const OverdueAutomationModal({
    super.key,
    required this.initialConfig,
    this.onSaved,
  });

  @override
  State<OverdueAutomationModal> createState() => _OverdueAutomationModalState();
}

class _OverdueAutomationModalState extends State<OverdueAutomationModal> {
  late bool _enableReminders;
  late bool _sendWhatsApp;
  late bool _sendEmail;
  late bool _sendInternalAlert;
  late bool _notifySupervisor;
  late bool _escalateToFinance;
  late bool _pushToOwnerDashboard;
  late TextEditingController _thresholdCtrl;

  @override
  void initState() {
    super.initState();
    _enableReminders = widget.initialConfig.enableReminders;
    _sendWhatsApp = widget.initialConfig.sendWhatsApp;
    _sendEmail = widget.initialConfig.sendEmail;
    _sendInternalAlert = widget.initialConfig.sendInternalAlert;
    _notifySupervisor = widget.initialConfig.notifySupervisor;
    _escalateToFinance = widget.initialConfig.escalateToFinance;
    _pushToOwnerDashboard = widget.initialConfig.pushToOwnerDashboard;
    _thresholdCtrl = TextEditingController(
      text: widget.initialConfig.escalationThreshold.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _thresholdCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = OverdueAutomationConfig(
      enableReminders: _enableReminders,
      sendWhatsApp: _sendWhatsApp,
      sendEmail: _sendEmail,
      sendInternalAlert: _sendInternalAlert,
      notifySupervisor: _notifySupervisor,
      escalateToFinance: _escalateToFinance,
      pushToOwnerDashboard: _pushToOwnerDashboard,
      escalationThreshold: double.tryParse(_thresholdCtrl.text) ?? 100000.0,
    );
    widget.onSaved?.call(updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Overdue Automation Rules updated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.settings_suggest_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OVERDUE ESCALATION AUTOMATION ENGINE',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'Configure automated reminders, supervisor halts & escalation rules',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const Divider(height: 24),

            // Automation Ladder
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Due Date', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
                  Text('WhatsApp Bot', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF22C55E))),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
                  Text('Site Supervisor', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning)),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
                  Text('Owner Desk', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Switches
            SwitchListTile(
              title: const Text('Master Reminder Automation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: const Text('Activate background task cron for unpaid balances', style: TextStyle(fontSize: 11)),
              value: _enableReminders,
              onChanged: (val) => setState(() => _enableReminders = val),
              dense: true,
            ),
            SwitchListTile(
              title: const Text('Automated WhatsApp Payment Requests', style: TextStyle(fontSize: 13)),
              subtitle: const Text('Sends template with virtual account & UPI link at 10 AM on Due Date', style: TextStyle(fontSize: 11)),
              value: _sendWhatsApp,
              onChanged: (val) => setState(() => _sendWhatsApp = val),
              dense: true,
            ),
            SwitchListTile(
              title: const Text('Notify Site Supervisor (Stage Intervention)', style: TextStyle(fontSize: 13)),
              subtitle: const Text('Triggers site inspection hold when dues exceed 7 days', style: TextStyle(fontSize: 11)),
              value: _notifySupervisor,
              onChanged: (val) => setState(() => _notifySupervisor = val),
              dense: true,
            ),
            SwitchListTile(
              title: const Text('Escalate to Finance Admin & Owner Dashboard', style: TextStyle(fontSize: 13)),
              subtitle: const Text('Push alerts into Owner Command Center for high-risk accounts', style: TextStyle(fontSize: 11)),
              value: _pushToOwnerDashboard,
              onChanged: (val) => setState(() => _pushToOwnerDashboard = val),
              dense: true,
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _thresholdCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'High-Value Escalation Threshold (₹)',
                prefixText: '₹ ',
                isDense: true,
                border: OutlineInputBorder(),
                helperText: 'Dues above this amount immediately bypass level 1 and alert Finance Lead.',
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Apply Automation Rules'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
