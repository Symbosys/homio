import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_mock_data.dart';
import '../models/dashboard_models.dart';
import '../widgets/compact_data_table.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_metric_card.dart';

/// Field Visits & Mileage tracking dashboard with live GPS route tracker,
/// 30-day travel mileage line chart, visit purpose pie chart, and claims table.
class DashboardTravelPage extends StatefulWidget {
  const DashboardTravelPage({super.key});

  @override
  State<DashboardTravelPage> createState() => _DashboardTravelPageState();
}

class _DashboardTravelPageState extends State<DashboardTravelPage> {
  DashboardDateFilter _dateFilter = DashboardDateFilter.month;
  bool _isTripActive = false;
  final List<FieldVisitItem> _visits = List.from(DashboardMockData.fieldVisits);

  void _toggleTrip() {
    setState(() => _isTripActive = !_isTripActive);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isTripActive
              ? 'GPS Tracking Started. Odometer calibrated from HQ.'
              : 'Trip ended. 14.2 km recorded for fuel reimbursement claim.',
          style: GoogleFonts.inter(fontSize: 12),
        ),
        backgroundColor: _isTripActive ? const Color(0xFF2563EB) : const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openLogVisitDialog() {
    final clientController = TextEditingController();
    final locationController = TextEditingController();
    final kmController = TextEditingController();
    String purpose = 'Site Measurement';

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              title: Row(
                children: [
                  const Icon(Icons.add_location_alt_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Log Field Visit / Mileage Claim',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Client Name', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: clientController,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'e.g. Mr. Rajesh Mehta',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Site Location', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: locationController,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'e.g. Prestige Willow Green, Flat 402',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Distance (km)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: kmController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'e.g. 18.5',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Purpose', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: purpose,
                                isDense: true,
                                style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? Colors.white : Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Site Measurement', child: Text('Measurement')),
                                  DropdownMenuItem(value: 'Inspection', child: Text('Inspection')),
                                  DropdownMenuItem(value: 'Client Meeting', child: Text('Client Meeting')),
                                  DropdownMenuItem(value: 'Handover', child: Text('Handover')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => purpose = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final dist = double.tryParse(kmController.text.trim()) ?? 10.0;
                    setState(() {
                      _visits.insert(
                        0,
                        FieldVisitItem(
                          id: 'vst-${DateTime.now().millisecondsSinceEpoch}',
                          clientName: clientController.text.trim().isEmpty ? 'Client Visit' : clientController.text.trim(),
                          siteLocation: locationController.text.trim().isEmpty ? 'Site Location' : locationController.text.trim(),
                          visitDate: 'Today',
                          distanceKm: dist,
                          reimbursementAmount: dist * 10,
                          status: 'pending',
                          purpose: purpose,
                        ),
                      );
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Visit logged and reimbursement queued for approval', style: GoogleFonts.inter(fontSize: 12)),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                  child: Text('Save Visit', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              DashboardHeader(
                title: 'Field Visits & Mileage Telemetry',
                subtitle: 'On-site inspections, verified GPS odometer tracking & fuel reimbursement audits',
                icon: Icons.directions_car_filled_outlined,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                primaryAction: ElevatedButton.icon(
                  onPressed: _openLogVisitDialog,
                  icon: const Icon(Icons.add, size: 14),
                  label: Text(
                    'Log Visit',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // Active Trip GPS Tracker Card
              _buildActiveTripCard(isDark, isMobile),
              const SizedBox(height: 18),

              // 4 Mileage KPI Metrics
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Charts Row: 30-day mileage line & purpose pie chart
              _buildChartsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Field Visits Data Grid
              _buildVisitsTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTripCard(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: _isTripActive
              ? const Color(0xFF2563EB).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTripInfo(isDark),
                const SizedBox(height: 12),
                _buildTripActionButton(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildTripInfo(isDark)),
                const SizedBox(width: 20),
                _buildTripActionButton(),
              ],
            ),
    );
  }

  Widget _buildTripInfo(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (_isTripActive ? const Color(0xFF2563EB) : const Color(0xFF64748B)).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isTripActive ? Icons.navigation : Icons.near_me_disabled,
            size: 18,
            color: _isTripActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _isTripActive ? 'GPS Live Trip In Progress' : 'No Active Field Trip',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DashboardBadge(
                    label: _isTripActive ? 'RECORDING GPS' : 'STANDBY',
                    color: _isTripActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                _isTripActive
                    ? 'Route: HQ -> Prestige Falcon Site | Est. 14.2 km | Start Odometer: 14,892 km'
                    : 'Start a trip when traveling for client visits, site measurements or material inspections.',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripActionButton() {
    return ElevatedButton.icon(
      onPressed: _toggleTrip,
      icon: Icon(_isTripActive ? Icons.stop_circle_outlined : Icons.play_arrow_rounded, size: 16),
      label: Text(
        _isTripActive ? 'End Trip & Upload Proof' : 'Start GPS Trip',
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isTripActive ? const Color(0xFFEF4444) : AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = DashboardMockData.travelKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return DashboardMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildChartsRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          DashboardTravelMileageLineChart(dataPoints: DashboardMockData.travelMileageTrend),
          const SizedBox(height: 16),
          DashboardVisitPurposePieChart(visits: _visits),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: DashboardTravelMileageLineChart(dataPoints: DashboardMockData.travelMileageTrend),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DashboardVisitPurposePieChart(visits: _visits),
        ),
      ],
    );
  }

  Widget _buildVisitsTable(bool isDark) {
    return CompactTableCard(
      title: 'Field Visits & Reimbursement Ledger',
      subtitle: 'Verified site visits with GPS distance calculations & claims',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Download Ledger', style: GoogleFonts.inter(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 920.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.6), // CLIENT / PROJECT
                  1: FlexColumnWidth(2.4), // SITE LOCATION
                  2: FlexColumnWidth(2.0), // PURPOSE
                  3: FlexColumnWidth(1.2), // DISTANCE
                  4: FlexColumnWidth(1.3), // FUEL CLAIM
                  5: FlexColumnWidth(1.3), // STATUS
                  6: FlexColumnWidth(0.9), // PROOF
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('CLIENT / PROJECT', isDark),
                      _buildHeaderCell('SITE LOCATION', isDark),
                      _buildHeaderCell('PURPOSE', isDark),
                      _buildHeaderCell('DISTANCE', isDark),
                      _buildHeaderCell('FUEL CLAIM', isDark),
                      _buildHeaderCell('STATUS', isDark),
                      _buildHeaderCell('PROOF', isDark, align: TextAlign.center),
                    ],
                  ),
                  ..._visits.map((v) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorder.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                        ),
                      ),
                      children: [
                        // CLIENT / PROJECT
                        _buildDataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v.clientName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                v.visitDate,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SITE LOCATION
                        _buildDataCell(
                          Text(
                            v.siteLocation,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // PURPOSE
                        _buildDataCell(
                          Text(
                            v.purpose,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // DISTANCE
                        _buildDataCell(
                          Text(
                            '${v.distanceKm} km',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // FUEL CLAIM
                        _buildDataCell(
                          Text(
                            '₹${v.reimbursementAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                        // STATUS
                        _buildDataCell(
                          DashboardBadge(label: v.status.toUpperCase(), color: v.statusColor),
                        ),
                        // PROOF
                        _buildDataCell(
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.receipt_long_outlined, size: 16),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Verified GPS odometer proof attached', style: GoogleFonts.inter(fontSize: 11.5)),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              tooltip: 'View Odometer Photo Proof',
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark, {TextAlign align = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget content, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: content,
    );
  }
}
