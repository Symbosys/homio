import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/labour_card.dart';
import '../widgets/labour_profile_drawer.dart';
import '../widgets/hire_labour_modal.dart';

class LabourDirectoryPage extends StatefulWidget {
  const LabourDirectoryPage({super.key});

  @override
  State<LabourDirectoryPage> createState() => _LabourDirectoryPageState();
}

class _LabourDirectoryPageState extends State<LabourDirectoryPage> {
  final List<LabourProfile> _workers = List.from(LabourMockData.profiles);
  String _searchQuery = '';
  TradeType? _selectedTrade;
  LabourStatus? _selectedStatus;
  KycStatus? _selectedKycStatus;
  bool _isTableView = true;
  String _sortBy = 'Rating (High to Low)';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    // Filter workers
    var filtered = _workers.where((w) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = w.legalName.toLowerCase().contains(q) || w.alias.toLowerCase().contains(q);
        final matchesId = w.id.toLowerCase().contains(q);
        final matchesPhone = w.phone.contains(q);
        final matchesTrade = w.trade.label.toLowerCase().contains(q);
        final matchesCity = w.city.toLowerCase().contains(q) || w.zone.toLowerCase().contains(q);
        if (!matchesName && !matchesId && !matchesPhone && !matchesTrade && !matchesCity) return false;
      }
      if (_selectedTrade != null && w.trade != _selectedTrade) return false;
      if (_selectedStatus != null && w.labourStatus != _selectedStatus) return false;
      if (_selectedKycStatus != null && w.kycStatus != _selectedKycStatus) return false;
      return true;
    }).toList();

    // Sort workers
    if (_sortBy == 'Rating (High to Low)') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Daily Rate (Low to High)') {
      filtered.sort((a, b) => a.dailyRate.compareTo(b.dailyRate));
    } else if (_sortBy == 'Completed Jobs') {
      filtered.sort((a, b) => b.completedJobs.compareTo(a.completedJobs));
    } else if (_sortBy == 'Punctuality Score') {
      filtered.sort((a, b) => b.punctualityScore.compareTo(a.punctualityScore));
    }

    final totalVerified = _workers.where((w) => w.kycStatus == KycStatus.approved).length;
    final onSiteCount = _workers.where((w) => w.labourStatus == LabourStatus.onSite).length;
    final availableCount = _workers.where((w) => w.labourStatus == LabourStatus.available).length;
    final blacklistedCount = _workers.where((w) => w.labourStatus == LabourStatus.blacklisted).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Skilled Labour & Tradesperson Directory',
              subtitle: 'Comprehensive registry of verified independent tradespeople, trade skill levels, daily rates, and live operational status.',
              activeTab: 'Labour Directory',
              trailing: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Labour directory export generated: CSV & PDF download started.')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Export Directory'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _openBroadcastModal(context),
                    icon: const Icon(Icons.podcasts_rounded, size: 16),
                    label: const Text('Broadcast Job Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
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
                            _buildKpiCard('Total Verified Tradesmen', '$totalVerified Active', 'Aadhaar & Police Cleared', Icons.verified_user_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiCard('Active On-Site Jobs', '$onSiteCount Deployed', 'Live GPS Tracking', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiCard('Available Immediately', '$availableCount Workers', 'Ready for Dispatch', Icons.bolt_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiCard('Locked / Flagged', '$blacklistedCount Blacklisted', 'Disciplinary Restrictions', Icons.block_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpiCard('Total Verified Tradesmen', '$totalVerified Active', 'Aadhaar & Police Cleared', Icons.verified_user_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiCard('Active On-Site Jobs', '$onSiteCount Deployed', 'Live GPS Tracking', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiCard('Available Immediately', '$availableCount Workers', 'Ready for Dispatch', Icons.bolt_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiCard('Locked / Flagged', '$blacklistedCount Blacklisted', 'Disciplinary Restrictions', Icons.block_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filter Toolbar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Row
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search by labour name, alias, ID, phone, trade, or operating location...',
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
                              child: DropdownButtonFormField<LabourStatus?>(
                                initialValue: _selectedStatus,
                                decoration: InputDecoration(
                                  labelText: 'Availability',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Availability')),
                                  ...LabourStatus.values.map((st) => DropdownMenuItem(value: st, child: Text(st.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedStatus = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<KycStatus?>(
                                initialValue: _selectedKycStatus,
                                decoration: InputDecoration(
                                  labelText: 'KYC Status',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All KYC Status')),
                                  ...KycStatus.values.map((k) => DropdownMenuItem(value: k, child: Text(k.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedKycStatus = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: _sortBy,
                                decoration: InputDecoration(
                                  labelText: 'Sort By',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Rating (High to Low)', child: Text('Rating (High-Low)')),
                                  DropdownMenuItem(value: 'Daily Rate (Low to High)', child: Text('Rate (Low-High)')),
                                  DropdownMenuItem(value: 'Completed Jobs', child: Text('Completed Jobs')),
                                  DropdownMenuItem(value: 'Punctuality Score', child: Text('Punctuality Score')),
                                ],
                                onChanged: (val) => setState(() => _sortBy = val ?? 'Rating (High to Low)'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // View Switcher Toggle
                            Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Table View',
                                    icon: Icon(Icons.table_chart_outlined, size: 20, color: _isTableView ? AppColors.primary : textSecondaryColor),
                                    onPressed: () => setState(() => _isTableView = true),
                                  ),
                                  IconButton(
                                    tooltip: 'Grid Card View',
                                    icon: Icon(Icons.grid_view_rounded, size: 20, color: !_isTableView ? AppColors.primary : textSecondaryColor),
                                    onPressed: () => setState(() => _isTableView = false),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Trade Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChip(
                                label: const Text('All Trades'),
                                selected: _selectedTrade == null,
                                onSelected: (_) => setState(() => _selectedTrade = null),
                                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                                checkmarkColor: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              ...TradeType.values.map((t) {
                                final isSelected = _selectedTrade == t;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    avatar: Icon(t.icon, size: 16, color: isSelected ? t.color : textSecondaryColor),
                                    label: Text(t.label),
                                    selected: isSelected,
                                    onSelected: (_) => setState(() => _selectedTrade = isSelected ? null : t),
                                    selectedColor: t.color.withValues(alpha: 0.15),
                                    checkmarkColor: t.color,
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

                  // Results Count & Active SLA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${filtered.length} Tradespeople in Directory',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 16, color: Color(0xFF10B981)),
                          SizedBox(width: 6),
                          Text(
                            '100% Aadhaar Verified & Insured Workforce',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main View: Table vs Card Grid
                  if (filtered.isEmpty)
                    _buildEmptyState(surfaceColor, borderColor, textPrimaryColor, textSecondaryColor)
                  else if (_isTableView)
                    _buildEnterpriseTable(filtered, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor)
                  else
                    _buildCardGrid(filtered),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
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
                Text(title, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterpriseTable(List<LabourProfile> workers, Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
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
          columnSpacing: 24,
          headingRowColor: WidgetStatePropertyAll(surfaceColor),
          columns: const [
            DataColumn(label: Text('Labour & ID', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Trade & Skill', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Location / Zone', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('KYC Verification', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Availability', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Rating (CSAT)', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Jobs Done', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Daily Rate', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Current Assignment', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
          ],
          rows: workers.map((w) {
            return DataRow(
              cells: [
                // Labour Name + Photo
                DataCell(
                  InkWell(
                    onTap: () => _openProfileDrawer(context, w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            w.photoUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 28),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(w.legalName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                            Text('${w.id} • ${w.phone}', style: TextStyle(fontSize: 11, color: textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Trade & Skill Level
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(w.trade.icon, size: 14, color: w.trade.color),
                          const SizedBox(width: 6),
                          Text(w.trade.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                        ],
                      ),
                      Text(w.skillLevel.label, style: TextStyle(fontSize: 10, color: textSecondary)),
                    ],
                  ),
                ),
                // Location
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(w.city, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                      Text('${w.distanceKm} km away', style: TextStyle(fontSize: 10, color: textSecondary)),
                    ],
                  ),
                ),
                // KYC
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: w.kycStatus.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      w.kycStatus.label,
                      style: TextStyle(color: w.kycStatus.color, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                // Availability
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: w.labourStatus.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      w.labourStatus.label,
                      style: TextStyle(color: w.labourStatus.color, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                // Rating
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${w.rating}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text(' (${w.totalReviews})', style: TextStyle(fontSize: 10, color: textSecondary)),
                    ],
                  ),
                ),
                // Jobs Done
                DataCell(Text('${w.completedJobs} Jobs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary))),
                // Daily Rate
                DataCell(
                  Text('₹${w.dailyRate.toInt()}/day', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                ),
                // Current Assignment
                DataCell(
                  Text(
                    w.currentSiteAssigned.isNotEmpty ? w.currentSiteAssigned : '— None —',
                    style: TextStyle(fontSize: 11, color: w.currentSiteAssigned.isNotEmpty ? AppColors.primary : textSecondary),
                  ),
                ),
                // Actions
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'View Profile',
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        onPressed: () => _openProfileDrawer(context, w),
                      ),
                      IconButton(
                        tooltip: 'Assign Job',
                        icon: const Icon(Icons.add_task_rounded, size: 18, color: AppColors.primary),
                        onPressed: () => _openHireModal(context, w),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCardGrid(List<LabourProfile> workers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : (constraints.maxWidth > 768 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 460,
          ),
          itemCount: workers.length,
          itemBuilder: (context, index) {
            final worker = workers[index];
            return LabourCard(
              worker: worker,
              onBook: () => _openHireModal(context, worker),
              onViewDetails: () => _openProfileDrawer(context, worker),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(Color bg, Color border, Color textPrimary, Color textSecondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_search_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 14),
          Text('No Tradespeople Match Selected Criteria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 6),
          Text('Try clearing the trade or location filters to see more profiles.', style: TextStyle(fontSize: 12, color: textSecondary)),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedTrade = null;
                _selectedStatus = null;
                _selectedKycStatus = null;
              });
            },
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  void _openProfileDrawer(BuildContext context, LabourProfile worker) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ProfileDrawer',
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: LabourProfileDrawer(
            worker: worker,
            onAssignJob: () {
              Navigator.pop(ctx);
              _openHireModal(context, worker);
            },
            onViewKyc: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing KYC verification record for ${worker.legalName}')),
              );
            },
            onViewRatings: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening reviews feed for ${worker.legalName}')),
              );
            },
            onToggleBlacklist: () {
              Navigator.pop(ctx);
              setState(() {
                final idx = _workers.indexWhere((w) => w.id == worker.id);
                if (idx != -1) {
                  final newStatus = worker.labourStatus == LabourStatus.blacklisted
                      ? LabourStatus.available
                      : LabourStatus.blacklisted;
                  _workers[idx] = worker.copyWith(labourStatus: newStatus);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Updated blacklist state for ${worker.legalName}')),
              );
            },
          ),
        );
      },
    );
  }

  void _openHireModal(BuildContext context, LabourProfile worker) {
    showDialog(
      context: context,
      builder: (ctx) => HireLabourModal(
        selectedWorker: worker,
        onBookingCreated: (newBooking) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking ${newBooking.bookingNumber} created for ${worker.legalName}.')),
          );
        },
      ),
    );
  }

  void _openBroadcastModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => HireLabourModal(
        onBookingCreated: (newBooking) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Open broadcast job ${newBooking.bookingNumber} dispatched.')),
          );
        },
      ),
    );
  }
}
