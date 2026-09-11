import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/organization_models.dart';
import '../models/organization_mock_data.dart';
import '../widgets/org_navigation_header.dart';
import '../widgets/org_toolbar.dart';
import '../widgets/org_status_badge.dart';
import '../widgets/org_detail_drawer.dart';
import '../widgets/org_confirmation_dialog.dart';
import '../widgets/org_create_team_dialog.dart';

class OrgTeamsPage extends StatefulWidget {
  const OrgTeamsPage({super.key});

  @override
  State<OrgTeamsPage> createState() => _OrgTeamsPageState();
}

class _OrgTeamsPageState extends State<OrgTeamsPage> {
  final List<OrganizationTeam> _teams = List.from(OrganizationMockData.teams);
  String _searchQuery = '';
  OrgViewMode _viewMode = OrgViewMode.table;
  String? _filterDepartmentId;
  OrgStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    final filtered = _teams.where((t) {
      final matchesSearch = _searchQuery.isEmpty ||
          t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.teamLead.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.departmentName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _filterDepartmentId == null || t.departmentId == _filterDepartmentId;
      final matchesStatus = _filterStatus == null || t.status == _filterStatus;
      return matchesSearch && matchesDept && matchesStatus;
    }).toList();

    // Summary counts
    final totalTeams = _teams.length;
    final totalMembers = _teams.fold<int>(0, (sum, t) => sum + t.memberCount);
    final avgSize = totalTeams > 0 ? (totalMembers / totalTeams).toStringAsFixed(1) : '0';
    final activeSquads = _teams.where((t) => t.status == OrgStatus.active).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Navigation Header
            OrgNavigationHeader(
              activeTab: OrgNavTab.teams,
              title: 'Operational Squads & Teams',
              subtitle: 'Cross-functional delivery teams, regional closing pods, site turnkey clusters & field leadership',
              trailing: !isCompact
                  ? ElevatedButton.icon(
                      onPressed: _openCreateTeam,
                      icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                      label: const Text('New Team'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 18),

            // 2. High-Level Summary Metrics Row
            _buildKpiMetrics(isDark, totalTeams, activeSquads, totalMembers, avgSize, width),
            const SizedBox(height: 20),

            // 3. Toolbar
            OrgToolbar(
              searchHint: 'Search teams by name, code, lead or department...',
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              currentViewMode: _viewMode,
              supportedViewModes: const [OrgViewMode.table, OrgViewMode.cards],
              onViewModeChanged: (m) => setState(() => _viewMode = m),
              primaryActionLabel: isCompact ? 'New Squad' : null,
              onPrimaryAction: _openCreateTeam,
              activeFilterCount: (_filterDepartmentId != null ? 1 : 0) + (_filterStatus != null ? 1 : 0),
              onFilterPressed: _showFilterDialog,
              onExportPressed: _exportData,
              onRefresh: () => setState(() {}),
            ),
            const SizedBox(height: 16),

            // 4. Content Area
            if (filtered.isEmpty)
              _buildEmptyState(isDark)
            else if (_viewMode == OrgViewMode.cards || isCompact)
              _buildCardsView(isDark, filtered)
            else
              _buildTableView(isDark, filtered),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // KPI Metrics
  // ---------------------------------------------------------------------------
  Widget _buildKpiMetrics(bool isDark, int teams, int active, int members, String avgSize, double width) {
    final cards = [
      _buildKpiCard(isDark, 'TOTAL SQUADS', '$teams', 'Across 8 departments', Icons.group_work_rounded, AppColors.primary),
      _buildKpiCard(isDark, 'ACTIVE TEAMS', '$active', 'Operational in field', Icons.check_circle_rounded, const Color(0xFF10B981)),
      _buildKpiCard(isDark, 'ASSIGNED MEMBERS', '$members', 'Total team members', Icons.groups_rounded, const Color(0xFF0284C7)),
      _buildKpiCard(isDark, 'AVG SQUAD SIZE', '$avgSize Members', 'Optimum 8-15 span', Icons.stacked_line_chart_rounded, const Color(0xFFD97706)),
    ];

    if (width < 600) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    } else if (width < 1100) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.3,
        children: cards,
      );
    } else {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    }
  }

  Widget _buildKpiCard(bool isDark, String label, String val, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary, letterSpacing: 0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    val,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Table View
  // ---------------------------------------------------------------------------
  Widget _buildTableView(bool isDark, List<OrganizationTeam> items) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkBackground : AppColors.lightBackground),
            horizontalMargin: 16,
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('TEAM NAME & CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('DEPARTMENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('TEAM LEAD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('MANAGER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('MEMBERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('BRANCH / HUB', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
            rows: items.map((t) {
              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () => _openManageMembers(t),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            '${t.code} • ${t.teamType}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(t.departmentName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ),
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(t.teamLead, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(t.teamLeadEmail, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                  DataCell(Text(t.manager, style: const TextStyle(fontSize: 12))),
                  DataCell(
                    ActionChip(
                      avatar: const Icon(Icons.group_rounded, size: 14, color: AppColors.primary),
                      label: Text('${t.memberCount} Members', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      onPressed: () => _openManageMembers(t),
                    ),
                  ),
                  DataCell(Text(t.branch, style: const TextStyle(fontSize: 12))),
                  DataCell(OrgStatusBadge.forOrgStatus(t.status, isDark)),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.group_add_outlined, size: 17),
                          tooltip: 'Manage Members',
                          onPressed: () => _openManageMembers(t),
                          color: AppColors.primary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          tooltip: 'Edit Team',
                          onPressed: () => _openEditTeam(t),
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 17),
                          onSelected: (action) => _handleTeamAction(action, t),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'toggle_status', child: Text('Toggle Active/Inactive')),
                            const PopupMenuItem(value: 'delete', child: Text('Deactivate Team', style: TextStyle(color: AppColors.error))),
                          ],
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
    );
  }

  // ---------------------------------------------------------------------------
  // Cards View (Mobile & Tablet)
  // ---------------------------------------------------------------------------
  Widget _buildCardsView(bool isDark, List<OrganizationTeam> items) {
    return Column(
      children: items.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
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
                      t.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  OrgStatusBadge.forOrgStatus(t.status, isDark),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${t.code} • ${t.departmentName}',
                style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text('Lead: ${t.teamLead} • Manager: ${t.manager}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildTag(isDark, '${t.memberCount} Members', Icons.people_outline_rounded),
                  _buildTag(isDark, t.branch, Icons.place_outlined),
                  _buildTag(isDark, t.teamType, Icons.tune_rounded),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 6,
                children: [
                  TextButton.icon(
                    onPressed: () => _openManageMembers(t),
                    icon: const Icon(Icons.people_alt_outlined, size: 16),
                    label: const Text('Manage Members', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton(
                    onPressed: () => _openEditTeam(t),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTag(bool isDark, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text(
            'No Operational Teams Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'No squads match the selected search query or department filter.',
            style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterDepartmentId = null;
                _filterStatus = null;
              });
            },
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dedicated Member Management Interface (Section 9.4)
  // ---------------------------------------------------------------------------
  void _openManageMembers(OrganizationTeam team) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final members = OrganizationMockData.employees.where((e) => e.teamId == team.id).toList();

    OrgDetailDrawer.show(
      context,
      title: team.name,
      subtitle: '${team.code} • ${team.departmentName} • ${team.branch}',
      badge: OrgStatusBadge.forOrgStatus(team.status, isDark),
      tabTitles: const ['Members', 'Leadership', 'Structure', 'Activity'],
      tabViews: [
        // Tab 1: Members Management
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CURRENT SQUAD ROSTER (${members.length}/${team.maxTeamSize})',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary, letterSpacing: 0.5),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddMemberDialog(team),
                  icon: const Icon(Icons.person_add_rounded, size: 16),
                  label: const Text('Add Member', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (members.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text('No employees currently assigned to this team.')),
              )
            else
              ...members.map((emp) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(emp.avatarUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(emp.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('${emp.jobTitle} • ID: ${emp.employeeId}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                            Text('Scope: ${emp.accessScopeName}', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 18, color: AppColors.error),
                        tooltip: 'Remove from Team',
                        onPressed: () async {
                          final confirmed = await OrgConfirmationDialog.show(
                            context,
                            title: 'Remove Member',
                            message: 'Are you sure you want to remove ${emp.name} from "${team.name}"?',
                            confirmLabel: 'Remove Member',
                            isDestructive: true,
                          );
                          if (confirmed == true && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${emp.name} removed from ${team.name}')),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),

        // Tab 2: Leadership
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Designated Team Lead', team.teamLead),
            _buildDetailRow('Team Lead Email', team.teamLeadEmail),
            _buildDetailRow('Reporting Manager', team.manager),
            _buildDetailRow('Manager Email', team.managerEmail),
            _buildDetailRow('Maximum Capacity', '${team.maxTeamSize} Members'),
          ],
        ),

        // Tab 3: Structure
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Parent Department', team.departmentName),
            _buildDetailRow('Branch Location', team.branch),
            _buildDetailRow('Team Specialization', team.teamType),
            _buildDetailRow('Default Access Scope', team.defaultAccessScopeId),
            const SizedBox(height: 12),
            Text(team.description, style: const TextStyle(fontSize: 12)),
          ],
        ),

        // Tab 4: Activity
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: OrganizationMockData.auditLogs
              .where((a) => a.entityId == team.id || a.entityType.contains('Team'))
              .map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text(log.reason, style: const TextStyle(fontSize: 11)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _openEditTeam(team);
          },
          child: const Text('Edit Squad Details'),
        ),
      ],
    );
  }

  void _openAddMemberDialog(OrganizationTeam team) {
    // Searchable employee selector dialog
    final unassigned = OrganizationMockData.employees.where((e) => e.teamId != team.id).toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Member to ${team.name}'),
          content: SizedBox(
            width: 400,
            height: 300,
            child: ListView.builder(
              itemCount: unassigned.length,
              itemBuilder: (c, idx) {
                final emp = unassigned[idx];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(emp.avatarUrl)),
                  title: Text(emp.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: Text('${emp.jobTitle} • ${emp.departmentName}', style: const TextStyle(fontSize: 11)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${emp.name} added to ${team.name}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Handlers & Dialog Triggers
  // ---------------------------------------------------------------------------
  void _openCreateTeam() {
    OrgCreateTeamDialog.show(
      context,
      onSave: (newTeam) {
        setState(() {
          _teams.insert(0, newTeam);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team "${newTeam.name}" created successfully!')),
        );
      },
    );
  }

  void _openEditTeam(OrganizationTeam team) {
    OrgCreateTeamDialog.show(
      context,
      teamToEdit: team,
      onSave: (updated) {
        setState(() {
          final idx = _teams.indexWhere((t) => t.id == team.id);
          if (idx != -1) _teams[idx] = updated;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team "${updated.name}" updated successfully!')),
        );
      },
    );
  }

  Future<void> _handleTeamAction(String action, OrganizationTeam t) async {
    if (action == 'toggle_status') {
      setState(() {
        final idx = _teams.indexWhere((item) => item.id == t.id);
        if (idx != -1) {
          _teams[idx] = t.copyWith(
            status: t.status == OrgStatus.active ? OrgStatus.inactive : OrgStatus.active,
          );
        }
      });
    } else if (action == 'delete') {
      final confirmed = await OrgConfirmationDialog.show(
        context,
        title: 'Deactivate Squad',
        message: 'Are you sure you want to deactivate "${t.name}"?',
        consequenceWarning: 'This squad currently has ${t.memberCount} members. They will be unassigned to department pool.',
        confirmLabel: 'Deactivate Team',
        isDestructive: true,
      );
      if (confirmed == true) {
        setState(() {
          final idx = _teams.indexWhere((item) => item.id == t.id);
          if (idx != -1) {
            _teams[idx] = t.copyWith(status: OrgStatus.archived);
          }
        });
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filter Operational Teams'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String?>(
                initialValue: _filterDepartmentId,
                decoration: const InputDecoration(labelText: 'Department'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Departments')),
                  ...OrganizationMockData.departments.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))),
                ],
                onChanged: (v) => setState(() => _filterDepartmentId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<OrgStatus?>(
                initialValue: _filterStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                  ...OrgStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.displayName))),
                ],
                onChanged: (v) => setState(() => _filterStatus = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterDepartmentId = null;
                  _filterStatus = null;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting operational squads roster...')),
    );
  }
}
