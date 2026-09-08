import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/ai_suite_models.dart';
import '../../models/ai_suite_mock_data.dart';
import '../../widgets/ai_suite_header.dart';
import '../../widgets/revenue_share_badge.dart';
import '../../widgets/video_consultation_room.dart';

class AiDesignerVideoCallPage extends StatefulWidget {
  const AiDesignerVideoCallPage({super.key});

  @override
  State<AiDesignerVideoCallPage> createState() => _AiDesignerVideoCallPageState();
}

class _AiDesignerVideoCallPageState extends State<AiDesignerVideoCallPage> {
  final List<DesignerConsultant> _roster = AiSuiteMockData.designerRoster;
  final List<BookedConsultationSession> _sessions = AiSuiteMockData.bookedSessions;

  int _activeAdminTab = 0; // 0: Experts Directory & Pricing, 1: Live Sessions & Audit Queue, 2: 50-50 Revenue Settlements
  String _searchQuery = '';
  DesignerAvailability? _filterAvailability;

  // Active supervision session
  DesignerConsultant? _supervisingDesigner;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 900;

    // If currently auditing a live room
    if (_supervisingDesigner != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0F19),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VideoConsultationRoom(
            designer: _supervisingDesigner!,
            onEndCall: () => setState(() => _supervisingDesigner = null),
          ),
        ),
      );
    }

    // Filtered Roster
    final filteredRoster = _roster.where((d) {
      if (_filterAvailability != null && d.availability != _filterAvailability) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = d.name.toLowerCase().contains(q);
        final matchesTitle = d.title.toLowerCase().contains(q);
        final matchesSpec = d.specializations.any((s) => s.toLowerCase().contains(q));
        if (!matchesName && !matchesTitle && !matchesSpec) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Suite Header
                const AiSuiteHeader(
                  title: 'Expert Consultants Roster & 30-Min Video Call Management',
                  subtitle:
                      'Admin governance suite to onboard certified architectural experts, configure consultation session prices, manage availability rosters, audit active video rooms, and track 50-50 revenue settlements.',
                  currentRoute: RouteNames.aiDesignerVideoCallPath,
                ),

                const SizedBox(height: 20),

                // 2. Quick Admin KPI Bar
                _buildAdminKpis(isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Admin Sub-Tabs & Add Expert Action
                _buildAdminActionBar(context, isDark, isMobile),

                const SizedBox(height: 16),

                // 4. Tab 0: Experts Directory & Pricing Table / Cards
                if (_activeAdminTab == 0) ...[
                  _buildExpertsDirectory(filteredRoster, isDark, isMobile),
                ],

                // 5. Tab 1: Live Sessions & Audit Queue
                if (_activeAdminTab == 1) ...[
                  _buildSessionsQueue(isDark, isMobile),
                ],

                // 6. Tab 2: 50-50 Revenue Settlements
                if (_activeAdminTab == 2) ...[
                  _buildRevenueSettlements(isDark, isMobile),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminKpis(bool isDark, bool isMobile) {
    final totalRevenue = _sessions.fold<double>(0.0, (sum, s) => sum + s.feePaid);
    final platformEarnings = totalRevenue * 0.5;
    final designerPayouts = totalRevenue * 0.5;

    final kpis = [
      (
        label: 'Listed Experts',
        val: '${_roster.length}',
        sub: 'Architects & Consultants',
        icon: Icons.badge_rounded,
        color: const Color(0xFF6366F1),
      ),
      (
        label: 'Online Available',
        val: '${_roster.where((d) => d.availability == DesignerAvailability.online).length}',
        sub: 'Ready for Instant Booking',
        icon: Icons.online_prediction_rounded,
        color: const Color(0xFF10B981),
      ),
      (
        label: 'Booked Sessions',
        val: '${_sessions.length}',
        sub: 'Active / Scheduled Calls',
        icon: Icons.video_call_rounded,
        color: const Color(0xFFF59E0B),
      ),
      (
        label: 'Total Revenue (50-50)',
        val: '₹${totalRevenue.toInt()}',
        sub: '₹${platformEarnings.toInt()} Org / ₹${designerPayouts.toInt()} Expert',
        icon: Icons.payments_rounded,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 800
            ? (constraints.maxWidth - 36) / 4
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: kpis.map((k) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(k.icon, size: 16, color: k.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            k.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      k.val,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      k.sub,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: k.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAdminActionBar(BuildContext context, bool isDark, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tab switcher
        SegmentedButton<int>(
          segments: [
            ButtonSegment<int>(
              value: 0,
              label: Text(isMobile ? 'Experts' : 'Experts Directory & Pricing (${_roster.length})'),
              icon: const Icon(Icons.people_alt_rounded, size: 16),
            ),
            ButtonSegment<int>(
              value: 1,
              label: Text(isMobile ? 'Live Calls' : 'Booked Sessions Queue (${_sessions.length})'),
              icon: const Icon(Icons.support_agent_rounded, size: 16),
            ),
            ButtonSegment<int>(
              value: 2,
              label: Text(isMobile ? '50-50' : '50-50 Revenue Ledger'),
              icon: const Icon(Icons.handshake_rounded, size: 16),
            ),
          ],
          selected: {_activeAdminTab},
          onSelectionChanged: (set) => setState(() => _activeAdminTab = set.first),
        ),

        // Add Expert Button
        ElevatedButton.icon(
          onPressed: () => _showAddExpertModal(context),
          icon: const Icon(Icons.person_add_rounded, size: 16),
          label: Text(isMobile ? 'Add Expert' : 'Onboard New Expert'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildExpertsDirectory(List<DesignerConsultant> roster, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search & Filter controls
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search expert by name, specialization, or qualification...',
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<DesignerAvailability?>(
              value: _filterAvailability,
              hint: const Text('All Statuses', style: TextStyle(fontSize: 12)),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Statuses')),
                ...DesignerAvailability.values.map(
                  (a) => DropdownMenuItem(value: a, child: Text(a.label)),
                ),
              ],
              onChanged: (val) => setState(() => _filterAvailability = val),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Experts Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 580,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.25 : 1.6,
          ),
          itemCount: roster.length,
          itemBuilder: (context, i) {
            final designer = roster[i];
            return _buildAdminExpertCard(designer, isDark);
          },
        ),
      ],
    );
  }

  Widget _buildAdminExpertCard(DesignerConsultant d, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  d.avatarUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 54,
                    height: 54,
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                    child: const Icon(Icons.person_rounded, color: Color(0xFF7C3AED)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            d.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status badge with click-to-toggle
                        InkWell(
                          onTap: () => _toggleExpertStatus(d),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: d.availability.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  d.availability.label.split(' ').first,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: d.availability.color,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(Icons.sync_alt_rounded, size: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      d.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                    Text(
                      d.qualification,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Price Tag + Experience
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Price: ₹${d.sessionFee.toInt()} / 30m',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${d.yearsExperience} Yrs • ★ ${d.rating} • ${d.totalConsultations} Consults',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Specializations
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: d.specializations.map((spec) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  spec,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),

          const Spacer(),

          // Admin Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showEditPriceModal(d),
                    icon: const Icon(Icons.edit_rounded, size: 14),
                    label: const Text('Set Price & Info'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _deleteExpert(d),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                    tooltip: 'Remove Expert',
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _supervisingDesigner = d);
                },
                icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
                label: const Text('Audit Room'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsQueue(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booked Video Consultation Sessions & Active Meetings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sessions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final s = _sessions[i];
            final isActive = s.status == 'Active / In Progress';

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF10B981).withValues(alpha: 0.6)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  width: isActive ? 1.8 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : const Color(0xFF6366F1).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isActive ? Icons.videocam_rounded : Icons.calendar_today_rounded,
                      color: isActive ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              s.clientName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                    : const Color(0xFF6366F1).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                s.status,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isActive ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Expert Assigned: ${s.expert.name} (${s.expert.title}) • Phone: ${s.clientPhone}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Fee Paid: ₹${s.feePaid.toInt()} (Split: ₹${(s.feePaid * 0.5).toInt()} Platform / ₹${(s.feePaid * 0.5).toInt()} Designer)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _supervisingDesigner = s.expert);
                    },
                    icon: const Icon(Icons.video_call_rounded, size: 16),
                    label: Text(isActive ? 'Enter Live Room' : 'Join as Supervisor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? const Color(0xFF10B981) : const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRevenueSettlements(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50-50 Platform & Designer Revenue Sharing Ledger',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const RevenueShareBadge(),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              ),
              columns: const [
                DataColumn(label: Text('Session ID')),
                DataColumn(label: Text('Client')),
                DataColumn(label: Text('Expert Designer')),
                DataColumn(label: Text('Total Paid')),
                DataColumn(label: Text('Platform (50%)')),
                DataColumn(label: Text('Designer (50%)')),
                DataColumn(label: Text('Status')),
              ],
              rows: _sessions.map((s) {
                final half = s.feePaid * 0.5;
                return DataRow(
                  cells: [
                    DataCell(Text(s.id, style: const TextStyle(fontWeight: FontWeight.w700))),
                    DataCell(Text(s.clientName)),
                    DataCell(Text(s.expert.name)),
                    DataCell(Text('₹${s.feePaid.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800))),
                    DataCell(Text('₹${half.toInt()}', style: const TextStyle(color: Color(0xFF10B981)))),
                    DataCell(Text('₹${half.toInt()}', style: const TextStyle(color: Color(0xFF8B5CF6)))),
                    DataCell(Text(s.status)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpertModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final titleCtrl = TextEditingController(text: 'Senior Interior Architect');
    final qualCtrl = TextEditingController(text: 'B.Arch, Council of Architecture');
    final expCtrl = TextEditingController(text: '8');
    final feeCtrl = TextEditingController(text: '300');
    final specCtrl = TextEditingController(text: 'Luxury Contemporary, Modular Kitchen, Vastu');
    DesignerAvailability avail = DesignerAvailability.online;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.person_add_rounded, color: Color(0xFF7C3AED), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Onboard New Expert & Set Price',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModalField('EXPERT FULL NAME', nameCtrl, 'e.g. Ar. Ananya Roy'),
                      const SizedBox(height: 10),
                      _buildModalField('TITLE / DESIGNATION', titleCtrl, 'e.g. Principal Architect'),
                      const SizedBox(height: 10),
                      _buildModalField('QUALIFICATION', qualCtrl, 'e.g. B.Arch (SPA Delhi)'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalField('YEARS EXPERIENCE', expCtrl, 'e.g. 8', isNumber: true),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModalField('SESSION PRICE (₹)', feeCtrl, '300', isNumber: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildModalField('SPECIALIZATIONS (COMMA-SEPARATED)', specCtrl, 'Modular Kitchen, Vastu, Turnkey'),
                      const SizedBox(height: 12),
                      Text(
                        'AVAILABILITY STATUS:',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButton<DesignerAvailability>(
                        value: avail,
                        isExpanded: true,
                        items: DesignerAvailability.values.map((a) {
                          return DropdownMenuItem(value: a, child: Text(a.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => avail = val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;

                    final newExp = DesignerConsultant(
                      id: 'DES-${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      title: titleCtrl.text.trim(),
                      qualification: qualCtrl.text.trim(),
                      rating: 4.95,
                      totalConsultations: 0,
                      yearsExperience: int.tryParse(expCtrl.text) ?? 5,
                      availability: avail,
                      avatarUrl:
                          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
                      specializations: specCtrl.text.split(',').map((s) => s.trim()).toList(),
                      sessionFee: double.tryParse(feeCtrl.text) ?? 300.0,
                    );

                    setState(() {
                      _roster.add(newExp);
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Expert ${newExp.name} added at ₹${newExp.sessionFee.toInt()} session fee!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save & Publish to Client App'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditPriceModal(DesignerConsultant d) {
    final feeCtrl = TextEditingController(text: d.sessionFee.toInt().toString());
    final titleCtrl = TextEditingController(text: d.title);
    DesignerAvailability avail = d.availability;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Edit Price & Profile for ${d.name}',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModalField('CONSULTATION SESSION FEE (₹)', feeCtrl, '300', isNumber: true),
                  const SizedBox(height: 12),
                  _buildModalField('TITLE / POSITION', titleCtrl, d.title),
                  const SizedBox(height: 12),
                  Text(
                    'AVAILABILITY STATUS:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButton<DesignerAvailability>(
                    value: avail,
                    isExpanded: true,
                    items: DesignerAvailability.values.map((a) {
                      return DropdownMenuItem(value: a, child: Text(a.label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => avail = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final newFee = double.tryParse(feeCtrl.text) ?? d.sessionFee;
                    final idx = _roster.indexWhere((item) => item.id == d.id);
                    if (idx != -1) {
                      setState(() {
                        _roster[idx] = d.copyWith(
                          sessionFee: newFee,
                          title: titleCtrl.text.trim(),
                          availability: avail,
                        );
                      });
                    }
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updated ${d.name} price to ₹${newFee.toInt()} and status to ${avail.label}'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update Price & Status'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleExpertStatus(DesignerConsultant d) {
    final idx = _roster.indexWhere((item) => item.id == d.id);
    if (idx == -1) return;

    final nextAvail = d.availability == DesignerAvailability.online
        ? DesignerAvailability.inCall
        : (d.availability == DesignerAvailability.inCall
            ? DesignerAvailability.offline
            : DesignerAvailability.online);

    setState(() {
      _roster[idx] = d.copyWith(availability: nextAvail);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${d.name} status switched to ${nextAvail.label}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteExpert(DesignerConsultant d) {
    setState(() {
      _roster.removeWhere((item) => item.id == d.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${d.name} removed from active expert roster'),
      ),
    );
  }

  Widget _buildModalField(String label, TextEditingController ctrl, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }
}
