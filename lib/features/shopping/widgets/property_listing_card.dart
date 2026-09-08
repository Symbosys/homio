import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';

class PropertyListingCard extends StatefulWidget {
  final PropertyListing property;
  final VoidCallback onUnlock;
  final VoidCallback onVideoTour;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewLeads;

  const PropertyListingCard({
    super.key,
    required this.property,
    required this.onUnlock,
    required this.onVideoTour,
    this.onEdit,
    this.onDelete,
    this.onViewLeads,
  });

  @override
  State<PropertyListingCard> createState() => _PropertyListingCardState();
}

class _PropertyListingCardState extends State<PropertyListingCard> {
  int _activeImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);
    final p = widget.property;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: p.isUnlocked ? const Color(0xFF10B981).withValues(alpha: 0.6) : borderColor,
          width: p.isUnlocked ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Carousel Header
          Stack(
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: p.images.length,
                  onPageChanged: (idx) => setState(() => _activeImageIndex = idx),
                  itemBuilder: (ctx, idx) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        p.images[idx],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          child: const Icon(Icons.apartment_rounded, size: 50, color: AppColors.primary),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Top Badges (Intent + Verified)
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: p.intent.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        p.intent.label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_rounded, size: 11, color: Color(0xFF10B981)),
                          const SizedBox(width: 3),
                          Text(
                            p.propertyType.label,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Video Walkthrough & Admin Menu Buttons
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: widget.onVideoTour,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle_filled_rounded, size: 13, color: Colors.white),
                            SizedBox(width: 3),
                            Text(
                              '3D Tour',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.onEdit != null || widget.onDelete != null || widget.onViewLeads != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30),
                        ),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 14, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Manage Property',
                          onSelected: (val) {
                            if (val == 'edit') widget.onEdit?.call();
                            if (val == 'leads') widget.onViewLeads?.call();
                            if (val == 'delete') widget.onDelete?.call();
                          },
                          itemBuilder: (ctx) => [
                            if (widget.onEdit != null)
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded, size: 16, color: Color(0xFF3B82F6)),
                                    SizedBox(width: 8),
                                    Text('Edit Listing', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            if (widget.onViewLeads != null)
                              const PopupMenuItem(
                                value: 'leads',
                                child: Row(
                                  children: [
                                    Icon(Icons.monetization_on_rounded, size: 16, color: Color(0xFF10B981)),
                                    SizedBox(width: 8),
                                    Text('Buyer Leads & Unlocks (₹500)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            if (widget.onDelete != null)
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                                    SizedBox(width: 8),
                                    Text('Delete Property', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom Price & Image Indicator
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.intent == ListingIntent.rent) ...[
                          Text(
                            '₹${(p.monthlyRent / 1000).toStringAsFixed(0)}K / month',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Deposit: ₹${(p.securityDeposit / 100000).toStringAsFixed(1)} Lakhs',
                            style: const TextStyle(fontSize: 10, color: Colors.white70),
                          ),
                        ] else ...[
                          Text(
                            '₹${(p.salePrice / 10000000).toStringAsFixed(2)} Cr',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Freehold All-Inclusive',
                            style: TextStyle(fontSize: 10, color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
                    // Carousel Dot Indicator
                    Row(
                      children: List.generate(
                        p.images.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 5,
                          width: _activeImageIndex == i ? 14 : 5,
                          decoration: BoxDecoration(
                            color: _activeImageIndex == i ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Content Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Location / Zone
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.primary),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${p.societyName}, ${p.zone}, ${p.city}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondaryColor),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Key Specs Grid (BHK, Area, Furnishing, Floor)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpecItem(Icons.bed_rounded, '${p.bedrooms} BHK', textPrimaryColor, textMutedColor),
                            _buildSpecItem(Icons.bathtub_outlined, '${p.bathrooms} Baths', textPrimaryColor, textMutedColor),
                            _buildSpecItem(Icons.square_foot_rounded, '${p.superAreaSqft} sqft', textPrimaryColor, textMutedColor),
                            _buildSpecItem(Icons.chair_outlined, p.furnishing.split(' ').first, textPrimaryColor, textMutedColor),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Amenities Pills (single row scrollable or compact row)
                      SizedBox(
                        height: 22,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: p.amenities.map((am) {
                            return Container(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: borderColor),
                              ),
                              child: Center(
                                child: Text(
                                  am,
                                  style: TextStyle(fontSize: 9.5, color: textSecondaryColor),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  // Divider & Owner Section / Unlock CTA
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(height: 10, thickness: 1, color: borderColor),
                      const SizedBox(height: 4),
                      if (!p.isUnlocked) ...[
                        // Locked State
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.lock_rounded, size: 14, color: Color(0xFFF59E0B)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      p.ownerMaskedPhone,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                    ),
                                    const SizedBox(width: 6),
                                    Text('•', style: TextStyle(fontSize: 12, color: textMutedColor)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${p.ownerName.split(' ').first} S*******',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 11, color: textMutedColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: widget.onUnlock,
                            icon: const Icon(Icons.key_rounded, size: 15),
                            label: const Text(
                              'Unlock Direct Owner Contact (₹500)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Unlocked State (Direct Call & WhatsApp)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFF10B981),
                                child: Icon(Icons.person, size: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${p.ownerName} • ${p.ownerRealPhone}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 34,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Opening WhatsApp Chat with ${p.ownerName}...')),
                                    );
                                  },
                                  icon: const Icon(Icons.chat, size: 14),
                                  label: const Text('WhatsApp', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: 34,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Dialing ${p.ownerRealPhone}...')),
                                    );
                                  },
                                  icon: const Icon(Icons.call, size: 14),
                                  label: const Text('Call Owner', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, Color textPrimary, Color textMuted) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textPrimary),
        ),
      ],
    );
  }
}
