import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';
import '../widgets/shopping_header.dart';
import '../widgets/digital_product_card.dart';
import '../widgets/admin_add_digital_product_modal.dart';
import '../widgets/guide_preview_modal.dart';

class DigitalStorePage extends StatefulWidget {
  const DigitalStorePage({super.key});

  @override
  State<DigitalStorePage> createState() => _DigitalStorePageState();
}

class _DigitalStorePageState extends State<DigitalStorePage> {
  List<DigitalProduct> _products = List.from(ShoppingMockData.digitalProducts);
  int _activeTabIndex = 0; // 0: Published Catalogue, 1: Sales & Orders Ledger
  String _searchQuery = '';
  GuideCategory? _selectedCategory;
  String _sortBy = 'Popularity';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    // Filter Catalogue
    var filtered = _products.where((p) {
      if (_selectedCategory != null && p.category != _selectedCategory) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = p.title.toLowerCase().contains(q);
        final matchesAuthor = p.authorName.toLowerCase().contains(q);
        final matchesTags = p.tags.any((t) => t.toLowerCase().contains(q));
        if (!matchesTitle && !matchesAuthor && !matchesTags) return false;
      }
      return true;
    }).toList();

    // Sorting
    if (_sortBy == 'Price (Low to High)') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price (High to Low)') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      filtered.sort((a, b) => b.downloadsCount.compareTo(a.downloadsCount));
    }

    final totalDownloads = _products.fold<int>(0, (sum, p) => sum + p.downloadsCount);
    final totalRevenue = _products.fold<double>(0.0, (sum, p) => sum + (p.downloadsCount * p.price));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Publish Button
            ShoppingHeader(
              title: 'Digital Architectural Guides & Publications Store',
              subtitle: 'Publish, price, and manage proprietary architectural handbooks, Vastu blueprints, and contractor playbooks.',
              activeTab: 'Digital Guides Store',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('Catalogue (${_products.length})'),
                        icon: const Icon(Icons.auto_stories_rounded, size: 16),
                      ),
                      const ButtonSegment<int>(
                        value: 1,
                        label: Text('Sales & Orders Ledger'),
                        icon: Icon(Icons.receipt_long_rounded, size: 16),
                      ),
                    ],
                    selected: {_activeTabIndex},
                    onSelectionChanged: (set) => setState(() => _activeTabIndex = set.first),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton.icon(
                    onPressed: () => _openPublishModal(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Publish New Guide', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Cards
                  Row(
                    children: [
                      _buildMetricCard(
                        title: 'Total Handbooks Sold',
                        value: '$totalDownloads Copies',
                        subtitle: 'Across ${_products.length} published titles',
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFFF59E0B),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Total Digital Revenue',
                        value: '₹${(totalRevenue / 100000).toStringAsFixed(2)} Lakhs',
                        subtitle: '94% Net Profit Margin',
                        icon: Icons.currency_rupee_rounded,
                        color: const Color(0xFF10B981),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Top Ranked Publication',
                        value: 'Vastu Master Guide',
                        subtitle: '4.9 ★ Rating (340+ Reviews)',
                        icon: Icons.star_rounded,
                        color: const Color(0xFF8B5CF6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Platform Delivery Health',
                        value: '100% Instant Delivery',
                        subtitle: 'Automated S3 Encrypted Links',
                        icon: Icons.verified_user_rounded,
                        color: const Color(0xFF3B82F6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (_activeTabIndex == 0) ...[
                    // Search, Filter Tabs & Sort Controls
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Search Bar
                              Expanded(
                                child: TextField(
                                  onChanged: (val) => setState(() => _searchQuery = val),
                                  decoration: InputDecoration(
                                    hintText: 'Search publications by title, author, keyword (e.g. Vastu, Plywood, Ergonomics)...',
                                    prefixIcon: const Icon(Icons.search, size: 18),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: borderColor),
                                    ),
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Sort Dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: _sortBy,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: ['Popularity', 'Rating', 'Price (Low to High)', 'Price (High to Low)']
                                      .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                                      .toList(),
                                  onChanged: (val) => setState(() => _sortBy = val ?? 'Popularity'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Category Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryChip(
                                  label: 'All Publications (${_products.length})',
                                  isSelected: _selectedCategory == null,
                                  onSelected: () => setState(() => _selectedCategory = null),
                                ),
                                ...GuideCategory.values.map((cat) {
                                  final count = _products.where((p) => p.category == cat).length;
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: _buildCategoryChip(
                                      label: '${cat.label} ($count)',
                                      icon: cat.icon,
                                      isSelected: _selectedCategory == cat,
                                      onSelected: () => setState(() => _selectedCategory = cat),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Products Grid
                    if (filtered.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(Icons.menu_book_rounded, size: 48, color: textSecondaryColor),
                              const SizedBox(height: 12),
                              Text('No digital publications found matching your criteria.', style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (ctx, constraints) {
                          final crossAxisCount = constraints.maxWidth > 1200
                              ? 3
                              : constraints.maxWidth > 800
                                  ? 2
                                  : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 440,
                            ),
                            itemBuilder: (ctx, idx) {
                              final product = filtered[idx];
                              return DigitalProductCard(
                                product: product,
                                onPreview: () => _openPreviewModal(context, product),
                                onEdit: () => _openEditModal(context, product),
                                onDelete: () => _confirmDeleteProduct(context, product),
                              );
                            },
                          );
                        },
                      ),
                  ] else ...[
                    // Customer Sales & Orders Ledger
                    _buildOrdersLedger(surfaceColor, borderColor, textPrimaryColor, textSecondaryColor, isDark),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersLedger(Color surface, Color border, Color textPrimary, Color textSecondary, bool isDark) {
    final mockOrders = [
      {
        'orderId': 'ORD-DIG-9821',
        'customerName': 'Vikram Malhotra',
        'email': 'vikram.m@architects.in',
        'phone': '+91 98112 34567',
        'item': 'Vastu Shastra Master Blueprint & Spatial Compass',
        'amount': '₹499',
        'date': 'Today, 11:20 AM',
        'status': 'Delivered (WhatsApp + Email)',
      },
      {
        'orderId': 'ORD-DIG-9820',
        'customerName': 'Neha Sharma',
        'email': 'neha.interiors@gmail.com',
        'phone': '+91 98765 43210',
        'item': 'Indian Luxury Home Styling & Lighting Guide (2026)',
        'amount': '₹699',
        'date': 'Today, 09:45 AM',
        'status': 'Delivered (WhatsApp + Email)',
      },
      {
        'orderId': 'ORD-DIG-9819',
        'customerName': 'Rajesh Singhania',
        'email': 'rajesh@singhaniagroup.com',
        'phone': '+91 99887 76655',
        'item': 'Commercial Interior Contractor Standard Playbook',
        'amount': '₹999',
        'date': 'Yesterday, 04:30 PM',
        'status': 'Delivered (WhatsApp + Email)',
      },
      {
        'orderId': 'ORD-DIG-9818',
        'customerName': 'Ananya Deshmukh',
        'email': 'ananya.d@outlook.com',
        'phone': '+91 97110 99881',
        'item': 'Modular Kitchen Ergonomics & Hardware Handbook',
        'amount': '₹399',
        'date': '05 Sep 2026, 02:15 PM',
        'status': 'Delivered (WhatsApp + Email)',
      },
      {
        'orderId': 'ORD-DIG-9817',
        'customerName': 'Harish Patel',
        'email': 'harish.patel@buildtech.co',
        'phone': '+91 98223 11445',
        'item': 'Turnkey Interior Finishing Materials Comparison Handbook',
        'amount': '₹449',
        'date': '04 Sep 2026, 06:10 PM',
        'status': 'Delivered (WhatsApp + Email)',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded, color: Color(0xFF10B981), size: 20),
                const SizedBox(width: 10),
                Text('Real-Time Customer Purchases & Fulfillment Ledger', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary)),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting Sales Ledger CSV report...')));
                  },
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text('Export CSV Report', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockOrders.length,
            separatorBuilder: (ctx, i) => Divider(height: 1, color: border),
            itemBuilder: (ctx, idx) {
              final o = mockOrders[idx];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o['item']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text('Order: ${o['orderId']} • ${o['date']}', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o['customerName']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                          Text('${o['phone']} | ${o['email']}', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                    Text(o['amount']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        o['status']!,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, size: 18, color: AppColors.primary),
                      tooltip: 'Resend PDF Download Link to Customer',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Instant PDF download link resent to ${o['email']}')),
                        );
                      },
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

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 4)],
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : null),
    );
  }

  void _openPublishModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AdminAddDigitalProductModal(
        onSuccess: () {
          setState(() {
            _products = List.from(ShoppingMockData.digitalProducts);
          });
        },
      ),
    );
  }

  void _openEditModal(BuildContext context, DigitalProduct product) {
    showDialog(
      context: context,
      builder: (ctx) => AdminAddDigitalProductModal(
        initialProduct: product,
        onSuccess: () {
          setState(() {
            _products = List.from(ShoppingMockData.digitalProducts);
          });
        },
      ),
    );
  }

  void _openPreviewModal(BuildContext context, DigitalProduct product) {
    showDialog(
      context: context,
      builder: (ctx) => GuidePreviewModal(
        product: product,
        onBuy: () {
          Navigator.of(ctx).pop();
          _openEditModal(context, product);
        },
      ),
    );
  }

  void _confirmDeleteProduct(BuildContext context, DigitalProduct product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete / Archive Digital Publication?'),
        content: Text('Are you sure you want to remove "${product.title}" from the active store? Existing buyers will retain lifetime access.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              ShoppingMockData.deleteDigitalProduct(product.id);
              setState(() {
                _products = List.from(ShoppingMockData.digitalProducts);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Publication "${product.title}" archived successfully.')),
              );
            },
            child: const Text('Archive Publication'),
          ),
        ],
      ),
    );
  }
}
