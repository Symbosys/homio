import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/labour_id_card_modal.dart';

class OnboardLabourPage extends StatefulWidget {
  const OnboardLabourPage({super.key});

  @override
  State<OnboardLabourPage> createState() => _OnboardLabourPageState();
}

class _OnboardLabourPageState extends State<OnboardLabourPage> {
  final _formKey = GlobalKey<FormState>();

  // Personal Info
  final _nameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedCity = 'Gurugram';
  final _zoneController = TextEditingController(text: 'DLF Phase 1-5 & Golf Course Ext');

  // Trade & Experience
  TradeType _primaryTrade = TradeType.carpentry;
  int _experienceYears = 8;
  final List<String> _selectedSkills = ['Modular Kitchen', 'Hardware Fitting'];
  final _newSkillController = TextEditingController();

  // Rate Card
  final _dailyRateController = TextEditingController(text: '1000');
  final _sqftRateController = TextEditingController(text: '50');
  final _overtimeRateController = TextEditingController(text: '180');

  // Government & Police
  final _aadhaarController = TextEditingController(text: 'XXXX-XXXX-');
  final _policePccController = TextEditingController(text: 'PCC-HR-GGN-2024-');
  final _policeStationController = TextEditingController(text: 'DLF Phase 1 PS, Gurugram');

  // Bank & Settlement
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController(text: 'HDFC0000280');
  final _accountHolderController = TextEditingController();
  final _upiController = TextEditingController();

  // Skill Score & Compliance
  double _tradeTestScore = 90.0;
  String _tradeGrade = 'Grade A+ Master Craftsman';
  String _riskLevel = 'LOW (Clear Background)';
  final _adminNotesController = TextEditingController(
    text: 'Aadhaar QR verified. Live facial selfie biometric matched at 99.1%. Police clearance authentic.',
  );
  final String _photoUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Onboard & Register New Tradesman',
              subtitle: 'Admin portal for complete identity verification, trade test certification, biometric capture, and rate card creation.',
              activeTab: 'Labour KYC & Security',
              trailing: OutlinedButton.icon(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(RouteNames.srvLabourKyc);
                  }
                },
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back to KYC Pipeline'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textPrimaryColor,
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Personal & Contact Details
                    _buildSectionHeader('1. Personal Identity & Contact Information', Icons.person_pin_rounded, isDark),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Legal Name (as per Aadhaar) *',
                                    hintText: 'e.g. Ramesh Chandra Verma',
                                    prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _aliasController,
                                  decoration: InputDecoration(
                                    labelText: 'Trade Nickname / Alias',
                                    hintText: 'e.g. Ramesh Mistri',
                                    prefixIcon: const Icon(Icons.tag, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Mobile Phone Number *',
                                    hintText: '+91 98XXX XXXXX',
                                    prefixIcon: const Icon(Icons.phone_android_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: _emergencyNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Emergency Contact Person & Relation',
                                    hintText: 'e.g. Sunita Verma (Wife)',
                                    prefixIcon: const Icon(Icons.contact_emergency_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _emergencyPhoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Emergency Phone Number',
                                    hintText: '+91 98XXX XXXXX',
                                    prefixIcon: const Icon(Icons.phone_callback_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<String>(
                                  initialValue: _selectedCity,
                                  decoration: InputDecoration(
                                    labelText: 'Operational City',
                                    prefixIcon: const Icon(Icons.location_city_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Gurugram', child: Text('Gurugram')),
                                    DropdownMenuItem(value: 'Delhi NCR', child: Text('Delhi NCR')),
                                    DropdownMenuItem(value: 'Mumbai', child: Text('Mumbai')),
                                    DropdownMenuItem(value: 'Bangalore', child: Text('Bangalore')),
                                    DropdownMenuItem(value: 'Noida', child: Text('Noida')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCity = val);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  controller: _zoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Operating Zone / Clusters',
                                    hintText: 'e.g. DLF Phase 1-5, Golf Course Extension',
                                    prefixIcon: const Icon(Icons.map_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Permanent Residential Address',
                                    hintText: 'House/Street/Town, District, State, PIN',
                                    prefixIcon: const Icon(Icons.home_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 2: Trade Specialization & Rate Card
                    _buildSectionHeader('2. Trade Specialization, Experience & Wage Rate Card', Icons.handshake_outlined, isDark),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<TradeType>(
                                  initialValue: _primaryTrade,
                                  decoration: InputDecoration(
                                    labelText: 'Primary Trade Specialization *',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                  items: TradeType.values.map((t) {
                                    return DropdownMenuItem(
                                      value: t,
                                      child: Row(
                                        children: [
                                          Icon(t.icon, size: 16, color: t.color),
                                          const SizedBox(width: 8),
                                          Text(t.label),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _primaryTrade = val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<int>(
                                  initialValue: _experienceYears,
                                  decoration: InputDecoration(
                                    labelText: 'Years of Field Experience',
                                    prefixIcon: const Icon(Icons.history_edu_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                  items: [1, 2, 3, 5, 8, 10, 12, 15, 20].map((yr) {
                                    return DropdownMenuItem(value: yr, child: Text('$yr Years Experience'));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _experienceYears = val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _dailyRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Daily Shift Rate (8h) (₹) *',
                                    prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _sqftRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Piece-Rate per Sq.Ft (₹)',
                                    prefixIcon: const Icon(Icons.square_foot_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: TextFormField(
                                  controller: _overtimeRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Overtime Rate per Hour (₹)',
                                    prefixIcon: const Icon(Icons.timer_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Secondary Skills & Toolsets:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ..._selectedSkills.map((skill) {
                                return Chip(
                                  label: Text(skill, style: const TextStyle(fontSize: 11)),
                                  onDeleted: () {
                                    setState(() => _selectedSkills.remove(skill));
                                  },
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                  deleteIconColor: AppColors.primary,
                                );
                              }),
                              ActionChip(
                                avatar: const Icon(Icons.add, size: 14),
                                label: const Text('Add Skill', style: TextStyle(fontSize: 11)),
                                onPressed: _promptAddSkill,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 3: KYC, Police Verification & Banking
                    _buildSectionHeader('3. Government ID, Police Verification & Bank Account', Icons.verified_user_rounded, isDark),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _aadhaarController,
                                  decoration: InputDecoration(
                                    labelText: 'Aadhaar Number (12 Digits) *',
                                    hintText: 'XXXX-XXXX-1234',
                                    prefixIcon: const Icon(Icons.credit_card_rounded, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: _policePccController,
                                  decoration: InputDecoration(
                                    labelText: 'Police Clearance Certificate (PCC) No.',
                                    hintText: 'PCC-HR-GGN-2024-XXXX',
                                    prefixIcon: const Icon(Icons.local_police_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _policeStationController,
                                  decoration: InputDecoration(
                                    labelText: 'Police Station Jurisdiction',
                                    hintText: 'e.g. DLF Phase 1 PS',
                                    prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _bankAccountController,
                                  decoration: InputDecoration(
                                    labelText: 'Bank Account Number *',
                                    hintText: '50100XXXXXXXXX',
                                    prefixIcon: const Icon(Icons.account_balance_outlined, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _ifscController,
                                  decoration: InputDecoration(
                                    labelText: 'Bank IFSC Code *',
                                    hintText: 'HDFC0000280',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _accountHolderController,
                                  decoration: InputDecoration(
                                    labelText: 'Account Holder Name',
                                    hintText: 'RAMESH CHANDRA VERMA',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _upiController,
                                  decoration: InputDecoration(
                                    labelText: 'UPI ID',
                                    hintText: 'worker@okhdfcbank',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 4: Admin Skill Evaluation & Live Biometrics
                    _buildSectionHeader('4. Admin Skill Evaluation & Live Biometric Record', Icons.face_retouching_natural_rounded, isDark),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Photo preview
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      _photoUrl,
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        height: 110,
                                        width: 110,
                                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                        child: const Icon(Icons.person, size: 50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text('Live Facial Selfie', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField<double>(
                                            initialValue: _tradeTestScore,
                                            decoration: InputDecoration(
                                              labelText: 'Trade Skill Test Score (%)',
                                              prefixIcon: const Icon(Icons.speed_rounded, size: 18),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                              filled: true,
                                              fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                            ),
                                            items: [95.0, 90.0, 85.0, 80.0, 75.0, 70.0].map((sc) {
                                              return DropdownMenuItem(value: sc, child: Text('$sc% Score'));
                                            }).toList(),
                                            onChanged: (val) {
                                              if (val != null) setState(() => _tradeTestScore = val);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: DropdownButtonFormField<String>(
                                            initialValue: _tradeGrade,
                                            decoration: InputDecoration(
                                              labelText: 'Trade Certified Grade',
                                              prefixIcon: const Icon(Icons.stars_rounded, size: 18),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                              filled: true,
                                              fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                            ),
                                            items: const [
                                              DropdownMenuItem(value: 'Grade A+ Master Craftsman', child: Text('Grade A+ Master Craftsman')),
                                              DropdownMenuItem(value: 'Grade A Certified Craftsman', child: Text('Grade A Certified Craftsman')),
                                              DropdownMenuItem(value: 'Grade B+ Skilled Worker', child: Text('Grade B+ Skilled Worker')),
                                              DropdownMenuItem(value: 'Grade B Apprentice', child: Text('Grade B Apprentice')),
                                            ],
                                            onChanged: (val) {
                                              if (val != null) setState(() => _tradeGrade = val);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: DropdownButtonFormField<String>(
                                            initialValue: _riskLevel,
                                            decoration: InputDecoration(
                                              labelText: 'Admin Risk Level',
                                              prefixIcon: const Icon(Icons.shield_outlined, size: 18),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                              filled: true,
                                              fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                            ),
                                            items: const [
                                              DropdownMenuItem(value: 'LOW (Clear Background)', child: Text('LOW (Clear Background)')),
                                              DropdownMenuItem(value: 'MEDIUM (Under Review)', child: Text('MEDIUM (Under Review)')),
                                              DropdownMenuItem(value: 'HIGH (Probationary)', child: Text('HIGH (Probationary)')),
                                            ],
                                            onChanged: (val) {
                                              if (val != null) setState(() => _riskLevel = val);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _adminNotesController,
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: 'Admin Verification & Compliance Audit Notes',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        filled: true,
                                        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Submission Bar
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.goNamed(RouteNames.srvLabourKyc);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Cancel & Discard'),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: _submitOnboarding,
                            icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                            label: const Text('Approve KYC & Activate Tradesman Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  void _promptAddSkill() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Secondary Skill'),
        content: TextField(
          controller: _newSkillController,
          decoration: const InputDecoration(hintText: 'e.g. Italian Veneer Polish, CPVC Piping'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_newSkillController.text.isNotEmpty) {
                setState(() => _selectedSkills.add(_newSkillController.text.trim()));
                _newSkillController.clear();
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitOnboarding() {
    if (!_formKey.currentState!.validate()) return;

    final workerId = 'LBR-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';
    final legalName = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Ramesh Chandra Verma';
    final alias = _aliasController.text.trim().isNotEmpty ? _aliasController.text.trim() : '$legalName Mistri';
    final phone = _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : '+91 98101 55667';
    final dailyRate = double.tryParse(_dailyRateController.text) ?? 1000.0;
    final sqftRate = double.tryParse(_sqftRateController.text) ?? 50.0;
    final overtimeRate = double.tryParse(_overtimeRateController.text) ?? 180.0;
    final aadhaar = _aadhaarController.text.trim().isNotEmpty ? _aadhaarController.text.trim() : 'XXXX-XXXX-8821';

    final newWorker = LabourProfile(
      id: workerId,
      legalName: legalName,
      alias: alias,
      phone: phone,
      trade: _primaryTrade,
      secondarySkills: _selectedSkills,
      experienceYears: _experienceYears,
      rating: 5.0,
      totalReviews: 1,
      completedJobs: 0,
      punctualityScore: 100.0,
      dailyRate: dailyRate,
      sqftRate: sqftRate,
      overtimeHourlyRate: overtimeRate,
      city: _selectedCity,
      zone: _zoneController.text,
      distanceKm: 3.5,
      kycStatus: KycStatus.approved,
      labourStatus: LabourStatus.available,
      aadhaarMasked: aadhaar,
      policeVerificationNo: _policePccController.text,
      photoUrl: _photoUrl,
      emergencyContact: _emergencyNameController.text.isNotEmpty ? _emergencyNameController.text : 'Family Contact',
      emergencyPhone: _emergencyPhoneController.text.isNotEmpty ? _emergencyPhoneController.text : '+91 98101 00998',
      skillBadges: [_tradeGrade, 'Verified Biometrics'],
    );

    final newKyc = LabourKycDocument(
      id: 'KYC-DOC-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      workerId: workerId,
      workerName: legalName,
      aadhaarNumber: aadhaar,
      aadhaarDocUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400',
      selfiePhotoUrl: _photoUrl,
      policeClearanceUrl: 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400',
      policeStationName: _policeStationController.text,
      bankAccountNo: _bankAccountController.text.isNotEmpty ? _bankAccountController.text : '50100492819201',
      ifscCode: _ifscController.text,
      accountHolderName: _accountHolderController.text.isNotEmpty ? _accountHolderController.text : legalName.toUpperCase(),
      upiId: _upiController.text.isNotEmpty ? _upiController.text : 'worker@okhdfcbank',
      tradeTestScore: _tradeTestScore,
      tradeGrade: _tradeGrade,
      riskLevel: _riskLevel,
      verificationNotes: _adminNotesController.text,
      submissionDate: DateTime.now(),
      verifiedAt: DateTime.now(),
      verifiedByAdmin: 'Admin / Compliance Controller',
      status: KycStatus.approved,
    );

    LabourMockData.profiles.insert(0, newWorker);
    LabourMockData.kycDocuments.insert(0, newKyc);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
            const SizedBox(width: 8),
            const Text('Tradesman Successfully Onboarded!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Worker $legalName ($workerId) is now active and verified in the Labour Marketplace.'),
            const SizedBox(height: 8),
            Text('Trade: ${_primaryTrade.label} • Rate: ₹${dailyRate.toStringAsFixed(0)}/day'),
            const SizedBox(height: 12),
            const Text('Digital ID Card generated with encrypted QR Code.'),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              showDialog(
                context: context,
                builder: (_) => LabourIdCardModal(worker: newWorker),
              );
            },
            child: const Text('View Digital ID Card'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(RouteNames.srvLabourKyc);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
            child: const Text('Go to KYC Pipeline'),
          ),
        ],
      ),
    );
  }
}
