import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/platform_property_listing_model.dart';
import '../queries/platform_marketplace_queries.dart';
import '../widgets/property_verification_dialog.dart';

class PlatformPropertiesPage extends StatefulWidget {
  const PlatformPropertiesPage({super.key});

  @override
  State<PlatformPropertiesPage> createState() => _PlatformPropertiesPageState();
}

class _PlatformPropertiesPageState extends State<PlatformPropertiesPage> {
  final PlatformMarketplaceQueries _queries = PlatformMarketplaceQueries();
  String _selectedStatus = 'UNDER_REVIEW';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  static const List<Map<String, String>> _statusTabs = [
    {'value': 'UNDER_REVIEW', 'label': 'Under Review (Pending)'},
    {'value': 'VERIFIED', 'label': 'Verified'},
    {'value': 'REJECTED', 'label': 'Rejected'},
    {'value': 'ALL', 'label': 'All Properties'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _inspectProperty(PlatformPropertyListingModel property) {
    showDialog(
      context: context,
      builder: (context) => PropertyVerificationDialog(
        property: property,
        onUpdateStatus: (newStatus) async {
          await _queries.getVerifyPropertyMutation().mutate(
            (id: property.id, status: newStatus),
          );
        },
      ),
    );
  }

  Future<void> _quickVerify(PlatformPropertyListingModel property) async {
    await _queries.getVerifyPropertyMutation().mutate(
      (id: property.id, status: 'VERIFIED'),
    );
  }

  Future<void> _quickReject(PlatformPropertyListingModel property) async {
    await _queries.getVerifyPropertyMutation().mutate(
      (id: property.id, status: 'REJECTED'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final propertiesQuery = _queries.getPropertiesQuery(
      verificationStatus: _selectedStatus == 'ALL' ? null : _selectedStatus,
      search: _searchQuery.isEmpty ? null : _searchQuery,
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
                      'Real Estate Property Verifications',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Inspect property listings submitted by organizations and issue official verification badges',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh queue',
                  onPressed: () => propertiesQuery.refetch(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusTabs.map((tab) {
                  final isSelected = _selectedStatus == tab['value'];
                  final isPending = tab['value'] == 'UNDER_REVIEW';

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: isPending
                          ? const Icon(Icons.hourglass_top_rounded, size: 16, color: Colors.amber)
                          : null,
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
                          setState(() => _selectedStatus = tab['value']!);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Search Filter
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Search by title, locality, city...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
            ),
            const SizedBox(height: 18),

            // Properties List
            Expanded(
              child: QueryBuilder(
                query: propertiesQuery,
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
                            'Failed to load properties',
                            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => propertiesQuery.refetch(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final list = state.data?.items ?? [];
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 48,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No properties in this status',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedStatus == 'UNDER_REVIEW'
                                ? 'All property verifications are up to date!'
                                : 'Try changing your search filter',
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
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Thumbnail / Icon
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Color(0xFF8B5CF6),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Listing Summary
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildStatusBadge(item.verificationStatus),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.bhk} • ${item.carpetAreaSqft.toStringAsFixed(0)} sq.ft • ${item.locality}, ${item.city} • ₹${item.price.toStringAsFixed(0)}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Submitted by Organization: ${item.organizationName} • Unlock fee: ₹${item.contactUnlockFee.toStringAsFixed(0)}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Action buttons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _inspectProperty(item),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('Inspect', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                                ),
                                if (item.verificationStatus != 'VERIFIED') ...[
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                                    label: Text(
                                      'Verify',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                    onPressed: () => _quickVerify(item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
                                if (item.verificationStatus != 'REJECTED') ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, color: Colors.red, size: 18),
                                    tooltip: 'Reject',
                                    onPressed: () => _quickReject(item),
                                  ),
                                ],
                              ],
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

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'VERIFIED':
        bg = const Color(0xFF10B981).withValues(alpha: 0.12);
        fg = const Color(0xFF10B981);
        label = 'Verified';
        break;
      case 'REJECTED':
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red;
        label = 'Rejected';
        break;
      case 'UNDER_REVIEW':
      default:
        bg = Colors.amber.withValues(alpha: 0.15);
        fg = Colors.amber.shade800;
        label = 'Under Review';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
