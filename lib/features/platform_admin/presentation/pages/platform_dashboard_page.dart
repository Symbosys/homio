import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../queries/platform_queries.dart';
import '../widgets/org_status_badge.dart';

class PlatformDashboardPage extends StatefulWidget {
  const PlatformDashboardPage({super.key});

  @override
  State<PlatformDashboardPage> createState() => _PlatformDashboardPageState();
}

class _PlatformDashboardPageState extends State<PlatformDashboardPage> {
  final PlatformQueries _queries = PlatformQueries();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orgsQuery = _queries.getOrganizationsQuery(page: 1, limit: 10);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: QueryBuilder(
        query: orgsQuery,
        builder: (context, state) {
          if (state.data == null && state.error == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            );
          }

          if (state.error != null && state.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load platform data: ${state.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => orgsQuery.refetch(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = state.data;
          final orgs = data?.org ?? [];
          final totalOrgs = data?.totalOrg ?? 0;

          int activeSubs = 0;
          double estimatedMrr = 0.0;
          int totalUsers = 0;

          for (final org in orgs) {
            totalUsers += org.totalUsers;
            if (org.activeSubscription != null &&
                (org.activeSubscription!.status == 'ACTIVE' ||
                    org.activeSubscription!.status == 'TRIALING')) {
              activeSubs++;
              estimatedMrr += org.activeSubscription!.priceMonthly;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Welcome Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SaaS Platform Overview',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Live metrics, tenants, revenue, and active subscriptions across all studios',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Refresh metrics',
                          icon: const Icon(Icons.refresh_rounded, size: 20, color: Color(0xFF8B5CF6)),
                          onPressed: () => _queries.invalidateOrganizationsCache(),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => context.go(RouteNames.platformSubscriptionsPath),
                          icon: const Icon(Icons.card_membership_rounded, size: 16),
                          label: const Text('Plans'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => context.go(RouteNames.platformOnboardOrgPath),
                          icon: const Icon(Icons.add_business_rounded, size: 16),
                          label: const Text('Onboard Org'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // KPI Cards Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 2.1 : 1.7,
                      children: [
                        _buildKpiCard(
                          title: 'Total Organizations',
                          value: '$totalOrgs',
                          subtitle: 'Tenant Studios',
                          icon: Icons.apartment_rounded,
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                        ),
                        _buildKpiCard(
                          title: 'Active Subscriptions',
                          value: '$activeSubs',
                          subtitle: 'Live or trialing',
                          icon: Icons.verified_rounded,
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                        _buildKpiCard(
                          title: 'Estimated MRR',
                          value: '₹${estimatedMrr.toStringAsFixed(0)}',
                          subtitle: 'Monthly recurring revenue',
                          icon: Icons.currency_rupee_rounded,
                          color: const Color(0xFF3B82F6),
                          isDark: isDark,
                        ),
                        _buildKpiCard(
                          title: 'Platform Users',
                          value: '$totalUsers',
                          subtitle: 'Combined tenant staff',
                          icon: Icons.group_rounded,
                          color: const Color(0xFFF59E0B),
                          isDark: isDark,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Recent Organizations Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Organizations',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Recently registered or onboarded tenant studios',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.go(RouteNames.platformOrganizationsPath),
                            child: const Text('View All Organizations →'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (orgs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.business_outlined, size: 40, color: Color(0xFF94A3B8)),
                                const SizedBox(height: 12),
                                Text(
                                  'No organizations onboarded yet',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => context.go(RouteNames.platformOnboardOrgPath),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8B5CF6),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Onboard First Studio'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 40,
                            dataRowMinHeight: 52,
                            dataRowMaxHeight: 52,
                            columns: const [
                              DataColumn(label: Text('Organization')),
                              DataColumn(label: Text('Code')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Plan')),
                              DataColumn(label: Text('Seats')),
                              DataColumn(label: Text('Created Date')),
                            ],
                            rows: orgs.take(5).map((org) {
                              final sub = org.activeSubscription;
                              return DataRow(
                                cells: [
                                  DataCell(
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
                                  ),
                                  DataCell(Text(org.code, style: GoogleFonts.robotoMono(fontSize: 12))),
                                  DataCell(OrgStatusBadge(status: org.status)),
                                  DataCell(
                                    sub != null
                                        ? Text(
                                            sub.planName,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF8B5CF6),
                                            ),
                                          )
                                        : const Text('No Plan', style: TextStyle(color: Colors.grey)),
                                  ),
                                  DataCell(Text('${org.totalUsers} users')),
                                  DataCell(
                                    Text(
                                      org.createdAt != null
                                          ? org.createdAt!.toIso8601String().substring(0, 10)
                                          : '-',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
