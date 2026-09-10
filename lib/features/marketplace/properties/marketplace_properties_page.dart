import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_domain_models.dart';
import '../domain/marketplace_enums.dart';
import '../widgets/marketplace_attention_panel.dart';
import '../widgets/marketplace_data_table.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_metric_card.dart';
import '../widgets/marketplace_status_badge.dart';
import '../widgets/property_listing_wizard_dialog.dart';
import '../widgets/property_unlock_detail_modal.dart';
import '../widgets/property_verification_dialog.dart';

class MarketplacePropertiesPage extends StatefulWidget {
  const MarketplacePropertiesPage({super.key});

  @override
  State<MarketplacePropertiesPage> createState() => _MarketplacePropertiesPageState();
}

class _MarketplacePropertiesPageState extends State<MarketplacePropertiesPage> {
  final _repo = MarketplaceRepository();
  final _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedType = 'all';
  String _selectedIntent = 'all';
  String _selectedVerifStatus = 'all';
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<PropertyListingEntity> get _filteredProperties {
    return _repo.properties.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = p.title.toLowerCase().contains(q);
        final matchLocality = p.locality.toLowerCase().contains(q);
        final matchCity = p.city.toLowerCase().contains(q);
        if (!matchTitle && !matchLocality && !matchCity) return false;
      }
      if (_selectedType != 'all' && p.propertyType.name.toLowerCase() != _selectedType.toLowerCase()) {
        return false;
      }
      if (_selectedIntent != 'all' && p.intent.name.toLowerCase() != _selectedIntent.toLowerCase()) {
        return false;
      }
      if (_selectedVerifStatus != 'all' && p.verificationStatus.name.toLowerCase() != _selectedVerifStatus.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openCreateWizard() {
    PropertyListingWizardDialog.show(context);
  }

  void _openEditWizard(PropertyListingEntity property) {
    PropertyListingWizardDialog.show(context, propertyToEdit: property);
  }

  void _openVerificationDialog(PropertyListingEntity property) {
    PropertyVerificationDialog.show(context, property);
  }

  void _openUnlockModal(PropertyListingEntity property) {
    final tx = _repo.unlockTransactions.firstWhere(
      (t) => t.propertyId == property.id,
      orElse: () => _repo.unlockTransactions.first,
    );
    PropertyUnlockDetailModal.show(context, tx);
  }

  void _confirmDelist(PropertyListingEntity property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text('Delist Property', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.warning)),
        content: Text(
          'Delisting "${property.title}" will hide it from buyer discovery feeds. Existing paid unlock buyers will retain access.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.lightTextMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () {
              Navigator.of(ctx).pop();
              _repo.verifyProperty(property.id, PropertyVerificationStatus.expired, 'Delisted by admin');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Property "${property.title}" has been delisted.'),
                  backgroundColor: AppColors.warning,
                ),
              );
            },
            child: Text('Confirm Delist', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final allProperties = _repo.properties;
    final verifiedCount = allProperties.where((p) => p.verificationStatus == PropertyVerificationStatus.verified).length;
    final totalUnlocks = allProperties.fold<int>(0, (sum, p) => sum + p.totalContactUnlocks);
    final totalUnlockRevenue = totalUnlocks * _repo.config.propertyUnlockFee;
    final pendingCount = allProperties.where((p) => p.verificationStatus == PropertyVerificationStatus.submitted || p.verificationStatus == PropertyVerificationStatus.inProgress).length;

    final filtered = _filteredProperties;
    final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paginatedItems = filtered.skip(startIndex).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            MarketplaceHeader(
              title: 'Verified Property Discovery Operations',
              subtitle: 'Manage verified rentals, resale properties, title deed audits, surveyor checklists & ₹500 contact unlock paywalls',
              icon: Icons.villa_rounded,
              actions: [
                OutlinedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: Icon(Icons.refresh_rounded, size: 16, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  label: Text('Refresh', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    side: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: _openCreateWizard,
                  icon: const Icon(Icons.add_home_work_outlined, size: 18, color: Colors.white),
                  label: Text('New Property Listing', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Attention Notice
            MarketplaceAttentionPanel(
              alerts: [
                if (pendingCount > 0)
                  MarketplaceAlertItem(
                    title: '$pendingCount Properties Pending Verification',
                    description: 'Properties require physical engineer site inspection and municipal legal title deed verification before receiving a verified badge.',
                    count: pendingCount,
                    icon: Icons.verified_user_outlined,
                    severityColor: AppColors.warning,
                    actionLabel: 'Filter Pending',
                    onAction: () {
                      setState(() {
                        _selectedVerifStatus = 'pendingverification';
                        _currentPage = 1;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Metrics Grid
            LayoutBuilder(
              builder: (ctx, constraints) {
                final crossAxisCount = isDesktop ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: isDesktop ? 2.3 : 2.6,
                  children: [
                    MarketplaceMetricCard(
                      title: 'Total Listings',
                      value: '${allProperties.length}',
                      subtitle: '$verifiedCount verified • $pendingCount under audit',
                      icon: Icons.home_work_outlined,
                      accentColor: AppColors.primary,
                    ),
                    MarketplaceMetricCard(
                      title: 'Verified & Active',
                      value: '$verifiedCount',
                      subtitle: '${((verifiedCount / (allProperties.isEmpty ? 1 : allProperties.length)) * 100).toStringAsFixed(0)}% verification rate',
                      icon: Icons.verified_rounded,
                      accentColor: AppColors.success,
                    ),
                    MarketplaceMetricCard(
                      title: 'Contact Unlocks (₹500)',
                      value: '$totalUnlocks',
                      subtitle: 'Direct owner contact leads sold',
                      icon: Icons.lock_open_rounded,
                      accentColor: AppColors.info,
                    ),
                    MarketplaceMetricCard(
                      title: 'Unlock Revenue',
                      value: '₹${totalUnlockRevenue.toStringAsFixed(0)}',
                      subtitle: '+18% GST: ₹${(totalUnlockRevenue * 0.18).toStringAsFixed(0)}',
                      icon: Icons.monetization_on_outlined,
                      accentColor: AppColors.warning,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Filter Bar
            MarketplaceFilterBar(
              searchController: _searchCtrl,
              searchHint: 'Search properties by title, locality, city...',
              onSearchChanged: (val) => setState(() {
                _searchQuery = val;
                _currentPage = 1;
              }),
              totalCount: filtered.length,
              entityLabel: 'Properties',
              onClear: () => setState(() {
                _searchCtrl.clear();
                _searchQuery = '';
                _selectedType = 'all';
                _selectedIntent = 'all';
                _selectedVerifStatus = 'all';
                _currentPage = 1;
              }),
              filterDropdowns: [
                DropdownButton<String>(
                  value: _selectedType,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Types')),
                    DropdownMenuItem(value: 'luxuryapartment', child: Text('Luxury Apartment')),
                    DropdownMenuItem(value: 'penthouse', child: Text('Penthouse')),
                    DropdownMenuItem(value: 'builderfloor', child: Text('Builder Floor')),
                    DropdownMenuItem(value: 'villa', child: Text('Gated Villa')),
                    DropdownMenuItem(value: 'commercialoffice', child: Text('Commercial Office')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedType = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedIntent,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Intents')),
                    DropdownMenuItem(value: 'rent', child: Text('For Rent')),
                    DropdownMenuItem(value: 'sale', child: Text('For Sale')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedIntent = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
                DropdownButton<String>(
                  value: _selectedVerifStatus,
                  underline: const SizedBox.shrink(),
                  dropdownColor: isDark ? const Color(0xFF131722) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'verified', child: Text('Verified Badge')),
                    DropdownMenuItem(value: 'pendingverification', child: Text('Pending Review')),
                    DropdownMenuItem(value: 'physicalinspectionscheduled', child: Text('Inspection Scheduled')),
                    DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                  ],
                  onChanged: (val) => setState(() {
                    _selectedVerifStatus = val ?? 'all';
                    _currentPage = 1;
                  }),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Properties Table
            MarketplaceDataTable(
              columns: const [
                DataColumn(label: Text('PROPERTY')),
                DataColumn(label: Text('LOCATION')),
                DataColumn(label: Text('INTENT & PRICE')),
                DataColumn(label: Text('OWNER RECORD (CONFIDENTIAL)')),
                DataColumn(label: Text('VERIFICATION')),
                DataColumn(label: Text('UNLOCK LEADS')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: paginatedItems.map((item) {
                return DataRow(
                  cells: [
                    // Property
                    DataCell(
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: AppRadius.sm,
                            child: Image.network(
                              item.coverImageUrl,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 44,
                                height: 44,
                                color: AppColors.primary.withValues(alpha: 0.1),
                                child: const Icon(Icons.home_work_outlined, color: AppColors.primary, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title.length > 28 ? '${item.title.substring(0, 26)}...' : item.title,
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${item.bhk} • ${item.propertyType.label}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Location
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.locality, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(item.city, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),

                    // Intent & Price
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.intent == ListingIntent.rent
                                ? '₹${item.monthlyRent.toStringAsFixed(0)}/mo'
                                : '₹${(item.salePrice / 100000).toStringAsFixed(1)} Lakhs',
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            item.intent.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: item.intent == ListingIntent.rent ? AppColors.info : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Owner Record (Confidential Protection)
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_rounded, size: 14, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.ownerName,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                item.ownerMobileMasked,
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Verification
                    DataCell(
                      MarketplaceStatusBadge.verification(item.verificationStatus),
                    ),

                    // Unlocks
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: AppRadius.sm,
                            ),
                            child: Text(
                              '${item.totalContactUnlocks} Unlocks',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status
                    DataCell(
                      MarketplaceStatusBadge.publication(item.publicationStatus),
                    ),

                    // Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.verified_outlined, size: 18, color: AppColors.primary),
                            tooltip: 'Verification Audit & Surveyor Checklist',
                            onPressed: () => _openVerificationDialog(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.lock_open_rounded, size: 18, color: AppColors.info),
                            tooltip: 'Unlock Transactions & Buyer Leads',
                            onPressed: () => _openUnlockModal(item),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            tooltip: 'Edit Listing Wizard',
                            onPressed: () => _openEditWizard(item),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            onSelected: (val) {
                              if (val == 'delist') {
                                _confirmDelist(item);
                              } else if (val == 'delete') {
                                _repo.deleteProperty(item.id);
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(value: 'delist', child: Text('Delist Listing')),
                              const PopupMenuItem(value: 'delete', child: Text('Delete Listing', style: TextStyle(color: AppColors.error))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),

            // Pagination strip
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${filtered.isEmpty ? 0 : startIndex + 1} to ${(startIndex + _pageSize).clamp(0, filtered.length)} of ${filtered.length} properties',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                    ),
                    Text('$_currentPage / $totalPages', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
