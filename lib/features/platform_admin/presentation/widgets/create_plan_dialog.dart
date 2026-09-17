import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/platform_plan_model.dart';

class CreatePlanDialog extends StatefulWidget {
  final PlatformPlanModel? initialPlan;
  final Future<void> Function(Map<String, dynamic> planData) onSubmit;

  const CreatePlanDialog({
    super.key,
    this.initialPlan,
    required this.onSubmit,
  });

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _monthlyPriceController;
  late final TextEditingController _yearlyPriceController;
  late final TextEditingController _currencyController;
  late final TextEditingController _maxUserController;
  late final TextEditingController _maxEmployeeController;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final plan = widget.initialPlan;
    _nameController = TextEditingController(text: plan?.name ?? '');
    _slugController = TextEditingController(text: plan?.slug ?? '');
    _descriptionController = TextEditingController(text: plan?.description ?? '');
    _monthlyPriceController =
        TextEditingController(text: plan != null ? plan.priceMonthly.toStringAsFixed(0) : '500');
    _yearlyPriceController =
        TextEditingController(text: plan != null ? plan.priceYearly.toStringAsFixed(0) : '5000');
    _currencyController = TextEditingController(text: plan?.currency ?? 'INR');
    _maxUserController = TextEditingController(
        text: (plan?.planFeature?.maxUser ?? 5).toString());
    _maxEmployeeController = TextEditingController(
        text: (plan?.planFeature?.maxEmployee ?? 10).toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _monthlyPriceController.dispose();
    _yearlyPriceController.dispose();
    _currencyController.dispose();
    _maxUserController.dispose();
    _maxEmployeeController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    if (widget.initialPlan == null) {
      final slug = value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      _slugController.text = slug;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final payload = {
        'name': _nameController.text.trim(),
        'slug': _slugController.text.trim().toLowerCase(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'priceMonthly': double.tryParse(_monthlyPriceController.text.trim()) ?? 0.0,
        'priceYearly': double.tryParse(_yearlyPriceController.text.trim()) ?? 0.0,
        'currency': _currencyController.text.trim().toUpperCase(),
        'planFeature': {
          'maxUser': int.tryParse(_maxUserController.text.trim()) ?? 5,
          'maxEmployee': int.tryParse(_maxEmployeeController.text.trim()) ?? 10,
        },
      };

      await widget.onSubmit(payload);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.initialPlan != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.card_membership_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Edit Subscription Plan' : 'Create Subscription Plan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Define pricing and capacity limits for organizations',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Plan Name & Slug
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: AppTextField(
                          controller: _nameController,
                          label: 'Plan Name',
                          hintText: 'e.g. Professional Tier',
                          prefixIcon: Icons.badge_rounded,
                          onChanged: _onNameChanged,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Name required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: AppTextField(
                          controller: _slugController,
                          label: 'Slug',
                          hintText: 'e.g. pro',
                          prefixIcon: Icons.link_rounded,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Slug required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Description
                  AppTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hintText: 'e.g. Tailored for growing interior design firms',
                    prefixIcon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 14),

                  // Pricing: Monthly & Yearly
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _monthlyPriceController,
                          label: 'Monthly Price (INR)',
                          hintText: '500',
                          prefixIcon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _yearlyPriceController,
                          label: 'Yearly Price (INR)',
                          hintText: '5000',
                          prefixIcon: Icons.calendar_month_rounded,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Feature Limits: maxUser & maxEmployee
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan Capacity Limits (Plan Features)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _maxUserController,
                                label: 'Max Users / Seats',
                                hintText: '5',
                                prefixIcon: Icons.group_rounded,
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val == null || val.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                controller: _maxEmployeeController,
                                label: 'Max Employees',
                                hintText: '10',
                                prefixIcon: Icons.badge_outlined,
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val == null || val.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 140,
                        child: AppButton(
                          text: isEditing ? 'Save Changes' : 'Create Plan',
                          size: AppButtonSize.medium,
                          isLoading: _isLoading,
                          onPressed: _handleSubmit,
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
}
