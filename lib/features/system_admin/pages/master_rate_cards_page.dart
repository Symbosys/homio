import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/system_admin_models.dart';
import '../models/system_admin_mock_data.dart';

class MasterRateCardsPage extends StatefulWidget {
  const MasterRateCardsPage({super.key});

  @override
  State<MasterRateCardsPage> createState() => _MasterRateCardsPageState();
}

class _MasterRateCardsPageState extends State<MasterRateCardsPage> {
  final List<MasterRateCardItem> _items = List.from(SystemAdminMockData.masterRateCards);
  final List<MarginTierRule> _marginRules = SystemAdminMockData.marginRules;
  RateCategory? _selectedCategory;
  String _searchQuery = '';

  List<MasterRateCardItem> get _filteredItems {
    return _items.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return item.itemName.toLowerCase().contains(q) ||
            item.itemCode.toLowerCase().contains(q) ||
            item.preferredBrand.toLowerCase().contains(q) ||
            item.subCategory.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  void _applyInflationMultiplier(double percentage) {
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        final current = _items[i];
        final factor = 1.0 + (percentage / 100.0);
        final newMaterial = (current.materialCost * factor).roundToDouble();
        final newLabor = (current.contractorLaborRate * factor).roundToDouble();
        final newSelling = (current.recommendedSellingPrice * factor).roundToDouble();

        _items[i] = current.copyWith(
          materialCost: newMaterial,
          contractorLaborRate: newLabor,
          recommendedSellingPrice: newSelling,
          lastUpdated: DateTime.now(),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Applied +$percentage% Global Inflation Adjustment across all ${_items.length} master rate items.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0F9D58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showAddRateItemModal(bool isDark) {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController(text: 'WD-MOD-${_items.length + 1}');
    final subCatCtrl = TextEditingController(text: 'Cabinetry Finishes');
    final materialCostCtrl = TextEditingController(text: '80');
    final laborCostCtrl = TextEditingController(text: '40');
    final sellingPriceCtrl = TextEditingController(text: '180');
    final brandCtrl = TextEditingController(text: 'CenturyPly / Hettich');
    final specCtrl = TextEditingController(text: 'High-density moisture-resistant core sheet with factory edge-band');
    RateCategory selectedCat = RateCategory.modularWoodwork;
    RateUnitType selectedUnit = RateUnitType.sqft;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final matCost = double.tryParse(materialCostCtrl.text) ?? 0;
          final labCost = double.tryParse(laborCostCtrl.text) ?? 0;
          final sellPrice = double.tryParse(sellingPriceCtrl.text) ?? 0;
          final totalCost = matCost + labCost;
          final marginPct = sellPrice > 0 ? ((sellPrice - totalCost) / sellPrice) * 100 : 0.0;

          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.add_box_rounded, color: AppColors.gold, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Add Master Rate Item',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 540,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Define a verified enterprise specification, vendor base cost, contractor labor, and protected selling price.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                      decoration: const InputDecoration(labelText: 'Item Name / Description (e.g. 19mm HDHMR Carcass)'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: codeCtrl,
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                            decoration: const InputDecoration(labelText: 'Item Code'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<RateCategory>(
                            initialValue: selectedCat,
                            dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 12),
                            decoration: const InputDecoration(labelText: 'Trade Category'),
                            items: RateCategory.values.map((c) {
                              return DropdownMenuItem(value: c, child: Text(c.label, overflow: TextOverflow.ellipsis));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedCat = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subCatCtrl,
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                            decoration: const InputDecoration(labelText: 'Sub-Category / Work Area'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<RateUnitType>(
                            initialValue: selectedUnit,
                            dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                            decoration: const InputDecoration(labelText: 'Unit Metric'),
                            items: RateUnitType.values.map((u) {
                              return DropdownMenuItem(value: u, child: Text(u.label));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedUnit = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: materialCostCtrl,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setModalState(() {}),
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                            decoration: const InputDecoration(labelText: 'Material Base (₹)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: laborCostCtrl,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setModalState(() {}),
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                            decoration: const InputDecoration(labelText: 'Labor Rate (₹)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: sellingPriceCtrl,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setModalState(() {}),
                            style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                            decoration: const InputDecoration(labelText: 'Selling Price (₹)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Live Computed Margin Pill
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (marginPct >= 20
                                ? const Color(0xFF10B981)
                                : (marginPct >= 12 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (marginPct >= 20
                                  ? const Color(0xFF10B981)
                                  : (marginPct >= 12 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)))
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Base Cost: ₹${totalCost.toStringAsFixed(0)} / ${selectedUnit.label}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                            ),
                          ),
                          Text(
                            'Gross Margin: ${marginPct.toStringAsFixed(1)}% ${marginPct < 12 ? '(BREACH: < 12% Floor Lock)' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: marginPct >= 20
                                  ? const Color(0xFF10B981)
                                  : (marginPct >= 12 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: brandCtrl,
                      style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                      decoration: const InputDecoration(labelText: 'Preferred Brands / Manufacturers'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: specCtrl,
                      maxLines: 2,
                      style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                      decoration: const InputDecoration(labelText: 'Technical Specification & Guarantee'),
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
                  if (nameCtrl.text.isEmpty) return;
                  final newItem = MasterRateCardItem(
                    id: 'RATE-${_items.length + 1}',
                    itemCode: codeCtrl.text,
                    itemName: nameCtrl.text,
                    category: selectedCat,
                    subCategory: subCatCtrl.text,
                    unit: selectedUnit,
                    materialCost: double.tryParse(materialCostCtrl.text) ?? 0,
                    contractorLaborRate: double.tryParse(laborCostCtrl.text) ?? 0,
                    recommendedSellingPrice: double.tryParse(sellingPriceCtrl.text) ?? 0,
                    preferredBrand: brandCtrl.text,
                    technicalSpecification: specCtrl.text,
                    lastUpdated: DateTime.now(),
                  );
                  setState(() {
                    _items.insert(0, newItem);
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Add to Catalogue', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final avgMargin = _items.fold<double>(0, (sum, i) => sum + i.activeMarginPercentage) / (_items.isEmpty ? 1 : _items.length);
    final breachCount = _items.where((i) => i.activeMarginPercentage < 15).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildMetricsRow(isDark, avgMargin, breachCount, width),
            const SizedBox(height: 24),
            _buildMarginGuardrailBanner(isDark),
            const SizedBox(height: 24),
            _buildMarginTierRulesCard(isDark, width),
            const SizedBox(height: 24),
            _buildSearchAndCategoryTabs(isDark, isDesktop),
            const SizedBox(height: 16),
            isDesktop ? _buildRateItemsTable(isDark) : _buildRateItemsMobile(isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.fact_check_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Master Rate Cards & Margin Configurations',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'PRD Module 14.2 & 8.0: Centralized quotation backend master DB, material specs, unit metrics, and margin floor locks.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: () => _applyInflationMultiplier(5.0),
              icon: const Icon(Icons.trending_up_rounded, size: 16),
              label: const Text('+5% Inflation Adj.'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddRateItemModal(isDark),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Rate Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.deepNavy,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsRow(bool isDark, double avgMargin, int breachCount, double width) {
    final isDesktop = width >= Breakpoints.medium;

    final cards = [
      _buildMetricCard(
        title: 'Master Items Active',
        value: '${_items.length} Specifications',
        subtitle: 'Across 7 construction trades',
        icon: Icons.inventory_2_outlined,
        color: AppColors.gold,
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Average Gross Margin',
        value: '${avgMargin.toStringAsFixed(1)}%',
        subtitle: 'Target: 25.0% - 32.0%',
        icon: Icons.pie_chart_outline_rounded,
        color: const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Floor Margin Alerts',
        value: '$breachCount Items Below 15%',
        subtitle: 'Requires Director discount sign-off',
        icon: Icons.warning_amber_rounded,
        color: breachCount > 0 ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Annual Revision Status',
        value: 'Q3 2026 Active',
        subtitle: 'Vendor price index synced',
        icon: Icons.sync_rounded,
        color: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards.map((c) => SizedBox(width: (width - 44) / 2, child: c)).toList(),
      );
    }
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMarginGuardrailBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.10 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVE MARGIN FLOOR POLICY: 12.0% MINIMUM GUARDRAIL HARD STOP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Sales consultants cannot submit client quotations where combined line item margins fall below 12.0%. Any custom pricing between 12.0% - 18.0% triggers automated approval routing to the Sales Head.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarginTierRulesCard(bool isDark, double width) {
    final isDesktop = width >= Breakpoints.medium;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rule_folder_outlined, color: AppColors.gold, size: 18),
              const SizedBox(width: 10),
              Text(
                'Enterprise Project Margin Tiers & Sign-off Authority',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          isDesktop
              ? Row(
                  children: _marginRules.map((rule) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildTierCard(rule, isDark),
                      ),
                    );
                  }).toList(),
                )
              : Column(
                  children: _marginRules.map((rule) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildTierCard(rule, isDark),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildTierCard(MarginTierRule rule, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rule.tierName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rule.budgetRange,
            style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Target Gross Margin:', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
              Text('${rule.targetGrossMargin.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Minimum Floor Margin:', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
              Text('${rule.minimumFloorMargin.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFF59E0B))),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rule.approverRole,
            style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndCategoryTabs(bool isDark, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: _selectedCategory == null,
                  showCheckmark: false,
                  label: const Text('All Categories'),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: _selectedCategory == null ? FontWeight.w700 : FontWeight.w500,
                    color: _selectedCategory == null ? AppColors.deepNavy : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                  ),
                  selectedColor: AppColors.gold,
                  backgroundColor: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onSelected: (val) => setState(() => _selectedCategory = null),
                ),
              ),
              ...RateCategory.values.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    label: Text(cat.label),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.deepNavy : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                    selectedColor: AppColors.gold,
                    backgroundColor: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Search Bar
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            decoration: InputDecoration(
              hintText: 'Search items by name, specification, brand, or code...',
              hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRateItemsTable(bool isDark) {
    final items = _filteredItems;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'ITEM DESCRIPTION & SPECIFICATION',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  ),
                ),
                _buildHeaderCell('UNIT', 1, isDark),
                _buildHeaderCell('MATERIAL (₹)', 2, isDark),
                _buildHeaderCell('LABOR (₹)', 2, isDark),
                _buildHeaderCell('TOTAL COST', 2, isDark),
                _buildHeaderCell('SELLING (₹)', 2, isDark),
                _buildHeaderCell('GROSS MARGIN', 2, isDark),
                _buildHeaderCell('STATUS', 2, isDark),
              ],
            ),
          ),

          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            itemBuilder: (context, index) {
              final item = items[index];
              final marginPct = item.activeMarginPercentage;
              final isSafe = marginPct >= 20;
              final isWarning = marginPct >= 12 && marginPct < 20;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    // Item details
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.itemName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.itemCode,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.subCategory} • Brand: ${item.preferredBrand}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.technicalSpecification,
                            style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubtext.withValues(alpha: 0.7) : AppColors.lightTextMuted.withValues(alpha: 0.8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Metrics
                    _buildCellText(item.unit.label, 1, isDark),
                    _buildCellText('₹${item.materialCost.toStringAsFixed(0)}', 2, isDark),
                    _buildCellText('₹${item.contractorLaborRate.toStringAsFixed(0)}', 2, isDark),
                    _buildCellText('₹${item.totalBaseCost.toStringAsFixed(0)}', 2, isDark, isBold: true),
                    _buildCellText('₹${item.recommendedSellingPrice.toStringAsFixed(0)}', 2, isDark, isGold: true),

                    // Gross margin %
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isSafe ? const Color(0xFF10B981) : (isWarning ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)))
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${marginPct.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isSafe ? const Color(0xFF10B981) : (isWarning ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Guardrail status badge
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSafe ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSafe ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFFF59E0B).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            isSafe ? 'PROTECTED' : (isWarning ? 'REVIEW' : 'BREACH'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isSafe ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, int flex, bool isDark) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
      ),
    );
  }

  Widget _buildCellText(String text, int flex, bool isDark, {bool isBold = false, bool isGold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isBold || isGold ? FontWeight.w700 : FontWeight.w500,
          color: isGold ? AppColors.gold : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
        ),
      ),
    );
  }

  Widget _buildRateItemsMobile(bool isDark) {
    final items = _filteredItems;

    return Column(
      children: items.map((item) {
        final marginPct = item.activeMarginPercentage;
        final isSafe = marginPct >= 20;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                    child: Text(item.itemCode, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gold)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('${item.category.label} • ${item.subCategory}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
              const SizedBox(height: 4),
              Text(item.technicalSpecification, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Unit: ${item.unit.label}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
                  Text('Base Cost: ₹${item.totalBaseCost.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
                  Text('Selling: ₹${item.recommendedSellingPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.gold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isSafe ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${marginPct.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: isSafe ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
