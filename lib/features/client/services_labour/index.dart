import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models/service_labour_models.dart';
import 'widgets/service_booking_card.dart';
import 'widgets/service_category_bar.dart';
import 'widgets/service_detail_modal.dart';
import 'widgets/service_provider_card.dart';
import 'widgets/service_provider_modal.dart';
import 'widgets/service_request_modal.dart';

/// Screen 2 & 5: MY SERVICES / LABOUR BOOKING & DETAIL FLOWS (/client/services)
/// Connected customer-facing services and labour hiring hub:
/// - Category discovery & multi-filter search (location, rate, availability)
/// - Responsive provider cards (3 cols desktop, 2 cols tablet, 1 col mobile)
/// - Detailed provider dossier modal with reviews & skills
/// - Structured booking request with project site prefill
/// - Active booking tracker with 10-step lifecycle, daily photo proof & payments
/// - 100% Dark & Light mode compatible
class ClientServicesLabourPage extends StatefulWidget {
  const ClientServicesLabourPage({super.key});

  @override
  State<ClientServicesLabourPage> createState() =>
      _ClientServicesLabourPageState();
}

class _ClientServicesLabourPageState extends State<ClientServicesLabourPage> {
  final ServiceRepository _repo = ServiceRepository.instance;

  String _mainTab = 'Directory'; // 'Directory', 'Bookings'
  String _selectedCategory = 'All Trades';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _verifiedOnly = false;
  String _availabilityFilter = 'All'; // 'All', 'Available Today'

  @override
  void initState() {
    super.initState();
    _repo.changeNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _repo.changeNotifier.removeListener(_onDataChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isCompact(context);
    final isTablet = Breakpoints.isTablet(context);

    // Filter providers
    final filteredProviders = _repo.providers.where((p) {
      final matchesCat = _selectedCategory == 'All Trades' ||
          p.trade.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.trade.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.skills.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesVerified = !_verifiedOnly || p.isVerified;
      final matchesAvail = _availabilityFilter == 'All' ||
          p.availabilityStatus.toLowerCase().contains('today');

      return matchesCat && matchesSearch && matchesVerified && matchesAvail;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          children: [
            // Page Header Hero
            _buildPageHeader(isDark, isMobile),
            const SizedBox(height: 20),

            // Top Tab Selector (Find Professionals vs My Bookings)
            _buildMainTabBar(isDark),
            const SizedBox(height: 18),

            if (_mainTab == 'Directory') ...[
              // Search & Filter Bar
              _buildSearchFilterBar(isDark, isMobile),
              const SizedBox(height: 14),

              // Category Chip Bar
              ServiceCategoryBar(
                categories: _repo.categories,
                selectedCategory: _selectedCategory,
                onSelected: (cat) => setState(() => _selectedCategory = cat),
              ),
              const SizedBox(height: 20),

              // Provider Cards Grid
              if (filteredProviders.isEmpty)
                _buildEmptyState(
                  'No service professionals matched.',
                  'Try adjusting your search query or trade filter.',
                  isDark,
                )
              else
                _buildProvidersGrid(filteredProviders, isMobile, isTablet),
            ] else ...[
              // My Bookings Tab
              _buildBookingsTab(isDark),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_repair_service_rounded, color: Color(0xFF0EA5E9), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOMIO TRUSTED LABOUR & SERVICES',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: const Color(0xFF0EA5E9),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Find & Book Verified Professionals for Your Home',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Master carpenters, certified electricians, sanitary plumbers and finish painters backed by HOMIO supervisor verification, daily site logs and guaranteed escrow settlement.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTabBar(bool isDark) {
    return Row(
      children: [
        _buildTabButton(
          title: 'Find Professionals',
          subtitle: '${_repo.providers.length} Vetted',
          icon: Icons.person_search_rounded,
          isSelected: _mainTab == 'Directory',
          onTap: () => setState(() => _mainTab = 'Directory'),
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildTabButton(
          title: 'My Bookings',
          subtitle: '${_repo.bookings.length} Tracked',
          icon: Icons.receipt_long_rounded,
          isSelected: _mainTab == 'Bookings',
          onTap: () => setState(() => _mainTab = 'Bookings'),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkCard : Colors.white),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFilterBar(bool isDark, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search by trade, skill (e.g. Modular Kitchen, Hafele, DB Dressing)...',
              hintStyle: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
              ),
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: isDark ? AppColors.darkCard : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () => _openFilterSheet(isDark),
          icon: Icon(
            _verifiedOnly || _availabilityFilter != 'All'
                ? Icons.filter_alt_rounded
                : Icons.filter_list_rounded,
          ),
          color: _verifiedOnly || _availabilityFilter != 'All' ? AppColors.primary : null,
          style: IconButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  void _openFilterSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filter Professionals',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _verifiedOnly = false;
                            _availabilityFilter = 'All';
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Verified Professionals Only'),
                    value: _verifiedOnly,
                    activeThumbColor: AppColors.primary,
                    onChanged: (v) {
                      setSheetState(() => _verifiedOnly = v);
                      setState(() => _verifiedOnly = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Availability',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Available Today'].map((opt) {
                      final isSel = _availabilityFilter == opt;
                      return ChoiceChip(
                        label: Text(opt),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        onSelected: (_) {
                          setSheetState(() => _availabilityFilter = opt);
                          setState(() => _availabilityFilter = opt);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProvidersGrid(
    List<LabourServiceProvider> list,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      return Column(
        children: list.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ServiceProviderCard(
              provider: p,
              onViewProfile: () => ServiceProviderModal.show(
                context,
                provider: p,
                onRequestBooking: () => ServiceRequestModal.show(
                  context,
                  provider: p,
                  onSubmitted: () => setState(() => _mainTab = 'Bookings'),
                ),
              ),
              onRequestService: () => ServiceRequestModal.show(
                context,
                provider: p,
                onSubmitted: () => setState(() => _mainTab = 'Bookings'),
              ),
            ),
          );
        }).toList(),
      );
    }

    final crossAxisCount = isTablet ? 2 : 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: list.map((p) {
            return SizedBox(
              width: itemWidth,
              child: ServiceProviderCard(
                provider: p,
                onViewProfile: () => ServiceProviderModal.show(
                  context,
                  provider: p,
                  onRequestBooking: () => ServiceRequestModal.show(
                    context,
                    provider: p,
                    onSubmitted: () => setState(() => _mainTab = 'Bookings'),
                  ),
                ),
                onRequestService: () => ServiceRequestModal.show(
                  context,
                  provider: p,
                  onSubmitted: () => setState(() => _mainTab = 'Bookings'),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBookingsTab(bool isDark) {
    final bookings = _repo.bookings;

    if (bookings.isEmpty) {
      return _buildEmptyState(
        'No active service bookings.',
        'Explore our directory to book vetted carpenters, electricians and plumbers.',
        isDark,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Your Active & Completed Bookings (${bookings.length})',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...bookings.map((b) {
          return ServiceBookingCard(
            booking: b,
            onViewDetails: () => ServiceDetailModal.show(
              context,
              booking: b,
              onStateUpdated: () => setState(() {}),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.handyman_outlined,
            size: 44,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
