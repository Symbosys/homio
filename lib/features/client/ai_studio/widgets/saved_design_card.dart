import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/saved_design_item.dart';

class SavedDesignCard extends StatelessWidget {
  final SavedDesignItem item;
  final VoidCallback onToggleShare;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const SavedDesignCard({
    super.key,
    required this.item,
    required this.onToggleShare,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: item.imageUrl.startsWith('http')
                        ? Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF1E293B),
                              child: const Icon(Icons.broken_image, color: Colors.white24),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF1E293B),
                            child: const Icon(Icons.image, color: Colors.white24),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: AppRadius.xs,
                      ),
                      child: Text(
                        item.category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(26, 26),
                      ),
                      onPressed: onRemove,
                      tooltip: 'Remove from Saved',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.colorPalette.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: item.colorPalette.map((hex) {
                          final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                          return Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black12),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (item.keyMaterials.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.keyMaterials.take(2).map((mat) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                              borderRadius: AppRadius.xs,
                            ),
                            child: Text(
                              mat,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          item.isSharedWithDesigner
                              ? Icons.check_circle_rounded
                              : Icons.send_rounded,
                          size: 14,
                          color: item.isSharedWithDesigner
                              ? AppColors.success
                              : AppColors.primaryLight,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.isSharedWithDesigner
                              ? 'Shared with Designer'
                              : 'Share with Designer',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: item.isSharedWithDesigner
                                  ? AppColors.success
                                  : AppColors.primaryLight,
                            ),
                          ),
                        ),
                        Switch(
                          value: item.isSharedWithDesigner,
                          onChanged: (_) => onToggleShare(),
                          activeThumbColor: AppColors.success,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
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
}
