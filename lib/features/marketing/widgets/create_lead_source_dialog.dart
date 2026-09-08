import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';

class CreateLeadSourceDialog extends StatefulWidget {
  final ValueChanged<LeadSourceItem> onSourceCreated;

  const CreateLeadSourceDialog({
    super.key,
    required this.onSourceCreated,
  });

  static Future<void> show(BuildContext context, {required ValueChanged<LeadSourceItem> onSourceCreated}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CreateLeadSourceDialog(onSourceCreated: onSourceCreated),
    );
  }

  @override
  State<CreateLeadSourceDialog> createState() => _CreateLeadSourceDialogState();
}

class _CreateLeadSourceDialogState extends State<CreateLeadSourceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Meta Lead Gen - South Mumbai');
  MarketingChannel _channel = MarketingChannel.metaAds;
  SourceType _type = SourceType.paid;
  final _costController = TextEditingController(text: '50000');
  final _utmSourceController = TextEditingController(text: 'meta');
  final _utmMediumController = TextEditingController(text: 'lead_form');
  final _utmCampaignController = TextEditingController(text: 'south_mumbai_villas');

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _utmSourceController.dispose();
    _utmMediumController.dispose();
    _utmCampaignController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final cost = double.tryParse(_costController.text) ?? 0;
      final newSource = LeadSourceItem(
        id: 'src-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        channel: _channel,
        type: _type,
        status: 'Connected',
        cost: cost,
        leadsGenerated: 0,
        conversions: 0,
        lastSynced: DateTime.now(),
        syncHealth: 'Healthy',
      );

      widget.onSourceCreated(newSource);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 650 ? 580.0 : screenWidth * 0.95;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Connect Lead Source',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.darkTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure real-time API sync or custom UTM attribution stream',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Source Name *',
                    hintText: 'e.g. Meta Ads - Pune Luxury Condos',
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<MarketingChannel>(
                        initialValue: _channel,
                        decoration: const InputDecoration(labelText: 'Channel'),
                        items: MarketingChannel.values.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _channel = val;
                              _type = val.isPaid ? SourceType.paid : SourceType.organic;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<SourceType>(
                        initialValue: _type,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: SourceType.values.map((t) {
                          return DropdownMenuItem(value: t, child: Text(t.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _type = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Budget / Cost (₹)',
                    prefixText: '₹ ',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'UTM Parameter Tracking',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _utmSourceController,
                        decoration: const InputDecoration(labelText: 'utm_source'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _utmMediumController,
                        decoration: const InputDecoration(labelText: 'utm_medium'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _utmCampaignController,
                  decoration: const InputDecoration(labelText: 'utm_campaign'),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.webhook_rounded, size: 20, color: AppColors.brandPrimary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Instant Ingestion Webhook URL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            Text(
                              'https://api.homio.in/v1/leads/webhook/${_channel.name}',
                              style: const TextStyle(fontSize: 10, color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.link, size: 16),
                      label: const Text('Save & Connect'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPrimary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
