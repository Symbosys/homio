import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_credit_service.dart';
import '../widgets/widgets.dart';

class AiCreditsPage extends StatefulWidget {
  const AiCreditsPage({super.key});

  @override
  State<AiCreditsPage> createState() => _AiCreditsPageState();
}

class _AiCreditsPageState extends State<AiCreditsPage> {
  void _buyPack(AiCreditPack pack) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Credit Purchase', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text(
          'Purchase ${pack.name} with ${pack.credits} Credits for ₹${pack.priceInr.toInt()} via instant UPI / Card?',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              AiCreditService.instance.addCredits(amount: pack.credits, packName: pack.name);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully added ${pack.credits} AI credits to your wallet!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Pay with UPI / Card'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balance = AiCreditService.instance.balance;
    final txns = AiCreditService.instance.transactions;

    return AiStudioPageScaffold(
      title: 'AI Credits & Generation Wallet',
      subtitle: 'Monitor Real-Time Credit Balances, Review Usage Ledgers & Top Up Project Credit Bundles',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Wallet Balance Card
          _buildBalanceHero(context, balance, isDark),
          const SizedBox(height: 28),

          // Available Top-Up Credit Packs
          Text(
            'Purchase Credit Bundles',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Credits never expire and roll over automatically across all your active interior projects.',
            style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.getTextSecondary(context)),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;
              final packs = AiCreditService.standardPacks;

              if (isDesktop) {
                return Row(
                  children: packs.map((p) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildPackCard(context, p, isDark),
                      ),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: packs.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildPackCard(context, p, isDark),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 36),

          // Usage & Transaction History
          Text(
            'Credit Transaction Ledger',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 14),
          if (txns.isEmpty)
            const EmptyStateView(
              icon: Icons.receipt_long_rounded,
              title: 'No transactions recorded',
              description: 'Your credit usage history will show up here.',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: txns.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final txn = txns[index];
                final isPositive = txn.type.isPositive;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? AppColors.success.withValues(alpha: 0.15)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Icon(
                          isPositive ? Icons.add_circle_outline_rounded : Icons.bolt_rounded,
                          color: isPositive ? AppColors.success : const Color(0xFFD97706),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              txn.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                            Text(
                              'Tool: ${txn.toolUsed} · Ref: ${txn.id}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${isPositive ? "+" : "-"}${txn.amountCredits} Credits',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isPositive ? AppColors.success : AppColors.getTextPrimary(context),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceHero(BuildContext context, int balance, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E2433), const Color(0xFF172554)]
              : [const Color(0xFFEEF2FF), const Color(0xFFDBEAFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.xl,
        border: Border.all(
          color: isDark ? const Color(0xFF3B4863) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.black87, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Studio Balance',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
                Text(
                  '$balance AI Credits',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.getTextPrimary(context),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Included in your active Turnkey Project · Free tier refreshes 50 credits each billing cycle.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.getTextMuted(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackCard(BuildContext context, AiCreditPack pack, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: pack.isPopular
              ? AppColors.primaryLight
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: pack.isPopular ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: pack.isPopular
                ? AppColors.primaryLight.withValues(alpha: isDark ? 0.2 : 0.08)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: pack.isPopular ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pack.savingsBadge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: pack.isPopular ? AppColors.primaryLight : const Color(0xFF10B981),
                borderRadius: AppRadius.xs,
              ),
              child: Text(
                pack.savingsBadge,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Text(
            pack.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${pack.credits}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Credits',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          Text(
            '₹${pack.perCreditRateInr.toStringAsFixed(2)} per credit',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: AppColors.getTextMuted(context),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Total:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.getTextMuted(context),
                ),
              ),
              const Spacer(),
              Text(
                '₹${pack.priceInr.toInt()}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _buyPack(pack),
              style: ElevatedButton.styleFrom(
                backgroundColor: pack.isPopular ? AppColors.primary : AppColors.getSurfaceSubtle(context),
                foregroundColor: pack.isPopular ? Colors.white : AppColors.getTextPrimary(context),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              ),
              child: Text(
                'Buy Pack',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
