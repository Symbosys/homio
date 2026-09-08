import 'package:flutter/material.dart';
import 'package:client/app/navigation/admin_navigation_config.dart';
import 'package:client/app/router/route_names.dart';

class AppSidebar extends StatefulWidget {
  final String currentRoute;
  final Function(String route) onNavigate;
  final Set<String> userPermissions;
  final String userName;
  final String userRole;
  final String workspaceHub;
  final String? userAvatarUrl;
  final bool isMobileDrawer;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    this.userPermissions = const {'*'}, // Defaults to Super Admin
    this.userName = 'Vikram Malhotra',
    this.userRole = 'Super Admin',
    this.workspaceHub = 'DLF Phase 5 Hub',
    this.userAvatarUrl,
    this.isMobileDrawer = false,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> with SingleTickerProviderStateMixin {
  bool _isCollapsed = false;
  String? _expandedGroupId;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _autoExpandParentForRoute(widget.currentRoute);
  }

  @override
  void didUpdateWidget(covariant AppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      _autoExpandParentForRoute(widget.currentRoute);
    }
  }

  /// Automatically expands the parent group containing the current route
  void _autoExpandParentForRoute(String rawRoute) {
    final route = RouteNames.resolveCanonicalRoute(rawRoute);
    for (final group in AdminNavigationConfig.masterGroups) {
      final hasActiveChild = group.children.any((child) => child.route == route);
      if (hasActiveChild) {
        setState(() {
          _expandedGroupId = group.id;
        });
        break;
      }
    }
  }

  void _handleNavigate(String route) {
    widget.onNavigate(route);
    if (widget.isMobileDrawer) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = const Color(0xFF0F766E); // Deep Teal / Emerald CRM Accent
    final activeBg = isDark
        ? const Color(0xFF134E4A).withValues(alpha: 0.35)
        : const Color(0xFFCCFBF1).withValues(alpha: 0.7);
    final sidebarBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    // Apply RBAC filtering
    final filteredGroups = AdminNavigationConfig.getFilteredNavigation(widget.userPermissions);

    // Search filtering
    final query = _searchQuery.trim().toLowerCase();
    final List<NavigationGroup> displayGroups = query.isEmpty
        ? filteredGroups
        : filteredGroups.map((group) {
            final matchingChildren = group.children.where((child) {
              final labelMatch = child.label.toLowerCase().contains(query);
              final keywordMatch = child.keywords.any((kw) => kw.toLowerCase().contains(query));
              final routeMatch = child.route.toLowerCase().contains(query);
              return labelMatch || keywordMatch || routeMatch;
            }).toList();

            return NavigationGroup(
              id: group.id,
              label: group.label,
              icon: group.icon,
              permission: group.permission,
              children: matchingChildren,
            );
          }).where((group) => group.children.isNotEmpty).toList();

    final width = widget.isMobileDrawer
        ? 300.0
        : (_isCollapsed ? 76.0 : 280.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: width,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: Border(
          right: BorderSide(color: borderColor, width: 1),
        ),
        boxShadow: widget.isMobileDrawer
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(4, 0),
                )
              ]
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header (HOMIO Branding & Collapse Toggle)
            _buildSidebarHeader(theme, primaryColor, borderColor),

            // 2. Global Module Search (Hidden in Collapsed desktop mode)
            if (!_isCollapsed) _buildSearchBar(theme, borderColor),

            const SizedBox(height: 6),

            // 3. Main Navigation Accordion List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                children: [
                  for (final group in displayGroups)
                    _buildGroupAccordion(
                      group: group,
                      theme: theme,
                      primaryColor: primaryColor,
                      activeBg: activeBg,
                      forceExpand: query.isNotEmpty,
                    ),
                ],
              ),
            ),

            // 4. User Profile Footer
            _buildSidebarFooter(theme, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarHeader(ThemeData theme, Color primaryColor, Color borderColor) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 12 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment:
            _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          if (_isCollapsed)
            Tooltip(
              message: 'HOMIO CRM - Expand Sidebar',
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    _isCollapsed = false;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, const Color(0xFF047857)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'H',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else ...[
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, const Color(0xFF047857)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'H',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'HOMIO',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'CRM',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Operations OS',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!widget.isMobileDrawer)
              IconButton(
                icon: Icon(
                  Icons.menu_open_rounded,
                  size: 19,
                  color: Colors.grey[600],
                ),
                tooltip: 'Collapse Sidebar',
                onPressed: () {
                  setState(() {
                    _isCollapsed = true;
                  });
                },
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Search modules... (Gantt, Vastu...)',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.search_rounded, size: 16, color: Colors.grey),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 14),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: theme.brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupAccordion({
    required NavigationGroup group,
    required ThemeData theme,
    required Color primaryColor,
    required Color activeBg,
    bool forceExpand = false,
  }) {
    final canonicalCurrentRoute = RouteNames.resolveCanonicalRoute(widget.currentRoute);
    final hasActiveChild = group.children.any((c) => c.route == canonicalCurrentRoute);
    final isExpanded = forceExpand || (_expandedGroupId == group.id);

    if (_isCollapsed && !widget.isMobileDrawer) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: group.label,
          preferBelow: false,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _isCollapsed = false;
                _expandedGroupId = group.id;
              });
              if (group.children.isNotEmpty) {
                _handleNavigate(group.children.first.route);
              }
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: hasActiveChild ? primaryColor.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  group.icon,
                  size: 20,
                  color: hasActiveChild ? primaryColor : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent Accordion Tile
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            final isCurrentlyExpanded = _expandedGroupId == group.id;
            setState(() {
              if (isCurrentlyExpanded && hasActiveChild) {
                _expandedGroupId = null; // Toggle closed if already on this screen
              } else {
                _expandedGroupId = group.id; // Toggle open
              }
            });
            // Redirect to the module's main screen and change URL
            if (group.children.isNotEmpty && (!hasActiveChild || !isCurrentlyExpanded)) {
              _handleNavigate(group.children.first.route);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: hasActiveChild ? primaryColor.withValues(alpha: 0.06) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  group.icon,
                  size: 18,
                  color: hasActiveChild ? primaryColor : Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    group.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasActiveChild ? FontWeight.w700 : FontWeight.w600,
                      color: hasActiveChild ? primaryColor : (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Submenus (Animated Accordion Body)
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 2, bottom: 6),
            child: Column(
              children: group.children.map((child) {
                final isActive = child.route == canonicalCurrentRoute;
                return InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => _handleNavigate(child.route),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                    decoration: BoxDecoration(
                      color: isActive ? activeBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: isActive
                          ? Border(
                              left: BorderSide(color: primaryColor, width: 3.5),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          child.icon,
                          size: 15,
                          color: isActive ? primaryColor : Colors.grey[500],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            child.label,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive
                                  ? primaryColor
                                  : (theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700]),
                            ),
                          ),
                        ),
                        if (child.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              child.badge!,
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSidebarFooter(ThemeData theme, Color borderColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 10 : 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: _isCollapsed
          ? PopupMenuButton<String>(
              tooltip: '${widget.userName} (${widget.userRole})',
              offset: const Offset(48, -140),
              onSelected: (val) {
                if (val == 'logout') {
                  _handleNavigate('/login');
                } else if (val == 'profile') {
                  _handleNavigate('/admin/settings');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('${widget.userRole} • ${widget.workspaceHub}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'profile', child: Text('Account Settings', style: TextStyle(fontSize: 12))),
                const PopupMenuItem(value: 'preferences', child: Text('Preferences', style: TextStyle(fontSize: 12))),
                const PopupMenuItem(value: 'security', child: Text('Security', style: TextStyle(fontSize: 12))),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'logout', child: Text('Logout', style: TextStyle(fontSize: 12, color: Colors.red))),
              ],
              child: CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
                  child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${widget.userRole} • ${widget.workspaceHub}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, size: 16, color: Colors.grey),
                  onSelected: (val) {
                    if (val == 'logout') {
                      _handleNavigate('/login');
                    } else if (val == 'profile') {
                      _handleNavigate('/admin/settings');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'profile', child: Text('Account Settings', style: TextStyle(fontSize: 12))),
                    const PopupMenuItem(value: 'preferences', child: Text('Preferences', style: TextStyle(fontSize: 12))),
                    const PopupMenuItem(value: 'security', child: Text('Security', style: TextStyle(fontSize: 12))),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: 'logout', child: Text('Logout', style: TextStyle(fontSize: 12, color: Colors.red))),
                  ],
                ),
              ],
            ),
    );
  }
}
