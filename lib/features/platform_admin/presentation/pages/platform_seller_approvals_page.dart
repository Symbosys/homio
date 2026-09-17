import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/platform_seller_application_model.dart';
import '../queries/platform_marketplace_queries.dart';
import '../widgets/review_seller_application_dialog.dart';

class PlatformSellerApprovalsPage extends StatefulWidget {
  const PlatformSellerApprovalsPage({super.key});

  @override
  State<PlatformSellerApprovalsPage> createState() => _PlatformSellerApprovalsPageState();
}

class _PlatformSellerApprovalsPageState extends State<PlatformSellerApprovalsPage> {
  final PlatformMarketplaceQueries _queries = PlatformMarketplaceQueries();
  String _selectedFilter = 'PENDING';

  static const List<Map<String, String>> _filterTabs = [
    {'value': 'PENDING', 'label': 'Pending Approval'},
    {'value': 'APPROVED', 'label': 'Approved Sellers'},
    {'value': 'ALL', 'label': 'All Registrations'},
  ];

  void _openReviewDialog(PlatformSellerApplicationModel app) {
    showDialog(
      context: context,
      builder: (context) => ReviewSellerApplicationDialog(
        application: app,
        onReview: (isApproved, commissionRate) async {
          await _queries.getReviewSellerApplicationMutation().mutate((
            id: app.id,
            isApproved: isApproved,
            commissionRate: commissionRate,
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool? isApprovedParam;
    if (_selectedFilter == 'PENDING') isApprovedParam = false;
    if (_selectedFilter == 'APPROVED') isApprovedParam = true;

    final appsQuery = _queries.getSellerApplicationsQuery(
      isApproved: isApprovedParam,
    );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller Category Approvals',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review tenant organization applications to sell under marketplace categories and set platform commission',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh applications',
                  onPressed: () => appsQuery.refetch(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterTabs.map((tab) {
                  final isSelected = _selectedFilter == tab['value'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        tab['label']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF8B5CF6),
                      backgroundColor:
                          isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = tab['value']!);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Applications List
            Expanded(
              child: QueryBuilder(
                query: appsQuery,
                builder: (context, state) {
                  if (state.data == null && state.error == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                    );
                  }

                  if (state.error != null && state.data == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load applications',
                            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => appsQuery.refetch(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final list = state.data ?? [];
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.how_to_reg_outlined,
                            size: 48,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No applications in this view',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedFilter == 'PENDING'
                                ? 'No pending seller applications awaiting review!'
                                : 'Try changing your filter',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.storefront_rounded, color: Color(0xFF8B5CF6), size: 22),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.organizationName,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: item.isApproved
                                              ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                              : Colors.amber.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.isApproved ? 'Approved' : 'Pending',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: item.isApproved ? const Color(0xFF10B981) : Colors.amber.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Requested Category: ${item.categoryName} (${item.marketplaceType}) • Platform Commission: ${item.commissionRate != null ? '${item.commissionRate!.toStringAsFixed(1)}%' : 'Not Set'}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.tune_rounded, size: 15),
                              label: Text(
                                item.isApproved ? 'Edit Commission' : 'Review & Approve',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () => _openReviewDialog(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B5CF6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
