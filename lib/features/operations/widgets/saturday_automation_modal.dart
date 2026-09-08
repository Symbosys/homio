import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class SaturdayAutomationModal extends StatefulWidget {
  final SaturdayAutomationConfig initialConfig;
  final List<SaturdayAutomationLog> logs;
  final ValueChanged<SaturdayAutomationConfig>? onSaveConfig;
  final VoidCallback? onTriggerNow;

  const SaturdayAutomationModal({
    super.key,
    required this.initialConfig,
    required this.logs,
    this.onSaveConfig,
    this.onTriggerNow,
  });

  @override
  State<SaturdayAutomationModal> createState() => _SaturdayAutomationModalState();
}

class _SaturdayAutomationModalState extends State<SaturdayAutomationModal> {
  late bool _isEnabled;
  late String _frequency;
  late String _dayOfWeek;
  late String _executionTime;
  late bool _generateRequest;
  late bool _sendWhatsApp;
  late bool _sendEmail;
  late bool _managerReviewRequired;
  late bool _accountsReviewRequired;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialConfig.isEnabled;
    _frequency = widget.initialConfig.frequency;
    _dayOfWeek = widget.initialConfig.dayOfWeek;
    _executionTime = widget.initialConfig.executionTime;
    _generateRequest = widget.initialConfig.generateRequest;
    _sendWhatsApp = widget.initialConfig.sendWhatsApp;
    _sendEmail = widget.initialConfig.sendEmail;
    _managerReviewRequired = widget.initialConfig.managerReviewRequired;
    _accountsReviewRequired = widget.initialConfig.accountsReviewRequired;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 760,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.alarm_on_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saturday Fee Automation Engine',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Automated weekly project cost calculation & WhatsApp payment dispatch engine',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Master Switch
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isEnabled
                            ? (isDark ? AppColors.success.withValues(alpha: 0.12) : const Color(0xFFF0FDF4))
                            : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isEnabled
                              ? AppColors.success.withValues(alpha: 0.4)
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isEnabled ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                                color: _isEnabled ? AppColors.success : AppColors.darkSubtext,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Weekly Fee Automation Master Trigger',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                  ),
                                  Text(
                                    _isEnabled
                                        ? 'Active • Automatically dispatches every Saturday at 10:00 AM IST'
                                        : 'Disabled • Automated Saturday dispatches are currently paused',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: _isEnabled,
                            activeThumbColor: AppColors.success,
                            onChanged: (val) => setState(() => _isEnabled = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Configuration Options
                    Text(
                      'Dispatch & Review Configuration',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _frequency,
                            decoration: const InputDecoration(
                              labelText: 'Frequency',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                              DropdownMenuItem(value: 'Bi-Weekly', child: Text('Bi-Weekly')),
                              DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _frequency = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _dayOfWeek,
                            decoration: const InputDecoration(
                              labelText: 'Execution Day',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Saturday', child: Text('Saturday')),
                              DropdownMenuItem(value: 'Sunday', child: Text('Sunday')),
                              DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                              DropdownMenuItem(value: 'Friday', child: Text('Friday')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _dayOfWeek = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: _executionTime,
                            decoration: const InputDecoration(
                              labelText: 'Dispatch Time',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) => _executionTime = val,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Toggles
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        _buildToggle(
                          'Generate Payment Requests',
                          _generateRequest,
                          (v) => setState(() => _generateRequest = v),
                        ),
                        _buildToggle(
                          'Send WhatsApp Link via API',
                          _sendWhatsApp,
                          (v) => setState(() => _sendWhatsApp = v),
                        ),
                        _buildToggle(
                          'Send Email Digest',
                          _sendEmail,
                          (v) => setState(() => _sendEmail = v),
                        ),
                        _buildToggle(
                          'Manager Sign-off Required',
                          _managerReviewRequired,
                          (v) => setState(() => _managerReviewRequired = v),
                        ),
                        _buildToggle(
                          'Accounts Verification Required',
                          _accountsReviewRequired,
                          (v) => setState(() => _accountsReviewRequired = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Automation History
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saturday Automation Execution History',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (widget.onTriggerNow != null)
                          OutlinedButton.icon(
                            onPressed: widget.onTriggerNow,
                            icon: const Icon(Icons.bolt_rounded, size: 14),
                            label: const Text('Test Trigger Now', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        children: widget.logs.map((log) {
                          return ListTile(
                            dense: true,
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_rounded,
                                  color: AppColors.success, size: 14),
                            ),
                            title: Text(
                              '${log.weekPeriod} • ${log.feeCount} Projects Billed',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                            subtitle: Text(
                              'Total: ₹${log.totalValue.toStringAsFixed(0)} • Executed on ${log.executionDate.day}/${log.executionDate.month}/${log.executionDate.year}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                log.status,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {
                      if (widget.onSaveConfig != null) {
                        widget.onSaveConfig!(
                          SaturdayAutomationConfig(
                            isEnabled: _isEnabled,
                            frequency: _frequency,
                            dayOfWeek: _dayOfWeek,
                            executionTime: _executionTime,
                            generateRequest: _generateRequest,
                            sendWhatsApp: _sendWhatsApp,
                            sendEmail: _sendEmail,
                            managerReviewRequired: _managerReviewRequired,
                            accountsReviewRequired: _accountsReviewRequired,
                          ),
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.save_rounded, size: 16),
                    label: const Text('Save Automation Rules'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return FilterChip(
      selected: value,
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onSelected: onChanged,
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
    );
  }
}
