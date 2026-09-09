import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';
import '../widgets/after_sales_header.dart';
import '../widgets/schedule_visit_modal.dart';
import '../widgets/field_visit_execution_modal.dart';

class ServiceVisitsPage extends StatefulWidget {
  const ServiceVisitsPage({super.key});

  @override
  State<ServiceVisitsPage> createState() => _ServiceVisitsPageState();
}

class _ServiceVisitsPageState extends State<ServiceVisitsPage> {
  final List<ServiceVisit> _visits = List.from(AfterSalesMockData.serviceVisits);

  String _searchQuery = '';
  ServiceVisitStatus? _selectedStatus;
  VisitType? _selectedType;
  String _dateFilter = 'This Month';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final filtered = _visits.where((v) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = v.visitNumber.toLowerCase().contains(q) ||
            v.customerName.toLowerCase().contains(q) ||
            v.projectName.toLowerCase().contains(q) ||
            v.assignedTechnician.toLowerCase().contains(q) ||
            v.purpose.toLowerCase().contains(q) ||
            v.siteAddress.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedStatus != null && v.status != _selectedStatus) return false;
      if (_selectedType != null && v.visitType != _selectedType) return false;
      return true;
    }).toList();

    // KPIs
    final totalVisits = _visits.length;
    final scheduledCount = _visits.where((v) => v.status == ServiceVisitStatus.scheduled || v.status == ServiceVisitStatus.confirmed).length;
    final checkedInCount = _visits.where((v) => v.status == ServiceVisitStatus.checkedIn || v.status == ServiceVisitStatus.inProgress).length;
    final completedCount = _visits.where((v) => v.status == ServiceVisitStatus.completed).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AfterSalesHeader(
              title: 'On-Site Field Service Visits & Attendance',
              subtitle: 'Operational dispatch center coordinating technician site visits, GPS geo-fenced attendance, inspection checklists, and customer sign-offs.',
              activeTab: 'Service Visits',
              selectedDateFilter: _dateFilter,
              onDateFilterChanged: (val) => setState(() => _dateFilter = val),
              trailing: ElevatedButton.icon(
                onPressed: () => _openScheduleModal(context),
                icon: const Icon(Icons.car_repair_rounded, size: 16),
                label: const Text('Schedule Service Visit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
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
                  // KPI Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpi('Total Dispatches', '$totalVisits', 'All recorded visits', Icons.car_repair_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Upcoming / Scheduled', '$scheduledCount', 'Awaiting site arrival', Icons.calendar_today_rounded, const Color(0xFF0284C7), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Active on Site', '$checkedInCount', 'GPS verified & in progress', Icons.pin_drop_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Completed & Signed', '$completedCount', 'Customer CSAT signed', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpi('Total Dispatches', '$totalVisits', 'All recorded visits', Icons.car_repair_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Upcoming / Scheduled', '$scheduledCount', 'Awaiting site arrival', Icons.calendar_today_rounded, const Color(0xFF0284C7), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Active on Site', '$checkedInCount', 'GPS verified & in progress', Icons.pin_drop_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Completed & Signed', '$completedCount', 'Customer CSAT signed', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
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
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search visits by #, customer, project, technician, or address...',
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
                          child: DropdownButtonFormField<ServiceVisitStatus?>(
                            initialValue: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Visit Status',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Statuses')),
                              ...ServiceVisitStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                            ],
                            onChanged: (val) => setState(() => _selectedStatus = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<VisitType?>(
                            initialValue: _selectedType,
                            decoration: InputDecoration(
                              labelText: 'Visit Type',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Types')),
                              ...VisitType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))),
                            ],
                            onChanged: (val) => setState(() => _selectedType = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Visits DataTable
                  Text('Service Visits Roster (${filtered.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                  const SizedBox(height: 12),

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
                          DataColumn(label: Text('Visit & Schedule', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Customer & Site', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Purpose & Scope', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Assigned Crew', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Status & GPS', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Field Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                        ],
                        rows: filtered.map((v) {
                          return DataRow(
                            cells: [
                              // Visit & Schedule
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(v.visitNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF0284C7))),
                                    Text('${v.visitDate.day}/${v.visitDate.month}/${v.visitDate.year} • ${v.startTime}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                                    Text(v.visitType.label, style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                  ],
                                ),
                              ),

                              // Customer & Site
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(v.customerName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimaryColor)),
                                    Text(v.projectName, style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                    Text(v.siteAddress, style: TextStyle(fontSize: 10, color: textMutedColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),

                              // Purpose
                              DataCell(
                                SizedBox(
                                  width: 220,
                                  child: Text(v.purpose, style: TextStyle(fontSize: 12, color: textPrimaryColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                              ),

                              // Assigned Crew
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(v.assignedTechnician, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                                    Text('Lead: ${v.assignedEmployee}', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                  ],
                                ),
                              ),

                              // Status & GPS
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: v.status.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(v.status.label, style: TextStyle(color: v.status.color, fontSize: 10, fontWeight: FontWeight.w800)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      v.checkInRecord != null ? 'GPS Check-in Verified' : 'Check-in Pending',
                                      style: TextStyle(fontSize: 10, color: v.checkInRecord != null ? const Color(0xFF10B981) : textSecondaryColor, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),

                              // Field Actions
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _openFieldExecutionModal(context, v),
                                      icon: const Icon(Icons.touch_app_rounded, size: 14),
                                      label: Text(v.status == ServiceVisitStatus.completed ? 'View Report' : 'Execute Visit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: v.status == ServiceVisitStatus.completed ? const Color(0xFF10B981) : AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        elevation: 0,
                                      ),
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
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
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

  void _openScheduleModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ScheduleVisitModal(
        onVisitScheduled: (newVisit) {
          setState(() => _visits.insert(0, newVisit));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service Visit ${newVisit.visitNumber} scheduled and dispatched!')),
          );
        },
      ),
    );
  }

  void _openFieldExecutionModal(BuildContext context, ServiceVisit v) {
    showDialog(
      context: context,
      builder: (ctx) => FieldVisitExecutionModal(
        visit: v,
        onVisitUpdated: (updated) {
          setState(() {
            final idx = _visits.indexWhere((x) => x.id == v.id);
            if (idx != -1) _visits[idx] = updated;
          });
        },
      ),
    );
  }
}
