import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/profile_models.dart';
import 'add_edit_address_modal.dart';

/// Address book component listing all saved properties & project site delivery points
class AddressBookSection extends StatelessWidget {
  final List<CustomerAddress> addresses;
  final VoidCallback onAddressUpdated;

  const AddressBookSection({
    super.key,
    required this.addresses,
    required this.onAddressUpdated,
  });

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'project site':
        return Icons.construction_rounded;
      case 'office':
        return Icons.business_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'project site':
        return const Color(0xFF10B981);
      case 'office':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF0EA5E9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Saved Addresses (${addresses.length})',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => AddEditAddressModal.show(context).then((_) => onAddressUpdated()),
              icon: const Icon(Icons.add_location_alt_outlined, size: 16),
              label: Text(
                'Add Address',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...addresses.map((addr) {
          final typeColor = _colorForType(addr.title);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: addr.isDefault
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
                width: addr.isDefault ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_iconForType(addr.title), size: 14, color: typeColor),
                          const SizedBox(width: 5),
                          Text(
                            addr.title.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: typeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (addr.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      onPressed: () => AddEditAddressModal.show(context, address: addr)
                          .then((_) => onAddressUpdated()),
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 16),
                      onPressed: () {
                        ProfileRepository.instance.deleteAddress(addr.id);
                        onAddressUpdated();
                      },
                      color: const Color(0xFFEF4444),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Text(
                  addr.formattedAddress,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                if (addr.landmark.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Landmark: ${addr.landmark}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${addr.contactPerson} (${addr.contactPhone})',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (!addr.isDefault)
                      TextButton(
                        onPressed: () {
                          ProfileRepository.instance.setDefaultAddress(addr.id);
                          onAddressUpdated();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Set Default',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
