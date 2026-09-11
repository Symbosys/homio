import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OrgDetailDrawer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? badge;
  final List<String> tabTitles;
  final List<Widget> tabViews;
  final List<Widget>? actions;

  const OrgDetailDrawer({
    super.key,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.tabTitles,
    required this.tabViews,
    this.actions,
  }) : assert(tabTitles.length == tabViews.length, 'tabTitles and tabViews count must match');

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? badge,
    required List<String> tabTitles,
    required List<Widget> tabViews,
    List<Widget>? actions,
  }) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => FractionallySizedBox(
          heightFactor: 0.9,
          child: OrgDetailDrawer(
            title: title,
            subtitle: subtitle,
            badge: badge,
            tabTitles: tabTitles,
            tabViews: tabViews,
            actions: actions,
          ),
        ),
      );
    } else {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Dismiss',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (ctx, anim1, anim2) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 580,
                height: double.infinity,
                child: OrgDetailDrawer(
                  title: title,
                  subtitle: subtitle,
                  badge: badge,
                  tabTitles: tabTitles,
                  tabViews: tabViews,
                  actions: actions,
                ),
              ),
            ),
          );
        },
        transitionBuilder: (ctx, anim, secondaryAnim, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: tabTitles.length,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (badge != null) ...[
                                const SizedBox(width: 8),
                                badge!,
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                    ),
                  ],
                ),
              ),

              // Drawer Tabs Header
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  tabAlignment: TabAlignment.start,
                  tabs: tabTitles.map((t) => Tab(text: t)).toList(),
                ),
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  children: tabViews.map((v) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: v,
                    );
                  }).toList(),
                ),
              ),

              // Optional Bottom Actions
              if (actions != null && actions!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
