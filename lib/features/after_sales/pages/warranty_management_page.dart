import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';
import '../widgets/after_sales_header.dart';
import '../widgets/warranty_claim_modal.dart';

class WarrantyManagementPage extends StatefulWidget {
  const WarrantyManagementPage({super.key});

  @override
  State<WarrantyManagementPage> createState() => _WarrantyManagementPageState();
}

class _WarrantyManagementPageState extends State<WarrantyManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<WarrantyRecord> _warranties = List.from(AfterSalesMockData.warranties);
  final List<WarrantyClaim> _claims = List.from(AfterSalesMockData.warrantyClaims);

  String _searchQuery = '';
  String _dateFilter = 'This Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final filteredWarranties = _warranties.where((w) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = w.warrantyNumber.toLowerCase().contains(q) ||
            w.customerName.toLowerCase().contains(q) ||
            w.projectName.toLowerCase().contains(q) ||
            w.coveredItemWork.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();

    // KPIs
    final totalWarranties = _warranties.length;
    final activeCount = _warranties.where((w) => w.status == WarrantyStatus.active).length;
    final expiringCount = _warranties.where((w) => w.isExpiringSoon).length;
    final claimsPending = _claims.where((c) => c.status == WarrantyStatus.claimUnderReview || c.status == WarrantyStatus.claimRaised).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AfterSalesHeader(
              title: 'Warranty Policies & Claims Adjudication',
              subtitle: 'Multi-tiered 10-Yr Structural and 1-Yr Comprehensive warranty tracking, coverage validation, and claims adjudication.',
              activeTab: 'Warranty',
              selectedDateFilter: _dateFilter,
              onDateFilterChanged: (val) => setState(() => _dateFilter = val),
              trailing: ElevatedButton.icon(
                onPressed: () => _openNewClaimModal(context),
                icon: const Icon(Icons.shield_outlined, size: 16),
                label: const Text('Lodge Warranty Claim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warranty KPIs
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpi('Total Policies', '$totalWarranties', 'Active project milestones', Icons.security_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Active Coverage', '$activeCount', 'Fully covered by Homio', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Expiring Soon', '$expiringCount', '< 30 days remaining', Icons.warning_amber_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Claims Under Review', '$claimsPending', 'Awaiting adjudication', Icons.gavel_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpi('Total Policies', '$totalWarranties', 'Active project milestones', Icons.security_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Active Coverage', '$activeCount', 'Fully covered by Homio', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Expiring Soon', '$expiringCount', '< 30 days remaining', Icons.warning_amber_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Claims Under Review', '$claimsPending', 'Awaiting adjudication', Icons.gavel_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search warranties by policy number, client name, project, or work coverage...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: backgroundColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: textSecondaryColor,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      tabs: [
                        Tab(text: 'Project Warranty Policies (${filteredWarranties.length})'),
                        Tab(text: 'Claims Review Queue (${_claims.length})'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Views
                  SizedBox(
                    height: 560,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Warranties List
                        _buildWarrantiesList(filteredWarranties, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor, backgroundColor),

                        // Tab 2: Claims Queue
                        _buildClaimsQueue(_claims, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor, backgroundColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarrantiesList(List<WarrantyRecord> list, Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary, Color bg) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final w = list[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: w.isExpiringSoon ? Colors.orange.withValues(alpha: 0.4) : borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: w.status.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.verified_user_rounded, color: w.status.color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.warrantyNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
                          Text('${w.category.label} • Linked to Invoice #${w.relatedInvoiceNumber}', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: w.status.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      w.isExpiringSoon ? 'EXPIRING IN ${w.daysRemaining} DAYS' : w.status.label.toUpperCase(),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: w.status.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(w.coveredItemWork, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
              const SizedBox(height: 4),
              Text(w.description, style: TextStyle(fontSize: 12, color: textSecondary, height: 1.3)),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('COVERED UNDER WARRANTY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                          const SizedBox(height: 2),
                          Text(w.inclusions.join(' • '), style: TextStyle(fontSize: 11, color: textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EXCLUSIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.orange.shade800)),
                          const SizedBox(height: 2),
                          Text(w.exclusions.join(' • '), style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Validity: ${w.startDate.day}/${w.startDate.month}/${w.startDate.year} → ${w.endDate.day}/${w.endDate.month}/${w.endDate.year} (${w.daysRemaining} days remaining)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading digital warranty certificate for ${w.warrantyNumber}...')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 14),
                    label: const Text('Download Certificate'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClaimsQueue(List<WarrantyClaim> claims, Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary, Color bg) {
    return ListView.separated(
      itemCount: claims.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final clm = claims[index];
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: clm.status.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.gavel_rounded, color: clm.status.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(clm.claimNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: clm.status.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(clm.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: clm.status.color)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${clm.issueArea} — ${clm.customerName} (${clm.projectName})', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                    Text(clm.description, style: TextStyle(fontSize: 11, color: textSecondary)),
                    const SizedBox(height: 6),
                    Text('Claimed on ${clm.claimDate.day}/${clm.claimDate.month}/${clm.claimDate.year} • Policy: ${clm.warrantyNumber}', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton.icon(
                onPressed: () => _openReviewClaimModal(context, clm),
                icon: const Icon(Icons.rate_review_outlined, size: 14),
                label: const Text('Review Claim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKpi(String label, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openNewClaimModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => WarrantyClaimModal(
        onClaimSaved: (newClaim) {
          setState(() => _claims.insert(0, newClaim));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Warranty Claim ${newClaim.claimNumber} registered and under review!')),
          );
        },
      ),
    );
  }

  void _openReviewClaimModal(BuildContext context, WarrantyClaim claim) {
    showDialog(
      context: context,
      builder: (ctx) => WarrantyClaimModal(
        existingClaimToReview: claim,
        onClaimSaved: (reviewed) {
          setState(() {
            final idx = _claims.indexWhere((x) => x.id == claim.id);
            if (idx != -1) _claims[idx] = reviewed;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Claim ${reviewed.claimNumber} adjudicated as ${reviewed.status.label}!')),
          );
        },
      ),
    );
  }
}
