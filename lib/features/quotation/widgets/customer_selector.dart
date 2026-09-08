import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Searchable customer selector with inline new customer creation.
class CustomerSelector extends StatefulWidget {
  final CustomerInfo? selectedCustomer;
  final ValueChanged<CustomerInfo> onCustomerSelected;

  const CustomerSelector({
    super.key,
    this.selectedCustomer,
    required this.onCustomerSelected,
  });

  @override
  State<CustomerSelector> createState() => _CustomerSelectorState();
}

class _CustomerSelectorState extends State<CustomerSelector> {
  final List<CustomerInfo> _allCustomers = [
    const CustomerInfo(
      id: 'CUST-001',
      name: 'Dr. Arjun K. Singhania',
      phone: '+91 98201 44552',
      email: 'arjun.singhania@apexheart.org',
      address: 'Tower 3, Penthouse 2401, The Camellias',
      city: 'Gurgaon',
      company: 'Singhania Healthcare Trust',
    ),
    const CustomerInfo(
      id: 'CUST-002',
      name: 'Meera & Rohan Deshmukh',
      phone: '+91 98205 91823',
      email: 'rohan.deshmukh@tcs.com',
      address: 'Flat 1804, Tower B, Oberoi Sky City',
      city: 'Mumbai',
      company: 'Tata Consultancy Services',
    ),
    const CustomerInfo(
      id: 'CUST-003',
      name: 'Sunita & Deepak Verma',
      phone: '+91 97411 88201',
      email: 'deepak.verma@wipro.com',
      city: 'Bangalore',
      address: 'Prestige Falcon City, Flat 1204',
    ),
    const CustomerInfo(
      id: 'CUST-004',
      name: 'Nitin & Shweta Parekh',
      phone: '+91 98210 66332',
      email: 'parekh.nitin@rediffmail.com',
      city: 'Thane',
      address: 'Hiranandani Estate, Pelican Tower',
    ),
  ];

  CustomerInfo? _selected;
  bool _isCreatingNew = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  @override
  void didUpdateWidget(CustomerSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCustomer != oldWidget.selectedCustomer) {
      _initSelection();
    }
  }

  void _initSelection() {
    if (widget.selectedCustomer != null) {
      final matchIndex = _allCustomers.indexWhere((c) => c.id == widget.selectedCustomer!.id);
      if (matchIndex >= 0) {
        _selected = _allCustomers[matchIndex];
      } else {
        _allCustomers.insert(0, widget.selectedCustomer!);
        _selected = widget.selectedCustomer;
      }
    } else {
      _selected = _allCustomers.isNotEmpty ? _allCustomers.first : null;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _saveNewCustomer() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) return;
    final newCust = CustomerInfo(
      id: 'CUST-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      city: _cityCtrl.text.isNotEmpty ? _cityCtrl.text : 'Bangalore',
    );
    setState(() {
      _allCustomers.insert(0, newCust);
      _selected = newCust;
      _isCreatingNew = false;
    });
    widget.onCustomerSelected(newCust);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Customer Information',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() => _isCreatingNew = !_isCreatingNew);
                },
                icon: Icon(_isCreatingNew ? Icons.search_rounded : Icons.person_add_rounded, size: 14),
                label: Text(
                  _isCreatingNew ? 'Select Existing' : '+ New Customer',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_isCreatingNew) ...[
            // Inline creation form
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(
                      labelText: 'Mobile Phone *',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _cityCtrl,
                    decoration: InputDecoration(
                      labelText: 'City',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saveNewCustomer,
              icon: const Icon(Icons.check_rounded, size: 14),
              label: const Text('Add & Select Customer'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
            ),
          ] else ...[
            // Searchable dropdown
            DropdownButtonFormField<String>(
              initialValue: _selected?.id,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Search or select customer...',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(borderRadius: AppRadius.sm),
              ),
              items: _allCustomers.map((cust) {
                return DropdownMenuItem<String>(
                  value: cust.id,
                  child: Text(
                    '${cust.name} (${cust.phone}) • ${cust.city ?? 'City N/A'}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  final found = _allCustomers.firstWhere((c) => c.id == id);
                  setState(() => _selected = found);
                  widget.onCustomerSelected(found);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
