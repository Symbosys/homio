import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../data/travel_repository.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';
import '../models/dashboard_mock_data.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/log_travel_modal.dart';
import '../widgets/state_feedback_widgets.dart';

/// Screen 4: Travel, Field Visits & Fuel Mileage Reimbursement.
/// Features Travel Summary KPIs, GPS Route Map visualization, configurable mileage rate calculation,
/// 30-day mileage charts, and responsive claims history table/cards.
class DashboardTravelPage extends StatefulWidget {
  final String userName;

  const DashboardTravelPage({
    super.key,
    this.userName = 'Vikram Malhotra',
  });

  @override
  State<DashboardTravelPage> createState() => _DashboardTravelPageState();
}

class _DashboardTravelPageState extends State<DashboardTravelPage> {
  final TravelRepository _repository = TravelRepository.instance;
  final ScrollController _scrollController = ScrollController();

  DashboardDateFilter _dateFilter = DashboardDateFilter.thisMonth;
  DashboardScopeFilter _scopeFilter = DashboardScopeFilter.myWork;

  bool _isLoading = true;
  TravelSummary? _summary;
  List<TravelRecord> _records = [];
  bool _isTripActive = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final savedOffset = _scrollController.hasClients ? _scrollController.offset : null;
    setState(() => _isLoading = true);
    final summary = await _repository.getTravelSummary(dateFilter: _dateFilter);
    final records = await _repository.getTravelHistory();

    if (mounted) {
      setState(() {
        _summary = summary;
        _records = records;
        _isLoading = false;
      });
      if (savedOffset != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            final target = savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
            _scrollController.jumpTo(target);
          }
        });
      }
    }
  }

  void _toggleLiveGpsTrip() {
    setState(() => _isTripActive = !_isTripActive);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isTripActive
              ? 'GPS Odometer Started. Real-time background location logging active.'
              : 'Trip completed. Recorded 18.4 km for company fuel reimbursement claim.',
          style: GoogleFonts.inter(fontSize: 12),
        ),
        backgroundColor: _isTripActive ? const Color(0xFF2563EB) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openLogVisitModal() {
    LogTravelModal.show(
      context,
      mileageRatePerKm: _summary?.mileageRatePerKm ?? 12.0,
      onLogTrip: ({
        required String clientName,
        required String projectName,
        required String fromLocation,
        required String toLocation,
        required double distanceKm,
        required String purpose,
      }) async {
        await _repository.logFieldVisit(
          clientName: clientName,
          projectName: projectName,
          fromLocation: fromLocation,
          toLocation: toLocation,
          distanceKm: distanceKm,
          purpose: purpose,
        );
        _loadData();
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
          controller: _scrollController,
          key: const PageStorageKey('dashboard_travel_scroll'),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Common Header
              DashboardHeader(
                title: 'Travel & Field Mileage Hub',
                subtitle: 'Track field site visits, GPS distance telemetry & fuel reimbursement claims',
                icon: Icons.commute_rounded,
                userName: widget.userName,
                activeDateFilter: _dateFilter,
                activeScopeFilter: _scopeFilter,
                onDateFilterChanged: (f) {
                  setState(() => _dateFilter = f);
                  _loadData();
                },
                onScopeFilterChanged: (s) {
                  setState(() => _scopeFilter = s);
                  _loadData();
                },
                onRefresh: _loadData,
                primaryAction: ElevatedButton.icon(
                  onPressed: _openLogVisitModal,
                  icon: const Icon(Icons.add_location_alt_rounded, size: 16),
                  label: Text(
                    '+ Log Field Visit',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
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

              // Non-disruptive inline indicator right below header
              DashboardInlineLoadingIndicator(isLoading: _isLoading && _summary != null),

              if (_isLoading && _summary == null) ...[
                const DashboardSkeletonLoader(height: 100),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 140),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 280),
              ] else if (_summary != null) ...[
                // 2. Travel Summary Cards Strip
                _buildTravelSummaryKpis(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 3. Live Trip & Waypoint Route Visualization Card
                _buildRouteAndGpsCard(isDark, isMobile),
                const SizedBox(height: 18),

                // 4. Configurable Mileage Rate & Reimbursement Formula Card
                _buildMileageRateCard(isDark, isMobile),
                const SizedBox(height: 18),

                // 5. Travel Charts Row (30-Day Line Chart + Purpose Pie Chart)
                _buildTravelChartsRow(isDark, isMobile, isTablet),
                const SizedBox(height: 20),

                // 6. Travel Claims & Field Visit History Table / Cards with Localized Loading
                LocalizedLoadingOverlay(
                  isLoading: _isLoading && _summary != null,
                  message: 'Refreshing claims & visits...',
                  child: _buildTravelHistorySection(isDark, isMobile),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION: TRAVEL SUMMARY CARDS
  // ===========================================================================
  Widget _buildTravelSummaryKpis(bool isDark, bool isMobile, bool isTablet) {
    final s = _summary!;
    final kpis = [
      _buildKpiCard('Total Distance', '${s.totalDistanceKm} KM', 'GPS verified', const Color(0xFF2563EB), isDark),
      _buildKpiCard('Total Visits', '${s.totalVisits}', 'client sites', const Color(0xFF6366F1), isDark),
      _buildKpiCard('Approved Reimbursement', '₹${s.approvedReimbursement.toStringAsFixed(0)}', 'credited to wallet', const Color(0xFF10B981), isDark),
      _buildKpiCard('Pending Reimbursement', '₹${s.pendingReimbursement.toStringAsFixed(0)}', 'under finance review', const Color(0xFFF59E0B), isDark),
      _buildKpiCard('This Month Total', '₹${s.thisMonthTotal.toStringAsFixed(0)}', 'eligible mileage', const Color(0xFF0EA5E9), isDark),
    ];

    if (isMobile) {
      return SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: kpis.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) => SizedBox(width: 145, child: kpis[index]),
        ),
      );
    }

    return Row(
      children: kpis.map((k) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: k))).toList(),
    );
  }

  Widget _buildKpiCard(String title, String val, String sub, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(val, style: GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: LIVE TRIP & WAYPOINT ROUTE CARD
  // ===========================================================================
  Widget _buildRouteAndGpsCard(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: _isTripActive
              ? const Color(0xFF2563EB).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.alt_route_rounded, size: 16, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Operational Field Route Telemetry',
                    style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _toggleLiveGpsTrip,
                icon: Icon(_isTripActive ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 15),
                label: Text(
                  _isTripActive ? 'End Trip & Claim' : 'Start Live GPS Trip',
                  style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTripActive ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visual Waypoints Path (Office -> Site A -> Site B -> Site C)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildWaypointStep('Office HQ Hub', '09:30 AM', 'Start Point', true, isDark),
                _buildRouteArrow(18.4, isDark),
                _buildWaypointStep('Project #104 (DLF Phase 5)', '10:15 AM', 'Framing Laser Check', false, isDark),
                _buildRouteArrow(24.2, isDark),
                _buildWaypointStep('Sobha City #402', '02:00 PM', 'CAD Measurement', false, isDark),
                _buildRouteArrow(16.5, isDark),
                _buildWaypointStep('Godrej Woods 3BHK', '04:30 PM', 'Marble Signoff', false, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaypointStep(String title, String time, String desc, bool isStart, bool isDark) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isStart ? const Color(0xFF2563EB) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isStart ? 1.2 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isStart ? Icons.business_rounded : Icons.location_on_rounded,
                size: 14,
                color: isStart ? const Color(0xFF2563EB) : const Color(0xFF10B981),
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          Text(
            desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteArrow(double km, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Text(
            '${km.toStringAsFixed(1)} km',
            style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(width: 14, height: 1.5, color: const Color(0xFF2563EB)),
              const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF2563EB)),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: CONFIGURABLE MILEAGE RATE CARD
  // ===========================================================================
  Widget _buildMileageRateCard(bool isDark, bool isMobile) {
    final s = _summary!;
    final estimatedPayout = s.totalDistanceKm * s.mileageRatePerKm;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: AppRadius.md,
        border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Company Mileage Rate: ',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF),
                    ),
                  ),
                  Text(
                    '₹${s.mileageRatePerKm.toStringAsFixed(0)} / KM',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Total Eligible Distance: ${s.totalDistanceKm} KM  ×  ₹${s.mileageRatePerKm.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Estimated Reimbursement',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                ),
              ),
              Text(
                '₹${estimatedPayout.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: CHARTS ROW
  // ===========================================================================
  Widget _buildTravelChartsRow(bool isDark, bool isMobile, bool isTablet) {
    const lineChartWidget = DashboardTravelMileageLineChart(
      dataPoints: DashboardMockData.travelMileageTrend,
    );

    const pieChartWidget = DashboardVisitPurposePieChart(
      visits: DashboardMockData.fieldVisits,
    );

    if (isMobile || isTablet) {
      return Column(
        children: [
          lineChartWidget,
          const SizedBox(height: 14),
          pieChartWidget,
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 6, child: lineChartWidget),
        const SizedBox(width: 14),
        Expanded(flex: 4, child: pieChartWidget),
      ],
    );
  }

  // ===========================================================================
  // SECTION: TRAVEL HISTORY TABLE / CARDS
  // ===========================================================================
  Widget _buildTravelHistorySection(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Field Visit & Mileage Ledger',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                '${_records.length} Recorded Trips',
                style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (isMobile) ...[
            ..._records.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
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
                        Text(r.date, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: r.status.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            r.status.label,
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: r.status.color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('${r.fromLocation} → ${r.toLocation}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(r.purpose, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${r.distanceKm} KM @ ₹${r.ratePerKm.toInt()}/KM', style: GoogleFonts.inter(fontSize: 11)),
                        Text('₹${r.reimbursementAmount.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF2563EB))),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.6),
                1: FlexColumnWidth(3.0),
                2: FlexColumnWidth(2.2),
                3: FlexColumnWidth(1.4),
                4: FlexColumnWidth(1.2),
                5: FlexColumnWidth(1.6),
                6: FlexColumnWidth(1.6),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.xs,
                  ),
                  children: [
                    _tableHeader('Date', isDark),
                    _tableHeader('Route (From → To)', isDark),
                    _tableHeader('Project', isDark),
                    _tableHeader('Distance', isDark),
                    _tableHeader('Rate/KM', isDark),
                    _tableHeader('Claim (₹)', isDark),
                    _tableHeader('Status', isDark),
                  ],
                ),
                ..._records.map((r) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8)),
                    ),
                    children: [
                      _tableCell(r.date, isDark, isBold: true),
                      _tableCell('${r.fromLocation} → ${r.toLocation}', isDark),
                      _tableCell(r.projectName, isDark),
                      _tableCell('${r.distanceKm} KM', isDark),
                      _tableCell('₹${r.ratePerKm.toInt()}', isDark),
                      _tableCell('₹${r.reimbursementAmount.toStringAsFixed(2)}', isDark, color: const Color(0xFF2563EB), isBold: true),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: r.status.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              r.status.label,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: r.status.color),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tableHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _tableCell(String text, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
    );
  }
}
