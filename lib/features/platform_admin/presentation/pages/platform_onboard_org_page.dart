import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/toast_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/platform_plan_model.dart';
import '../queries/platform_queries.dart';
import '../widgets/logo_picker_field.dart';

class PlatformOnboardOrgPage extends StatefulWidget {
  const PlatformOnboardOrgPage({super.key});

  @override
  State<PlatformOnboardOrgPage> createState() => _PlatformOnboardOrgPageState();
}

class _PlatformOnboardOrgPageState extends State<PlatformOnboardOrgPage> {
  final _formKey = GlobalKey<FormState>();
  final PlatformQueries _queries = PlatformQueries();

  // Organization Form Controllers
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _legalNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Admin User Account Controllers
  final _adminFirstNameController = TextEditingController();
  final _adminLastNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController(text: 'StudioAdmin@2026');
  final _adminPhoneController = TextEditingController();

  // Subscription Selection
  List<PlatformPlanModel> _availablePlans = [];
  String? _selectedPlanId;
  String _selectedBillingCycle = 'MONTHLY';
  String _selectedSubscriptionStatus = 'TRIALING';
  final int _trialDays = 14;

  bool _isLoadingPlans = true;
  bool _isSubmitting = false;
  String? _error;

  Uint8List? _logoBytes;
  String? _logoFileName;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _legalNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _taxIdController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();

    _adminFirstNameController.dispose();
    _adminLastNameController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _adminPhoneController.dispose();
    super.dispose();
  }

  void _onNameChanged(String val) {
    final slug = val.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    _slugController.text = slug;
  }

  Future<void> _loadPlans() async {
    try {
      final res = await _queries.getPlansQuery(includeInactive: false).fetch();
      if (mounted) {
        setState(() {
          _availablePlans = res.data ?? [];
          if (_availablePlans.isNotEmpty) {
            _selectedPlanId = _availablePlans.first.id;
          }
          _isLoadingPlans = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load subscription plans: $e';
          _isLoadingPlans = false;
        });
      }
    }
  }

  Future<void> _handleOnboard() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPlanId == null) {
      ToastService.showError('Please select a subscription plan');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final payload = {
        'organization': {
          'name': _nameController.text.trim(),
          'slug': _slugController.text.trim().toLowerCase(),
          'legalName': _legalNameController.text.trim().isNotEmpty
              ? _legalNameController.text.trim()
              : null,
          'email': _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim().toLowerCase()
              : null,
          'phone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
          'taxId': _taxIdController.text.trim().isNotEmpty ? _taxIdController.text.trim() : null,
          'city': _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : null,
          'state': _stateController.text.trim().isNotEmpty ? _stateController.text.trim() : null,
          'address':
              _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
          'pincode':
              _pincodeController.text.trim().isNotEmpty ? _pincodeController.text.trim() : null,
        },
        'subscription': {
          'planId': _selectedPlanId,
          'billingCycle': _selectedBillingCycle,
          'status': _selectedSubscriptionStatus,
          'trialDays': _trialDays,
        },
        'adminUser': {
          'firstName': _adminFirstNameController.text.trim(),
          'lastName': _adminLastNameController.text.trim().isNotEmpty
              ? _adminLastNameController.text.trim()
              : null,
          'email': _adminEmailController.text.trim().toLowerCase(),
          'password': _adminPasswordController.text,
          'phone':
              _adminPhoneController.text.trim().isNotEmpty ? _adminPhoneController.text.trim() : null,
        },
      };

      final mutation = _queries.getOnboardOrgMutation(
        onOnboarded: (_) {
          if (mounted) {
            context.go(RouteNames.platformOrganizationsPath);
          }
        },
      );

      final result = await mutation.mutate((
        payload: payload,
        logoBytes: _logoBytes,
        logoFileName: _logoFileName,
      ));
      if (result.error != null) {
        if (mounted) {
          setState(() {
            _error = result.error.toString();
            _isSubmitting = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception:', '').trim();
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Onboard New Organization',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provision a tenant studio, assign subscription tier, and create owner credentials.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Section 1: Organization Details
                  _buildCard(
                    title: '1. Organization / Studio Details',
                    icon: Icons.business_rounded,
                    isDark: isDark,
                    children: [
                      LogoPickerField(
                        selectedBytes: _logoBytes,
                        selectedFileName: _logoFileName,
                        onImageSelected: (bytes, name) {
                          setState(() {
                            _logoBytes = bytes;
                            _logoFileName = name;
                          });
                        },
                        onImageRemoved: () {
                          setState(() {
                            _logoBytes = null;
                            _logoFileName = null;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: AppTextField(
                              controller: _nameController,
                              label: 'Studio / Business Name',
                              hintText: 'e.g. Studio Aranya Interiors',
                              prefixIcon: Icons.apartment_rounded,
                              onChanged: _onNameChanged,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Studio name required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: AppTextField(
                              controller: _slugController,
                              label: 'Slug / Subdomain',
                              hintText: 'e.g. studio-aranya',
                              prefixIcon: Icons.link_rounded,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Slug required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _legalNameController,
                              label: 'Legal Registered Name',
                              hintText: 'e.g. Aranya Design Studio Pvt Ltd',
                              prefixIcon: Icons.gavel_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _taxIdController,
                              label: 'GSTIN / Tax ID',
                              hintText: 'e.g. 27AABCS1429B1ZB',
                              prefixIcon: Icons.receipt_long_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _emailController,
                              label: 'Studio Official Email',
                              hintText: 'contact@studioaranya.com',
                              prefixIcon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _phoneController,
                              label: 'Studio Contact Phone',
                              hintText: '+91 98765 43210',
                              prefixIcon: Icons.phone_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _cityController,
                              label: 'City',
                              hintText: 'Mumbai',
                              prefixIcon: Icons.location_city_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _stateController,
                              label: 'State',
                              hintText: 'Maharashtra',
                              prefixIcon: Icons.map_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: AppTextField(
                              controller: _pincodeController,
                              label: 'Pincode',
                              hintText: '400001',
                              prefixIcon: Icons.pin_drop_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Section 2: Subscription Plan Selection
                  _buildCard(
                    title: '2. Subscription Plan & Billing',
                    icon: Icons.card_membership_rounded,
                    isDark: isDark,
                    children: [
                      if (_isLoadingPlans)
                        const Center(child: CircularProgressIndicator())
                      else if (_availablePlans.isEmpty)
                        Text(
                          'No subscription plans found. Please create a plan in Subscription Plans tab first.',
                          style: GoogleFonts.plusJakartaSans(color: Colors.red),
                        )
                      else ...[
                        DropdownButtonFormField<String>(
                          initialValue: _selectedPlanId,
                          decoration: InputDecoration(
                            labelText: 'Subscription Plan Tier',
                            prefixIcon: const Icon(Icons.card_membership_rounded, size: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: _availablePlans.map((plan) {
                            return DropdownMenuItem(
                              value: plan.id,
                              child: Text(
                                '${plan.name} — ₹${plan.priceMonthly.toStringAsFixed(0)}/mo (${plan.planFeature?.maxUser ?? 5} users, ${plan.planFeature?.maxEmployee ?? 10} employees)',
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedPlanId = val);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedBillingCycle,
                                decoration: InputDecoration(
                                  labelText: 'Billing Cycle',
                                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
                                  DropdownMenuItem(
                                      value: 'QUARTERLY', child: Text('Quarterly (3 months)')),
                                  DropdownMenuItem(
                                      value: 'YEARLY', child: Text('Yearly (12 months)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedBillingCycle = val);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedSubscriptionStatus,
                                decoration: InputDecoration(
                                  labelText: 'Initial Status',
                                  prefixIcon: const Icon(Icons.verified_rounded, size: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'TRIALING', child: Text('14-Day Free Trial (TRIALING)')),
                                  DropdownMenuItem(value: 'ACTIVE', child: Text('Active (Paid)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedSubscriptionStatus = val);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Section 3: Initial Studio Admin User
                  _buildCard(
                    title: '3. Initial Studio Admin / Owner Credentials',
                    icon: Icons.person_add_alt_1_rounded,
                    isDark: isDark,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _adminFirstNameController,
                              label: 'Admin First Name',
                              hintText: 'Amit',
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _adminLastNameController,
                              label: 'Admin Last Name',
                              hintText: 'Kumar',
                              prefixIcon: Icons.person_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _adminEmailController,
                              label: 'Admin Email (Login ID)',
                              hintText: 'amit@studioaranya.com',
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _adminPasswordController,
                              label: 'Temporary Password',
                              hintText: 'StudioAdmin@2026',
                              prefixIcon: Icons.lock_outline_rounded,
                              validator: (val) =>
                                  val == null || val.length < 8 ? 'Min 8 chars' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => context.go(RouteNames.platformOrganizationsPath),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 220,
                        child: AppButton(
                          text: 'Onboard Organization',
                          size: AppButtonSize.medium,
                          isLoading: _isSubmitting,
                          onPressed: _handleOnboard,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF8B5CF6), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}
