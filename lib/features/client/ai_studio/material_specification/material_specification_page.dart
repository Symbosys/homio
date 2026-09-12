import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class MaterialSpecificationPage extends StatefulWidget {
  const MaterialSpecificationPage({super.key});

  @override
  State<MaterialSpecificationPage> createState() => _MaterialSpecificationPageState();
}

class _MaterialSpecificationPageState extends State<MaterialSpecificationPage> {
  MaterialCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allMaterials = AiStudioService.instance.materials;

    final filtered = allMaterials.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = item.productName.toLowerCase().contains(q);
        final matchesBrand = item.brand.toLowerCase().contains(q);
        final matchesArea = item.applicationArea.toLowerCase().contains(q);
        final matchesCode = item.gradeOrCode.toLowerCase().contains(q);
        return matchesName || matchesBrand || matchesArea || matchesCode;
      }
      return true;
    }).toList();

    final boqCount = allMaterials.where((m) => m.isSavedToProjectBOQ).length;

    return AiStudioPageScaffold(
      title: 'Material Intelligence & Specs',
      subtitle: 'Indian Standards (IS:710, IS:1658), Certified Brand Specs & Live Project BOQ Sync',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BOQ Sync Highlights Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.35) : const Color(0xFFECFDF5),
              borderRadius: AppRadius.lg,
              border: Border.all(
                color: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.playlist_add_check_circle_rounded, color: AppColors.success, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$boqCount Materials Synced to Project BOQ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
                        ),
                      ),
                      Text(
                        'Approved specifications automatically flow into your turnkey execution contract and contractor bill of quantities.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Bar & Filters
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: AppColors.getTextPrimary(context),
                    ),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search_rounded, size: 20),
                      hintText: 'Search brand, grade, plywood type, or hardware...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.getTextMuted(context),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showAddCustomMaterialDialog,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Add Custom Spec',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('All Categories (${allMaterials.length})'),
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
                ...MaterialCategory.values.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(cat.label),
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
          const SizedBox(height: 24),

          // Materials Grid
          if (filtered.isEmpty)
            const EmptyStateView(
              icon: Icons.texture_rounded,
              title: 'No materials match your filter',
              description: 'Try searching another brand name or reset your category filter.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 768;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 1.6 : 1.35,
                  ),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return MaterialSpecCard(
                      item: item,
                      onToggleBOQ: () {
                        setState(() {
                          AiStudioService.instance.toggleMaterialBOQ(item.id);
                        });
                        final updated = AiStudioService.instance.materials.firstWhere((m) => m.id == item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              updated.isSavedToProjectBOQ
                                  ? '${item.productName} added to Project BOQ!'
                                  : '${item.productName} removed from Project BOQ.',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  void _showAddCustomMaterialDialog() {
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    final areaCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    MaterialCategory category = MaterialCategory.carcassCore;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: Text(
            'Add Custom Material Specification',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 460,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<MaterialCategory>(
                    initialValue: category,
                    items: MaterialCategory.values
                        .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                        .toList(),
                    onChanged: (val) => setDlgState(() => category = val!),
                    decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'e.g. Action TESA HDHMR Board',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: brandCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Brand Manufacturer',
                      hintText: 'e.g. Action TESA',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: gradeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Standard / IS Code',
                      hintText: 'e.g. IS:1658 Density > 850 kg/m³',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: areaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Application Area',
                      hintText: 'e.g. Bedroom Wardrobe Carcasses',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: costCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Approx Cost per sq.ft (₹)',
                      hintText: 'e.g. 115',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final brand = brandCtrl.text.trim();
                if (name.isNotEmpty && brand.isNotEmpty) {
                  final cost = double.tryParse(costCtrl.text.trim()) ?? 120.0;
                  final newItem = MaterialSpecificationItem(
                    id: 'MAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    category: category,
                    productName: name,
                    brand: brand,
                    gradeOrCode: gradeCtrl.text.trim().isNotEmpty ? gradeCtrl.text.trim() : 'IS Standard Certified',
                    applicationArea: areaCtrl.text.trim().isNotEmpty ? areaCtrl.text.trim() : 'Interior Cabinetry',
                    durabilityLevel: 'Moisture Resistant Residential Grade',
                    costPerUnit: cost,
                    unit: 'sq.ft',
                    warrantyYears: 10,
                    maintenanceTips: 'Clean with damp cloth and mild cleanser.',
                    isSavedToProjectBOQ: true,
                  );
                  setState(() {
                    AiStudioService.instance.addCustomMaterial(newItem);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added and linked to BOQ!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Save Material'),
            ),
          ],
        ),
      ),
    );
  }
}
