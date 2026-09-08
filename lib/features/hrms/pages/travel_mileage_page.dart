import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hrms_models.dart';
import '../models/hrms_mock_data.dart';

class TravelMileagePage extends StatefulWidget {
  const TravelMileagePage({super.key});

  @override
  State<TravelMileagePage> createState() => _TravelMileagePageState();
}

class _TravelMileagePageState extends State<TravelMileagePage> {
  final List<TravelMileageRecord> _travelLogs = List.from(hrmsMockTravelRecords);

  String _searchQuery = '';
  ApprovalStatus? _filterStatus;
  VehicleType? _filterVehicle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredLogs = _travelLogs.where((log) {
      final matchesSearch = log.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.employeeCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.originAddress.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.destinationAddress.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (log.projectReference?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesStatus = _filterStatus == null || log.status == _filterStatus;
      final matchesVehicle = _filterVehicle == null || log.vehicleType == _filterVehicle;

      return matchesSearch && matchesStatus && matchesVehicle;
    }).toList();

    // Summary calculations
    final totalDistance = _travelLogs.fold<double>(0, (sum, l) => sum + l.distanceKm);
    final totalReimbursement = _travelLogs.fold<double>(0, (sum, l) => sum + l.reimbursementAmount);
    final approvedCount = _travelLogs.where((l) => l.status == ApprovalStatus.approved).length;
    final pendingCount = _travelLogs.where((l) => l.status == ApprovalStatus.pending).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, totalDistance, totalReimbursement, approvedCount, pendingCount, width),
            const SizedBox(height: 24),
            _buildTripLogsCard(isDark, filteredLogs),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.navigation_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'GPS Travel Mileage & Claims',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Departure (Selfie A) to Destination (Selfie B) automated distance tracking with ₹12-₹18/km rates.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showLogTripModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Log Field Travel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiMetrics(
    bool isDark,
    double totalKm,
    double totalReimbursement,
    int approved,
    int pending,
    double width,
  ) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Total Logged Distance',
        value: '${totalKm.toStringAsFixed(1)} KM',
        sub: 'Automated GPS odometer',
        icon: Icons.alt_route_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Travel Allowance Pool',
        value: '₹${NumberFormat('#,##,###').format(totalReimbursement)}',
        sub: '₹12/km (2W) | ₹18/km (4W)',
        icon: Icons.currency_rupee_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Pending Manager Audit',
        value: '$pending Trips',
        sub: 'Selfie A & B verification',
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFFF59E0B),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Approved Disbursed',
        value: '$approved Trips',
        sub: 'Cleared for monthly payout',
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    if (width < Breakpoints.compact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripLogsCard(bool isDark, List<TravelMileageRecord> logs) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Field Site Mileage Roster & Photo Proofs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _filterStatus == null,
                    onSelected: (_) => setState(() => _filterStatus = null),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Pending'),
                    selected: _filterStatus == ApprovalStatus.pending,
                    onSelected: (val) => setState(() => _filterStatus = val ? ApprovalStatus.pending : null),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Approved'),
                    selected: _filterStatus == ApprovalStatus.approved,
                    onSelected: (val) => setState(() => _filterStatus = val ? ApprovalStatus.approved : null),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search by employee, project reference, or location...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (logs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.location_off_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No travel claims match the current criteria.',
                      style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final log = logs[index];
                return _buildTripRow(isDark, log);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTripRow(bool isDark, TravelMileageRecord log) {
    final vehicleIcon = log.vehicleType == VehicleType.twoWheeler ? Icons.two_wheeler_rounded : Icons.directions_car_rounded;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Departure & Arrival Photo Thumbnails
        Column(
          children: [
            Row(
              children: [
                _buildPhotoThumbnail(log.startSelfieUrl, 'Selfie A\n(Start)', isDark),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.gold),
                const SizedBox(width: 6),
                _buildPhotoThumbnail(log.endSelfieUrl, 'Selfie B\n(End)', isDark),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM, hh:mm a').format(log.startTime),
              style: TextStyle(
                fontSize: 10.5,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    log.employeeName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.employeeCode,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (log.projectReference != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        log.projectReference!,
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.gold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.radio_button_checked_rounded, size: 12, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      log.originAddress,
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFFEF4444)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      log.destinationAddress,
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Distance & Rate Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(vehicleIcon, size: 14, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                const SizedBox(width: 6),
                Text(
                  '${log.distanceKm} KM',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '@ ₹${log.ratePerKm.toStringAsFixed(0)}/km = ₹${log.reimbursementAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Approval Status & Actions
        _buildApprovalActions(isDark, log),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String? url, String label, bool isDark) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        image: url != null ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover) : null,
      ),
      child: url == null
          ? Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 8, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
            )
          : null,
    );
  }

  Widget _buildApprovalActions(bool isDark, TravelMileageRecord log) {
    if (log.status == ApprovalStatus.approved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, size: 13, color: Color(0xFF10B981)),
            SizedBox(width: 4),
            Text('Approved', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
          ],
        ),
      );
    }

    if (log.status == ApprovalStatus.rejected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('Rejected', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              final idx = _travelLogs.indexWhere((l) => l.id == log.id);
              if (idx != -1) {
                _travelLogs[idx] = log.copyWith(status: ApprovalStatus.approved);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Approved travel claim for ${log.employeeName}')),
            );
          },
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
          tooltip: 'Approve Claim',
        ),
        IconButton(
          onPressed: () {
            setState(() {
              final idx = _travelLogs.indexWhere((l) => l.id == log.id);
              if (idx != -1) {
                _travelLogs[idx] = log.copyWith(status: ApprovalStatus.rejected);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Rejected travel claim for ${log.employeeName}')),
            );
          },
          icon: const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 18),
          tooltip: 'Reject Claim',
        ),
      ],
    );
  }

  void _showLogTripModal(bool isDark) {
    String selectedEmpId = hrmsMockEmployees.first.id;
    final originCtrl = TextEditingController(text: 'Homio Design Studio, Indiranagar');
    final destCtrl = TextEditingController(text: 'Villa #42, Sobha Royal Pavilion');
    final projCtrl = TextEditingController(text: 'PRJ-VILLA-42');
    VehicleType vehicle = VehicleType.twoWheeler;
    double distanceKm = 18.5;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final rate = vehicle.defaultRatePerKm;
          final totalReimbursement = distanceKm * rate;

          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Log Site Travel Mileage Claim',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: selectedEmpId,
                      decoration: const InputDecoration(labelText: 'Employee', border: OutlineInputBorder()),
                      items: hrmsMockEmployees.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.name} (${e.code})'))).toList(),
                      onChanged: (val) => setDialogState(() => selectedEmpId = val!),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: originCtrl,
                      decoration: const InputDecoration(labelText: 'Origin Address (Selfie A point)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: destCtrl,
                      decoration: const InputDecoration(labelText: 'Destination Site (Selfie B point)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: projCtrl,
                      decoration: const InputDecoration(labelText: 'Project Reference / BOQ Site Code', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<VehicleType>(
                            initialValue: vehicle,
                            decoration: const InputDecoration(labelText: 'Vehicle Mode', border: OutlineInputBorder()),
                            items: const [
                              DropdownMenuItem(value: VehicleType.twoWheeler, child: Text('2-Wheeler (₹12/km)')),
                              DropdownMenuItem(value: VehicleType.fourWheeler, child: Text('4-Wheeler (₹18/km)')),
                            ],
                            onChanged: (val) => setDialogState(() => vehicle = val!),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            initialValue: distanceKm.toString(),
                            decoration: const InputDecoration(labelText: 'Distance (KM)', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setDialogState(() => distanceKm = double.tryParse(val) ?? 0.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Reimbursement:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(
                            '₹${totalReimbursement.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final emp = hrmsMockEmployees.firstWhere((e) => e.id == selectedEmpId);
                  final newTrip = TravelMileageRecord(
                    id: 'trv-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.name,
                    employeeCode: emp.code,
                    startTime: DateTime.now().subtract(const Duration(hours: 1)),
                    endTime: DateTime.now(),
                    startLatitude: 12.9716,
                    startLongitude: 77.5946,
                    endLatitude: 12.9352,
                    endLongitude: 77.6245,
                    originAddress: originCtrl.text.trim(),
                    destinationAddress: destCtrl.text.trim(),
                    distanceKm: distanceKm,
                    vehicleType: vehicle,
                    ratePerKm: rate,
                    reimbursementAmount: totalReimbursement,
                    status: ApprovalStatus.pending,
                    startSelfieUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                    endSelfieUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                    projectReference: projCtrl.text.trim().isEmpty ? null : projCtrl.text.trim(),
                  );
                  setState(() {
                    _travelLogs.insert(0, newTrip);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged ${newTrip.distanceKm} KM travel claim for ${newTrip.employeeName}')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Submit Travel Claim'),
              ),
            ],
          );
        },
      ),
    );
  }
}
