import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/labour_card.dart';
import '../widgets/hire_labour_modal.dart';
import '../widgets/labour_id_card_modal.dart';

class HireLabourPage extends StatefulWidget {
  const HireLabourPage({super.key});

  @override
  State<HireLabourPage> createState() => _HireLabourPageState();
}

class _HireLabourPageState extends State<HireLabourPage> {
  final List<LabourProfile> _workers = List.from(LabourMockData.profiles);
  String _searchQuery = '';
  TradeType? _selectedTrade;
  LabourStatus? _selectedStatus;
  final double _minRating = 0.0;
  String _sortBy = 'Rating (High to Low)';

  @override
  Widget build(BuildContext context) {
    // Filter workers
    var filtered = _workers.where((w) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = w.legalName.toLowerCase().contains(q);
        final matchesTrade = w.trade.label.toLowerCase().contains(q);
        final matchesCity = w.city.toLowerCase().contains(q) || w.zone.toLowerCase().contains(q);
        if (!matchesName && !matchesTrade && !matchesCity) return false;
      }
      if (_selectedTrade != null && w.trade != _selectedTrade) return false;
      if (_selectedStatus != null && w.labourStatus != _selectedStatus) return false;
      if (w.rating < _minRating) return false;
      return true;
    }).toList();

    // Sort workers
    if (_sortBy == 'Rating (High to Low)') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Daily Rate (Low to High)') {
      filtered.sort((a, b) => a.dailyRate.compareTo(b.dailyRate));
    } else if (_sortBy == 'Punctuality Score') {
      filtered.sort((a, b) => b.punctualityScore.compareTo(a.punctualityScore));
    } else if (_sortBy == 'Distance (Nearest First)') {
      filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    final totalVerified = _workers.where((w) => w.kycStatus == KycStatus.approved).length;
    final onSiteCount = _workers.where((w) => w.labourStatus == LabourStatus.onSite).length;
    final availableToday = _workers.where((w) => w.labourStatus == LabourStatus.available).length;
    final avgRating = _workers.map((w) => w.rating).reduce((a, b) => a + b) / _workers.length;

    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Hire On-Demand Skilled Labour',
              subtitle: 'Search, evaluate, and dispatch pre-vetted trade contractors with biometric KYC verification and SLA guarantees.',
              activeTab: 'Hire Labour Marketplace',
              trailing: ElevatedButton.icon(
                onPressed: () => _openBroadcastModal(context),
                icon: const Icon(Icons.podcasts_rounded, size: 16),
                label: const Text('Broadcast Open Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Scoreboard
                  Row(
                    children: [
                      _buildMetricCard(
                        title: 'Total Verified Tradesmen',
                        value: '$totalVerified Workers',
                        subtitle: '100% Aadhaar & Police cleared',
                        icon: Icons.verified_user_rounded,
                        color: const Color(0xFF10B981),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Active Deployments',
                        value: '$onSiteCount On Site',
                        subtitle: 'GPS tracked attendance',
                        icon: Icons.engineering_rounded,
                        color: const Color(0xFF3B82F6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Available Immediately',
                        value: '$availableToday Available',
                        subtitle: 'Ready within 15 min dispatch',
                        icon: Icons.electric_bolt_rounded,
                        color: const Color(0xFFF59E0B),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Average CSAT Rating',
                        value: '${avgRating.toStringAsFixed(2)} ★',
                        subtitle: 'From 400+ client reviews',
                        icon: Icons.star_rounded,
                        color: const Color(0xFF8B5CF6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search and Filter Bar
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
                        // Search Row + Sort Dropdown
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search by tradesman name, trade specialization, skill badges, or location...',
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
                              flex: 3,
                              child: DropdownButtonFormField<String>(
                                initialValue: _sortBy,
                                decoration: InputDecoration(
                                  labelText: 'Sort By',
                                  prefixIcon: const Icon(Icons.sort_rounded, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Rating (High to Low)', child: Text('Rating (High to Low)')),
                                  DropdownMenuItem(value: 'Daily Rate (Low to High)', child: Text('Daily Rate (Low to High)')),
                                  DropdownMenuItem(value: 'Punctuality Score', child: Text('Punctuality Score')),
                                  DropdownMenuItem(value: 'Distance (Nearest First)', child: Text('Distance (Nearest First)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _sortBy = val);
                                },
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
                                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                                  ...LabourStatus.values.map((st) {
                                    return DropdownMenuItem(value: st, child: Text(st.label));
                                  }),
                                ],
                                onChanged: (val) => setState(() => _selectedStatus = val),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

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

                  // Results Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${filtered.length} Tradesmen Matching Criteria',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const Text(
                        '15-Min Auto-Reassignment SLA Active',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Worker Cards Grid
                  LayoutBuilder(
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
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final worker = filtered[index];
                          return LabourCard(
                            worker: worker,
                            onBook: () => _openHireModal(context, worker),
                            onViewDetails: () => _openIdCardModal(context, worker),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color textMutedColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
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
                  Text(title, style: TextStyle(fontSize: 11, color: textMutedColor)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openHireModal(BuildContext context, LabourProfile worker) {
    showDialog(
      context: context,
      builder: (ctx) => HireLabourModal(
        selectedWorker: worker,
        onBookingCreated: (newBooking) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking ${newBooking.bookingNumber} created and dispatched to ${worker.legalName}.')),
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
            SnackBar(content: Text('Open broadcast job ${newBooking.bookingNumber} dispatched to all matching workers.')),
          );
        },
      ),
    );
  }

  void _openIdCardModal(BuildContext context, LabourProfile worker) {
    showDialog(
      context: context,
      builder: (ctx) => LabourIdCardModal(worker: worker),
    );
  }
}
