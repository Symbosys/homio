import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

// Global shared state for demo wallet
final AiWallet globalAiWallet = AiWallet();

/// Universal top navigation bar for all Client AI Studio screens.
class ClientAiStudioNavBar extends StatelessWidget {
  final String activeRoutePath;

  const ClientAiStudioNavBar({
    super.key,
    required this.activeRoutePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final tabs = [
      (
        label: 'Studio Hub',
        icon: Icons.hub_rounded,
        routePath: RouteNames.clientAiSuitePath,
        routeName: RouteNames.clientAiSuite,
      ),
      (
        label: '50/50 Room Gen',
        icon: Icons.auto_awesome_rounded,
        routePath: RouteNames.clientAiRoomGenPath,
        routeName: RouteNames.clientAiRoomGen,
      ),
      (
        label: 'Vastu Consultant',
        icon: Icons.compass_calibration_rounded,
        routePath: RouteNames.clientAiVastuPath,
        routeName: RouteNames.clientAiVastu,
      ),
      (
        label: 'Budget Estimator',
        icon: Icons.calculate_rounded,
        routePath: RouteNames.clientAiBudgetPath,
        routeName: RouteNames.clientAiBudget,
      ),
      (
        label: 'Doubt Solver',
        icon: Icons.psychology_rounded,
        routePath: RouteNames.clientAiDoubtSolverPath,
        routeName: RouteNames.clientAiDoubtSolver,
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Studio Branding + Wallet Token Counter + Designer Share Chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Homio AI Architectural Studio',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '50% Render Tokens Credited to Designer ${globalAiWallet.assignedDesigner}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 10 : 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Wallet Tokens Pill with Add Action
              InkWell(
                key: const Key('navbar_token_pill'),
                onTap: () => showBuyTokensDialog(context, isDark),
                borderRadius: AppRadius.full,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.toll_rounded,
                        color: Color(0xFF6366F1),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${globalAiWallet.totalTokens} Tokens',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Color(0xFF6366F1),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Bottom Row: Navigation Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: tabs.map((tab) {
                final isActive = activeRoutePath == tab.routePath;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () {
                      if (!isActive) {
                        context.goNamed(tab.routeName);
                      }
                    },
                    borderRadius: AppRadius.md,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                          ? const Color(0xFF6366F1)
                          : (isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9)),
                        borderRadius: AppRadius.md,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tab.icon,
                            size: 14,
                            color: isActive
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tab.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w600,
                              color: isActive
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
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
        ],
      ),
    );
  }
}

/// Modal dialog to recharge AI Studio Tokens.
void showBuyTokensDialog(BuildContext context, bool isDark) {
  showDialog(
    context: context,
    builder: (dialogCtx) {
      return AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                borderRadius: AppRadius.md,
              ),
              child: const Icon(
                Icons.toll_rounded,
                color: Color(0xFF6366F1),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Add AI Studio Tokens',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.handshake_rounded,
                      color: Color(0xFF059669),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '50-50 Partner Commitment: 50% of your purchase directly rewards your assigned designer (${globalAiWallet.assignedDesigner}).',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _buildTokenOption(
                dialogCtx,
                tokens: 50,
                price: '₹250',
                popular: false,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildTokenOption(
                dialogCtx,
                tokens: 150,
                price: '₹600',
                popular: true,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildTokenOption(
                dialogCtx,
                tokens: 500,
                price: '₹1,800',
                popular: false,
                isDark: isDark,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildTokenOption(
  BuildContext context, {
  required int tokens,
  required String price,
  required bool popular,
  required bool isDark,
}) {
  return InkWell(
    onTap: () {
      globalAiWallet.totalTokens += tokens;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully loaded $tokens Tokens! Balance: ${globalAiWallet.totalTokens}',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    },
    borderRadius: AppRadius.md,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: popular
            ? const Color(0xFF6366F1)
            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: popular ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.generating_tokens_rounded,
            size: 20,
            color: Color(0xFF6366F1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$tokens AI Tokens',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    if (popular) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'POPULAR',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${(tokens / 10).floor()} Room Renders or $tokens Doubt queries',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF6366F1),
            ),
          ),
        ],
      ),
    ),
  );
}
