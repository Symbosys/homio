import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Digital Store Page for Architectural & Interior Blueprint Guides.
class ClientDigitalStorePage extends StatefulWidget {
  const ClientDigitalStorePage({super.key});

  @override
  State<ClientDigitalStorePage> createState() => _ClientDigitalStorePageState();
}

class _ClientDigitalStorePageState extends State<ClientDigitalStorePage> {
  DigitalGuideCategory _selectedCategory = DigitalGuideCategory.all;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final guides = globalMarketplaceState.digitalGuides.where((guide) {
      final matchesCat = _selectedCategory == DigitalGuideCategory.all || guide.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          guide.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          guide.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          guide.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    final purchasedGuides = globalMarketplaceState.digitalGuides.where((g) => g.isPurchased).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page Title & Subtitle Banner
              _buildStoreBanner(isDark, isMobile),
              const SizedBox(height: 18),

              // Search and Category Tabs
              _buildFilterBar(isDark, isMobile),
              const SizedBox(height: 20),

              // Unlocked / Purchased Blueprints Quick Access Tray
              if (purchasedGuides.isNotEmpty) ...[
                _buildPurchasedTray(purchasedGuides, isDark, isMobile),
                const SizedBox(height: 22),
              ],

              // Store Blueprints Section Title
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVAILABLE BLUEPRINTS & HANDBOOKS (${guides.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Instant PDF Vector Downloads',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Text(
                      'AVAILABLE BLUEPRINTS & HANDBOOKS (${guides.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Instant PDF Vector Downloads',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              // Guides List
              if (guides.isEmpty)
                _buildEmptyState(isDark)
              else
                ...guides.map((guide) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildGuideCard(guide, isDark, isMobile),
                    )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreBanner(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Architectural Blueprints & Digital Vault',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Comprehensive engineering handbooks, Vastu shastra compliance diagrams, and site execution checklists.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 11.5 : 13,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Input
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Search blueprints by topic, author, or specification...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: DigitalGuideCategory.values.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 14,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      Text(cat.label),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  selectedColor: const Color(0xFF10B981),
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.full,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPurchasedTray(List<DigitalGuide> purchased, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.08),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.download_done_rounded, color: Color(0xFF10B981), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'YOUR UNLOCKED BLUEPRINTS (${purchased.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Instant Access for Villa 402',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.download_done_rounded, color: Color(0xFF10B981), size: 18),
                const SizedBox(width: 8),
                Text(
                  'YOUR UNLOCKED BLUEPRINTS (${purchased.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Instant Access for Villa 402',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          ...purchased.map((g) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  g.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _showPreviewModal(context, g, isDark),
                                icon: const Icon(Icons.visibility_rounded, size: 15),
                                label: const Text('Preview'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600),
                                  minimumSize: const Size(0, 36),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _simulateDownload(g),
                                icon: const Icon(Icons.download_rounded, size: 15),
                                label: const Text('Download PDF'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                                  minimumSize: const Size(0, 36),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              g.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _showPreviewModal(context, g, isDark),
                            icon: const Icon(Icons.visibility_rounded, size: 16),
                            label: const Text('Preview'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                              minimumSize: const Size(0, 38),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _simulateDownload(g),
                            icon: const Icon(Icons.download_rounded, size: 16),
                            label: const Text('Download PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                              minimumSize: const Size(0, 38),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                            ),
                          ),
                        ],
                      ),
              )),
        ],
      ),
    );
  }

  Widget _buildGuideCard(DigitalGuide guide, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: guide.isPurchased
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top metadata row
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  guide.category.label.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  '${guide.fileFormat} • ${guide.pageCount} Pages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 15),
                  const SizedBox(width: 3),
                  Text(
                    '${guide.rating}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    ' (${guide.reviewsCount})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title & Subtitle
          Text(
            guide.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            guide.subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Author attribution
          Row(
            children: [
              const Icon(Icons.account_circle_outlined, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'By ${guide.author} (${guide.authorTitle})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Table of Contents snippets
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: guide.tableOfContents.take(3).map((item) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 290),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 11, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Divider
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Bottom Action Row: Price & Buttons
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPriceSection(guide, isDark),
                const SizedBox(height: 10),
                _buildActionButtons(guide, isDark),
              ],
            )
          else
            Row(
              children: [
                _buildPriceSection(guide, isDark),
                const Spacer(),
                _buildActionButtons(guide, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(DigitalGuide guide, bool isDark) {
    if (guide.isPurchased) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.12),
          borderRadius: AppRadius.full,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
            const SizedBox(width: 5),
            Text(
              'UNLOCKED FOR VILLA 402',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF10B981),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Text(
          '₹${guide.mrpPrice.toInt()}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '₹${guide.clientPrice.toInt()}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            borderRadius: AppRadius.sm,
          ),
          child: Text(
            'Client Special',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(DigitalGuide guide, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => _showPreviewModal(context, guide, isDark),
          icon: const Icon(Icons.menu_book_rounded, size: 16),
          label: const Text('Read Preview'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
        ),
        if (guide.isPurchased)
          ElevatedButton.icon(
            onPressed: () => _simulateDownload(guide),
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () => _showUnlockDialog(context, guide, isDark),
            icon: const Icon(Icons.lock_open_rounded, size: 16),
            label: Text('Unlock for ₹${guide.clientPrice.toInt()}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          ),
      ],
    );
  }

  void _showPreviewModal(BuildContext context, DigitalGuide guide, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Preview Excerpt • ${guide.pageCount} Pages • Author: ${guide.author}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 580,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 16),
                  Text(
                    'COMPLETE TABLE OF CONTENTS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...guide.tableOfContents.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key + 1}. ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 14),
                  Text(
                    'WATERMARKED EXCERPT PREVIEW',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.md,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      guide.previewExcerpt,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
            if (!guide.isPurchased)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showUnlockDialog(context, guide, isDark);
                },
                icon: const Icon(Icons.lock_open_rounded, size: 16),
                label: Text('Unlock (₹${guide.clientPrice.toInt()})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _simulateDownload(guide);
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Download Full Vector PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showUnlockDialog(BuildContext context, DigitalGuide guide, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text(
            'Confirm Blueprint Unlock',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are unlocking: "${guide.title}".',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Special Homio Client Price: ₹${guide.clientPrice.toInt()} (Regular MRP ₹${guide.mrpPrice.toInt()}). Includes full lifetime updates and unlimited vector PDF downloads for Palm Heights Villa 402.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  guide.isPurchased = true;
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF10B981),
                    content: Text(
                      'Successfully unlocked "${guide.title}"! Ready to download.',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Pay ₹${guide.clientPrice.toInt()} & Unlock',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  void _simulateDownload(DigitalGuide guide) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        content: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Downloading "${guide.title}.pdf" (${guide.pageCount} pages, vector)...',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              'No blueprints found matching your search',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing the category filter or search keywords.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
