import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/estimate_result.dart';
import '../widgets/otp_verification.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_metric_card.dart';

/// Screen 6: Customer Self-Quotation Portal & B2C Lead Magnet (PRD Section 33 to 40).
/// Split into:
/// 1. B2C Mobile-First Customer Estimator Portal with OTP Verification
/// 2. Admin Captured CRM Leads Dashboard
class QuotationSelfServicePage extends StatefulWidget {
  const QuotationSelfServicePage({super.key});

  @override
  State<QuotationSelfServicePage> createState() => _QuotationSelfServicePageState();
}

class _QuotationSelfServicePageState extends State<QuotationSelfServicePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<CustomerSelfEstimateLead> _capturedLeads;

  // Portal Wizard State
  int _wizardStep = 0; // 0: Contact & OTP, 1: Property, 2: Rooms, 3: Style, 4: Tier, 5: Result

  // Step 0: Contact
  final _nameCtrl = TextEditingController(text: 'Siddharth Mehra');
  final _phoneCtrl = TextEditingController(text: '+91 98205 11234');
  final _emailCtrl = TextEditingController(text: 'siddharth.m@gmail.com');
  bool _otpSent = false;
  bool _otpVerified = false;

  // Step 1: Property
  String _propertyType = '3BHK';
  double _carpetAreaSqft = 1450.0;
  String _city = 'Bangalore';
  String _timeline = 'Ready to Move';

  // Step 2: Rooms
  final Set<String> _selectedRooms = {'Living Room', 'Master Bedroom', 'Modular Kitchen', 'Dining Area', 'Guest Bedroom'};

  // Step 3: Design Style
  String _selectedStyle = 'Modern Contemporary';

  // Step 4: Material Tier
  MaterialTier _selectedTier = MaterialTier.premium;

  static const List<String> propertyTypes = ['1BHK', '2BHK', '3BHK', '4BHK', 'Penthouse', 'Luxury Villa'];
  static const List<String> designStyles = [
    'Modern Contemporary',
    'Scandinavian Minimalist',
    'Japandi Organic',
    'Industrial Chic',
    'Bohemian Eclectic',
    'Royal Neoclassical',
  ];

  static const List<Map<String, dynamic>> roomOptions = [
    {'name': 'Living Room', 'icon': Icons.weekend_rounded},
    {'name': 'Modular Kitchen', 'icon': Icons.kitchen_rounded},
    {'name': 'Master Bedroom', 'icon': Icons.king_bed_rounded},
    {'name': 'Guest Bedroom', 'icon': Icons.single_bed_rounded},
    {'name': 'Kids Bedroom', 'icon': Icons.child_friendly_rounded},
    {'name': 'Dining Area', 'icon': Icons.restaurant_rounded},
    {'name': 'Balcony Deck', 'icon': Icons.deck_rounded},
    {'name': 'Pooja Room', 'icon': Icons.temple_hindu_rounded},
    {'name': 'Home Office', 'icon': Icons.computer_rounded},
    {'name': 'Foyer Area', 'icon': Icons.door_front_door_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _capturedLeads = List.from(QuotationMockData.selfEstimateLeads);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  double get _baseRatePerSqft {
    switch (_selectedTier) {
      case MaterialTier.budget:
        return 780.0;
      case MaterialTier.premium:
        return 1250.0;
      case MaterialTier.luxury:
        return 1950.0;
    }
  }

  double get _minEstimate => _carpetAreaSqft * _baseRatePerSqft * 0.92;
  double get _maxEstimate => _carpetAreaSqft * _baseRatePerSqft * 1.18;

  void _finishCalculation() {
    final newLead = CustomerSelfEstimateLead(
      id: 'SEL-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      propertyType: _propertyType,
      city: _city,
      possessionTimeline: _timeline,
      carpetAreaSqft: _carpetAreaSqft,
      tier: _selectedTier,
      designStyle: _selectedStyle,
      selectedRooms: _selectedRooms.toList(),
      estimatedMinBudget: _minEstimate,
      estimatedMaxBudget: _maxEstimate,
      isOtpVerified: true,
      createdAt: DateTime.now(),
      crmLeadStatus: 'SYNCED_TO_SALES',
    );

    setState(() {
      _capturedLeads.insert(0, newLead);
      _wizardStep = 5; // Result step
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Header with Breadcrumbs
            QuotationHeader(
              title: 'Customer Self-Quotation & Lead Magnet Engine',
              subtitle: 'Public interactive cost calculator with instant SMS OTP verification & CRM lead capture (PRD Section 33)',
              icon: Icons.touch_app_rounded,
              breadcrumbs: const ['Homio CRM', 'Commercials', 'Self-Quotation'],
              onRefresh: () {
                setState(() {
                  _capturedLeads = List.from(QuotationMockData.selfEstimateLeads);
                });
              },
            ),
            const SizedBox(height: 12),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                tabs: [
                  const Tab(text: 'Public Interactive Estimator Portal'),
                  Tab(text: 'CRM Captured Leads (${_capturedLeads.length})'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Views
            SizedBox(
              height: 820,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCustomerEstimatorPortal(isDark),
                  _buildCapturedLeadsDashboard(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Customer Estimator Portal
  Widget _buildCustomerEstimatorPortal(bool isDark) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              // Wizard Progress Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_wizardStep + 1} of 6: ${_getStepTitle(_wizardStep)}',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  if (_wizardStep > 0 && _wizardStep < 5)
                    TextButton.icon(
                      onPressed: () => setState(() => _wizardStep--),
                      icon: const Icon(Icons.arrow_back_rounded, size: 14),
                      label: const Text('Back'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_wizardStep + 1) / 6,
                backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
              const SizedBox(height: 18),

              // Steps
              if (_wizardStep == 0) _buildPortalStep0Contact(isDark),
              if (_wizardStep == 1) _buildPortalStep1Property(isDark),
              if (_wizardStep == 2) _buildPortalStep2Rooms(isDark),
              if (_wizardStep == 3) _buildPortalStep3Style(isDark),
              if (_wizardStep == 4) _buildPortalStep4Tier(isDark),
              if (_wizardStep == 5)
                EstimateResult(
                  estimate: _capturedLeads.first,
                  onBookConsultation: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Consultation booked! A Senior Designer will call within 2 hours.'), backgroundColor: AppColors.success),
                    );
                  },
                  onWhatsAppChat: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening WhatsApp chat with Homio Designer...'), backgroundColor: Color(0xFF25D366)),
                    );
                  },
                  onDownloadSummary: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading Instant Estimate PDF...'), backgroundColor: AppColors.primary),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Verify Contact Details';
      case 1:
        return 'Property Configuration';
      case 2:
        return 'Select Scope of Rooms';
      case 3:
        return 'Preferred Aesthetic Style';
      case 4:
        return 'Material & Finish Tier';
      case 5:
        return 'Estimated Budget Output';
      default:
        return '';
    }
  }

  // Step 0: Contact & OTP
  Widget _buildPortalStep0Contact(bool isDark) {
    if (_otpSent && !_otpVerified) {
      return OtpVerification(
        phone: _phoneCtrl.text,
        onVerified: () {
          setState(() {
            _otpVerified = true;
            _wizardStep = 1;
          });
        },
        onChangePhone: () => setState(() => _otpSent = false),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calculate Instant Interior Cost', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'Receive an accurate, room-by-room architectural estimate tailored to your floor plan in under 60 seconds.',
            style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Your Full Name *',
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 18),
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Phone (For OTP Verification) *',
              prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 18),
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address (To Receive PDF Dossier)',
              prefixIcon: const Icon(Icons.email_outlined, size: 18),
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty && _phoneCtrl.text.isNotEmpty) {
                  setState(() => _otpSent = true);
                }
              },
              icon: const Icon(Icons.lock_clock_rounded, size: 16),
              label: const Text('Send Verification OTP & Proceed'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Property Details
  Widget _buildPortalStep1Property(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Property Type & Carpet Area', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: propertyTypes.map((type) {
              final isSel = _propertyType == type;
              return ChoiceChip(
                label: Text(type, style: GoogleFonts.inter(fontWeight: isSel ? FontWeight.w700 : FontWeight.w500)),
                selected: isSel,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                onSelected: (_) => setState(() => _propertyType = type),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Carpet Area (Sq.Ft):', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
              Text('${_carpetAreaSqft.toInt()} Sq.Ft', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          Slider(
            value: _carpetAreaSqft,
            min: 400.0,
            max: 5000.0,
            divisions: 92,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _carpetAreaSqft = val),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _city,
                  decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder(borderRadius: AppRadius.sm)),
                  items: ['Bangalore', 'Mumbai', 'Delhi NCR', 'Hyderabad', 'Pune']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _city = v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _timeline,
                  decoration: InputDecoration(labelText: 'Possession Timeline', border: OutlineInputBorder(borderRadius: AppRadius.sm)),
                  items: ['Ready to Move', '1 - 3 Months', '3 - 6 Months', 'Under Construction']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 11))))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _timeline = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => setState(() => _wizardStep = 2),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Next: Choose Rooms'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Room Selection
  Widget _buildPortalStep2Rooms(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Which spaces are you designing?', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 80,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: roomOptions.length,
            itemBuilder: (context, idx) {
              final r = roomOptions[idx];
              final name = r['name'] as String;
              final icon = r['icon'] as IconData;
              final isSel = _selectedRooms.contains(name);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSel) {
                      _selectedRooms.remove(name);
                    } else {
                      _selectedRooms.add(name);
                    }
                  });
                },
                borderRadius: AppRadius.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1) : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
                    borderRadius: AppRadius.sm,
                    border: Border.all(
                      color: isSel ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: isSel ? 1.5 : 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: isSel ? AppColors.primary : Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => setState(() => _wizardStep = 3),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Next: Choose Design Style'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Design Style
  Widget _buildPortalStep3Style(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Your Preferred Interior Mood', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ...designStyles.map((style) {
            final isSel = _selectedStyle == style;
            return InkWell(
              onTap: () => setState(() => _selectedStyle = style),
              borderRadius: AppRadius.sm,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary.withValues(alpha: 0.1) : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isSel ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: isSel ? 1.5 : 0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(style, style: GoogleFonts.inter(fontSize: 13, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500)),
                    if (isSel) const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => setState(() => _wizardStep = 4),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Next: Material Specification Tier'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 4: Material Tier
  Widget _buildPortalStep4Tier(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Material & Craftsmanship Tier', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ...MaterialTier.values.map((tier) {
            final isSel = _selectedTier == tier;
            return InkWell(
              onTap: () => setState(() => _selectedTier = tier),
              borderRadius: AppRadius.md,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary.withValues(alpha: 0.1) : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isSel ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: isSel ? 1.5 : 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tier.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                        if (isSel) const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primary),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(tier.description, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _finishCalculation,
              icon: const Icon(Icons.calculate_rounded, size: 16),
              label: const Text('Calculate Instant Estimate'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: CRM Captured Leads Dashboard
  Widget _buildCapturedLeadsDashboard(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPI Row
        Row(
          children: [
            SizedBox(
              width: 180,
              child: QuotationMetricCard(
                title: 'CAPTURED LEADS',
                value: '${_capturedLeads.length}',
                subtitle: '100% Mobile OTP Verified',
                icon: Icons.contact_phone_rounded,
                accentColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 180,
              child: QuotationMetricCard(
                title: 'CONVERTED TO CRM',
                value: '${_capturedLeads.where((l) => l.crmLeadStatus == 'SYNCED_TO_SALES').length}',
                subtitle: 'Sales Assigned',
                icon: Icons.sync_rounded,
                accentColor: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
                  columns: const [
                    DataColumn(label: Text('Customer Name & Phone')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Property Scope')),
                    DataColumn(label: Text('City')),
                    DataColumn(label: Text('Finish Tier')),
                    DataColumn(label: Text('Estimated Range (₹)')),
                    DataColumn(label: Text('OTP Status')),
                    DataColumn(label: Text('CRM Sync Status')),
                  ],
                  rows: _capturedLeads.map((l) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(l.phone, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            ],
                          ),
                        ),
                        DataCell(Text(l.email, style: const TextStyle(fontSize: 11))),
                        DataCell(Text('${l.propertyType} (${l.carpetAreaSqft.toInt()} sq.ft)', style: const TextStyle(fontSize: 11))),
                        DataCell(Text(l.city, style: const TextStyle(fontSize: 11))),
                        DataCell(Text(l.tier.title, style: const TextStyle(fontSize: 11))),
                        DataCell(
                          Text(
                            '₹${(l.estimatedMinBudget / 100000).toStringAsFixed(1)}L - ₹${(l.estimatedMaxBudget / 100000).toStringAsFixed(1)}L',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: AppRadius.sm),
                            child: const Text('VERIFIED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.success)),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: AppRadius.sm),
                            child: Text(l.crmLeadStatus, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
