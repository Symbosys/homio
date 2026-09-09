import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';
import '../widgets/after_sales_header.dart';
import '../widgets/create_service_request_modal.dart';
import '../widgets/service_request_detail_drawer.dart';
import '../widgets/schedule_visit_modal.dart';
import '../widgets/service_estimate_payment_modal.dart';

class ServiceRequestsPage extends StatefulWidget {
  const ServiceRequestsPage({super.key});

  @override
  State<ServiceRequestsPage> createState() => _ServiceRequestsPageState();
}

class _ServiceRequestsPageState extends State<ServiceRequestsPage> {
  final List<ServiceRequest> _requests = List.from(AfterSalesMockData.serviceRequests);

  String _searchQuery = '';
  ServiceCategory? _selectedCategory;
  ServiceRequestStatus? _selectedStatus;
  ServicePriority? _selectedPriority;
  String _dateFilter = 'This Month';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final filtered = _requests.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = r.requestNumber.toLowerCase().contains(q) ||
            r.customerName.toLowerCase().contains(q) ||
            r.customerPhone.contains(q) ||
            r.projectName.toLowerCase().contains(q) ||
            r.subject.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedCategory != null && r.category != _selectedCategory) return false;
      if (_selectedStatus != null && r.status != _selectedStatus) return false;
      if (_selectedPriority != null && r.priority != _selectedPriority) return false;
      return true;
    }).toList();

    // KPIs
    final totalRequests = _requests.length;
    final openRequests = _requests.where((r) => r.status != ServiceRequestStatus.resolved && r.status != ServiceRequestStatus.closed).length;
    final scheduledCount = _requests.where((r) => r.status == ServiceRequestStatus.scheduled).length;
    final resolvedCount = _requests.where((r) => r.status == ServiceRequestStatus.resolved || r.status == ServiceRequestStatus.closed).length;
    final overdueCount = _requests.where((r) => r.isOverdue).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AfterSalesHeader(
              title: 'Customer Service Requests Workspace',
              subtitle: 'Central command for post-handover customer tickets, trade classifications, SLA tracking, and technical field dispatch.',
              activeTab: 'Service Requests',
              selectedDateFilter: _dateFilter,
              onDateFilterChanged: (val) => setState(() => _dateFilter = val),
              trailing: ElevatedButton.icon(
                onPressed: () => _openCreateModal(context),
                icon: const Icon(Icons.add_task_rounded, size: 16),
                label: const Text('Raise Service Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Operational Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpi('Total Requests', '$totalRequests', 'All recorded tickets', Icons.receipt_long_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Active / Open', '$openRequests', 'Requiring resolution', Icons.pending_actions_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Visits Scheduled', '$scheduledCount', 'Technicians allocated', Icons.calendar_today_rounded, const Color(0xFF0284C7), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('SLA Overdue', '$overdueCount', 'Action immediately', Icons.warning_amber_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Resolved & Closed', '$resolvedCount', 'Customer signed off', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpi('Total Requests', '$totalRequests', 'All recorded tickets', Icons.receipt_long_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Active / Open', '$openRequests', 'Requiring resolution', Icons.pending_actions_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Visits Scheduled', '$scheduledCount', 'Technicians allocated', Icons.calendar_today_rounded, const Color(0xFF0284C7), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('SLA Overdue', '$overdueCount', 'Action immediately', Icons.warning_amber_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Resolved & Closed', '$resolvedCount', 'Customer signed off', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filters Panel
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search requests by ID, customer name, phone, project, or subject...',
                                  prefixIcon: const Icon(Icons.search, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<ServiceRequestStatus?>(
                                initialValue: _selectedStatus,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                                  ...ServiceRequestStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedStatus = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<ServicePriority?>(
                                initialValue: _selectedPriority,
                                decoration: InputDecoration(
                                  labelText: 'Priority',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Priorities')),
                                  ...ServicePriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedPriority = val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Category Chips Bar
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChip(
                                label: const Text('All Categories'),
                                selected: _selectedCategory == null,
                                onSelected: (_) => setState(() => _selectedCategory = null),
                                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                                checkmarkColor: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              ...ServiceCategory.values.map((cat) {
                                final isSelected = _selectedCategory == cat;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    avatar: Icon(cat.icon, size: 14, color: isSelected ? Colors.white : cat.color),
                                    label: Text(cat.label),
                                    selected: isSelected,
                                    onSelected: (_) => setState(() => _selectedCategory = isSelected ? null : cat),
                                    selectedColor: cat.color.withValues(alpha: 0.8),
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : textPrimaryColor,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Results Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Requests Registry (${filtered.length})',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const Text(
                        'Persistent Customer ↔ Project Lifecycle Active',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Main Requests Table
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 20,
                        columnSpacing: 22,
                        headingRowColor: WidgetStatePropertyAll(surfaceColor),
                        columns: const [
                          DataColumn(label: Text('Request & Project', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Category & Subject', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Priority & SLA', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Assigned To', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                        ],
                        rows: filtered.map((r) {
                          return DataRow(
                            cells: [
                              // Request & Project
                              DataCell(
                                InkWell(
                                  onTap: () => _openDetailDrawer(context, r),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(r.requestNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
                                      Text(r.projectName, style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                      Text('${r.projectId} • Handover: ${r.handoverDate.day}/${r.handoverDate.month}/${r.handoverDate.year}', style: TextStyle(fontSize: 10, color: textMutedColor)),
                                    ],
                                  ),
                                ),
                              ),

                              // Customer
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(r.customerName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimaryColor)),
                                    Text(r.customerPhone, style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                    Text('Channel: ${r.preferredChannel}', style: const TextStyle(fontSize: 10, color: Color(0xFF10B981))),
                                  ],
                                ),
                              ),

                              // Category & Subject
                              DataCell(
                                SizedBox(
                                  width: 240,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(r.category.icon, size: 14, color: r.category.color),
                                          const SizedBox(width: 6),
                                          Text(r.category.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: r.category.color)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(r.subject, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text('${r.areaRoom} • ${r.specificLocation}', style: TextStyle(fontSize: 10, color: textSecondaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),

                              // Priority & SLA
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: r.priority.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(r.priority.name.toUpperCase(), style: TextStyle(color: r.priority.color, fontSize: 10, fontWeight: FontWeight.w800)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      r.isOverdue ? 'OVERDUE' : 'Due: ${r.dueDate.day}/${r.dueDate.month} ${r.dueDate.hour}:00',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: r.isOverdue ? Colors.red : textSecondaryColor),
                                    ),
                                  ],
                                ),
                              ),

                              // Status
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: r.status.color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(r.status.label, style: TextStyle(color: r.status.color, fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                              ),

                              // Assigned To
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(r.assignedToName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                                    Text(r.assignedToRole, style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                  ],
                                ),
                              ),

                              // Actions
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'View Command Center Dossier',
                                      icon: const Icon(Icons.visibility_outlined, size: 18),
                                      onPressed: () => _openDetailDrawer(context, r),
                                    ),
                                    IconButton(
                                      tooltip: 'Schedule Visit',
                                      icon: const Icon(Icons.calendar_month_outlined, size: 18, color: Color(0xFF0284C7)),
                                      onPressed: () => _openScheduleVisit(context, r),
                                    ),
                                    if (!r.isWarrantyCovered)
                                      IconButton(
                                        tooltip: 'Estimate & WhatsApp Payment Link',
                                        icon: const Icon(Icons.receipt_long_outlined, size: 18, color: Colors.green),
                                        onPressed: () => _openEstimateModal(context, r),
                                      ),
                                    if (r.status != ServiceRequestStatus.resolved && r.status != ServiceRequestStatus.closed)
                                      IconButton(
                                        tooltip: 'Mark Resolved',
                                        icon: const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF10B981)),
                                        onPressed: () => _resolveRequest(r),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpi(String label, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetailDrawer(BuildContext context, ServiceRequest r) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ServiceRequestDetail',
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: ServiceRequestDetailDrawer(
            request: r,
            onScheduleVisit: () {
              Navigator.pop(ctx);
              _openScheduleVisit(context, r);
            },
            onResolveRequest: () {
              Navigator.pop(ctx);
              _resolveRequest(r);
            },
            onAssignTechnician: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Assign technician workflow launched for ${r.requestNumber}')),
              );
            },
          ),
        );
      },
    );
  }

  void _openCreateModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CreateServiceRequestModal(
        onRequestCreated: (newReq) {
          setState(() => _requests.insert(0, newReq));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service Request ${newReq.requestNumber} logged successfully!')),
          );
        },
      ),
    );
  }

  void _openScheduleVisit(BuildContext context, ServiceRequest r) {
    showDialog(
      context: context,
      builder: (ctx) => ScheduleVisitModal(
        initialRequest: r,
        onVisitScheduled: (visit) {
          setState(() {
            final idx = _requests.indexWhere((x) => x.id == r.id);
            if (idx != -1) {
              _requests[idx] = _requests[idx].copyWith(
                status: ServiceRequestStatus.scheduled,
                visitIds: [..._requests[idx].visitIds, visit.id],
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Visit ${visit.visitNumber} scheduled & dispatched to ${visit.assignedTechnician}!')),
          );
        },
      ),
    );
  }

  void _openEstimateModal(BuildContext context, ServiceRequest r) {
    showDialog(
      context: context,
      builder: (ctx) => ServiceEstimatePaymentModal(
        request: r,
        onEstimateSaved: (est) {
          setState(() {
            final idx = _requests.indexWhere((x) => x.id == r.id);
            if (idx != -1) {
              _requests[idx] = _requests[idx].copyWith(paymentLinkSent: true);
            }
          });
        },
      ),
    );
  }

  void _resolveRequest(ServiceRequest r) {
    setState(() {
      final idx = _requests.indexWhere((x) => x.id == r.id);
      if (idx != -1) {
        _requests[idx] = _requests[idx].copyWith(
          status: ServiceRequestStatus.resolved,
          resolvedDate: DateTime.now(),
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request ${r.requestNumber} marked as RESOLVED. Customer feedback request triggered.')),
    );
  }
}
