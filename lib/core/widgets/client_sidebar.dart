import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/router/route_names.dart';
import '../navigation/client_navigation_registry.dart';
import '../navigation/client_sidebar_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Responsive, clean sidebar navigation tailored for the Homio Client/Customer Portal.
/// Displays direct single-level menus for primary execution items (1-9) and expandable submenus for AI Studio and Marketplace,
/// with automatic auto-scroll so expanding bottom menus immediately reveals their submenus.
class ClientSidebar extends StatefulWidget {
  final bool isDrawer;

  const ClientSidebar({
    super.key,
    this.isDrawer = false,
  });

  @override
  State<ClientSidebar> createState() => _ClientSidebarState();
}

class _ClientSidebarState extends State<ClientSidebar> {
  final ClientSidebarController _controller = ClientSidebarController.instance;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  final Map<String, GlobalKey> _menuKeys = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _controller.searchQuery);
    _scrollController = ScrollController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _scrollToItem(GlobalKey key, {bool isLastItem = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. Immediate progressive scroll nudge while accordion is animating open
      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted || !_scrollController.hasClients) return;
        if (isLastItem) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
          );
        }
      });

      // 2. Definitive explicit alignment scroll once crossfade animation completes (250ms)
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        if (key.currentContext != null) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            alignment: 1.0, // Aligns bottom of the expanded section flush with the viewport bottom
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
          );
        } else if (_scrollController.hasClients && isLastItem) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCollapsed = !widget.isDrawer && _controller.isCollapsed;
    final items = _controller.getFilteredItems();

    final sidebarWidth = widget.isDrawer
        ? 300.0
        : (isCollapsed ? 80.0 : 280.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOutCubic,
      width: sidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. BRAND HEADER
          _buildHeader(isDark, isCollapsed),

          // 2. ACTIVE PROJECT BADGE CARD (If expanded)
          if (!isCollapsed) _buildActiveProjectCard(isDark),

          // 3. SEARCH BAR (If expanded)
          if (!isCollapsed) _buildSearchBar(isDark),

          const SizedBox(height: 6),

          // 4. MENU LIST (Flat for items 1-9, Accordion Submenus for AI & Marketplace)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 8.0 : AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item.hasSubItems) {
                  return _buildExpandableMenuItem(item, isDark, isCollapsed);
                }
                return _buildFlatMenuItem(item, isDark, isCollapsed);
              },
            ),
          ),

          // 5. FOOTER CLIENT PROFILE & SWITCHER
          _buildFooterProfile(isDark, isCollapsed),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. BRAND HEADER
  // ---------------------------------------------------------------------------
  Widget _buildHeader(bool isDark, bool isCollapsed) {
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Client Badge
          Flexible(
            child: InkWell(
              onTap: () {
                _controller.setActiveRoute(RouteNames.clientOverviewPath);
                context.goNamed(RouteNames.clientOverview);
              },
              borderRadius: AppRadius.sm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF34D399), Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.md,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_repair_service_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: AppRadius.full,
                              ),
                              child: Text(
                                'CLIENT',
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFF10B981),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Client Portal',
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
                isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
              ),
              onPressed: () => _controller.toggleCollapse(),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. ACTIVE PROJECT PROGRESS CARD
  // ---------------------------------------------------------------------------
  Widget _buildActiveProjectCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B).withValues(alpha: 0.6), const Color(0xFF0F172A)]
              : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF312E81) : const Color(0xFFE0E7FF),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  color: Color(0xFF6366F1),
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Villa 402, Palm Heights',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ON TIME',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Stage: Carpentry & Polish',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '72%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 4.5,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: SizedBox(
        height: 34,
        child: TextField(
          controller: _searchController,
          onChanged: (val) => _controller.setSearchQuery(val),
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11.5,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurfaceSubtle,
            hintText: 'Search portal tools...',
            hintStyle: AppTypography.bodySmall.copyWith(
              fontSize: 11.5,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 15,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 34),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    iconSize: 14,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _searchController.clear();
                      _controller.setSearchQuery('');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: AppRadius.sm,
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.sm,
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadius.sm,
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
  // 4. FLAT MENU ITEM BUILDER (Single-Level Direct Navigation for Items 1-9)
  // ---------------------------------------------------------------------------
  Widget _buildFlatMenuItem(
    ClientMenuItem item,
    bool isDark,
    bool isCollapsed,
  ) {
    final isActive = _controller.activeRoute == item.routePath;

    final activeBg = isDark
        ? const Color(0xFF064E3B).withValues(alpha: 0.35)
        : const Color(0xFFECFDF5);

    final activeBorder = const Color(0xFF10B981);
    final activeTextColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Tooltip(
          message: item.title,
          preferBelow: false,
          child: InkWell(
            onTap: () {
              _controller.setActiveRoute(item.routePath);
              context.goNamed(item.routeName);
            },
            borderRadius: AppRadius.sm,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: isActive ? activeBg : Colors.transparent,
                borderRadius: AppRadius.sm,
                border: isActive
                    ? Border.all(color: activeBorder.withValues(alpha: 0.4), width: 1)
                    : null,
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  size: 20,
                  color: isActive
                      ? activeTextColor
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: InkWell(
        onTap: () {
          _controller.setActiveRoute(item.routePath);
          context.goNamed(item.routeName);
        },
        borderRadius: AppRadius.md,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.transparent,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isActive
                  ? activeBorder.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF10B981).withValues(alpha: 0.18)
                      : (isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: 16,
                  color: isActive
                      ? activeTextColor
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              const SizedBox(width: 10),

              // Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                        color: isActive
                            ? (isDark ? Colors.white : const Color(0xFF0F172A))
                            : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge Count
              if (item.badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: (item.badgeColor ?? const Color(0xFF10B981)).withValues(alpha: 0.15),
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    '${item.badgeCount}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: item.badgeColor ?? const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. EXPANDABLE MENU ITEM BUILDER (For AI Studio & Marketplace Submenus)
  // ---------------------------------------------------------------------------
  Widget _buildExpandableMenuItem(
    ClientMenuItem item,
    bool isDark,
    bool isCollapsed,
  ) {
    final key = _menuKeys.putIfAbsent(item.id, () => GlobalKey());
    final isExpanded = _controller.expandedMenuIds.contains(item.id);
    final isParentActive = _controller.activeRoute == item.routePath;
    final isAnySubActive = item.subItems.any((s) => s.routePath == _controller.activeRoute);
    final isHighlighted = isParentActive || isAnySubActive;

    final activeBg = isDark
        ? const Color(0xFF064E3B).withValues(alpha: 0.35)
        : const Color(0xFFECFDF5);
    final activeBorder = const Color(0xFF10B981);
    final activeTextColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Tooltip(
          message: '${item.title} (${item.subItems.length} sub-tools)',
          preferBelow: false,
          child: InkWell(
            onTap: () {
              _controller.setActiveRoute(item.routePath);
              context.goNamed(item.routeName);
            },
            borderRadius: AppRadius.sm,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: isHighlighted ? activeBg : Colors.transparent,
                borderRadius: AppRadius.sm,
                border: isHighlighted
                    ? Border.all(color: activeBorder.withValues(alpha: 0.4), width: 1)
                    : null,
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  size: 20,
                  color: isHighlighted
                      ? activeTextColor
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return KeyedSubtree(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Parent Header Tile
            InkWell(
              onTap: () {
                final willExpand = !isExpanded;
                _controller.toggleMenuExpansion(item.id);
                if (willExpand) {
                  final isLast = item.id == ClientNavigationRegistry.items.last.id;
                  _scrollToItem(key, isLastItem: isLast);
                }
                _controller.setActiveRoute(item.routePath);
                context.go(item.routePath);
              },
              borderRadius: AppRadius.md,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isHighlighted ? activeBg : Colors.transparent,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isHighlighted
                        ? activeBorder.withValues(alpha: 0.35)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? const Color(0xFF10B981).withValues(alpha: 0.18)
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        size: 16,
                        color: isHighlighted
                            ? activeTextColor
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
                              color: isHighlighted
                                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                  : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${item.subItems.length} Sub-tools available',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chevron indicator
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isHighlighted
                            ? activeTextColor
                            : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Smooth Animated Submenu Items List
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 4.0, bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: item.subItems.map((sub) {
                    final isSubActive = _controller.activeRoute == sub.routePath;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: InkWell(
                        onTap: () {
                          _controller.setActiveRoute(sub.routePath);
                          context.goNamed(sub.routeName);
                        },
                        borderRadius: AppRadius.sm,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.0),
                          decoration: BoxDecoration(
                            color: isSubActive
                                ? (isDark
                                    ? const Color(0xFF064E3B).withValues(alpha: 0.45)
                                    : const Color(0xFFD1FAE5))
                                : Colors.transparent,
                            borderRadius: AppRadius.sm,
                            border: Border(
                              left: BorderSide(
                                color: isSubActive
                                    ? const Color(0xFF10B981)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                width: 2.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                sub.icon,
                                size: 14,
                                color: isSubActive
                                    ? const Color(0xFF10B981)
                                    : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  sub.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: isSubActive ? FontWeight.w700 : FontWeight.w500,
                                    color: isSubActive
                                        ? (isDark ? Colors.white : const Color(0xFF064E3B))
                                        : (isDark ? AppColors.darkTextSecondary : const Color(0xFF475569)),
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
              ),
              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 240),
              firstCurve: Curves.easeInOutCubic,
              secondCurve: Curves.easeInOutCubic,
              sizeCurve: Curves.easeInOutCubic,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. FOOTER PROFILE & CRM SWITCHER
  // ---------------------------------------------------------------------------
  Widget _buildFooterProfile(bool isDark, bool isCollapsed) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8.0 : 12.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: isCollapsed
          ? Center(
              child: IconButton(
                iconSize: 20,
                tooltip: 'Switch to CRM Admin',
                icon: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF10B981)),
                onPressed: () => context.goNamed(RouteNames.login),
              ),
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF10B981),
                  child: Text(
                    'SJ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sarah Jenkins',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Homeowner Client',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: 'Switch to Team CRM',
                  child: IconButton(
                    iconSize: 18,
                    splashRadius: 16,
                    icon: Icon(
                      Icons.logout_rounded,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    onPressed: () => context.goNamed(RouteNames.login),
                  ),
                ),
              ],
            ),
    );
  }
}
