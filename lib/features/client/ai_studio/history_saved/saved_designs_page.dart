import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class SavedDesignsPage extends StatefulWidget {
  const SavedDesignsPage({super.key});

  @override
  State<SavedDesignsPage> createState() => _SavedDesignsPageState();
}

class _SavedDesignsPageState extends State<SavedDesignsPage> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allSaved = AiStudioService.instance.savedDesigns;

    final categories = allSaved.map((s) => s.category).toSet().toList();
    final filtered = _selectedCategory == null
        ? allSaved
        : allSaved.where((s) => s.category == _selectedCategory).toList();

    return AiStudioPageScaffold(
      title: 'Saved Studio Vault & Moodboards',
      subtitle: 'Organize Your Favorite 3D Transformations, Color Palettes & Share Bookmarks with Your Designer',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter Chips
          if (categories.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('All Spaces (${allSaved.length})'),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                    selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                    backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                    labelStyle: TextStyle(
                      color: _selectedCategory == null
                          ? AppColors.primaryLight
                          : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                      fontWeight: _selectedCategory == null ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                  ),
                  ...categories.map((cat) {
                    final isSelected = cat == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                        backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primaryLight
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Grid
          if (filtered.isEmpty)
            const EmptyStateView(
              icon: Icons.bookmark_border_rounded,
              title: 'Your Saved Studio Vault is Empty',
              description: 'Save 3D room transformations or visual concepts here to build your personalized moodboard.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth >= 1080) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth >= 650) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: crossAxisCount == 1 ? 1.4 : 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return SavedDesignCard(
                      item: item,
                      onToggleShare: () {
                        setState(() {
                          AiStudioService.instance.toggleShareWithDesigner(item.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              item.isSharedWithDesigner
                                  ? 'Unshared with designer.'
                                  : 'Shared directly with your assigned architect!',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      onRemove: () {
                        setState(() {
                          AiStudioService.instance.toggleBookmarkDesign(item);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed from Studio Vault.')),
                        );
                      },
                      onTap: () => _showInspectDialog(context, item),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  void _showInspectDialog(BuildContext context, SavedDesignItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.md,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey.shade900),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Category: ${item.category}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                if (item.personalNotes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Notes: ${item.personalNotes}', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                ],
                if (item.keyMaterials.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text('Key Materials:', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12)),
                  const SizedBox(height: 4),
                  ...item.keyMaterials.map((m) => Text('• $m', style: GoogleFonts.plusJakartaSans(fontSize: 12))),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
