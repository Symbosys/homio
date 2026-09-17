import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/platform_org_model.dart';
import '../../data/models/platform_plan_model.dart';
import '../queries/platform_queries.dart';
import '../widgets/edit_organization_dialog.dart';
import '../widgets/org_status_badge.dart';

class PlatformOrganizationsPage extends StatefulWidget {
  const PlatformOrganizationsPage({super.key});

  @override
  State<PlatformOrganizationsPage> createState() => _PlatformOrganizationsPageState();
}

class _PlatformOrganizationsPageState extends State<PlatformOrganizationsPage> {
  final PlatformQueries _queries = PlatformQueries();

  int _currentPage = 1;
  final int _limit = 10;

  String _searchQuery = '';
  String _selectedStatus = 'ALL';
  final _searchController = TextEditingController();

  List<PlatformPlanModel> _availablePlans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlans() async {
    try {
      final res = await _queries.getPlansQuery(includeInactive: false).fetch();
      if (mounted) {
        setState(() {
          _availablePlans = res.data ?? [];
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleOrgStatus(PlatformOrgModel org) async {
    final nextStatus = org.status == 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
    final actionName = nextStatus == 'SUSPENDED' ? 'Suspend' : 'Activate';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$actionName "${org.name}"?'),
        content: Text(
          nextStatus == 'SUSPENDED'
              ? 'Suspending this organization will block staff from accessing the workspace until reactivated.'
              : 'Reactivating this organization will restore staff access immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: nextStatus == 'SUSPENDED' ? Colors.red : const Color(0xFF10B981),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(actionName, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _queries.getUpdateOrgStatusMutation().mutate((id: org.id, status: nextStatus));
    }
  }

  Future<void> _openChangePlanDialog(PlatformOrgModel org) async {
    if (_availablePlans.isEmpty) {
      await _loadPlans();
    }
    if (!mounted) return;

    String selectedPlanId = _availablePlans.isNotEmpty ? _availablePlans.first.id : '';
    String selectedCycle = 'MONTHLY';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Assign Subscription Plan',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Assigning plan to ${org.name}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedPlanId.isNotEmpty ? selectedPlanId : null,
                    decoration: InputDecoration(
                      labelText: 'Select Plan',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _availablePlans.map((plan) {
                      return DropdownMenuItem(
                        value: plan.id,
                        child: Text(
                          '${plan.name} (₹${plan.priceMonthly.toStringAsFixed(0)}/mo)',
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedPlanId = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCycle,
                    decoration: InputDecoration(
                      labelText: 'Billing Cycle',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
                      DropdownMenuItem(value: 'QUARTERLY', child: Text('Quarterly (3 months)')),
                      DropdownMenuItem(value: 'YEARLY', child: Text('Yearly (12 months)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedCycle = val);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Assign Plan', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && selectedPlanId.isNotEmpty) {
      _queries.getAssignSubscriptionMutation().mutate((
        id: org.id,
        data: {
          'planId': selectedPlanId,
          'subscriptionPlanId': selectedPlanId,
          'billingCycle': selectedCycle,
          'status': 'ACTIVE',
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orgsQuery = _queries.getOrganizationsQuery(
      page: _currentPage,
      limit: _limit,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      status: _selectedStatus != 'ALL' ? _selectedStatus : null,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
                      'Organizations',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'All tenant studios, subscription statuses, and seat usage',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: 'Refresh directory',
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Color(0xFF8B5CF6)),
                  onPressed: () => _queries.invalidateOrganizationsCache(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search & Filter Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by studio name, slug, email, or phone...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                        _currentPage = 1;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      items: const [
                        DropdownMenuItem(value: 'ALL', child: Text('All Statuses')),
                        DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                        DropdownMenuItem(value: 'SUSPENDED', child: Text('Suspended')),
                        DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                        DropdownMenuItem(value: 'PENDING_VERIFICATION', child: Text('Pending')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedStatus = val;
                            _currentPage = 1;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Live Cached Query Builder for Organizations
            Expanded(
              child: QueryBuilder(
                query: orgsQuery,
                builder: (context, state) {
                  if (state.data == null && state.error == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                    );
                  }

                  if (state.error != null && state.data == null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            state.error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => orgsQuery.refetch(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final data = state.data;
                  final organizations = data?.org ?? [];
                  final totalOrg = data?.totalOrg ?? 0;
                  final totalPage = data?.totalPage ?? 1;

                  if (organizations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business_outlined, size: 48, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 12),
                          Text(
                            'No organizations match your query',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try adjusting your search keywords or status filter',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('Studio / Organization')),
                                    DataColumn(label: Text('Code')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Subscription Tier')),
                                    DataColumn(label: Text('Users')),
                                    DataColumn(label: Text('Created At')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: organizations.map((org) {
                                    final sub = org.activeSubscription;
                                    return DataRow(
                                      cells: [
                                        // Logo + Name + Email
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 34,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(7),
                                                  child: org.logoUrl != null && org.logoUrl!.isNotEmpty
                                                      ? Image.network(
                                                          org.logoUrl!,
                                                          width: 34,
                                                          height: 34,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, _, _) => Center(
                                                            child: Text(
                                                              org.name.isNotEmpty
                                                                  ? org.name.substring(0, 1).toUpperCase()
                                                                  : 'O',
                                                              style: GoogleFonts.plusJakartaSans(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w700,
                                                                color: const Color(0xFF8B5CF6),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                            org.name.isNotEmpty
                                                                ? org.name.substring(0, 1).toUpperCase()
                                                                : 'O',
                                                            style: GoogleFonts.plusJakartaSans(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w700,
                                                              color: const Color(0xFF8B5CF6),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    org.name,
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (org.email != null)
                                                    Text(
                                                      org.email!,
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Code
                                        DataCell(
                                          Text(
                                            org.code,
                                            style: GoogleFonts.robotoMono(fontSize: 12),
                                          ),
                                        ),
                                        // Status
                                        DataCell(OrgStatusBadge(status: org.status)),
                                        // Subscription
                                        DataCell(
                                          sub != null
                                              ? Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      sub.planName,
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xFF8B5CF6),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${sub.status} • ${sub.billingCycle.toLowerCase()}',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  'No Active Plan',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                        ),
                                        // Users count
                                        DataCell(
                                          Text(
                                            '${org.totalUsers} seats',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        // Created Date
                                        DataCell(
                                          Text(
                                            org.createdAt != null
                                                ? org.createdAt!.toIso8601String().substring(0, 10)
                                                : '-',
                                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                          ),
                                        ),
                                        // Actions
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'Edit Organization Profile & Logo',
                                                icon: const Icon(
                                                  Icons.edit_rounded,
                                                  size: 18,
                                                  color: Color(0xFF3B82F6),
                                                ),
                                                onPressed: () => EditOrganizationDialog.show(
                                                  context,
                                                  organization: org,
                                                  queries: _queries,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Assign / Change Plan',
                                                icon: const Icon(
                                                  Icons.card_membership_rounded,
                                                  size: 18,
                                                  color: Color(0xFF8B5CF6),
                                                ),
                                                onPressed: () => _openChangePlanDialog(org),
                                              ),
                                              IconButton(
                                                tooltip: org.status == 'ACTIVE'
                                                    ? 'Suspend Org'
                                                    : 'Activate Org',
                                                icon: Icon(
                                                  org.status == 'ACTIVE'
                                                      ? Icons.pause_circle_outline_rounded
                                                      : Icons.play_circle_outline_rounded,
                                                  size: 18,
                                                  color: org.status == 'ACTIVE'
                                                      ? Colors.amber
                                                      : const Color(0xFF10B981),
                                                ),
                                                onPressed: () => _toggleOrgStatus(org),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pagination Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Showing ${organizations.length} of $totalOrg organizations',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left_rounded),
                                onPressed: _currentPage > 1
                                    ? () => setState(() => _currentPage--)
                                    : null,
                              ),
                              Text(
                                'Page $_currentPage of $totalPage',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right_rounded),
                                onPressed: _currentPage < totalPage
                                    ? () => setState(() => _currentPage++)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
