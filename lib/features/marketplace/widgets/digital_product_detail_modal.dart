import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_domain_models.dart';
import 'marketplace_status_badge.dart';

class DigitalProductDetailModal extends StatelessWidget {
  final DigitalProductEntity product;

  const DigitalProductDetailModal({super.key, required this.product});

  static void show(BuildContext context, DigitalProductEntity product) {
    showDialog(
      context: context,
      builder: (ctx) => DigitalProductDetailModal(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 680),
        child: DefaultTabController(
          length: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.sm,
                      child: Image.network(
                        product.coverImageUrl,
                        width: 48,
                        height: 58,
                        fit: BoxFit.cover,
                        errorBuilder: (_, err, stack) => Container(
                          width: 48,
                          height: 58,
                          color: Colors.grey.shade800,
                          child: const Icon(Icons.book_rounded, color: Colors.white, size: 24),
                        ),
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
                                product.productCode,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              MarketplaceStatusBadge.publication(product.publicationStatus, isSmall: true),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'By ${product.authorName} (${product.authorTitle}) • ${product.fileFormat.label}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                indicatorColor: AppColors.primary,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'Overview & Specs'),
                  Tab(text: 'Commercials'),
                  Tab(text: 'Purchases (482)'),
                  Tab(text: 'Download Activity'),
                  Tab(text: 'Security & DRM'),
                ],
              ),

              // Tab View
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOverviewTab(isDark),
                    _buildCommercialsTab(isDark),
                    _buildPurchasesTab(isDark),
                    _buildDownloadActivityTab(isDark),
                    _buildSecurityTab(isDark),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last updated on ${product.updatedAt.day}/${product.updatedAt.month}/${product.updatedAt.year}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Publication Abstract'),
          Text(
            product.fullDescription,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              height: 1.5,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _sectionTitle('Table of Contents'),
          ...product.tableOfContents.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppSpacing.md),
          _sectionTitle('Digital File Specifications'),
          Row(
            children: [
              _specTile('Format', product.fileFormat.label, isDark),
              _specTile('Size', product.fileSize, isDark),
              _specTile('Pages', '${product.pageCount} Pages', isDark),
              _specTile('Version', product.version, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommercialsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Pricing Architecture'),
          Row(
            children: [
              _specTile('Original MRP', '₹${product.mrp}', isDark),
              _specTile('Selling Price', '₹${product.sellingPrice}', isDark),
              _specTile('Discount', '${product.discountPercent.toInt()}% OFF', isDark),
              _specTile('GST Rate', '${product.taxRate}%', isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _sectionTitle('Financial Performance Summary'),
          Row(
            children: [
              _kpiBox('Total Lifetime Revenue', '₹${product.grossRevenue.toStringAsFixed(0)}', const Color(0xFF10B981), isDark),
              const SizedBox(width: 12),
              _kpiBox('Paid Copies Sold', '${product.totalPurchases}', const Color(0xFF3B82F6), isDark),
              const SizedBox(width: 12),
              _kpiBox('Total Downloads', '${product.totalDownloads}', const Color(0xFF8B5CF6), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _purchaseRow('Ananya Deshpande', 'MKT-ORD-2026-00482', '₹499.00', '9 Sep 2026', 'Completed', isDark),
        _purchaseRow('Karan Singhania', 'MKT-ORD-2026-00475', '₹499.00', '8 Sep 2026', 'Completed', isDark),
        _purchaseRow('Ar. Ramesh Naidu', 'MKT-ORD-2026-00461', '₹499.00', '7 Sep 2026', 'Completed', isDark),
        _purchaseRow('Varma Architects LLP', 'MKT-ORD-2026-00450', '₹499.00', '6 Sep 2026', 'Completed', isDark),
      ],
    );
  }

  Widget _buildDownloadActivityTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _downloadRow('meera.krishnan@gmail.com', 'Success (100%)', '103.21.244.12 (Mac Safari)', '9 Sep 2026, 14:14', const Color(0xFF10B981), isDark),
        _downloadRow('karan.singh@gmail.com', 'Success (100%)', '49.36.12.80 (Windows Chrome)', '8 Sep 2026, 18:22', const Color(0xFF10B981), isDark),
        _downloadRow('ananya.d@cognizant.com', 'Token Expired', '152.57.19.4 (Android Mobile)', '7 Sep 2026, 21:05', const Color(0xFFEF4444), isDark),
      ],
    );
  }

  Widget _buildSecurityTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Digital Rights Management (DRM) Rules'),
          ListTile(
            leading: const Icon(Icons.timer_outlined, color: Color(0xFF3B82F6)),
            title: Text('Token Expiry: ${product.downloadLinkExpiryHours} Hours', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
            subtitle: Text('Temporary HMAC signed link self-destructs after period.', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline_outlined, color: Color(0xFF8B5CF6)),
            title: Text('Limit: Max ${product.maxDownloads} Downloads', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
            subtitle: Text('Prevents unauthorized link redistribution.', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
          ),
          ListTile(
            leading: const Icon(Icons.branding_watermark_outlined, color: Color(0xFF10B981)),
            title: Text('Dynamic PDF Stamping: Active', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
            subtitle: Text(product.watermarkText, style: GoogleFonts.plusJakartaSans(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF64748B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _specTile(String label, String val, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
          borderRadius: AppRadius.sm,
          border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            const SizedBox(height: 2),
            Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }

  Widget _kpiBox(String title, String val, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.md,
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(height: 4),
            Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _purchaseRow(String name, String orderId, String amount, String date, String status, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text(orderId, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.primary)),
            ],
          ),
          Text(amount, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
          Text(date, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _downloadRow(String email, String status, String ip, String time, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text(ip, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.sm),
            child: Text(status, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
          ),
          Text(time, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
        ],
      ),
    );
  }
}
