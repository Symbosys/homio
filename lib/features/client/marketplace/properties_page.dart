import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Verified Rental & Properties Network Page with Zero-Brokerage Direct Owner Unlock.
class ClientPropertiesPage extends StatefulWidget {
  const ClientPropertiesPage({super.key});

  @override
  State<ClientPropertiesPage> createState() => _ClientPropertiesPageState();
}

class _ClientPropertiesPageState extends State<ClientPropertiesPage> {
  PropertyType _selectedType = PropertyType.all;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final listings = globalMarketplaceState.propertyListings.where((prop) {
      final matchesType = _selectedType == PropertyType.all || prop.propertyType == _selectedType;
      final matchesQuery = _searchQuery.isEmpty ||
          prop.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prop.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prop.architecturalHighlight.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();

    final unlockedListings = globalMarketplaceState.propertyListings.where((p) => p.isUnlocked).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page Title & Subtitle Banner
              _buildPropertiesBanner(isDark, isMobile),
              const SizedBox(height: 18),

              // Search & Filter
              _buildFilterBar(isDark, isMobile),
              const SizedBox(height: 18),

              // Unlocked Direct Contacts Tray
              if (unlockedListings.isNotEmpty) ...[
                _buildUnlockedTray(unlockedListings, isDark, isMobile),
                const SizedBox(height: 20),
              ],

              // Section Header
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERIFIED RESIDENCES (${listings.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '100% Physical Inspection Audit',
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
                      'VERIFIED RESIDENCES (${listings.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '100% Physical Inspection Audit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              // Listings
              if (listings.isEmpty)
                _buildEmptyState(isDark)
              else
                ...listings.map((prop) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPropertyCard(prop, isDark, isMobile),
                    )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertiesBanner(bool isDark, bool isMobile) {
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
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.holiday_village_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verified Rental & Properties Network',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Direct owner luxury rentals with zero brokerage fees. Each residence undergoes a 42-point structural audit by Homio engineers.',
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
        // Search
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
              hintText: 'Search by neighborhood (e.g. Banjara Hills, Jubilee Hills), amenities, or BHK...',
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

        // Type filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: PropertyType.values.map((type) {
              final isSelected = _selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type.icon,
                        size: 14,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      Text(type.label),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedType = type),
                  selectedColor: const Color(0xFF8B5CF6),
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
                          ? const Color(0xFF8B5CF6)
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

  Widget _buildUnlockedTray(List<PropertyListing> unlocked, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
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
                    const Icon(Icons.verified_user_rounded, color: Color(0xFF8B5CF6), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'DIRECT OWNER CONTACTS UNLOCKED (${unlocked.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF8B5CF6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Zero Brokerage Applied',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Color(0xFF8B5CF6), size: 18),
                const SizedBox(width: 8),
                Text(
                  'DIRECT OWNER CONTACTS UNLOCKED (${unlocked.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8B5CF6),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Zero Brokerage Applied',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          ...unlocked.map((prop) => Container(
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
                              const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF10B981), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${prop.title} • Owner: ${prop.ownerName}',
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
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                prop.ownerPhone,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: const Color(0xFF10B981),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _simulateCall(prop),
                                icon: const Icon(Icons.call_rounded, size: 15),
                                label: const Text('Call Owner'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                          const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF10B981), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${prop.title} • Owner: ${prop.ownerName} (${prop.ownerPhone})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _simulateCall(prop),
                            icon: const Icon(Icons.call_rounded, size: 15),
                            label: const Text('Call Owner'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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

  Widget _buildPropertyCard(PropertyListing prop, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: prop.isUnlocked
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  prop.propertyType.label.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8B5CF6),
                    letterSpacing: 0.5,
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
                  '${prop.bhk} BHK • ${prop.carpetAreaSqFt} sq.ft Carpet',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ),
              if (prop.verifiedByHomio)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        'Homio Civil Verified',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              if (prop.hasVideoTour)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_circle_fill_rounded, size: 12, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      Text(
                        '4K Video Tour',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Title & Location
          Text(
            prop.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${prop.location}, ${prop.city}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Architectural Highlight box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.architecture_rounded, size: 16, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prop.architecturalHighlight,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Key amenities chips
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: prop.keyAmenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  amenity,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Unlocked Owner Section (if already unlocked)
          if (prop.isUnlocked) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Direct Owner: ${prop.ownerName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              prop.ownerPhone,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _simulateCall(prop),
                              icon: const Icon(Icons.call_rounded, size: 15),
                              label: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Direct Owner: ${prop.ownerName}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'Phone: ${prop.ownerPhone} • Zero Brokerage Agreement Active',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _simulateCall(prop),
                          icon: const Icon(Icons.call_rounded, size: 16),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                            minimumSize: const Size(0, 38),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),
          ],

          const Divider(height: 1),
          const SizedBox(height: 12),

          // Bottom Price & Action Row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPriceSection(prop, isDark),
                const SizedBox(height: 10),
                _buildActionButtons(prop, isDark, isMobile),
              ],
            )
          else
            Row(
              children: [
                _buildPriceSection(prop, isDark),
                const Spacer(),
                _buildActionButtons(prop, isDark, isMobile),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(PropertyListing prop, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(
              '₹${prop.monthlyRent.toInt()}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF8B5CF6),
              ),
            ),
            Text(
              ' / month',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Deposit: ₹${(prop.securityDeposit / 100000).toStringAsFixed(1)}L • ${prop.furnishingStatus}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(PropertyListing prop, bool isDark, bool isMobile) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        if (prop.hasVideoTour)
          OutlinedButton.icon(
            onPressed: () => _showVideoTourModal(context, prop, isDark),
            icon: const Icon(Icons.videocam_rounded, size: 16),
            label: const Text('Video Tour'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          ),
        if (!prop.isUnlocked)
          ElevatedButton.icon(
            onPressed: () => _showUnlockDialog(context, prop, isDark),
            icon: const Icon(Icons.key_rounded, size: 16),
            label: Text(isMobile ? 'Unlock Owner (₹500)' : 'Unlock Owner Contact (₹500)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
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

  void _showUnlockDialog(BuildContext context, PropertyListing prop, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Text(
            'Unlock Direct Owner Contact',
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
                'Unlock direct contact details for: "${prop.title}".',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Flat Fee: ₹500 (Zero Brokerage).\nYou save ₹1,00,000+ in broker commissions. You will receive direct phone contact with ${prop.ownerName} and full Homio physical inspection documents.',
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
                  prop.isUnlocked = true;
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF8B5CF6),
                    content: Text(
                      'Direct owner contact unlocked! Contact ${prop.ownerName} at ${prop.ownerPhone}.',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Pay ₹500 & Unlock',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVideoTourModal(BuildContext context, PropertyListing prop, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.videocam_rounded, color: Color(0xFF0284C7), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '4K Video Tour: ${prop.title}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            width: 500,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: AppRadius.md,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_circle_outline_rounded, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    'Streaming 4K Homio Verified Walkthrough',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${prop.location} • Carpet: ${prop.carpetAreaSqFt} sq.ft',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white70,
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
          ],
        );
      },
    );
  }

  void _simulateCall(PropertyListing prop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        content: Text(
          'Dialing direct owner ${prop.ownerName} (${prop.ownerPhone})...',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
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
              'No properties match your filter',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try selecting "All Homes" or clearing search keywords.',
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
