import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_names.dart';
import '../navigation/navigation_models.dart';
import '../navigation/sidebar_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Production-grade, responsive collapsible navigation sidebar for Homio CRM.
class AppSidebar extends StatefulWidget {
  final bool isDrawer;

  const AppSidebar({
    super.key,
    this.isDrawer = false,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final SidebarController _controller = SidebarController.instance;
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _searchFieldController.text = _controller.searchQuery;
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _searchFieldController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCollapsed = !widget.isDrawer && _controller.isCollapsed;
    final filteredClusters = _controller.getFilteredClusters();

    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOutCubic,
      width: isCollapsed ? 82.0 : 284.0,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(color: borderColor, width: 1.0),
        ),
        boxShadow: widget.isDrawer
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(4, 0),
                )
              ]
            : null,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. BRAND HEADER
            _buildBrandHeader(isDark, isCollapsed),

            // 2. QUICK SEARCH BAR (Expanded mode only)
            if (!isCollapsed) _buildSearchBar(isDark),

            // 3. CLUSTERED ACCORDION MENU LIST
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? AppSpacing.xs : AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                itemCount: filteredClusters.length,
                itemBuilder: (context, index) {
                  final cluster = filteredClusters[index];
                  return _buildClusterSection(
                    cluster: cluster,
                    isDark: isDark,
                    isCollapsed: isCollapsed,
                  );
                },
              ),
            ),

            // 4. FOOTER / USER PROFILE CARD
            _buildFooterProfile(isDark, isCollapsed),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. BRAND HEADER
  // ---------------------------------------------------------------------------
  Widget _buildBrandHeader(bool isDark, bool isCollapsed) {
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Name
          Flexible(
            child: InkWell(
              onTap: () {
                _controller.setActiveRoute(RouteNames.dashboardOverviewPath);
                context.goNamed(RouteNames.dashboardOverview);
              },
              borderRadius: AppRadius.md,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppRadius.md,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.architecture_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'HOMIO',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: AppRadius.full,
                              ),
                              child: Text(
                                'CRM',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Operations OS',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10.5,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Collapse Button (Only in persistent sidebar, not in drawer)
          if (!widget.isDrawer)
            IconButton(
              iconSize: 20,
              splashRadius: 18,
              tooltip: isCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
              icon: Icon(
                isCollapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextSecondary,
              ),
              onPressed: () => _controller.toggleCollapse(),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. QUICK SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: SizedBox(
        height: 38,
        child: TextField(
          controller: _searchFieldController,
          onChanged: (val) => _controller.setSearchQuery(val),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            hintText: 'Search modules (e.g. Vastu, Gantt)...',
            hintStyle: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            suffixIcon: _searchFieldController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      _searchFieldController.clear();
                      _controller.setSearchQuery('');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
            border: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: Color(0xFF2563EB),
                width: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. CLUSTER & MENU SECTION
  // ---------------------------------------------------------------------------
  Widget _buildClusterSection({
    required NavigationCluster cluster,
    required bool isDark,
    required bool isCollapsed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isCollapsed)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            child: Text(
              cluster.title,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Divider(height: 1, thickness: 1),
          ),
        ...cluster.items.map((item) {
          return _buildMenuItemTile(
            item: item,
            isDark: isDark,
            isCollapsed: isCollapsed,
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MENU ITEM TILE (With Accordion Submenus)
  // ---------------------------------------------------------------------------
  Widget _buildMenuItemTile({
    required NavigationMenuItem item,
    required bool isDark,
    required bool isCollapsed,
  }) {
    final isExpanded = _controller.expandedMenuIds.contains(item.id);
    final isParentActive = item.subItems.any((sub) =>
        sub.routePath == _controller.activeRoute ||
        sub.id == _controller.activeSubItemId);

    final activeBg = isDark
        ? AppColors.primaryMutedDark
        : AppColors.primaryMuted;
    final activeTextColor =
        isDark ? AppColors.primaryLight : AppColors.primary;

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: Tooltip(
          message: '${item.title}\n${item.tooltip ?? ""}',
          waitDuration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: () {
              if (item.subItems.isNotEmpty) {
                final firstSub = item.subItems.first;
                _controller.setActiveRoute(firstSub.routePath, subItemId: firstSub.id);
                context.goNamed(firstSub.routeName);
              }
            },
            borderRadius: AppRadius.md,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isParentActive ? activeBg : Colors.transparent,
                borderRadius: AppRadius.md,
                border: isParentActive
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: isParentActive
                        ? activeTextColor
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  if (item.badgeCount != null && item.badgeCount! > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: item.badgeColor ?? AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Parent Menu Row (Accordion Trigger)
          InkWell(
            onTap: () {
              _controller.toggleMenuExpansion(item.id);
            },
            borderRadius: AppRadius.md,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 8.5,
              ),
              decoration: BoxDecoration(
                color: isParentActive ? activeBg : Colors.transparent,
                borderRadius: AppRadius.md,
                border: isParentActive
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  // Active left accent indicator bar
                  if (isParentActive)
                    Container(
                      width: 3.5,
                      height: 18,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppRadius.full,
                      ),
                    ),

                  Icon(
                    item.icon,
                    size: 20,
                    color: isParentActive
                        ? activeTextColor
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Menu Title
                  Expanded(
                    child: Text(
                      item.title,
                      style: AppTypography.labelMedium.copyWith(
                        fontSize: 13,
                        fontWeight:
                            isParentActive ? FontWeight.w700 : FontWeight.w500,
                        color: isParentActive
                            ? (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),

                  // Notification Badge
                  if (item.badgeCount != null && item.badgeCount! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: (item.badgeColor ?? AppColors.primary)
                            .withValues(alpha: 0.15),
                        borderRadius: AppRadius.full,
                      ),
                      child: Text(
                        '${item.badgeCount}',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: item.badgeColor ?? AppColors.primary,
                        ),
                      ),
                    ),

                  // Accordion Chevron
                  if (item.hasSubmenu)
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0.0,
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeInOutCubic,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Submenu Accordion Drawer with Smooth Height & Opacity Transition
          if (item.hasSubmenu)
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 3.0),
                child: Stack(
                  children: [
                    // Vertical connecting guide line
                    Positioned(
                      left: 9,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        width: 1.5,
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),

                    // Submenu Items Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: item.subItems.map((sub) {
                        final isSubActive =
                            _controller.activeSubItemId == sub.id ||
                                _controller.activeRoute == sub.routePath;

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 18.0,
                            top: 1.5,
                            bottom: 1.5,
                          ),
                          child: InkWell(
                            onTap: () {
                              _controller.setActiveRoute(
                                sub.routePath,
                                subItemId: sub.id,
                              );
                              context.goNamed(sub.routeName);
                            },
                            borderRadius: AppRadius.sm,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSubActive
                                    ? (isDark
                                        ? AppColors.darkSurfaceElevated
                                        : AppColors.lightSurfaceSubtle)
                                    : Colors.transparent,
                                borderRadius: AppRadius.sm,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    sub.icon,
                                    size: 15,
                                    color: isSubActive
                                        ? AppColors.primaryLight
                                        : (isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      sub.title,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: isSubActive
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSubActive
                                            ? (isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary)
                                            : (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary),
                                      ),
                                    ),
                                  ),
                                  if (sub.badgeCount != null &&
                                      sub.badgeCount! > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (sub.badgeColor ??
                                                AppColors.primary)
                                            .withValues(alpha: 0.15),
                                        borderRadius: AppRadius.full,
                                      ),
                                      child: Text(
                                        '${sub.badgeCount}',
                                        style:
                                            AppTypography.labelSmall.copyWith(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: sub.badgeColor ??
                                              AppColors.primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 260),
              firstCurve: Curves.easeInOutCubic,
              secondCurve: Curves.easeInOutCubic,
              sizeCurve: Curves.easeInOutCubic,
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. FOOTER PROFILE & ORG SWITCHER
  // ---------------------------------------------------------------------------
  Widget _buildFooterProfile(bool isDark, bool isCollapsed) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? AppSpacing.xs : AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.0,
          ),
        ),
      ),
      child: isCollapsed
          ? IconButton(
              tooltip: 'Admin Profile & Settings',
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  'SA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onPressed: () => _showProfileMenu(context),
            )
          : Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'SA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Vikram Malhotra',
                        style: AppTypography.labelMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'SUPER_ADMIN',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 9.5,
                              letterSpacing: 0.4,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 18,
                  splashRadius: 18,
                  icon: const Icon(Icons.more_vert_rounded),
                  tooltip: 'Options',
                  onPressed: () => _showProfileMenu(context),
                ),
              ],
            ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vikram Malhotra',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Workspace: DLF Phase 5 Hub',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded),
                  title: const Text('Account Profile & Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    _controller.setActiveRoute(RouteNames.dashboardOverviewPath);
                    context.goNamed(RouteNames.dashboardOverview);
                  },
                ),
                const Divider(height: 16),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                  title: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteNames.login);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
