import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';
import '../widgets/shopping_header.dart';
import '../widgets/property_listing_card.dart';
import '../widgets/property_unlock_modal.dart';
import '../widgets/admin_add_property_modal.dart';
import '../widgets/admin_property_leads_modal.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  int _selectedTabIndex = 0; // 0: Browse Properties, 1: Unlocked Contacts History
  String _searchCity = 'All Cities';
  ListingIntent? _selectedIntent;
  int? _selectedBhk;

  List<PropertyListing> get _properties => ShoppingMockData.properties;
  List<PropertyUnlockRecord> get _unlockRecords => ShoppingMockData.unlockRecords;

  void _openAddEditPropertyModal([PropertyListing? property]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AdminAddPropertyModal(
        initialProperty: property,
        onSuccess: () => setState(() {}),
      ),
    );
  }

  void _openPropertyLeadsModal(PropertyListing property) {
    showDialog(
      context: context,
      builder: (ctx) => AdminPropertyLeadsModal(
        property: property,
      ),
    );
  }

  void _deleteProperty(PropertyListing property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Delete Property Listing', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to delete "${property.title}"? This will permanently remove the listing.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              ShoppingMockData.deleteProperty(property.id);
              Navigator.of(ctx).pop();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Property #${property.id} deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    // Filter Properties
    final filtered = _properties.where((p) {
      if (_searchCity != 'All Cities' && !p.city.toLowerCase().contains(_searchCity.toLowerCase())) return false;
      if (_selectedIntent != null && p.intent != _selectedIntent) return false;
      if (_selectedBhk != null && p.bedrooms != _selectedBhk) return false;
      return true;
    }).toList();

    final unlockedCount = _properties.where((p) => p.isUnlocked).length;
    final totalPaywallRevenue = _unlockRecords.fold<double>(0.0, (sum, r) => sum + r.paidAmount);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ShoppingHeader(
              title: 'Verified Luxury Rental & Real Estate Marketplace',
              subtitle: 'Direct owner property listings with 3D virtual tours and ₹500 verified contact unlock paywall.',
              activeTab: 'Rental & Real Estate (₹500 Paywall)',
              trailing: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SegmentedButton<int>(
                    segments: [
                      const ButtonSegment<int>(
                        value: 0,
                        label: Text('Browse Properties'),
                        icon: Icon(Icons.apartment_rounded, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('Unlocked Contacts ($unlockedCount)'),
                        icon: const Icon(Icons.lock_open_rounded, size: 16),
                      ),
                    ],
                    selected: {_selectedTabIndex},
                    onSelectionChanged: (set) => setState(() => _selectedTabIndex = set.first),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openAddEditPropertyModal(),
                    icon: const Icon(Icons.add_home_work_rounded, size: 18),
                    label: const Text('List New Property', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // KPI Row
                  Row(
                    children: [
                      _buildMetricCard(
                        title: 'Verified Luxury Properties',
                        value: '${_properties.length} Active Listings',
                        subtitle: 'DLF 5, Bandra West, Indiranagar',
                        icon: Icons.domain_verification_rounded,
                        color: const Color(0xFF10B981),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Unlocked Direct Owners',
                        value: '$unlockedCount Contacts Revealed',
                        subtitle: 'Zero Brokerage Direct Deals',
                        icon: Icons.lock_open_rounded,
                        color: const Color(0xFF3B82F6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Paywall Monetization (₹500)',
                        value: '₹${totalPaywallRevenue.toStringAsFixed(0)} Collected',
                        subtitle: '100% Platform Margin',
                        icon: Icons.monetization_on_rounded,
                        color: const Color(0xFFF59E0B),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMetricCard(
                        title: 'Average Monthly Rent',
                        value: '₹2.38 Lakhs/mo',
                        subtitle: 'Ultra-Luxury High Net-Worth',
                        icon: Icons.currency_rupee_rounded,
                        color: const Color(0xFF8B5CF6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimaryColor,
                        textSecondary: textSecondaryColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (_selectedTabIndex == 0) ...[
                    // Filter Toolbar
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
                              // City Selector
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _searchCity,
                                      icon: const Icon(Icons.location_city_rounded, size: 18),
                                      items: ['All Cities', 'Gurugram', 'Mumbai', 'Bengaluru']
                                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))))
                                          .toList(),
                                      onChanged: (val) => setState(() => _searchCity = val ?? 'All Cities'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Intent Toggle (Rent vs Sale)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedIntent == null ? 'All Types' : _selectedIntent!.label,
                                    icon: const Icon(Icons.sell_outlined, size: 18),
                                    items: ['All Types', 'For Rent', 'For Resale']
                                        .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == 'For Rent') {
                                          _selectedIntent = ListingIntent.rent;
                                        } else if (val == 'For Resale') {
                                          _selectedIntent = ListingIntent.sale;
                                        } else {
                                          _selectedIntent = null;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // BHK Filter
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedBhk == null ? 'All BHKs' : '$_selectedBhk BHK',
                                    icon: const Icon(Icons.bed_rounded, size: 18),
                                    items: ['All BHKs', '3 BHK', '4 BHK', '5 BHK']
                                        .map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == '3 BHK') {
                                          _selectedBhk = 3;
                                        } else if (val == '4 BHK') {
                                          _selectedBhk = 4;
                                        } else if (val == '5 BHK') {
                                          _selectedBhk = 5;
                                        } else {
                                          _selectedBhk = null;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Property Listings Grid
                    if (filtered.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(Icons.apartment_rounded, size: 48, color: textSecondaryColor),
                              const SizedBox(height: 12),
                              Text('No verified properties match your selected criteria.', style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _openAddEditPropertyModal(),
                                icon: const Icon(Icons.add_home_work_rounded, size: 16),
                                label: const Text('List a New Property'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                ),
                              ),
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
                              mainAxisExtent: 510,
                            ),
                            itemBuilder: (ctx, idx) {
                              final prop = filtered[idx];
                              return PropertyListingCard(
                                property: prop,
                                onUnlock: () => _openUnlockModal(context, prop),
                                onVideoTour: () => _openVideoTourDialog(context, prop),
                                onEdit: () => _openAddEditPropertyModal(prop),
                                onDelete: () => _deleteProperty(prop),
                                onViewLeads: () => _openPropertyLeadsModal(prop),
                              );
                            },
                          );
                        },
                      ),
                  ] else ...[
                    // Unlocked Contacts History View
                    _buildUnlockedHistoryTable(context, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor, isDark),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedHistoryTable(
    BuildContext context,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (_unlockRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.lock_open_rounded, size: 48, color: textSecondary),
              const SizedBox(height: 12),
              Text('No unlocked owner contacts yet. Unlock any property for ₹500 to view details.', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Direct Property Owner Contacts (₹500 Paid Leads)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                    Text('Full contact access permanently unlocked for your CRM team', style: TextStyle(fontSize: 12, color: textSecondary)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_unlockRecords.length} Active Records',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _unlockRecords.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
            itemBuilder: (ctx, idx) {
              final rec = _unlockRecords[idx];
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF10B981),
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rec.propertyTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text('Owner: ${rec.ownerName} • ${rec.ownerPhone}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Unlocked By: ${rec.unlockedByName}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                          Text('Txn: ${rec.transactionId}', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opening WhatsApp chat with ${rec.ownerName}...')),
                            );
                          },
                          icon: const Icon(Icons.chat, color: Color(0xFF10B981)),
                          tooltip: 'WhatsApp Owner',
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling ${rec.ownerPhone}...')),
                            );
                          },
                          icon: const Icon(Icons.call, color: AppColors.primary),
                          tooltip: 'Call Owner',
                        ),
                      ],
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
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openUnlockModal(BuildContext context, PropertyListing property) {
    showDialog(
      context: context,
      builder: (ctx) => PropertyUnlockModal(
        property: property,
        onUnlockSuccess: (rec) {
          setState(() {
            property.isUnlocked = true;
            _unlockRecords.insert(0, rec);
          });
        },
      ),
    );
  }

  void _openVideoTourDialog(BuildContext context, PropertyListing property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.play_circle_filled_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 10),
            const Text('3D Virtual Walkthrough', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(property.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                property.images.first,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'High-definition Matterport 3D digital twin loaded. You can navigate room-by-room with spatial audio & balcony views.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Launching 3D Matterport twin for ${property.societyName}...')),
              );
            },
            icon: const Icon(Icons.fullscreen, size: 16),
            label: const Text('Enter Fullscreen VR Tour'),
          ),
        ],
      ),
    );
  }
}
