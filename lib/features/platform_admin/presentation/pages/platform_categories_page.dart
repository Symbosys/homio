import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/platform_marketplace_category_model.dart';
import '../queries/platform_marketplace_queries.dart';
import '../widgets/create_edit_category_dialog.dart';

class PlatformCategoriesPage extends StatefulWidget {
  const PlatformCategoriesPage({super.key});

  @override
  State<PlatformCategoriesPage> createState() => _PlatformCategoriesPageState();
}

class _PlatformCategoriesPageState extends State<PlatformCategoriesPage> {
  final PlatformMarketplaceQueries _queries = PlatformMarketplaceQueries();
  String _selectedVertical = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  static const List<Map<String, String>> _verticalTabs = [
    {'value': 'ALL', 'label': 'All Verticals'},
    {'value': 'PROPERTIES', 'label': 'Real Estate'},
    {'value': 'MATERIALS', 'label': 'Materials'},
    {'value': 'HOME_DECOR', 'label': 'Home Decor'},
    {'value': 'DIGITAL_ASSET', 'label': 'Digital Assets'},
    {'value': 'OTHER', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCategoryDialog(
    List<PlatformMarketplaceCategoryModel> allCategories, [
    PlatformMarketplaceCategoryModel? existing,
  ]) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateEditCategoryDialog(
        initialCategory: existing,
        existingCategories: allCategories,
        onSubmit: (data, {imageBytes, imageFileName}) async {
          if (existing != null) {
            await _queries.getUpdateCategoryMutation().mutate((
              id: existing.id,
              data: data,
              imageBytes: imageBytes,
              imageFileName: imageFileName,
            ));
          } else {
            await _queries.getCreateCategoryMutation().mutate((
              data: data,
              imageBytes: imageBytes,
              imageFileName: imageFileName,
            ));
          }
        },
      ),
    );
  }

  Future<void> _deleteCategory(PlatformMarketplaceCategoryModel cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${cat.name}"?'),
        content: const Text(
          'Are you sure you want to delete this category? Items in this category might be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _queries.getDeleteCategoryMutation().mutate(cat.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesQuery = _queries.getCategoriesQuery(
      marketplaceType: _selectedVertical == 'ALL' ? null : _selectedVertical,
    );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Marketplace Categories',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage master taxonomy, verticals, and hierarchical catalog structures',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                QueryBuilder(
                  query: categoriesQuery,
                  builder: (context, state) {
                    final list = state.data ?? [];
                    return AppButton(
                      text: 'Create Category',
                      prefixIcon: Icons.add_rounded,
                      onPressed: () => _openCategoryDialog(list),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Vertical Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _verticalTabs.map((tab) {
                  final isSelected = _selectedVertical == tab['value'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        tab['label']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF8B5CF6),
                      backgroundColor:
                          isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedVertical = tab['value']!);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Search categories by name, code, or slug...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
            ),
            const SizedBox(height: 18),

            // Categories Table / List
            Expanded(
              child: QueryBuilder(
                query: categoriesQuery,
                builder: (context, state) {
                  if (state.data == null && state.error == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                    );
                  }

                  if (state.error != null && state.data == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load categories',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => categoriesQuery.refetch(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final all = state.data ?? [];
                  final filtered = all.where((c) {
                    if (_searchQuery.isEmpty) return true;
                    return c.name.toLowerCase().contains(_searchQuery) ||
                        c.code.toLowerCase().contains(_searchQuery) ||
                        c.slug.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 48,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No categories found',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try changing the vertical filter or create a new category',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 360,
                      mainAxisExtent: 290,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final parentCat = item.parentId != null
                          ? all.where((c) => c.id == item.parentId).firstOrNull
                          : null;
                      return _buildCategoryCard(
                        context: context,
                        item: item,
                        parentCategory: parentCat,
                        allCategories: all,
                        isDark: isDark,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required PlatformMarketplaceCategoryModel item,
    required PlatformMarketplaceCategoryModel? parentCategory,
    required List<PlatformMarketplaceCategoryModel> allCategories,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image / Banner with Badges
            SizedBox(
              height: 125,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                    Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderBanner(item, isDark),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF8B5CF6),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    _buildPlaceholderBanner(item, isDark),

                  // Dark subtle gradient overlay on bottom of image for contrast
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Top-Left: Vertical Tag
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getIconForType(item.marketplaceType),
                            size: 13,
                            color: const Color(0xFFA78BFA),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatVerticalName(item.marketplaceType),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top-Right: Active / Disabled Status Pill
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.isActive
                            ? const Color(0xFF10B981).withValues(alpha: 0.9)
                            : Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.isActive ? 'Active' : 'Disabled',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Bottom-Left: Code Pill
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.code,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Slug & Parent Hierarchy Info
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '/${item.slug}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        if (parentCategory != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'in ${parentCategory.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Description
                    Expanded(
                      child: Text(
                        item.description != null && item.description!.isNotEmpty
                            ? item.description!
                            : 'No description provided.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          height: 1.35,
                          fontStyle: (item.description == null || item.description!.isEmpty)
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card Footer / Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Item count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 13,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${item.itemCount} ${item.itemCount == 1 ? "item" : "items"}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Edit action button
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    tooltip: 'Edit Category',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _openCategoryDialog(allCategories, item),
                  ),

                  // Delete action button
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 17, color: Colors.red),
                    tooltip: 'Delete Category',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _deleteCategory(item),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderBanner(PlatformMarketplaceCategoryModel item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF312E81),
                  const Color(0xFF1E1B4B),
                ]
              : [
                  const Color(0xFFEDE9FE),
                  const Color(0xFFDDD6FE),
                ],
        ),
      ),
      child: Center(
        child: Icon(
          _getIconForType(item.marketplaceType),
          size: 40,
          color: isDark
              ? const Color(0xFFA78BFA).withValues(alpha: 0.6)
              : const Color(0xFF8B5CF6).withValues(alpha: 0.6),
        ),
      ),
    );
  }

  String _formatVerticalName(String type) {
    switch (type) {
      case 'PROPERTIES':
        return 'Real Estate';
      case 'MATERIALS':
        return 'Materials';
      case 'HOME_DECOR':
        return 'Home Decor';
      case 'DIGITAL_ASSET':
        return 'Digital Assets';
      default:
        return type;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'PROPERTIES':
        return Icons.apartment_rounded;
      case 'MATERIALS':
        return Icons.layers_rounded;
      case 'HOME_DECOR':
        return Icons.chair_rounded;
      case 'DIGITAL_ASSET':
        return Icons.folder_zip_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
