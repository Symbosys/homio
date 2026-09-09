// Homio CRM — Enterprise Customer Context 360 Panel

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import 'comm_status_badge.dart';

class CustomerContextPanel extends StatefulWidget {
  final CustomerContext contextData;
  final VoidCallback? onClose;
  final VoidCallback? onScheduleMeeting;
  final VoidCallback? onCreateQuotation;
  final VoidCallback? onViewCrmProfile;

  const CustomerContextPanel({
    super.key,
    required this.contextData,
    this.onClose,
    this.onScheduleMeeting,
    this.onCreateQuotation,
    this.onViewCrmProfile,
  });

  @override
  State<CustomerContextPanel> createState() => _CustomerContextPanelState();
}

class _CustomerContextPanelState extends State<CustomerContextPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(2)} L';
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final c = widget.contextData;

    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          left: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header / Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Customer CRM 360°',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    if (widget.onClose != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: widget.onClose,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    c.customerName.substring(0, c.customerName.length >= 2 ? 2 : 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  c.customerName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                CommStatusBadge.fromCrmStage(c.crmStage),
                const SizedBox(height: 8),
                Text(
                  '${c.customerPhone} • ${c.city}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Tabs: Profile / Financials / Site & Docs
          TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Profile'),
              Tab(text: 'Financials'),
              Tab(text: 'Site & Files'),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Profile Tab
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildInfoRow('Lead ID', c.leadId ?? 'Direct Account', isDark),
                    _buildInfoRow('Lead Source', c.leadSource, isDark),
                    _buildInfoRow('Property Scope', c.propertyType, isDark),
                    _buildInfoRow('Budget Range', c.budgetRange, isDark),
                    _buildInfoRow('Assigned Staff', c.assignedEmployeeName, isDark),
                    if (c.assignedDesignerName != null)
                      _buildInfoRow('Lead Architect', c.assignedDesignerName!, isDark),
                    if (c.projectName != null)
                      _buildInfoRow('Project Name', c.projectName!, isDark),
                    const SizedBox(height: 12),
                    const Text(
                      'CRM Tags',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: c.tags.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 10)),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // 2. Financials Tab
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildFinancialCard(
                      'Contract Value',
                      _formatCurrency(c.contractValue),
                      Icons.assignment_outlined,
                      AppColors.primary,
                      isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildFinancialCard(
                      'Total Invoiced',
                      _formatCurrency(c.totalInvoiced),
                      Icons.receipt_long_outlined,
                      const Color(0xFF6366F1),
                      isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildFinancialCard(
                      'Collected to Date',
                      _formatCurrency(c.totalPaid),
                      Icons.check_circle_outline,
                      const Color(0xFF10B981),
                      isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildFinancialCard(
                      'Outstanding Balance',
                      _formatCurrency(c.balanceDue),
                      Icons.pending_actions_outlined,
                      c.balanceDue > 0 ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                      isDark,
                    ),
                  ],
                ),

                // 3. Site & Files Tab
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (c.nextMeetingDate != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.event, size: 14, color: Color(0xFF8B5CF6)),
                                SizedBox(width: 6),
                                Text(
                                  'Upcoming Meeting',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8B5CF6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.nextMeetingType ?? 'Design Consultation',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              c.nextMeetingDate!.toString().substring(0, 16),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    const Text(
                      'Milestone Checklist',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...c.recentMilestones.map((m) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_box, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                m,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    const Text(
                      'Shared Documents',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    _buildFileRow('3D_Walkthrough_Render_Set.pdf', '14.2 MB', isDark),
                    _buildFileRow('Detailed_BOQ_Contract_V2.pdf', '3.8 MB', isDark),
                    _buildFileRow('Approved_Floor_Plan_CAD.dwg', '8.1 MB', isDark),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.onScheduleMeeting != null)
                  OutlinedButton.icon(
                    onPressed: widget.onScheduleMeeting,
                    icon: const Icon(Icons.calendar_month, size: 14),
                    label: const Text('Schedule Consultation', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                if (widget.onViewCrmProfile != null) ...[
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: widget.onViewCrmProfile,
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text('Open Full CRM Lead', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileRow(String name, String size, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Color(0xFFEF4444), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1),
                Text(size, style: TextStyle(fontSize: 9, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ],
            ),
          ),
          const Icon(Icons.download, size: 14),
        ],
      ),
    );
  }
}
