import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';

class CampaignCreateDialog extends StatefulWidget {
  final ValueChanged<CampaignItem> onCampaignCreated;

  const CampaignCreateDialog({
    super.key,
    required this.onCampaignCreated,
  });

  static Future<void> show(BuildContext context, {required ValueChanged<CampaignItem> onCampaignCreated}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CampaignCreateDialog(onCampaignCreated: onCampaignCreated),
    );
  }

  @override
  State<CampaignCreateDialog> createState() => _CampaignCreateDialogState();
}

class _CampaignCreateDialogState extends State<CampaignCreateDialog> {
  int _currentStep = 0;

  // Step 1
  final _nameController = TextEditingController(text: 'Festive Luxury Interiors 2026');
  MarketingChannel _selectedChannel = MarketingChannel.metaAds;
  CampaignObjective _selectedObjective = CampaignObjective.leadGeneration;

  // Step 2
  final _budgetController = TextEditingController(text: '75000');
  final _dailySpendController = TextEditingController(text: '2500');

  // Step 3
  final _locationsController = TextEditingController(text: 'Mumbai, Pune, Thane');
  final _interestsController = TextEditingController(text: 'Luxury Interior, Modular Kitchen, Home Renovation');

  // Step 4
  final _headlineController = TextEditingController(text: 'Transform Your Home with Luxury Turnkey Interiors');
  final _adCopyController = TextEditingController(text: '45-day guaranteed delivery, zero hidden costs, bespoke modular designs.');
  final _destinationUrlController = TextEditingController(text: 'https://homio.in/festive-offer');
  String _selectedCta = 'Get Free Quote';

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _dailySpendController.dispose();
    _locationsController.dispose();
    _interestsController.dispose();
    _headlineController.dispose();
    _adCopyController.dispose();
    _destinationUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    final budget = double.tryParse(_budgetController.text) ?? 50000;
    final newCampaign = CampaignItem(
      id: 'camp-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim().isEmpty ? 'New Campaign' : _nameController.text.trim(),
      channel: _selectedChannel,
      objective: _selectedObjective,
      status: CampaignStatus.active,
      budget: budget,
      spent: 0,
      leadsGenerated: 0,
      conversions: 0,
      clicks: 0,
      impressions: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
    );

    widget.onCampaignCreated(newCampaign);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 750.0 : screenWidth * 0.95;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: dialogWidth,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Launch New Marketing Campaign',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Step ${_currentStep + 1} of 5: ${_stepTitle(_currentStep)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Step Progress Bar
            LinearProgressIndicator(
              value: (_currentStep + 1) / 5,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPrimary),
              minHeight: 4,
            ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStepContent(isDark),
              ),
            ),

            // Footer Navigation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentStep > 0
                      ? OutlinedButton(
                          onPressed: () => setState(() => _currentStep--),
                          child: const Text('Back'),
                        )
                      : TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                  _currentStep < 4
                      ? ElevatedButton(
                          onPressed: () => setState(() => _currentStep++),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPrimary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Next Step'),
                        )
                      : ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.rocket_launch_rounded, size: 16),
                          label: const Text('Publish & Launch'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
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

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return 'Campaign Details & Channel';
      case 1:
        return 'Budget & Scheduling';
      case 2:
        return 'Target Audience & Locations';
      case 3:
        return 'Creative & Destination';
      case 4:
        return 'Review & Launch';
      default:
        return '';
    }
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Campaign Name *',
                hintText: 'e.g. Q3 Pune Villa Interior Campaign',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Advertising Channel',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : AppColors.darkTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: MarketingChannel.values.map((channel) {
                final isSelected = _selectedChannel == channel;
                return ChoiceChip(
                  label: Text(channel.label),
                  avatar: Icon(channel.icon, size: 16),
                  selected: isSelected,
                  selectedColor: AppColors.brandPrimary.withValues(alpha: 0.2),
                  onSelected: (_) => setState(() => _selectedChannel = channel),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Campaign Objective',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : AppColors.darkTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: CampaignObjective.values.map((obj) {
                final isSelected = _selectedObjective == obj;
                return ChoiceChip(
                  label: Text(obj.label),
                  selected: isSelected,
                  selectedColor: AppColors.brandPrimary.withValues(alpha: 0.2),
                  onSelected: (_) => setState(() => _selectedObjective = obj),
                );
              }).toList(),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Lifetime Budget (₹) *',
                prefixText: '₹ ',
                helperText: 'Recommended for 30 days: ₹50,000 - ₹1,50,000',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dailySpendController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Spend Limit (₹)',
                prefixText: '₹ ',
                helperText: 'Pacing will automatically optimize based on Meta/Google auctions',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.brandPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.brandPrimary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.insights, color: AppColors.brandPrimary, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI Estimate: With ₹75,000 budget, expected leads: ~160-200 with an average CPL of ₹380 - ₹440.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _locationsController,
              decoration: const InputDecoration(
                labelText: 'Target Locations / Cities *',
                hintText: 'e.g. Mumbai, Pune, Navi Mumbai, Thane',
                helperText: 'Comma separated list of target cities or postal codes',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _interestsController,
              decoration: const InputDecoration(
                labelText: 'Interests & Behavioral Tags',
                hintText: 'e.g. Interior Design, Architecture, Luxury Homes',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audience Demographics: Age 28-55 | All Genders | Homeowners & Buyers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text('Exclusions: Users who already booked or converted in the past 60 days', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _headlineController,
              decoration: const InputDecoration(
                labelText: 'Ad Headline *',
                hintText: 'e.g. Luxury 3BHK Turnkey Interior Packages',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _adCopyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Primary Ad Text *',
                hintText: 'Describe offer, warranties, 3D visualization, or festive discounts',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _destinationUrlController,
              decoration: const InputDecoration(
                labelText: 'Destination URL (Landing Page) *',
                hintText: 'https://homio.in/campaign-page',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCta,
              decoration: const InputDecoration(labelText: 'Call to Action Button'),
              items: const [
                DropdownMenuItem(value: 'Get Free Quote', child: Text('Get Free Quote')),
                DropdownMenuItem(value: 'Book Site Visit', child: Text('Book Site Visit')),
                DropdownMenuItem(value: 'Download Brochure', child: Text('Download Brochure')),
                DropdownMenuItem(value: 'Contact Designer', child: Text('Contact Designer')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedCta = val);
              },
            ),
          ],
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Channel: ${_selectedChannel.label} • Objective: ${_selectedObjective.label}'),
                  const SizedBox(height: 4),
                  Text('Total Budget: ₹${_budgetController.text} (Daily: ₹${_dailySpendController.text})'),
                  const SizedBox(height: 4),
                  Text('Locations: ${_locationsController.text}'),
                  const SizedBox(height: 4),
                  Text('Destination: ${_destinationUrlController.text}'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'CTA: $_selectedCta',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.brandPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Meta & Google Ads Pixel integration active. UTM tags will be automatically appended.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF10B981)),
                  ),
                ),
              ],
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
