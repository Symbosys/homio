import 'package:flutter/material.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../widgets/crm_header.dart';
import '../widgets/customer_detail_360_modal.dart';

/// Screen 3: Customers Directory
/// Displays booked/converted interior design clients, active project tracking,
/// contract values, payment collections vs outstanding, and 360° modal integration.
class SalesCustomersPage extends StatefulWidget {
  const SalesCustomersPage({super.key});

  @override
  State<SalesCustomersPage> createState() => _SalesCustomersPageState();
}

class _SalesCustomersPageState extends State<SalesCustomersPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _selectedStatus = 'All Statuses';
  String _selectedScope = 'All Organization';
  List<CustomerItem> _customers = [];

  final List<String> _statusFilters = [
    'All Statuses',
    'Active Execution',
    'Handover Completed',
    'Warranty',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final results = await SalesRepository.instance.getCustomers(
      query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      status: _selectedStatus == 'All Statuses' ? null : _selectedStatus,
    );

    if (!mounted) return;
    setState(() {
      _customers = results;
      _isLoading = false;
    });

    if (preserveScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(savedOffset.clamp(0.0, max));
        }
      });
    }
  }

  void _openCustomerDetail(CustomerItem customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CustomerDetail360Modal(customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenType = AdaptiveLayout.getScreenType(context);
    final isDesktop = screenType == ScreenType.desktop || screenType == ScreenType.laptop;

    // Financial KPI aggregations
    final totalBookedValue = _customers.fold(0.0, (sum, c) => sum + c.totalContractValue);
    final totalCollected = _customers.fold(0.0, (sum, c) => sum + c.totalPaid);
    final totalOutstanding = _customers.fold(0.0, (sum, c) => sum + c.totalOutstanding);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // CRM Top Header
          CrmHeader(
            title: 'Customer Directory & Accounts',
            subtitle: 'Booked interior design clients, active site handovers, payment ledgers, and warranties.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadCustomers(preserveScroll: true);
            },
            onRefresh: () => _loadCustomers(preserveScroll: true),
            actionButtons: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting customer financial ledger (CSV)...')),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Export Ledger'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : AppColors.darkTextPrimary,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ],
          ),

          // Main View Body
          Expanded(
            child: _isLoading && _customers.isEmpty
                ? const DashboardSkeleton(itemCount: 6, height: 70)
                : RefreshIndicator(
                    onRefresh: () => _loadCustomers(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_customers_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // KPI Metric Strip
                          _buildFinancialKpiStrip(
                            totalBookedValue,
                            totalCollected,
                            totalOutstanding,
                            _customers.length,
                            isDark,
                            isDesktop,
                          ),
                          const SizedBox(height: 16),

                          // Search & Status Filter
                          _buildFilterBar(isDark),
                          const SizedBox(height: 16),

                          // Customer List or Table
                          if (isDesktop)
                            _buildDataTableDesktop(isDark)
                          else
                            _buildCardListMobile(isDark),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialKpiStrip(
    double totalBooked,
    double collected,
    double outstanding,
    int clientCount,
    bool isDark,
    bool isDesktop,
  ) {
    final cards = [
      _buildMiniKpiCard(
        title: 'Active Customers',
        value: '$clientCount Clients',
        subtitle: 'In execution / handover',
        icon: Icons.people_alt_rounded,
        color: AppColors.primary,
        isDark: isDark,
      ),
      _buildMiniKpiCard(
        title: 'Total Contract Value',
        value: '₹${totalBooked.toStringAsFixed(1)} L',
        subtitle: 'Cumulated project bookings',
        icon: Icons.assignment_turned_in_rounded,
        color: Colors.blue,
        isDark: isDark,
      ),
      _buildMiniKpiCard(
        title: 'Collected Amount',
        value: '₹${collected.toStringAsFixed(1)} L',
        subtitle: '${((collected / (totalBooked > 0 ? totalBooked : 1)) * 100).toStringAsFixed(1)}% realization',
        icon: Icons.check_circle_outline_rounded,
        color: Colors.green,
        isDark: isDark,
      ),
      _buildMiniKpiCard(
        title: 'Outstanding Dues',
        value: '₹${outstanding.toStringAsFixed(1)} L',
        subtitle: 'Milestone invoicing pending',
        icon: Icons.pending_actions_rounded,
        color: Colors.amber.shade800,
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }
  }

  Widget _buildMiniKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Search Input
          SizedBox(
            width: 260,
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _loadCustomers(preserveScroll: true),
              decoration: InputDecoration(
                hintText: 'Search customer, project, phone...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          _loadCustomers(preserveScroll: true);
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
            ),
          ),

          // Status Filter
          DropdownButtonHideUnderline(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedStatus,
                isDense: true,
                items: _statusFilters.map(
                  (s) => DropdownMenuItem<String>(
                    value: s,
                    child: Text(s, style: const TextStyle(fontSize: 12)),
                  ),
                ).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedStatus = val);
                    _loadCustomers(preserveScroll: true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTableDesktop(bool isDark) {
    if (_customers.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 1000),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
              ),
              dataRowMinHeight: 64,
              dataRowMaxHeight: 72,
              columnSpacing: 20,
              horizontalMargin: 16,
              columns: const [
                DataColumn(label: Text('Customer & Contact', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Project Name & Location', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Contract Value', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Paid vs Due', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Target Handover', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Project Manager', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _customers.map((c) {
                final paidPercent = c.totalContractValue > 0 ? (c.totalPaid / c.totalContractValue) : 0.0;

                return DataRow(
                  cells: [
                    DataCell(
                      InkWell(
                        onTap: () => _openCustomerDetail(c),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${c.id} • ${c.phone}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(c.projectName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          Text(
                            c.address,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(c.status).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _getStatusColor(c.status).withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          c.status,
                          style: TextStyle(
                            color: _getStatusColor(c.status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '₹${c.totalContractValue.toStringAsFixed(1)} L',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '₹${c.totalPaid.toStringAsFixed(1)} L / ₹${c.totalOutstanding.toStringAsFixed(1)} L',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: paidPercent.clamp(0.0, 1.0),
                                minHeight: 4,
                                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation(Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(c.handoverTargetDate, style: const TextStyle(fontSize: 12)),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: Colors.blue.withValues(alpha: 0.15),
                            child: Text(
                              c.projectManager.isNotEmpty ? c.projectManager[0] : 'P',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(c.projectManager, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone_outlined, size: 16, color: Colors.blue),
                            tooltip: 'Call Customer',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Calling ${c.name} (${c.phone})...')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.green),
                            tooltip: 'WhatsApp Customer',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening WhatsApp for ${c.name}...')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            tooltip: 'Customer 360° View',
                            onPressed: () => _openCustomerDetail(c),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardListMobile(bool isDark) {
    if (_customers.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final c = _customers[idx];
        return InkWell(
          onTap: () => _openCustomerDetail(c),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            '${c.id} • ${c.phone}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getStatusColor(c.status).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        c.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(c.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${c.projectName} • ${c.address}',
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Contract: ₹${c.totalContractValue.toStringAsFixed(1)} L',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      'Due: ₹${c.totalOutstanding.toStringAsFixed(1)} L',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade800, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target: ${c.handoverTargetDate}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone_outlined, size: 18, color: Colors.blue),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling ${c.phone}...')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.green),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('WhatsApp ${c.phone}...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active execution':
        return Colors.green;
      case 'handover completed':
        return Colors.blue;
      case 'warranty':
        return Colors.purple;
      case 'on hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.person_search_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('No customer records found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(
            'Try resetting your search query or status filter.',
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}
