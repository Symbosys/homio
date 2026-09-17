import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../core/storage/local_storage.dart';

class PlatformSidebar extends StatelessWidget {
  final bool isDrawer;

  const PlatformSidebar({
    super.key,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentRoute = GoRouterState.of(context).uri.path;
    final auth = AuthStateNotifier.instance;
    final user = auth.currentUser;

    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Platform Brand Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA855F7), Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Homio SaaS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Platform Owner Console',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Menu Category Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(
              'PLATFORM MANAGEMENT',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
            ),
          ),

          // The 4 Core Sidebar Tabs
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(
                  context,
                  title: 'Dashboard',
                  icon: Icons.dashboard_rounded,
                  route: RouteNames.platformDashboardPath,
                  isActive: currentRoute == RouteNames.platformDashboardPath,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  title: 'Subscription Plans',
                  icon: Icons.card_membership_rounded,
                  route: RouteNames.platformSubscriptionsPath,
                  isActive: currentRoute == RouteNames.platformSubscriptionsPath,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  title: 'Organizations',
                  icon: Icons.domain_rounded,
                  route: RouteNames.platformOrganizationsPath,
                  isActive: currentRoute == RouteNames.platformOrganizationsPath,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  title: 'Onboard / Create Org',
                  icon: Icons.add_business_rounded,
                  route: RouteNames.platformOnboardOrgPath,
                  isActive: currentRoute == RouteNames.platformOnboardOrgPath,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                // Marketplace Category Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    'MARKETPLACE GOVERNANCE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                _buildNavItem(
                  context,
                  title: 'Categories',
                  icon: Icons.category_rounded,
                  route: RouteNames.platformCategoriesPath,
                  isActive: currentRoute == RouteNames.platformCategoriesPath,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  title: 'Property Verifications',
                  icon: Icons.verified_rounded,
                  route: RouteNames.platformPropertiesPath,
                  isActive: currentRoute == RouteNames.platformPropertiesPath,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  title: 'Seller Approvals',
                  icon: Icons.how_to_reg_rounded,
                  route: RouteNames.platformSellerApprovalsPath,
                  isActive: currentRoute == RouteNames.platformSellerApprovalsPath,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // User Profile & Quick Logout Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  child: Text(
                    (user?.firstName.isNotEmpty ?? false)
                        ? user!.firstName[0].toUpperCase()
                        : 'P',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.fullName ?? 'Platform SuperAdmin',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        user?.email ?? 'superadmin@homio.com',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Logout',
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  onPressed: () async {
                    await LocalStorage.instance.clearSession();
                    AuthStateNotifier.instance.setUnauthenticated();
                    if (context.mounted) {
                      context.go(RouteNames.loginPath);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required bool isActive,
    required bool isDark,
  }) {
    final activeColor = const Color(0xFF8B5CF6);
    final activeBg = isDark
        ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
        : const Color(0xFFF3E8FF);

    return InkWell(
      onTap: () {
        if (isDrawer && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        context.go(route);
      },
      borderRadius: BorderRadius.circular(9),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: isActive
                  ? activeColor
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? activeColor
                      : (isDark ? Colors.white : const Color(0xFF1E293B)),
                ),
              ),
            ),
            if (isActive)
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
