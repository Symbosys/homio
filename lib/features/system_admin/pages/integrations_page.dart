import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class IntegrationsPage extends StatefulWidget {
  const IntegrationsPage({super.key});

  @override
  State<IntegrationsPage> createState() => _IntegrationsPageState();
}

class _IntegrationsPageState extends State<IntegrationsPage> {
  // State
  List<IntegrationService> _services = [];
  IntegrationService? _selectedServiceForConfig;
  IntegrationCategory? _selectedCategoryFilter;
  String _searchQuery = '';

  // Credential Masking Toggle
  final Set<String> _revealedCredentialKeys = {};
  bool _isTestingConnection = false;
  String? _testConnectionResult;

  @override
  void initState() {
    super.initState();
    _services = List.from(AdminMockData.integrations);
  }

  List<IntegrationService> get _filteredServices {
    return _services.where((svc) {
      if (_selectedCategoryFilter != null && svc.category != _selectedCategoryFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = svc.name.toLowerCase().contains(q) ||
            svc.description.toLowerCase().contains(q) ||
            svc.providerKey.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: 'External Integrations Hub',
                  description: 'Manage external API connections, OAuth credentials, webhook routing, visual field mappings, and service health.',
                  icon: Icons.integration_instructions_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'Integrations'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => _testAllConnections(),
                      icon: const Icon(Icons.network_check_rounded, size: 16),
                      label: const Text('Test All Endpoints', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Summary Metrics Ribbon
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Connected Providers',
                      value: '${_services.where((s) => s.connectionStatus == IntegrationConnectionStatus.connected).length} / ${_services.length}',
                      subtitle: '7 Category Clusters',
                      icon: Icons.cloud_done_outlined,
                      color: AppColors.success,
                    ),
                    AdminMetricItem(
                      label: 'Sync Volume (24h)',
                      value: '10,850 Requests',
                      subtitle: 'Avg Latency: 165ms',
                      icon: Icons.sync_alt_rounded,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Action Required',
                      value: '${_services.where((s) => s.connectionStatus == IntegrationConnectionStatus.actionRequired).length} Provider',
                      subtitle: 'Google Calendar Token',
                      icon: Icons.error_outline_rounded,
                      color: AppColors.warning,
                    ),
                    AdminMetricItem(
                      label: 'Webhook Health',
                      value: '99.96% Uptime',
                      subtitle: 'Zero dropped payloads',
                      icon: Icons.verified_outlined,
                      color: AppColors.secondary,
                      trendText: 'Healthy',
                      isPositiveTrend: true,
                    ),
                  ],
                ),

                // 3. Search & Category Filters
                AdminFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (q) => setState(() => _searchQuery = q),
                  searchHint: 'Search integrations by name, provider key, category...',
                  filterControls: [
                    DropdownButton<IntegrationCategory?>(
                      value: _selectedCategoryFilter,
                      hint: const Text('Integration Category', style: TextStyle(fontSize: 12)),
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Categories', style: TextStyle(fontSize: 12))),
                        for (final c in IntegrationCategory.values)
                          DropdownMenuItem(value: c, child: Text(c.label, style: const TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) => setState(() => _selectedCategoryFilter = val),
                    ),
                  ],
                ),

                // 4. Integrations Grid
                _filteredServices.isEmpty
                    ? _buildEmptyState(isDark)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 420,
                          mainAxisExtent: 225,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredServices.length,
                        itemBuilder: (context, index) {
                          final svc = _filteredServices[index];
                          return _buildIntegrationCard(svc, isDark);
                        },
                      ),
              ],
            ),
          ),

          // Detail / Configuration Drawer
          if (_selectedServiceForConfig != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildConfigDrawer(isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard(IntegrationService svc, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Row
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    svc.iconUrl,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 32,
                      height: 32,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(svc.category.icon, color: AppColors.primary, size: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(svc.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      Text('${svc.category.label} • ${svc.environment}', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
                AdminStatusBadge(label: svc.connectionStatus.label, color: svc.connectionStatus.color),
              ],
            ),
            const SizedBox(height: 6),

            // Description
            SizedBox(
              height: 34,
              child: Text(
                svc.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, height: 1.35, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
            const SizedBox(height: 6),

            // Metrics Line
            Row(
              children: [
                Icon(Icons.speed_rounded, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                const SizedBox(width: 4),
                Text('${svc.healthMetrics.latencyMs}ms Latency', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                const SizedBox(width: 10),
                Icon(Icons.bar_chart_rounded, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                const SizedBox(width: 4),
                Text('${svc.healthMetrics.totalRequests24h} hits / 24h', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ],
            ),
            const Divider(height: 14),

            // Footer Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  svc.lastSyncTimestamp != null
                      ? 'Synced ${svc.lastSyncTimestamp!.hour}:${svc.lastSyncTimestamp!.minute.toString().padLeft(2, '0')}'
                      : 'Not synced yet',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedServiceForConfig = svc;
                      _revealedCredentialKeys.clear();
                      _testConnectionResult = null;
                    });
                  },
                  icon: const Icon(Icons.settings_outlined, size: 13),
                  label: const Text('Configure & Map', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // CONFIGURATION & FIELD MAPPING DRAWER
  // ==========================================================================
  Widget _buildConfigDrawer(bool isDark) {
    final svc = _selectedServiceForConfig!;

    return AdminDrawerLayout(
      title: svc.name,
      subtitle: '${svc.category.label} • Provider: ${svc.providerKey}',
      onClose: () => setState(() => _selectedServiceForConfig = null),
      footerActions: [
        OutlinedButton.icon(
          onPressed: _runConnectionTest,
          icon: _isTestingConnection
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.network_ping_rounded, size: 16),
          label: const Text('Test Connection'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => _selectedServiceForConfig = null);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${svc.name} credentials and mappings updated successfully.'), backgroundColor: AppColors.success),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Save Configuration'),
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              indicatorColor: AppColors.primary,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Credentials & Auth'),
                Tab(text: 'Visual Field Mapping'),
                Tab(text: 'Operational Settings'),
                Tab(text: 'Health & Risk'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Credentials & Auth
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🔐 Sensitive Credential Security: All secret tokens are encrypted at rest using AES-256 and masked by default.',
                          style: TextStyle(fontSize: 12, color: AppColors.info, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final entry in svc.credentialsMap.entries) ...[
                        _buildCredentialField(entry.key, entry.value, isDark),
                        const SizedBox(height: 12),
                      ],
                      if (_testConnectionResult != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _testConnectionResult!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Tab 2: Visual Field Mapping
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text('Payload Field Mapping (External API ➔ Homio CRM)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      const SizedBox(height: 6),
                      Text('Configure how external webhook attributes populate internal lead and project fields.', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 14),
                      for (final m in svc.fieldMappings)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(m.externalField, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(m.homioField, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                              if (m.isRequired)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Required', style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                        ),
                      if (svc.fieldMappings.isEmpty)
                        Text('No custom field mappings required for this service archetype.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                  // Tab 3: Operational Settings
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      for (final entry in svc.providerConfig.entries) ...[
                        Text(entry.key, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        const SizedBox(height: 4),
                        Text('${entry.value}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const Divider(height: 20),
                      ],
                    ],
                  ),
                  // Tab 4: Health & Risk
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                                SizedBox(width: 8),
                                Text('Operational Impact Warning on Disabling', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warning)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            for (final aff in svc.affectedWorkflowsOnDisable) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('• $aff', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Telemetry & Uptime', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      const SizedBox(height: 8),
                      Text('• Uptime: ${svc.healthMetrics.uptimePercent}%', style: const TextStyle(fontSize: 12)),
                      Text('• Successful 24h Calls: ${svc.healthMetrics.successfulRequests24h}', style: const TextStyle(fontSize: 12)),
                      Text('• Failed Calls: ${svc.healthMetrics.failedRequests24h}', style: const TextStyle(fontSize: 12)),
                      Text('• Error Log: ${svc.healthMetrics.lastErrorSummary}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialField(String key, String value, bool isDark) {
    final isRevealed = _revealedCredentialKeys.contains(key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(key, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isRevealed ? value : (value.length > 8 ? '${value.substring(0, 4)}••••••••••••${value.substring(value.length - 4)}' : '••••••••••••'),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5),
                ),
              ),
              IconButton(
                icon: Icon(isRevealed ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 16),
                splashRadius: 16,
                onPressed: () {
                  setState(() {
                    if (isRevealed) {
                      _revealedCredentialKeys.remove(key);
                    } else {
                      _revealedCredentialKeys.add(key);
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16),
                splashRadius: 16,
                tooltip: 'Copy to Clipboard',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$key copied to clipboard.')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _runConnectionTest() {
    setState(() => _isTestingConnection = true);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _isTestingConnection = false;
        _testConnectionResult = '✓ Connection Diagnostic Successful!\n• Auth Handshake: 200 OK (OAuth 2.0 / Bearer verified)\n• Webhook Ping: 42ms response latency\n• Permissions: Full read/write access granted';
      });
    });
  }

  void _testAllConnections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Testing all external API endpoints... 7 connected healthy, 1 action required.'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.integration_instructions_outlined, size: 54, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text('No integrations found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
        ],
      ),
    );
  }
}
