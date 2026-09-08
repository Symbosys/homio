import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hrms_models.dart';
import '../models/hrms_mock_data.dart';

class GeofenceAttendancePage extends StatefulWidget {
  const GeofenceAttendancePage({super.key});

  @override
  State<GeofenceAttendancePage> createState() => _GeofenceAttendancePageState();
}

class _GeofenceAttendancePageState extends State<GeofenceAttendancePage> {
  final List<AttendanceRecord> _records = List.from(hrmsMockAttendance);
  final List<GeofenceZone> _zones = List.from(hrmsMockZones);

  String _searchQuery = '';
  AttendanceStatus? _filterStatus;
  GeofenceStatus? _filterGeofence;
  String _selectedZoneId = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredRecords = _records.where((rec) {
      final matchesSearch = rec.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rec.employeeCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rec.zoneName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == null || rec.status == _filterStatus;
      final matchesGeofence = _filterGeofence == null || rec.geofenceStatus == _filterGeofence;
      final matchesZone = _selectedZoneId == 'all' || rec.zoneId == _selectedZoneId;

      return matchesSearch && matchesStatus && matchesGeofence && matchesZone;
    }).toList();

    // Summary counts
    final totalCheckins = _records.length;
    final insideGeofence = _records.where((r) => r.geofenceStatus.isInside).length;
    final outsideViolations = _records.where((r) => !r.geofenceStatus.isInside).length;
    final doublePenalties = _records.where((r) => r.status == AttendanceStatus.doublePenalty).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, totalCheckins, insideGeofence, outsideViolations, doublePenalties, width),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildAttendanceLedger(isDark, filteredRecords),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: _buildGeofenceRadarVisualizer(isDark),
                  ),
                ],
              )
            else ...[
              _buildAttendanceLedger(isDark, filteredRecords),
              const SizedBox(height: 24),
              _buildGeofenceRadarVisualizer(isDark),
            ],
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
                  child: const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Geofenced Attendance & Punch-In',
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
              'Real-time GPS radius verification (100m-200m) with mandatory selfie photo-capture stamps.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showSimulatePunchInDialog(isDark),
          icon: const Icon(Icons.camera_alt_rounded, size: 16),
          label: const Text('Simulate Punch-In'),
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
    int totalCheckins,
    int insideGeofence,
    int outsideViolations,
    int doublePenalties,
    double width,
  ) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Today Check-Ins',
        value: '$totalCheckins',
        sub: 'Across active project sites',
        icon: Icons.how_to_reg_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Inside Authorized Geofence',
        value: '$insideGeofence',
        sub: '${((insideGeofence / (totalCheckins == 0 ? 1 : totalCheckins)) * 100).toStringAsFixed(0)}% within perimeter',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Perimeter Violations',
        value: '$outsideViolations',
        sub: 'Flagged > 200m radius',
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFF59E0B),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Double Salary Penalties',
        value: '$doublePenalties',
        sub: 'Unapproved Absence',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFEF4444),
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

  Widget _buildAttendanceLedger(bool isDark, List<AttendanceRecord> records) {
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
                'Daily Attendance & Geofence Logs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              Text(
                DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search and Filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    hintText: 'Search by employee, code, or zone...',
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedZoneId,
                dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                underline: const SizedBox(),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All Zones')),
                  ..._zones.map((z) => DropdownMenuItem(value: z.id, child: Text(z.name))),
                ],
                onChanged: (val) => setState(() => _selectedZoneId = val ?? 'all'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.person_off_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No matching attendance records found.',
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
              itemCount: records.length,
              separatorBuilder: (_, _) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final rec = records[index];
                return _buildAttendanceRow(isDark, rec);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(bool isDark, AttendanceRecord rec) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              backgroundImage: rec.selfieUrl != null ? NetworkImage(rec.selfieUrl!) : null,
              child: rec.selfieUrl == null
                  ? Icon(Icons.person_rounded, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: rec.geofenceStatus.isInside
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? AppColors.darkCardBg : AppColors.pureWhite, width: 2),
                ),
                child: Icon(
                  rec.geofenceStatus.isInside ? Icons.check : Icons.close,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    rec.employeeName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rec.employeeCode,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(Icons.apartment_rounded, size: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(
                    rec.zoneName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Punch: ${rec.checkInTime != null ? DateFormat('hh:mm a').format(rec.checkInTime!) : '--'}',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildGeofenceBadge(rec.geofenceStatus),
        const SizedBox(width: 10),
        _buildStatusBadge(rec.status),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _showRecordDetailsModal(isDark, rec),
          icon: const Icon(Icons.visibility_rounded, size: 18),
          tooltip: 'Inspect GPS & Selfie Evidence',
        ),
      ],
    );
  }

  Widget _buildGeofenceBadge(GeofenceStatus status) {
    Color color;
    String label;
    IconData icon;

    if (status.isInside) {
      color = const Color(0xFF10B981);
      label = 'Within Radius';
      icon = Icons.check_circle_outline_rounded;
    } else {
      color = const Color(0xFFEF4444);
      label = 'Violation (>200m)';
      icon = Icons.error_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(AttendanceStatus status) {
    Color color;
    String label;

    switch (status) {
      case AttendanceStatus.present:
        color = const Color(0xFF10B981);
        label = 'Present';
        break;
      case AttendanceStatus.late:
        color = const Color(0xFFF59E0B);
        label = 'Late';
        break;
      case AttendanceStatus.halfDay:
        color = const Color(0xFFF59E0B);
        label = 'Half Day';
        break;
      case AttendanceStatus.absent:
        color = const Color(0xFF64748B);
        label = 'Absent';
        break;
      case AttendanceStatus.onLeave:
        color = const Color(0xFF3B82F6);
        label = 'On Leave';
        break;
      case AttendanceStatus.doublePenalty:
        color = const Color(0xFFEF4444);
        label = '2x Penalty Applied';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _buildGeofenceRadarVisualizer(bool isDark) {
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.radar_rounded, color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Active Geofence Zones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Employees must be physically located within the designated circular perimeter to punch-in.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 18),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _zones.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final zone = _zones[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          zone.name,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Radius: ${zone.radiusMeters}m',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      zone.address,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.explore_rounded, size: 12, color: AppColors.gold),
                        const SizedBox(width: 5),
                        Text(
                          '${zone.latitude.toStringAsFixed(4)}° N, ${zone.longitude.toStringAsFixed(4)}° E',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.security_update_warning_rounded, size: 18, color: Color(0xFFEF4444)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tamper Warning: Mock location / GPS spoofing triggers automatic HR flag & admin notification.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRecordDetailsModal(bool isDark, AttendanceRecord rec) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Punch-In Audit: ${rec.employeeName}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
          ),
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rec.selfieUrl != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      rec.selfieUrl!,
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _buildDetailLine('Employee ID', rec.employeeCode, isDark),
              _buildDetailLine('Assigned Zone', rec.zoneName, isDark),
              _buildDetailLine('Punch Timestamp', rec.checkInTime != null ? DateFormat('dd MMM yyyy, hh:mm:ss a').format(rec.checkInTime!) : '--', isDark),
              _buildDetailLine('GPS Coordinates', '${rec.latitude.toStringAsFixed(5)}, ${rec.longitude.toStringAsFixed(5)}', isDark),
              _buildDetailLine('Perimeter Status', rec.geofenceStatus.isInside ? 'Authorized Inside' : 'VIOLATION DETECTED', isDark),
              if (rec.penaltyReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Double Penalty Note: ${rec.penaltyReason}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailLine(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
        ],
      ),
    );
  }

  void _showSimulatePunchInDialog(bool isDark) {
    String selectedEmpId = hrmsMockEmployees.first.id;
    String selectedZoneId = _zones.first.id;
    bool simulateViolation = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Simulate Geofence Punch-In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              ),
            ),
            content: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedEmpId,
                    decoration: const InputDecoration(labelText: 'Employee', border: OutlineInputBorder()),
                    items: hrmsMockEmployees.map((e) {
                      return DropdownMenuItem(value: e.id, child: Text('${e.name} (${e.code})'));
                    }).toList(),
                    onChanged: (val) => setDialogState(() => selectedEmpId = val!),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: selectedZoneId,
                    decoration: const InputDecoration(labelText: 'Target Geofence Zone', border: OutlineInputBorder()),
                    items: _zones.map((z) {
                      return DropdownMenuItem(value: z.id, child: Text('${z.name} (${z.radiusMeters}m)'));
                    }).toList(),
                    onChanged: (val) => setDialogState(() => selectedZoneId = val!),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    title: const Text('Simulate Perimeter Violation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Simulates employee standing 650m outside designated boundary', style: TextStyle(fontSize: 11)),
                    value: simulateViolation,
                    onChanged: (val) => setDialogState(() => simulateViolation = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final emp = hrmsMockEmployees.firstWhere((e) => e.id == selectedEmpId);
                  final zone = _zones.firstWhere((z) => z.id == selectedZoneId);

                  final newRecord = AttendanceRecord(
                    id: 'att-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.name,
                    employeeCode: emp.code,
                    zoneId: zone.id,
                    zoneName: zone.name,
                    checkInTime: DateTime.now(),
                    latitude: simulateViolation ? zone.latitude + 0.006 : zone.latitude + 0.0001,
                    longitude: simulateViolation ? zone.longitude + 0.006 : zone.longitude + 0.0001,
                    geofenceStatus: simulateViolation ? GeofenceStatus.outsideViolation : GeofenceStatus.withinGeofence,
                    status: simulateViolation ? AttendanceStatus.halfDay : AttendanceStatus.present,
                    selfieUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                  );

                  setState(() {
                    _records.insert(0, newRecord);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Punch-In registered: ${newRecord.employeeName} (${simulateViolation ? "VIOLATION" : "VERIFIED"})'),
                      backgroundColor: simulateViolation ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Submit Punch-In'),
              ),
            ],
          );
        },
      ),
    );
  }
}
