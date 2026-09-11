import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_phase2_models.dart';
import '../models/admin_phase2_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  OrganizationSettings _org = AdminPhase2MockData.defaultOrgSettings;
  SecuritySettings _security = AdminPhase2MockData.defaultSecuritySettings;
  CommercialDefaults _commercial = AdminPhase2MockData.defaultCommercialSettings;
  OperationalBusinessRules _businessRules = AdminPhase2MockData.defaultBusinessRules;

  String? _selectedCategory; // null = overview landing view
  bool _showChangePreviewModal = false;
  String _previewField = '';
  String _currentVal = '';
  String _newVal = '';
  String _impactStatement = '';
  VoidCallback? _onConfirmSave;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: _selectedCategory == null ? 'Global System Settings' : 'Settings: $_selectedCategory',
                  description: 'Manage platform-wide defaults, enterprise security, localization, branding, and commercial operational rules.',
                  icon: Icons.tune_rounded,
                  breadcrumbs: [
                    'Homio Administration',
                    'Platform Configuration',
                    _selectedCategory ?? 'Global Settings',
                  ],
                  actions: [
                    if (_selectedCategory != null)
                      OutlinedButton.icon(
                        onPressed: () => setState(() => _selectedCategory = null),
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text('Back to Categories', style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All platform configurations verified against standard ISO-27001 baseline.')),
                        );
                      },
                      icon: const Icon(Icons.verified_outlined, size: 16),
                      label: const Text('System Baseline OK', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Metrics Ribbon
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Configured Setting Domains',
                      value: '8 Primary Categories',
                      subtitle: 'Active across all branches',
                      icon: Icons.tune_rounded,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Security & Auth Policy',
                      value: '2FA Enforced',
                      subtitle: '${_security.sessionTimeoutMinutes}m Session Timeout',
                      icon: Icons.shield_rounded,
                      color: AppColors.success,
                      trendText: 'Hardened',
                      isPositiveTrend: true,
                    ),
                    AdminMetricItem(
                      label: 'Default Localization',
                      value: 'INR (₹) • IST',
                      subtitle: 'Asia/Kolkata (+05:30)',
                      icon: Icons.language_rounded,
                      color: AppColors.secondary,
                    ),
                    AdminMetricItem(
                      label: 'Commercial Validity',
                      value: '${_commercial.quotationValidityDays} Days Tariff Lock',
                      subtitle: '${_commercial.maxExecutiveDiscountPercent}% Max Auto-Discount',
                      icon: Icons.verified_user_outlined,
                      color: AppColors.info,
                    ),
                  ],
                ),

                // 3. Category Landing Cards or Specific Form
                if (_selectedCategory == null)
                  _buildCategoriesLandingGrid(isDark, isMobile)
                else
                  _buildSelectedCategoryForm(isDark, isMobile),
              ],
            ),
          ),

          // Change Preview Confirmation Modal
          if (_showChangePreviewModal)
            _buildChangePreviewModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // SETTINGS OVERVIEW LANDING (8 Clean Categorized Cards)
  // ==========================================================================
  Widget _buildCategoriesLandingGrid(bool isDark, bool isMobile) {
    final categories = [
      _CategoryCardData(
        title: 'Organization Profile',
        description: 'Legal business name, registered GST numbers, head office address, support phone, and domain identity.',
        icon: Icons.corporate_fare_rounded,
        color: AppColors.primary,
        settingCount: 8,
        status: 'Configured',
      ),
      _CategoryCardData(
        title: 'Platform Security & Auth',
        description: 'Session timeout limits, account lockout thresholds, password complexity, and 2FA enforcement rules.',
        icon: Icons.security_rounded,
        color: AppColors.error,
        settingCount: 7,
        status: 'Hardened',
      ),
      _CategoryCardData(
        title: 'Localization & Currency',
        description: 'Base currency, timezones, date formats, number grouping conventions, and default regional language.',
        icon: Icons.public_rounded,
        color: AppColors.secondary,
        settingCount: 6,
        status: 'IST / INR',
      ),
      _CategoryCardData(
        title: 'Commercial & Pricing Defaults',
        description: 'Standard milestone payment terms, quotation validity days, invoice grace periods, and discount caps.',
        icon: Icons.receipt_long_rounded,
        color: AppColors.success,
        settingCount: 5,
        status: 'Active',
      ),
      _CategoryCardData(
        title: 'Customer Experience & Portal',
        description: 'Client sign-off workflows, document download rights, portal registrations, and notification opt-ins.',
        icon: Icons.person_pin_circle_rounded,
        color: AppColors.info,
        settingCount: 6,
        status: 'Active',
      ),
      _CategoryCardData(
        title: 'Business Hours & Operating SLAs',
        description: 'Working days, business hours, weekend auto-shift behavior, and automated follow-up SLA targets.',
        icon: Icons.access_time_rounded,
        color: AppColors.warning,
        settingCount: 5,
        status: '6 Days/Week',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Global Platform Configuration Domains', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          Text('Select a category to inspect or modify global platform rules and organization parameters.', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: isMobile ? 2.0 : 1.6,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _selectedCategory = cat.title),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(cat.icon, size: 20, color: cat.color),
                            ),
                            AdminStatusBadge(label: cat.status, color: cat.color),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(cat.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${cat.settingCount} Parameters', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DEDICATED SETTINGS FORM VIEW
  // ==========================================================================
  Widget _buildSelectedCategoryForm(bool isDark, bool isMobile) {
    switch (_selectedCategory) {
      case 'Platform Security & Auth':
        return _buildSecurityForm(isDark);
      case 'Commercial & Pricing Defaults':
        return _buildCommercialForm(isDark);
      case 'Business Hours & Operating SLAs':
        return _buildBusinessRulesForm(isDark);
      case 'Organization Profile':
      default:
        return _buildOrganizationForm(isDark);
    }
  }

  Widget _buildOrganizationForm(bool isDark) {
    final nameCtrl = TextEditingController(text: _org.orgName);
    final legalCtrl = TextEditingController(text: _org.legalName);
    final gstCtrl = TextEditingController(text: _org.gstNumber);
    final addrCtrl = TextEditingController(text: _org.businessAddress);
    final emailCtrl = TextEditingController(text: _org.contactEmail);
    final phoneCtrl = TextEditingController(text: _org.supportPhone);

    return _formContainer(
      isDark: isDark,
      title: 'Organization Identity & Legal Details',
      subtitle: 'Official corporate credentials displayed on client proposals, invoices, and statutory tax receipts.',
      children: [
        _formTextField('Organization Display Name', nameCtrl),
        _formTextField('Legal Entity Name (Statutory Invoicing)', legalCtrl),
        _formTextField('Registered GSTIN Tax Number', gstCtrl),
        _formTextField('Headquarters Commercial Address', addrCtrl, maxLines: 2),
        Row(
          children: [
            Expanded(child: _formTextField('Official Contact Email', emailCtrl)),
            const SizedBox(width: 14),
            Expanded(child: _formTextField('Central Support Phone', phoneCtrl)),
          ],
        ),
        const SizedBox(height: 18),
        _saveButton(
          onSave: () {
            _triggerChangePreview(
              field: 'Organization Legal Identity',
              currentVal: _org.legalName,
              newVal: legalCtrl.text,
              impact: 'Updating statutory name will apply to all newly generated invoices, quotations, and vendor contracts.',
              onConfirm: () {
                setState(() {
                  _org = OrganizationSettings(
                    orgName: nameCtrl.text,
                    legalName: legalCtrl.text,
                    logoUrl: _org.logoUrl,
                    businessAddress: addrCtrl.text,
                    contactEmail: emailCtrl.text,
                    supportPhone: phoneCtrl.text,
                    website: _org.website,
                    gstNumber: gstCtrl.text,
                    defaultCurrency: _org.defaultCurrency,
                    defaultTimezone: _org.defaultTimezone,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSecurityForm(bool isDark) {
    int timeout = _security.sessionTimeoutMinutes;
    int maxAttempts = _security.maxLoginAttemptsBeforeLockout;
    bool enforce2FA = _security.requireTwoFactorAuthForAdmins;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return _formContainer(
          isDark: isDark,
          title: 'Platform Authentication & Security Policies',
          subtitle: 'Enforce session timeouts, password complexity, and two-factor authentication across administrators.',
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Require Two-Factor Authentication (2FA) for Administrators', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('Mandates TOTP authenticator app verification upon login for all role levels.', style: TextStyle(fontSize: 11.5)),
              value: enforce2FA,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setLocalState(() => enforce2FA = val),
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Inactivity Session Timeout (Minutes)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: timeout,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), isDense: true),
                        items: const [
                          DropdownMenuItem(value: 15, child: Text('15 Minutes (Strict Banking Standard)')),
                          DropdownMenuItem(value: 30, child: Text('30 Minutes')),
                          DropdownMenuItem(value: 60, child: Text('60 Minutes (Standard Enterprise)')),
                          DropdownMenuItem(value: 120, child: Text('120 Minutes (Extended)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setLocalState(() => timeout = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Max Failed Login Attempts Before Lockout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        initialValue: maxAttempts,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), isDense: true),
                        items: const [
                          DropdownMenuItem(value: 3, child: Text('3 Attempts (Maximum Hardening)')),
                          DropdownMenuItem(value: 5, child: Text('5 Attempts (Recommended)')),
                          DropdownMenuItem(value: 10, child: Text('10 Attempts')),
                        ],
                        onChanged: (val) {
                          if (val != null) setLocalState(() => maxAttempts = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _saveButton(
              onSave: () {
                _triggerChangePreview(
                  field: 'Security & 2FA Enforcement Policy',
                  currentVal: '2FA: ${_security.requireTwoFactorAuthForAdmins ? "Enabled" : "Disabled"}, Timeout: ${_security.sessionTimeoutMinutes}m',
                  newVal: '2FA: ${enforce2FA ? "Enabled" : "Disabled"}, Timeout: ${timeout}m',
                  impact: 'Changing authentication policy will log out inactive sessions and prompt administrators for 2FA verification on subsequent login.',
                  onConfirm: () {
                    setState(() {
                      _security = SecuritySettings(
                        sessionTimeoutMinutes: timeout,
                        maxLoginAttemptsBeforeLockout: maxAttempts,
                        requireTwoFactorAuthForAdmins: enforce2FA,
                      );
                    });
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommercialForm(bool isDark) {
    final termsCtrl = TextEditingController(text: _commercial.standardPaymentTerms);
    final validityCtrl = TextEditingController(text: _commercial.quotationValidityDays.toString());
    final discountCtrl = TextEditingController(text: _commercial.maxExecutiveDiscountPercent.toString());

    return _formContainer(
      isDark: isDark,
      title: 'Commercial Defaults & Quotation Validity',
      subtitle: 'Standard financial milestones, quote expiration timers, and margin discount authorization thresholds.',
      children: [
        _formTextField('Standard Quotation Validity (Days)', validityCtrl),
        _formTextField('Maximum Unapproved Consultant Discount (%)', discountCtrl),
        _formTextField('Default Project Tranche Payment Terms', termsCtrl, maxLines: 2),
        const SizedBox(height: 18),
        _saveButton(
          onSave: () {
            _triggerChangePreview(
              field: 'Commercial Proposal Validity & Discount Cap',
              currentVal: '${_commercial.quotationValidityDays} days, ${_commercial.maxExecutiveDiscountPercent}% discount',
              newVal: '${validityCtrl.text} days, ${discountCtrl.text}% discount',
              impact: 'Alters default expiration on all future quotation drafts. Existing sent proposals retain historical lock.',
              onConfirm: () {
                setState(() {
                  _commercial = CommercialDefaults(
                    standardPaymentTerms: termsCtrl.text,
                    quotationValidityDays: int.tryParse(validityCtrl.text) ?? 15,
                    maxExecutiveDiscountPercent: double.tryParse(discountCtrl.text) ?? 5.0,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBusinessRulesForm(bool isDark) {
    final startCtrl = TextEditingController(text: _businessRules.businessStartTime);
    final endCtrl = TextEditingController(text: _businessRules.businessEndTime);
    final slaCtrl = TextEditingController(text: _businessRules.defaultSlaFollowUpHours.toString());

    return _formContainer(
      isDark: isDark,
      title: 'Operating Hours & Customer SLA Standards',
      subtitle: 'Standard working schedule governing automated task deadlines, meeting scheduling availability, and response SLAs.',
      children: [
        Row(
          children: [
            Expanded(child: _formTextField('Daily Operating Start Time', startCtrl)),
            const SizedBox(width: 14),
            Expanded(child: _formTextField('Daily Operating End Time', endCtrl)),
          ],
        ),
        _formTextField('Lead Initial Follow-Up SLA (Hours)', slaCtrl),
        const SizedBox(height: 18),
        _saveButton(
          onSave: () {
            _triggerChangePreview(
              field: 'Operational SLA Hours',
              currentVal: '${_businessRules.defaultSlaFollowUpHours} Hours',
              newVal: '${slaCtrl.text} Hours',
              impact: 'Changes target resolution times for newly assigned leads and site visit tasks.',
              onConfirm: () {
                setState(() {
                  _businessRules = OperationalBusinessRules(
                    businessStartTime: startCtrl.text,
                    businessEndTime: endCtrl.text,
                    defaultSlaFollowUpHours: int.tryParse(slaCtrl.text) ?? 4,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // HELPER WIDGETS
  // ==========================================================================
  Widget _formContainer({
    required bool isDark,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              const Divider(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _formTextField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
      ),
    );
  }

  Widget _saveButton({required VoidCallback onSave}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => setState(() => _selectedCategory = null),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Review & Save Changes'),
        ),
      ],
    );
  }

  // ==========================================================================
  // CHANGE PREVIEW CONFIRMATION MODAL
  // ==========================================================================
  void _triggerChangePreview({
    required String field,
    required String currentVal,
    required String newVal,
    required String impact,
    required VoidCallback onConfirm,
  }) {
    setState(() {
      _previewField = field;
      _currentVal = currentVal;
      _newVal = newVal;
      _impactStatement = impact;
      _onConfirmSave = onConfirm;
      _showChangePreviewModal = true;
    });
  }

  Widget _buildChangePreviewModal(bool isDark) {
    return Center(
      child: Container(
        width: 520,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.warning, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 28, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.change_circle_outlined, color: AppColors.warning, size: 22),
                const SizedBox(width: 8),
                const Text('Confirm Global Configuration Change', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20),
            Text('You are modifying global platform parameter: "$_previewField"', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Active Value', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error)),
                        const SizedBox(height: 4),
                        Text(_currentVal, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Proposed New Value', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                        const SizedBox(height: 4),
                        Text(_newVal, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Potential Impact: $_impactStatement', style: const TextStyle(fontSize: 11.5, color: AppColors.warning, height: 1.4))),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _showChangePreviewModal = false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_onConfirmSave != null) _onConfirmSave!();
                    setState(() {
                      _showChangePreviewModal = false;
                      _selectedCategory = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Global system configuration successfully updated.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Confirm & Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCardData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int settingCount;
  final String status;

  const _CategoryCardData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.settingCount,
    required this.status,
  });
}
