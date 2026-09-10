import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_domain_models.dart';
import '../domain/marketplace_enums.dart';
import '../widgets/approval_review_dialog.dart';
import '../widgets/marketplace_charts.dart';
import '../widgets/marketplace_config_dialog.dart';
import '../widgets/marketplace_data_table.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/marketplace_metric_card.dart';

class MarketplaceManagementPage extends StatefulWidget {
  const MarketplaceManagementPage({super.key});

  @override
  State<MarketplaceManagementPage> createState() => _MarketplaceManagementPageState();
}

class _MarketplaceManagementPageState extends State<MarketplaceManagementPage> with SingleTickerProviderStateMixin {
  final _repo = MarketplaceRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _openConfigDialog() {
    MarketplaceConfigDialog.show(context, _repo.config);
  }

  void _openAddCategoryDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController();
    final slugCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    var selectedType = MarketplaceType.digital;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text('Add Marketplace Category', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Category Name', hintText: 'e.g. Sanitaryware & Bath Fittings'),
                  onChanged: (val) {
                    slugCtrl.text = val.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: slugCtrl,
                  decoration: const InputDecoration(labelText: 'URL Slug', hintText: 'sanitaryware-bath-fittings'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Category scope and details'),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Marketplace Model:', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                DropdownButton<MarketplaceType>(
                  value: selectedType,
                  isExpanded: true,
                  items: MarketplaceType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.label))).toList(),
                  onChanged: (newType) {
                    if (newType != null) {
                      setDlgState(() => selectedType = newType);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.lightTextMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final newCat = MarketplaceCategory(
                  id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  code: 'CAT-${DateTime.now().millisecondsSinceEpoch % 10000}',
                  marketplaceType: selectedType,
                  description: descCtrl.text.trim(),
                  iconCode: 'folder_open',
                  slug: slugCtrl.text.trim().isNotEmpty ? slugCtrl.text.trim() : 'category-new',
                  sortOrder: _repo.categories.length + 1,
                  isActive: true,
                  subcategories: [],
                );
                _repo.addCategory(newCat);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Category "${newCat.name}" added successfully.'), backgroundColor: AppColors.success),
                );
              },
              child: Text('Save Category', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddBrandDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController();
    final websiteCtrl = TextEditingController();
    final originCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text('Register Authorized Brand', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Brand Name', hintText: 'e.g. Schneider Electric'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: websiteCtrl,
                decoration: const InputDecoration(labelText: 'Official Website', hintText: 'https://se.com/in'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: originCtrl,
                decoration: const InputDecoration(labelText: 'Country of Origin', hintText: 'e.g. France / India'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Contact Email', hintText: 'partner@brand.com'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Brand Description', hintText: 'Manufacturer description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.lightTextMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final newBrand = MarketplaceBrand(
                id: 'brand_${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                code: 'BRD-${DateTime.now().millisecondsSinceEpoch % 10000}',
                logoUrl: 'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=100',
                description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'Authorized Brand Partner',
                website: websiteCtrl.text.trim().isNotEmpty ? websiteCtrl.text.trim() : 'https://brand.com',
                countryOfOrigin: originCtrl.text.trim().isNotEmpty ? originCtrl.text.trim() : 'India',
                contactEmail: emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : 'contact@brand.com',
                isActive: true,
                linkedProductCount: 0,
              );
              _repo.addBrand(newBrand);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Brand "${newBrand.name}" registered successfully.'), backgroundColor: AppColors.success),
              );
            },
            child: Text('Register Brand', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pendingApprovals = _repo.approvals.where((a) => a.currentStatus.toLowerCase() == 'pending').length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            MarketplaceHeader(
              title: 'Marketplace Operations & Management Control',
              subtitle: 'Global taxonomy, brand authorization, review moderation, approvals queue & operational rules engine',
              icon: Icons.storefront_rounded,
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Marketplace Audit Log export generated (CSV / JSON format).'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  icon: Icon(Icons.file_download_outlined, size: 16, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  label: Text('Export Audit Log', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    side: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: _openConfigDialog,
                  icon: const Icon(Icons.tune_rounded, size: 18, color: Colors.white),
                  label: Text('Operational Rules & SLAs', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tab Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131722) : Colors.white,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
                tabs: [
                  const Tab(icon: Icon(Icons.dashboard_outlined, size: 18), text: 'Executive Overview'),
                  const Tab(icon: Icon(Icons.category_outlined, size: 18), text: 'Categories & Taxonomy'),
                  const Tab(icon: Icon(Icons.verified_outlined, size: 18), text: 'Brands Master'),
                  Tab(
                    icon: pendingApprovals > 0
                        ? Badge(label: Text('$pendingApprovals'), child: const Icon(Icons.fact_check_outlined, size: 18))
                        : const Icon(Icons.fact_check_outlined, size: 18),
                    text: 'Approvals Queue',
                  ),
                  const Tab(icon: Icon(Icons.star_outline_rounded, size: 18), text: 'Reviews & Moderation'),
                  const Tab(icon: Icon(Icons.photo_library_outlined, size: 18), text: 'Media Assets'),
                  const Tab(icon: Icon(Icons.history_edu_outlined, size: 18), text: 'Audit Trail'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Tab Content
            SizedBox(
              height: 820,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExecutiveOverviewTab(),
                  _buildCategoriesTab(),
                  _buildBrandsTab(),
                  _buildApprovalsTab(),
                  _buildReviewsTab(),
                  _buildMediaTab(),
                  _buildAuditTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 1: EXECUTIVE OVERVIEW
  // -------------------------------------------------------------
  Widget _buildExecutiveOverviewTab() {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Metric Bar
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
                    title: 'Total Gross Volume (GMV)',
                    value: '₹${_repo.totalGrossSales.toStringAsFixed(0)}',
                    subtitle: 'Across all 4 active business models',
                    icon: Icons.account_balance_wallet_outlined,
                    accentColor: AppColors.primary,
                  ),
                  MarketplaceMetricCard(
                    title: 'Property Unlock Revenue',
                    value: '₹${_repo.totalPropertyUnlockRevenue.toStringAsFixed(0)}',
                    subtitle: '${_repo.totalPropertyUnlocks} contact leads unlocked',
                    icon: Icons.lock_open_rounded,
                    accentColor: AppColors.success,
                  ),
                  MarketplaceMetricCard(
                    title: 'Affiliate Commissions',
                    value: '₹${_repo.totalDecorEstimatedCommission.toStringAsFixed(0)}',
                    subtitle: '${_repo.totalDecorAffiliateClicks} outbound customer clicks',
                    icon: Icons.hub_outlined,
                    accentColor: AppColors.info,
                  ),
                  MarketplaceMetricCard(
                    title: 'Digital Licensing Volume',
                    value: '₹${_repo.digitalGrossRevenue.toStringAsFixed(0)}',
                    subtitle: '${_repo.totalDigitalDownloads} architectural downloads',
                    icon: Icons.folder_zip_outlined,
                    accentColor: AppColors.warning,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // Analytical Charts
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 380,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131722) : Colors.white,
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monthly Marketplace Sales & Transaction Velocity', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('Combined gross transaction value across all business verticals', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                      const SizedBox(height: AppSpacing.md),
                      const Expanded(child: MarketplaceSalesTrendChart()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                flex: 2,
                child: Container(
                  height: 380,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131722) : Colors.white,
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Revenue Contribution by Model', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('Digital • Affiliates • Wholesale • Property Unlocks', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                      const SizedBox(height: AppSpacing.md),
                      const Expanded(child: MarketplaceRevenueByModelDonut()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Operational Health Highlights
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.health_and_safety_outlined, color: AppColors.success, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marketplace Services Operational SLA Status: 99.98% Normal', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                      Text('Signed S3 download token servers, Razorpay payment gateway webhooks, WhatsApp Business notifications & GPS transport telemetry running with 0 errors.', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _openConfigDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                  child: const Text('Tuned Parameters', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 2: CATEGORIES & TAXONOMY
  // -------------------------------------------------------------
  Widget _buildCategoriesTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = _repo.categories;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Marketplace Categories & Subcategory Taxonomy', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text('Hierarchical classifications spanning Digital Assets, Home Decor, Wholesale Materials & Properties', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _openAddCategoryDialog,
                icon: const Icon(Icons.add_circle_outline, size: 18, color: Colors.white),
                label: const Text('Add Category', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final cat = categories[idx];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.category_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(cat.name, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                              const SizedBox(width: AppSpacing.sm),
                              Text('/${cat.slug}', style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontFamily: 'monospace')),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(cat.description, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                              borderRadius: AppRadius.xs,
                              border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                            ),
                            child: Text(cat.marketplaceType.label, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${cat.subcategories.length} Subcategories', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Switch(
                      value: cat.isActive,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 3: BRANDS MASTER
  // -------------------------------------------------------------
  Widget _buildBrandsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brands = _repo.brands;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Authorized Brand Registry', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text('Certified manufacturers, brand owners and verified distributors', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _openAddBrandDialog,
                icon: const Icon(Icons.domain_add_outlined, size: 18, color: Colors.white),
                label: const Text('Register Brand', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 2.4,
            ),
            itemCount: brands.length,
            itemBuilder: (ctx, idx) {
              final b = brands[idx];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.sm,
                      child: Image.network(
                        b.logoUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 48,
                          height: 48,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.business_outlined, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(b.name, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                              if (b.isActive) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 14, color: AppColors.info),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('${b.countryOfOrigin} • ${b.code}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('${b.linkedProductCount} Linked Products', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 4: APPROVALS QUEUE
  // -------------------------------------------------------------
  Widget _buildApprovalsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final approvals = _repo.approvals;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Operational Approvals Queue', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
          Text('Submissions requiring marketplace supervisor authorization prior to publishing', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: AppSpacing.lg),

          MarketplaceDataTable(
            columns: const [
              DataColumn(label: Text('SUBMISSION / ENTITY')),
              DataColumn(label: Text('TYPE')),
              DataColumn(label: Text('SUBMITTED BY')),
              DataColumn(label: Text('DATE & TIME')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: approvals.map((app) {
              return DataRow(
                cells: [
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(app.entityTitle, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                        Text('Entity ID: ${app.entityId}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9), borderRadius: AppRadius.sm, border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
                      child: Text(app.entityType.label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  DataCell(
                    Text(app.submittedByName, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                  ),
                  DataCell(
                    Text('${app.submittedAt.day}/${app.submittedAt.month}/${app.submittedAt.year}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: app.currentStatus.toLowerCase() == 'approved'
                            ? AppColors.success.withValues(alpha: 0.1)
                            : (app.currentStatus.toLowerCase() == 'rejected' ? AppColors.error.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1)),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        app.currentStatus.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: app.currentStatus.toLowerCase() == 'approved' ? AppColors.success : (app.currentStatus.toLowerCase() == 'rejected' ? AppColors.error : AppColors.warning),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                      onPressed: () => ApprovalReviewDialog.show(context, app),
                      child: const Text('Review', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 5: REVIEWS & MODERATION
  // -------------------------------------------------------------
  Widget _buildReviewsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reviews = _repo.reviews;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Reviews & Ratings Moderation', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
          Text('Audit verified buyer ratings, quality scores and moderate reported content', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: AppSpacing.lg),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (c, i) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (ctx, idx) {
              final r = reviews[idx];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (starIdx) => Icon(
                            starIdx < r.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                            size: 18,
                            color: const Color(0xFFF59E0B),
                          )),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text('${r.rating.toStringAsFixed(1)} / 5.0', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(width: AppSpacing.md),
                        if (r.isVerifiedPurchase)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: AppRadius.xs,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user_rounded, size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text('VERIFIED BUYER', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: r.status == ReviewStatus.approved ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Text(
                            r.status.label.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: r.status == ReviewStatus.approved ? AppColors.success : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(r.reviewTitle, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(r.reviewText, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Reviewed on: ${r.entityTitle} by ${r.customerName} (${r.submittedAt.day}/${r.submittedAt.month}/${r.submittedAt.year})', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (r.status != ReviewStatus.approved)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                            ),
                            icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                            label: const Text('Approve & Publish', style: TextStyle(color: Colors.white, fontSize: 12)),
                            onPressed: () {
                              _repo.moderateReview(r.id, ReviewStatus.approved, null);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Review published.'), backgroundColor: AppColors.success),
                              );
                            },
                          ),
                        const SizedBox(width: AppSpacing.sm),
                        if (r.status != ReviewStatus.hidden)
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                              side: const BorderSide(color: AppColors.warning),
                            ),
                            icon: const Icon(Icons.flag_outlined, size: 16, color: AppColors.warning),
                            label: const Text('Hide Review', style: TextStyle(color: AppColors.warning, fontSize: 12)),
                            onPressed: () {
                              _repo.moderateReview(r.id, ReviewStatus.hidden, 'Hidden by supervisor');
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 6: DIGITAL MEDIA LIBRARY
  // -------------------------------------------------------------
  Widget _buildMediaTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final media = _repo.mediaItems;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Digital Asset & Media CDN Repository', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
          Text('High-resolution product imagery, architectural preview renders & property survey photographs', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: AppSpacing.lg),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemCount: media.length,
            itemBuilder: (ctx, idx) {
              final m = media[idx];
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.network(
                          m.fileUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: const Center(child: Icon(Icons.image_outlined, color: AppColors.primary, size: 32)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.fileName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('${m.fileType} • ${m.fileSize}', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 7: AUDIT TRAIL
  // -------------------------------------------------------------
  Widget _buildAuditTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auditLogs = _repo.auditRecords;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enterprise Marketplace Security & Operations Audit Trail', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
          Text('Immutable timestamped records of every price change, listing approval, refund authorization & paywall unlock', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: AppSpacing.lg),

          MarketplaceDataTable(
            columns: const [
              DataColumn(label: Text('TIMESTAMP')),
              DataColumn(label: Text('OPERATOR / USER')),
              DataColumn(label: Text('ACTION')),
              DataColumn(label: Text('TARGET ENTITY')),
              DataColumn(label: Text('DETAILS')),
              DataColumn(label: Text('IP ADDRESS')),
            ],
            rows: auditLogs.map((log) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      '${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year} ${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontFamily: 'monospace'),
                    ),
                  ),
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(log.userName, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(log.userRole, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        log.action.label,
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ),
                  DataCell(
                    Text('${log.entityName} (${log.entityId})', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                  ),
                  DataCell(
                    Text('${log.oldValue} → ${log.newValue} (${log.reason})', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  ),
                  DataCell(
                    Text(log.ipAddress, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontFamily: 'monospace')),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
