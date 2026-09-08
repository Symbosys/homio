import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/marketing_repository.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';
import '../widgets/create_lead_source_dialog.dart';
import '../widgets/marketing_header.dart';

class MarketingSourcesPage extends StatefulWidget {
  const MarketingSourcesPage({super.key});

  @override
  State<MarketingSourcesPage> createState() => _MarketingSourcesPageState();
}

class _MarketingSourcesPageState extends State<MarketingSourcesPage> {
  final _repo = MarketingRepository();
  String _searchQuery = '';
  SourceType? _selectedType;
  MarketingChannel? _selectedChannel;
  bool _isRefreshing = false;
  late List<LeadSourceItem> _sources;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _sources = _repo.getLeadSources();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _loadData();
        _isRefreshing = false;
      });
    }
  }

  void _openConnectSourceDialog() {
    CreateLeadSourceDialog.show(
      context,
      onSourceCreated: (newSource) {
        _repo.addLeadSource(newSource);
        _handleRefresh();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lead Source "${newSource.name}" connected!')),
        );
      },
    );
  }

  void _syncAllNow() {
    setState(() => _isRefreshing = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _sources = _sources.map((s) => s.copyWith(lastSynced: DateTime.now(), syncHealth: 'Healthy')).toList();
          _isRefreshing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All lead sources synced with Meta Graph & Google Ads APIs!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _sources.where((s) {
      if (_selectedType != null && s.type != _selectedType) return false;
      if (_selectedChannel != null && s.channel != _selectedChannel) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return s.name.toLowerCase().contains(q) || s.channel.label.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey('marketing_sources_scroll_key'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketingHeader(
                title: 'Lead Sources & Integrations',
                subtitle: 'Meta Lead Ads, Google Ads, Organic Webhook pipelines, and attribution integrity',
                isRefreshing: _isRefreshing,
                onRefresh: _handleRefresh,
                primaryActionLabel: 'Connect Source',
                primaryActionIcon: Icons.add_link_rounded,
                onPrimaryAction: _openConnectSourceDialog,
              ),
              const SizedBox(height: 20),
            // Top Controls Bar: Search & Filter Chips & Sync All Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search sources by name or channel...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _syncAllNow,
                        icon: const Icon(Icons.sync_rounded, size: 16),
                        label: const Text('Sync All Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All Types'),
                        selected: _selectedType == null,
                        onSelected: (_) => setState(() => _selectedType = null),
                      ),
                      ...SourceType.values.map((t) {
                        return FilterChip(
                          label: Text(t.label),
                          selected: _selectedType == t,
                          onSelected: (_) => setState(() => _selectedType = t),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Ingestion Diagnostics Strip
            _buildDiagnosticsStrip(isDark),

            const SizedBox(height: 20),

            // Sources Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;
                final crossAxisCount = isWide ? 3 : (isMedium ? 2 : 1);

                if (filtered.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: Text(
                      'No lead sources matched the current filters.',
                      style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final s = filtered[index];
                    return _buildSourceCard(s, isDark);
                  },
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildDiagnosticsStrip(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: Color(0xFF3B82F6), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Webhook Ingestion Engine: 99.98% Attribution Accuracy',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Meta Graph API v19.0 & Google Ads REST API sync active. Webhook avg latency: 120ms. Ingestion errors: 0 in last 24h.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Webhook Log Diagnostics...')),
              );
            },
            icon: const Icon(Icons.terminal_rounded, size: 14),
            label: const Text('View Logs', style: TextStyle(fontSize: 11)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(LeadSourceItem s, bool isDark) {
    final cpl = s.leadsGenerated > 0 ? (s.cost / s.leadsGenerated) : 0.0;
    final convRate = s.leadsGenerated > 0 ? (s.conversions / s.leadsGenerated * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Card Top
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(s.channel.icon, color: AppColors.brandPrimary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.darkTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${s.channel.label} • ${s.type.label}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  s.syncHealth,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                ),
              ),
            ],
          ),

          // Card Middle Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSourceMetric('Leads', '${s.leadsGenerated}', isDark),
                _buildSourceMetric('Spend', s.cost == 0 ? '₹0' : '₹${(s.cost / 1000).toStringAsFixed(0)}k', isDark),
                _buildSourceMetric('CPL', cpl == 0 ? '₹0' : '₹${cpl.toStringAsFixed(0)}', isDark),
                _buildSourceMetric('Conv.', '${convRate.toStringAsFixed(1)}%', isDark),
              ],
            ),
          ),

          // Card Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Synced ${_formatLastSynced(s.lastSynced)}',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 16),
                    tooltip: 'Test & Re-sync',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Syncing ${s.name}...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: 16),
                    tooltip: 'Configure Mappings',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Configuring ${s.name} mappings')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceMetric(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.darkTextPrimary),
        ),
      ],
    );
  }

  String _formatLastSynced(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
