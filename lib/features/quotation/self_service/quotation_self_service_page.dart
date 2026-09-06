import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/quotation_header.dart';

/// Screen 5: Customer Self-Quotation Portal & B2C Lead Magnet (PRD Section 9.5 & requirmenet.md).
class QuotationSelfServicePage extends StatefulWidget {
  const QuotationSelfServicePage({super.key});

  @override
  State<QuotationSelfServicePage> createState() => _QuotationSelfServicePageState();
}

class _QuotationSelfServicePageState extends State<QuotationSelfServicePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<CustomerSelfEstimateLead> _capturedLeads;

  // Public Estimator Wizard State
  int _wizardStep = 0; // 0: OTP Gate, 1: Property Type, 2: Room Selection, 3: Material Tier, 4: Generated Estimate

  // Step 0: OTP Form
  final _nameController = TextEditingController(text: 'Siddharth Mehra');
  final _phoneController = TextEditingController(text: '+91 98205 11234');
  final _emailController = TextEditingController(text: 'siddharth.m@gmail.com');
  final _otpController = TextEditingController(text: '123456');
  bool _isOtpSent = false;
  bool _isOtpVerified = false;

  // Step 1: Property Type
  String _selectedPropertyType = '3BHK';
  double _carpetAreaSqft = 1450.0;

  // Step 2: Room Selection
  final Set<String> _selectedRooms = {'Living Room', 'Master Bedroom', 'Modular Kitchen', 'Dining Area', 'Guest Bedroom'};

  // Step 3: Material Tier
  MaterialTier _selectedTier = MaterialTier.premium;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _capturedLeads = List.from(QuotationMockData.selfEstimateLeads);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Cost estimation formula based on BHK, sqft, room count, and finish tier
  double get _baseCostPerSqft {
    switch (_selectedTier) {
      case MaterialTier.budget:
        return 750.0;
      case MaterialTier.premium:
        return 1150.0;
      case MaterialTier.luxury:
        return 1750.0;
    }
  }

  double get _estimatedMinTotal => _carpetAreaSqft * _baseCostPerSqft * 0.9;
  double get _estimatedMaxTotal => _carpetAreaSqft * _baseCostPerSqft * 1.15;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            QuotationHeader(
              title: 'Customer Self-Quotation Portal & B2C Lead Magnet',
              subtitle: 'Public interactive cost calculator with instant SMS OTP verification & CRM lead sync',
              icon: Icons.touch_app_rounded,
            ),

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
                tabs: const [
                  Tab(icon: Icon(Icons.calculate_outlined, size: 18), text: 'Public Estimator Simulator (5-Step B2C Wizard)'),
                  Tab(icon: Icon(Icons.people_alt_outlined, size: 18), text: 'Captured Ingestion Feed (CRM Sync)'),
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
                  _buildInteractiveWizardTab(isDark),
                  _buildCapturedLeadsTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 1: Interactive B2C Estimator Wizard
  // ---------------------------------------------------------------------------
  Widget _buildInteractiveWizardTab(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wizard Stepper Bar
          Row(
            children: [
              _buildStepIndicator(0, '1. OTP Gate', isDark),
              _buildStepDivider(isDark),
              _buildStepIndicator(1, '2. Layout & Size', isDark),
              _buildStepDivider(isDark),
              _buildStepIndicator(2, '3. Rooms', isDark),
              _buildStepDivider(isDark),
              _buildStepIndicator(3, '4. Materials', isDark),
              _buildStepDivider(isDark),
              _buildStepIndicator(4, '5. Instant Quote', isDark),
            ],
          ),
          const Divider(height: 32),

          // Active Step View
          Expanded(
            child: SingleChildScrollView(
              child: _buildActiveStepContent(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIdx, String label, bool isDark) {
    final isActive = _wizardStep == stepIdx;
    final isDone = _wizardStep > stepIdx;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isDone
                ? AppColors.success
                : isActive
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : Text(
                    '${stepIdx + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isDark) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
    );
  }

  Widget _buildActiveStepContent(bool isDark) {
    switch (_wizardStep) {
      case 0:
        return _buildStep0OtpGate(isDark);
      case 1:
        return _buildStep1PropertyLayout(isDark);
      case 2:
        return _buildStep2RoomSelection(isDark);
      case 3:
        return _buildStep3MaterialTier(isDark);
      case 4:
        return _buildStep4GeneratedEstimate(isDark);
      default:
        return const SizedBox();
    }
  }

  // Step 0: Name, Phone & OTP Gate
  Widget _buildStep0OtpGate(bool isDark) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Client Identity & OTP Verification Gate', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'Before generating the dynamic estimate, verify your contact number. This prevents bot spam and guarantees locked-in price quotes.',
            style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_rounded, size: 18)),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Mobile Phone Number',
              prefixIcon: const Icon(Icons.phone_rounded, size: 18),
              suffixIcon: !_isOtpSent
                  ? TextButton(
                      onPressed: () {
                        setState(() => _isOtpSent = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('6-Digit OTP sent to mobile (Use: 123456)'), backgroundColor: AppColors.primary),
                        );
                      },
                      child: const Text('Send OTP'),
                    )
                  : const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
            ),
          ),
          const SizedBox(height: 14),

          if (_isOtpSent) ...[
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter 6-Digit SMS OTP',
                hintText: '123456',
                prefixIcon: Icon(Icons.lock_clock_rounded, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.shield_rounded, size: 14, color: AppColors.success),
                const SizedBox(width: 4),
                Text('Test Demo Helper: Enter 123456 for instant verification', style: GoogleFonts.inter(fontSize: 11, color: AppColors.success)),
              ],
            ),
          ],
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              if (!_isOtpSent) {
                setState(() => _isOtpSent = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP sent! Please verify.'), backgroundColor: AppColors.primary),
                );
              } else {
                setState(() {
                  _isOtpVerified = true;
                  _wizardStep = 1;
                });
              }
            },
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: Text(!_isOtpSent ? 'Send OTP to Continue' : 'Verify & Proceed to Floor Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Layout & Carpet Size
  Widget _buildStep1PropertyLayout(bool isDark) {
    final types = ['1BHK', '2BHK', '3BHK', '4BHK', 'Villa', 'Commercial Studio'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2: Property Configuration & Carpet Area', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('Select the property layout and adjust the approximate carpet area slider.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 20),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: types.map((type) {
            final isSel = _selectedPropertyType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSel,
              onSelected: (_) => setState(() => _selectedPropertyType = type),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              labelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                color: isSel ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Carpet Area (Square Feet):', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(
              '${_carpetAreaSqft.toStringAsFixed(0)} Sq.Ft',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ],
        ),
        Slider(
          value: _carpetAreaSqft,
          min: 450.0,
          max: 4500.0,
          divisions: 81,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _carpetAreaSqft = val),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            OutlinedButton(onPressed: () => setState(() => _wizardStep = 0), child: const Text('Back')),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => setState(() => _wizardStep = 2),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Next: Room Selection'),
            ),
          ],
        ),
      ],
    );
  }

  // Step 2: Room Selection
  Widget _buildStep2RoomSelection(bool isDark) {
    final availableRooms = [
      'Living Room',
      'Dining Area',
      'Modular Kitchen',
      'Master Bedroom',
      'Kids Bedroom',
      'Guest Bedroom',
      'Master Bathroom',
      'Common Bathroom',
      'Foyer & Shoe Rack',
      'Balcony Garden Deck',
      'Pooja Room',
      'Home Office Study',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 3: Select Rooms for Interior Fitout', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('Choose which areas you want to include in this quotation.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 20),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableRooms.map((room) {
            final isSel = _selectedRooms.contains(room);
            return FilterChip(
              avatar: Icon(isSel ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, size: 16),
              label: Text(room),
              selected: isSel,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedRooms.add(room);
                  } else {
                    if (_selectedRooms.length > 1) _selectedRooms.remove(room);
                  }
                });
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                color: isSel ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            OutlinedButton(onPressed: () => setState(() => _wizardStep = 1), child: const Text('Back')),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => setState(() => _wizardStep = 3),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Next: Specification Finish Tier'),
            ),
          ],
        ),
      ],
    );
  }

  // Step 3: Material & Finish Tier
  Widget _buildStep3MaterialTier(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 4: Quality & Material Finish Tier', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('Select your preferred finishes and hardware grade.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 20),

        Row(
          children: MaterialTier.values.map((tier) {
            final isSel = _selectedTier == tier;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSel
                      ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                      : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isSel ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSel ? 2.0 : 0.8,
                  ),
                ),
                child: InkWell(
                  onTap: () => setState(() => _selectedTier = tier),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tier.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800)),
                          if (isSel) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tier.description,
                        style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            OutlinedButton(onPressed: () => setState(() => _wizardStep = 2), child: const Text('Back')),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                _syncLeadToCrm();
                setState(() => _wizardStep = 4);
              },
              icon: const Icon(Icons.auto_awesome_rounded, size: 16),
              label: const Text('Generate Instant Estimation'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // Step 4: Generated Estimate Output + Lead Fed Confirmation
  Widget _buildStep4GeneratedEstimate(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: AppRadius.md,
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 0.8),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, size: 28, color: AppColors.success),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quotation Estimate Generated & Synced to CRM!', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.success)),
                    Text(
                      'A qualified lead for ${_nameController.text} has been automatically registered under Sales Stage 1 (New Leads).',
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Cost Range Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Estimated Interior Budget Range:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                '₹${(_estimatedMinTotal / 100000).toStringAsFixed(2)} Lakhs - ₹${(_estimatedMaxTotal / 100000).toStringAsFixed(2)} Lakhs',
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                'Includes complete civil, woodwork, hardware (${_selectedTier.title}), and turnkey execution for ${_carpetAreaSqft.toStringAsFixed(0)} Sq.Ft ($_selectedPropertyType).',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
              ),
              const Divider(height: 24),

              Text('Included Areas (${_selectedRooms.length} Spaces):', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _selectedRooms.map((r) {
                  return Chip(
                    label: Text(r),
                    labelStyle: GoogleFonts.inter(fontSize: 11),
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Estimate PDF summary downloaded!'), backgroundColor: AppColors.success),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('Download Estimate Summary'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _wizardStep = 0;
                  _isOtpSent = false;
                  _isOtpVerified = false;
                });
              },
              icon: const Icon(Icons.restart_alt_rounded, size: 16),
              label: const Text('Start New Estimate'),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 2: Captured Ingestion Feed (CRM Leads)
  // ---------------------------------------------------------------------------
  Widget _buildCapturedLeadsTab(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.md,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            headingRowHeight: 44,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 64,
            headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
            headingTextStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            columns: const [
              DataColumn(label: Text('PROSPECT NAME & CONTACT')),
              DataColumn(label: Text('PROPERTY TYPE & SQFT')),
              DataColumn(label: Text('FINISH TIER')),
              DataColumn(label: Text('ESTIMATED BUDGET RANGE')),
              DataColumn(label: Text('OTP VERIFIED')),
              DataColumn(label: Text('CRM STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: _capturedLeads.map((lead) {
              return DataRow(
                cells: [
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(lead.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                        Text('${lead.phone} • ${lead.email}', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                  DataCell(
                    Text('${lead.propertyType} (${lead.carpetAreaSqft.toStringAsFixed(0)} Sq.Ft)', style: GoogleFonts.inter(fontSize: 12)),
                  ),
                  DataCell(
                    Text(lead.tier.title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondaryLight)),
                  ),
                  DataCell(
                    Text(
                      '₹${(lead.estimatedMinBudget / 100000).toStringAsFixed(1)}L - ₹${(lead.estimatedMaxBudget / 100000).toStringAsFixed(1)}L',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('OTP Verified', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(lead.crmLeadStatus, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lead for ${lead.name} opened in Sales Pipeline!'), backgroundColor: AppColors.primary),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        visualDensity: VisualDensity.compact,
                        textStyle: GoogleFonts.inter(fontSize: 11),
                      ),
                      child: const Text('View Lead'),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _syncLeadToCrm() {
    final newLead = CustomerSelfEstimateLead(
      id: 'SEL-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      propertyType: _selectedPropertyType,
      carpetAreaSqft: _carpetAreaSqft,
      tier: _selectedTier,
      selectedRooms: _selectedRooms.toList(),
      estimatedMinBudget: _estimatedMinTotal,
      estimatedMaxBudget: _estimatedMaxTotal,
      isOtpVerified: _isOtpVerified,
      createdAt: DateTime.now(),
    );

    setState(() {
      _capturedLeads.insert(0, newLead);
    });
  }
}
