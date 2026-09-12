import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/property_models.dart';
import '../../services/marketplace_service.dart';
import '../../widgets/marketplace_bottom_sheet.dart';
import '../../widgets/spec_row.dart';
import '../../widgets/verified_badge.dart';
import 'contact_unlock_dialog.dart';

/// Comprehensive modal detail sheet for a verified property listing
class PropertyDetailSheet extends StatelessWidget {
  final PropertyItem property;

  const PropertyDetailSheet({super.key, required this.property});

  static void show(BuildContext context, PropertyItem property) {
    MarketplaceBottomSheet.show(
      context: context,
      title: property.title,
      subtitle: '${property.locality}, ${property.city}',
      headerTag: const VerifiedBadge(type: VerifiedBadgeType.reraApproved),
      body: PropertyDetailSheet(property: property),
      bottomBar: _PropertyBottomBar(property: property),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ListenableBuilder(
      listenable: MarketplaceService(),
      builder: (context, _) {
        final isUnlocked = MarketplaceService().isPropertyUnlocked(property.id);

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Image Gallery
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  property.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    child: const Icon(Icons.apartment_rounded, size: 48, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Key Highlights Bar (BHK, Bath, Area, Furnishing)
            Row(
              children: [
                _buildQuickStat('${property.bedrooms} BHK', 'Bedrooms', Icons.bed_rounded, isDark, border, textPrimary, textMuted),
                const SizedBox(width: 8),
                _buildQuickStat('${property.bathrooms}', 'Baths', Icons.bathtub_outlined, isDark, border, textPrimary, textMuted),
                const SizedBox(width: 8),
                _buildQuickStat('${property.carpetAreaSqFt}', 'Carpet Sq.Ft', Icons.square_foot_rounded, isDark, border, textPrimary, textMuted),
                const SizedBox(width: 8),
                _buildQuickStat('${property.parkingSpots}', 'Car Parks', Icons.directions_car_filled_outlined, isDark, border, textPrimary, textMuted),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              'Architectural Overview',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              property.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: textMuted,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Compliance & Vastu
            Text(
              'RERA & Vastu Compliance',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            SpecRow(label: 'RERA Registration', value: property.reraNumber, icon: Icons.gavel_rounded),
            SpecRow(label: 'Vastu Alignment', value: property.vastuFacing, icon: Icons.explore_rounded),
            SpecRow(label: 'Super Built-up Area', value: '${property.superAreaSqFt} sq.ft', icon: Icons.straighten_rounded),
            SpecRow(label: 'Furnishing Status', value: property.furnishingStatus, icon: Icons.chair_outlined),
            SpecRow(label: 'Possession Date', value: property.availableFrom, icon: Icons.event_available_rounded),

            const SizedBox(height: 20),

            // Amenities
            if (property.amenities.isNotEmpty) ...[
              Text(
                'Exclusive Amenities',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: property.amenities
                    .map((a) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF10B981)),
                              const SizedBox(width: 6),
                              Text(
                                a,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Direct Owner Contact Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? const Color(0xFF10B981).withValues(alpha: 0.1)
                    : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                        color: isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isUnlocked ? 'Direct Owner Contact (Unlocked)' : 'Direct Owner Contact (Locked)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (isUnlocked) ...[
                    SpecRow(label: 'Owner Name', value: property.ownerName),
                    SpecRow(label: 'Phone Number', value: property.ownerPhone),
                    SpecRow(label: 'Email', value: property.ownerEmail),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Calling ${property.ownerName} (${property.ownerPhone})...'),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            },
                            icon: const Icon(Icons.call_rounded, size: 16),
                            label: const Text('Call Owner'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening WhatsApp with ${property.ownerName}...'),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF10B981),
                              side: const BorderSide(color: Color(0xFF10B981)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'Unlock direct phone and email access to the title holder with zero brokerage commission.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => ContactUnlockDialog.show(context, property),
                        icon: const Icon(Icons.key_rounded, size: 16),
                        label: Text(
                          'Unlock Owner Contact (₹${property.unlockFee.toStringAsFixed(0)})',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStat(
    String value,
    String label,
    IconData icon,
    bool isDark,
    Color border,
    Color textPrimary,
    Color textMuted,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF10B981)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyBottomBar extends StatelessWidget {
  final PropertyItem property;

  const _PropertyBottomBar({required this.property});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MarketplaceService(),
      builder: (context, _) {
        final isUnlocked = MarketplaceService().isPropertyUnlocked(property.id);

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    property.listingType.label,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    property.formattedPrice,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (isUnlocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connecting to ${property.ownerName}...'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                } else {
                  ContactUnlockDialog.show(context, property);
                }
              },
              icon: Icon(isUnlocked ? Icons.call_rounded : Icons.lock_open_rounded, size: 16),
              label: Text(
                isUnlocked ? 'Contact Owner' : 'Unlock Contact (₹${property.unlockFee.toStringAsFixed(0)})',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                foregroundColor: isUnlocked ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }
}
