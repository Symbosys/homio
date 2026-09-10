import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/marketplace_repository.dart';

class AffiliatePerformanceModal extends StatefulWidget {
  const AffiliatePerformanceModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const AffiliatePerformanceModal(),
    );
  }

  @override
  State<AffiliatePerformanceModal> createState() => _AffiliatePerformanceModalState();
}

class _AffiliatePerformanceModalState extends State<AffiliatePerformanceModal> {
  final _repo = MarketplaceRepository();
  String _selectedPartner = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = _repo.homeDecorProducts.where((p) => p.isAffiliateEnabled).toList();

    final totalClicks = _repo.totalDecorAffiliateClicks;
    final totalCommission = _repo.totalDecorEstimatedCommission;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880, maxHeight: 680),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.insights_rounded, color: Color(0xFF8B5CF6), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Affiliate Performance & Click Intelligence',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Real-time redirection tracking, campaign conversion attribution & partner payouts',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),

            // Top Metrics
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  _statCard('Total Tracked Clicks', '$totalClicks Clicks', const Color(0xFF3B82F6), isDark),
                  const SizedBox(width: 10),
                  _statCard('Conversion Orders', '70 Orders', const Color(0xFF10B981), isDark),
                  const SizedBox(width: 10),
                  _statCard('Estimated Commission', '₹${totalCommission.toStringAsFixed(0)}', const Color(0xFF8B5CF6), isDark),
                  const SizedBox(width: 10),
                  _statCard('Average Conversion Rate', '7.6%', const Color(0xFFF59E0B), isDark),
                ],
              ),
            ),

            // Filter & Partner Switcher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Text(
                    'Filter by Merchant:',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedPartner,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Partners (Amazon, West Elm, Pepperfry)')),
                      DropdownMenuItem(value: 'westElm', child: Text('West Elm Modern')),
                      DropdownMenuItem(value: 'pepperfry', child: Text('Pepperfry Exclusive')),
                      DropdownMenuItem(value: 'amazon', child: Text('Amazon Associates')),
                    ],
                    onChanged: (v) => setState(() => _selectedPartner = v ?? 'all'),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Affiliate click report exported to CSV.')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 14),
                    label: Text('Export CSV Report', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                  ),
                ],
              ),
            ),

            // Product Performance Table
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: products.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final p = products[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.sm,
                          child: Image.network(p.coverImageUrl, width: 44, height: 44, fit: BoxFit.cover, errorBuilder: (_, err, stack) => const Icon(Icons.chair_rounded)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                              Text('Partner: ${p.affiliatePartner.label} • Rate: ${p.commissionRate}%', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${p.affiliateClicksCount}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF3B82F6))),
                              Text('Clicks', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${p.conversionsCount}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                              Text('Conversions', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${p.estimatedCommissionEarned.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF8B5CF6))),
                              Text('Earned', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.sm,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: const Color(0xFF64748B))),
            const SizedBox(height: 3),
            Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ),
    );
  }
}
