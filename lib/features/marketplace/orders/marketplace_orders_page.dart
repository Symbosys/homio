import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_domain_models.dart';
import '../domain/marketplace_enums.dart';
import '../widgets/marketplace_attention_panel.dart';
import '../widgets/marketplace_data_table.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_metric_card.dart';
import '../widgets/marketplace_status_badge.dart';
import '../widgets/order_detail_workspace_modal.dart';
import '../widgets/order_vendor_assign_dialog.dart';

class MarketplaceOrdersPage extends StatefulWidget {
  const MarketplaceOrdersPage({super.key});

  @override
  State<MarketplaceOrdersPage> createState() => _MarketplaceOrdersPageState();
}

class _MarketplaceOrdersPageState extends State<MarketplaceOrdersPage> {
  final _repo = MarketplaceRepository();
  final _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedType = 'all';
  String _selectedStatus = 'all';
  String _selectedPayment = 'all';
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<MarketplaceOrderEntity> get _filteredOrders {
    return _repo.orders.where((o) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchOrder = o.orderNumber.toLowerCase().contains(q);
        final matchCustomer = o.customerName.toLowerCase().contains(q);
        final matchEmail = o.customerEmail.toLowerCase().contains(q);
        final matchMobile = o.customerMobile.toLowerCase().contains(q);
        if (!matchOrder && !matchCustomer && !matchEmail && !matchMobile) return false;
      }
      if (_selectedType != 'all' && o.orderType.name.toLowerCase() != _selectedType.toLowerCase()) {
        return false;
      }
      if (_selectedStatus != 'all' && o.orderStatus.name.toLowerCase() != _selectedStatus.toLowerCase()) {
        return false;
      }
      if (_selectedPayment != 'all' && o.paymentStatus.name.toLowerCase() != _selectedPayment.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openOrderWorkspace(MarketplaceOrderEntity order) {
    OrderDetailWorkspaceModal.show(context, order);
  }

  void _openVendorAssignment(MarketplaceOrderEntity order) {
    OrderVendorAssignDialog.show(context, order);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final allOrders = _repo.orders;
    final totalGmv = allOrders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
    final pendingOrders = allOrders.where((o) => o.orderStatus == OrderStatus.confirmed || o.orderStatus == OrderStatus.processing).length;
    final unassignedCount = allOrders.where((o) => o.assignedVendorId == null && o.orderType == OrderType.materialProcurement).length;

    final filtered = _filteredOrders;
    final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paginatedItems = filtered.skip(startIndex).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            MarketplaceHeader(
              title: 'Centralized Marketplace Orders & Fulfillment',
              subtitle: 'Omnichannel order management across digital assets, decor items, bulk site materials & ₹500 property unlock paywalls',
              icon: Icons.receipt_long_outlined,
              actions: [
                OutlinedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: Icon(Icons.refresh_rounded, size: 16, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  label: Text('Refresh', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    side: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('GST Sales & Tax Invoices batch exported for accounting reconciliation.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 18, color: Colors.white),
                  label: Text('Export GST Invoices', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Operational Attention Panel
            MarketplaceAttentionPanel(
              alerts: [
                if (unassignedCount > 0)
                  MarketplaceAlertItem(
                    title: '$unassignedCount Material Orders Pending Vendor Assignment',
                    description: 'Bulk site procurement orders must be routed to primary suppliers within 4 hours to guarantee site delivery SLAs.',
                    count: unassignedCount,
                    icon: Icons.assignment_late_outlined,
                    severityColor: AppColors.warning,
                    actionLabel: 'Assign Vendors',
                    onAction: () {
                      setState(() {
                        _selectedType = 'materialprocurement';
                        _currentPage = 1;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // KPI Grid
            LayoutBuilder(
              builder: (ctx, constraints) {
                final crossAxisCount = isDesktop ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: isDesktop ? 2.3 : 2.6,
                  children: [
                    MarketplaceMetricCard(
                      title: 'Total Placed Orders',
                      value: '${allOrders.length}',
                      subtitle: 'Across all 4 business models',
                      icon: Icons.receipt_long_outlined,
                      accentColor: AppColors.primary,
                    ),
                    MarketplaceMetricCard(
                      title: 'Gross Marketplace Value',
                      value: '₹${totalGmv.toStringAsFixed(0)}',
                      subtitle: 'Combined transactional volume',
                      icon: Icons.currency_rupee_rounded,
                      accentColor: AppColors.success,
                    ),
                    MarketplaceMetricCard(
                      title: 'In Fulfillment / Transit',
                      value: '$pendingOrders',
                      subtitle: 'Active processing or dispatched',
                      icon: Icons.local_shipping_outlined,
                      accentColor: AppColors.info,
                    ),
                    MarketplaceMetricCard(
                      title: 'Unassigned Procurement',
                      value: '$unassignedCount',
                      subtitle: 'Needs supplier routing',
                      icon: Icons.pending_actions_outlined,
                      accentColor: AppColors.warning,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Filter Bar
            MarketplaceFilterBar(
              searchController: _searchCtrl,
              searchHint: 'Search orders by #, customer name, email, phone...',
              onSearchChanged: (val) => setState(() {
                _searchQuery = val;
                _currentPage = 1;
              }),
              totalCount: filtered.length,
              entityLabel: 'Orders',
              onClear: () => setState(() {
                _searchCtrl.clear();
                _searchQuery = '';
                _selectedType = 'all';
                _selectedStatus = 'all';
                _selectedPayment = 'all';
                _currentPage = 1;
              }),
              filterDropdowns: [
                DropdownButton<String>(
                  value: _selectedType,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Types')),
                    DropdownMenuItem(value: 'digital', child: Text('Digital Asset')),
                    DropdownMenuItem(value: 'decoraffiliate', child: Text('Decor Direct/Affiliate')),
                    DropdownMenuItem(value: 'materialprocurement', child: Text('Wholesale Materials')),
                    DropdownMenuItem(value: 'propertyunlock', child: Text('Property Unlock (₹500)')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedType = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'placed', child: Text('Placed')),
                    DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                    DropdownMenuItem(value: 'processing', child: Text('Processing')),
                    DropdownMenuItem(value: 'dispatched', child: Text('Dispatched')),
                    DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                    DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedStatus = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedPayment,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Payments')),
                    DropdownMenuItem(value: 'successful', child: Text('Paid & Settled')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'refunded', child: Text('Refunded')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedPayment = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Orders Data Table
            MarketplaceDataTable(
              columns: const [
                DataColumn(label: Text('ORDER # & DATE')),
                DataColumn(label: Text('CUSTOMER 360')),
                DataColumn(label: Text('ORDER MODEL')),
                DataColumn(label: Text('ITEMS & AMOUNT')),
                DataColumn(label: Text('PAYMENT')),
                DataColumn(label: Text('FULFILLMENT')),
                DataColumn(label: Text('SUPPLIER / COURIER')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: paginatedItems.map((item) {
                return DataRow(
                  cells: [
                    // Order # & Date
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.orderNumber, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(
                            '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year} ${item.createdAt.hour}:${item.createdAt.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),

                    // Customer 360
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.customerName, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(item.customerMobile, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),

                    // Order Model
                    DataCell(
                      MarketplaceStatusBadge.orderType(item.orderType),
                    ),

                    // Items & Amount
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${item.totalAmount.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('${item.items.length} item(s)', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),

                    // Payment
                    DataCell(
                      MarketplaceStatusBadge.payment(item.paymentStatus),
                    ),

                    // Fulfillment
                    DataCell(
                      MarketplaceStatusBadge.order(item.orderStatus),
                    ),

                    // Supplier / Courier
                    DataCell(
                      item.assignedVendorName != null
                          ? Text(item.assignedVendorName!, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600))
                          : (item.orderType == OrderType.digital
                              ? Text('Digital Instant', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600))
                              : (item.orderType == OrderType.propertyUnlock
                                  ? Text('Instant Paywall', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600))
                                  : Text('Unassigned', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w700)))),
                    ),

                    // Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.fullscreen_rounded, size: 20, color: AppColors.primary),
                            tooltip: 'Open Order Fulfillment Workspace',
                            onPressed: () => _openOrderWorkspace(item),
                          ),
                          if (item.orderType == OrderType.materialProcurement || item.orderType == OrderType.decorAffiliate)
                            IconButton(
                              icon: const Icon(Icons.assignment_ind_outlined, size: 18, color: AppColors.info),
                              tooltip: 'Assign Supplier / Dispatcher',
                              onPressed: () => _openVendorAssignment(item),
                            ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            onSelected: (val) {
                              if (val == 'view_dossier') {
                                _openOrderWorkspace(item);
                              } else if (val == 'mark_delivered') {
                                _repo.updateOrderStatus(item.id, OrderStatus.delivered, 'Hub Center', 'Marked delivered via admin');
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(value: 'view_dossier', child: Text('Open Full Workspace')),
                              if (item.orderStatus != OrderStatus.delivered && item.orderStatus != OrderStatus.cancelled)
                                const PopupMenuItem(value: 'mark_delivered', child: Text('Mark Delivered')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),

            // Pagination strip
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${filtered.isEmpty ? 0 : startIndex + 1} to ${(startIndex + _pageSize).clamp(0, filtered.length)} of ${filtered.length} orders',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                    ),
                    Text('$_currentPage / $totalPages', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
