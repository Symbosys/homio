import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/sales_domain_models.dart';

/// Customer 360° Inspection Modal
class CustomerDetail360Modal extends StatefulWidget {
  final CustomerItem customer;

  const CustomerDetail360Modal({super.key, required this.customer});

  static Future<void> show(BuildContext context, {required CustomerItem customer}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerDetail360Modal(customer: customer),
    );
  }

  @override
  State<CustomerDetail360Modal> createState() => _CustomerDetail360ModalState();
}

class _CustomerDetail360ModalState extends State<CustomerDetail360Modal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = widget.customer;
    final height = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 1. Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: AppRadius.md,
                  ),
                  child: const Icon(Icons.assignment_ind_rounded, size: 26, color: Color(0xFF10B981)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(c.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              c.status,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'ID: ${c.id}  •  ${c.phone}  •  ${c.city}',
                        style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 16),
                ),
              ],
            ),
          ),

          // 2. Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Profile 360'),
                Tab(text: 'Linked Projects'),
                Tab(text: 'Payments & Ledger'),
                Tab(text: 'Communication'),
              ],
            ),
          ),

          // 3. Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(c, isDark),
                _buildProjectsTab(c, isDark),
                _buildPaymentsTab(c, isDark),
                _buildCommunicationTab(c, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(CustomerItem c, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _infoCard(
          title: 'Account & Relationship Details',
          isDark: isDark,
          children: [
            _row('Customer ID', c.id),
            _row('Lead Origin ID', c.leadOriginId),
            _row('Full Name', c.name),
            _row('Phone Number', c.phone),
            _row('Email Address', c.email),
            _row('Site Address', c.address),
            _row('City / Pincode', '${c.city} — ${c.pincode}'),
            if (c.companyName != null) _row('Company / Firm', c.companyName!),
            _row('Sales Owner', c.salesOwner),
            _row('Project Manager', c.relationshipManager),
            _row('Satisfaction Rating', '★ ${c.satisfactionRating} / 5.0 (Excellent)'),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectsTab(CustomerItem c, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active Project: ${c.address}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('₹${c.totalContractValueLakhs}L', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 6),
              Text('Status: ${c.status}', style: GoogleFonts.inter(fontSize: 11.5)),
              const SizedBox(height: 4),
              Text('Handover Target: Diwali 2026  •  PM: ${c.relationshipManager}', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsTab(CustomerItem c, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _infoCard(
          title: 'Financial Ledger & Milestone Collections',
          isDark: isDark,
          children: [
            _row('Total Contract Value', '₹${c.totalContractValueLakhs.toStringAsFixed(1)} Lakhs'),
            _row('Received Milestone Dues', '₹${(c.totalContractValueLakhs - c.outstandingDuesLakhs).toStringAsFixed(1)} Lakhs'),
            _row('Outstanding Balance', '₹${c.outstandingDuesLakhs.toStringAsFixed(1)} Lakhs'),
            _row('Next Payment Trigger', 'Upon 3D Design Approval Signoff (₹5.0 Lakhs)'),
          ],
        ),
      ],
    );
  }

  Widget _buildCommunicationTab(CustomerItem c, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Direct Customer Communication', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening WhatsApp for ${c.name}...')),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: Text('WhatsApp', style: GoogleFonts.inter(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dialing ${c.phone}...')),
                );
              },
              icon: const Icon(Icons.phone_outlined, size: 16),
              label: Text('Call', style: GoogleFonts.inter(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoCard({required String title, required List<Widget> children, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B))),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
