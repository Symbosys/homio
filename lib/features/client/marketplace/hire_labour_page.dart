import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// On-Demand Labour & Certified Craftsmen Service Booking Page.
class ClientHireLabourPage extends StatefulWidget {
  const ClientHireLabourPage({super.key});

  @override
  State<ClientHireLabourPage> createState() => _ClientHireLabourPageState();
}

class _ClientHireLabourPageState extends State<ClientHireLabourPage> {
  LabourTrade _selectedTrade = LabourTrade.all;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final craftsmen = globalMarketplaceState.labourProfiles.where((craftsman) {
      final matchesTrade = _selectedTrade == LabourTrade.all || craftsman.trade == _selectedTrade;
      final matchesQuery = _searchQuery.isEmpty ||
          craftsman.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          craftsman.trade.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          craftsman.skillTags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesTrade && matchesQuery;
    }).toList();

    final activeBookings = globalMarketplaceState.activeBookings;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page Title & Subtitle Banner
              _buildLabourBanner(isDark, isMobile),
              const SizedBox(height: 18),

              // Search & Trade Filter Chips
              _buildFilterBar(isDark, isMobile),
              const SizedBox(height: 18),

              // Active On-Site Bookings Tray (Palm Heights Villa 402)
              if (activeBookings.isNotEmpty) ...[
                _buildActiveBookingsTray(activeBookings, isDark, isMobile),
                const SizedBox(height: 20),
              ],

              // Craftsmen Directory Header
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOMIO CERTIFIED CRAFTSMEN (${craftsmen.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFF59E0B),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '100% Police Verified & Insured',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Text(
                      'HOMIO CERTIFIED CRAFTSMEN (${craftsmen.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFF59E0B),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '100% Police Verified & Insured',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              // Craftsmen List
              if (craftsmen.isEmpty)
                _buildEmptyState(isDark)
              else
                ...craftsmen.map((profile) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCraftsmanCard(profile, isDark, isMobile),
                    )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabourBanner(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.engineering_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hire On-Demand Labour & Certified Guild',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Direct contractor rates with zero middleman margin. Every worker is background checked, skill tested, and supervised by a Homio civil engineer.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 11.5 : 13,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Search craftsmen by name, trade specialization, or hardware skill...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Trade filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: LabourTrade.values.map((trade) {
              final isSelected = _selectedTrade == trade;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trade.icon,
                        size: 14,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      Text(trade.label),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedTrade = trade),
                  selectedColor: const Color(0xFFF59E0B),
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.full,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFF59E0B)
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveBookingsTray(List<LabourBooking> bookings, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFFF59E0B), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ACTIVE LABOUR ENGAGEMENTS (${bookings.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFF59E0B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Live at Palm Heights Villa 402',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 8),
                Text(
                  'ACTIVE LABOUR ENGAGEMENTS (${bookings.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFF59E0B),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Live at Palm Heights Villa 402',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          ...bookings.map((booking) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  booking.status.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                              Text(
                                '₹${booking.dealValue.toInt()} (${booking.durationDays} Days)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${booking.labourName} • ${booking.trade.label}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: AppRadius.full,
                            ),
                            child: Text(
                              booking.status.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${booking.labourName} • ${booking.trade.label}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Text(
                            '₹${booking.dealValue.toInt()} (${booking.durationDays} Days)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 6),
                    Text(
                      booking.siteAddress,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Task checklist preview
                    ...booking.taskChecklist.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 12, color: Color(0xFF10B981)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  task,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCraftsmanCard(LabourProfile profile, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Trade pill, KYC badge, Rating
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  profile.trade.label.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFF59E0B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (profile.verifiedKyc)
                Container(
                  constraints: const BoxConstraints(maxWidth: 290),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 12, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Aadhaar & Police KYC Verified',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 15),
                  const SizedBox(width: 3),
                  Text(
                    '${profile.homioRating}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    ' (${profile.completedJobsCount} jobs)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Name and experience
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                profile.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  '${profile.experienceYears} Years Exp',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  profile.availability,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Supervisor Endorsement quote
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote_rounded, size: 16, color: Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    profile.supervisorEndorsement,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Skill tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: profile.skillTags.map((tag) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 280),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  tag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          const Divider(height: 1),
          const SizedBox(height: 12),

          // Bottom Price & Action Row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRateSection(profile, isDark),
                const SizedBox(height: 10),
                _buildActionButtons(profile, isDark),
              ],
            )
          else
            Row(
              children: [
                _buildRateSection(profile, isDark),
                const Spacer(),
                _buildActionButtons(profile, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRateSection(LabourProfile profile, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(
              '₹${profile.dayRate}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF59E0B),
              ),
            ),
            Text(
              ' / day (8 hrs)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Or measurement rate: ₹${profile.sqFtRate}/sq.ft',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(LabourProfile profile, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showBookingDialog(context, profile, isDark),
          icon: const Icon(Icons.handyman_rounded, size: 16),
          label: Text('Book ${profile.name.split(' ').first}'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
        ),
      ],
    );
  }

  void _showBookingDialog(BuildContext context, LabourProfile profile, bool isDark) {
    int durationDays = 3;
    bool termsAccepted = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final totalEstimate = durationDays * profile.dayRate;

            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: AppRadius.md,
                    ),
                    child: const Icon(Icons.calendar_month_rounded, color: Color(0xFFF59E0B), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book ${profile.name}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${profile.trade.label} • Rate: ₹${profile.dayRate}/day',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 16),
                      Text(
                        'WORK LOCATION',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFF59E0B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Palm Heights Villa 402 (Active Client Site)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'ESTIMATED DURATION (DAYS)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFF59E0B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [1, 2, 3, 5, 7].map((days) {
                          final isSel = durationDays == days;
                          return InkWell(
                            onTap: () => setDialogState(() => durationDays = days),
                            borderRadius: AppRadius.sm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? const Color(0xFFF59E0B)
                                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Text(
                                '$days ${days == 1 ? 'Day' : 'Days'}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                  color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Total Value calculation
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 1,
                          ),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ESTIMATED CONTRACT VALUE',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                                Text(
                                  '₹$totalEstimate',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Text(
                                'Post-Work Inspection Signoff',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // T&C Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: termsAccepted,
                            onChanged: (v) => setDialogState(() => termsAccepted = v ?? false),
                            activeColor: const Color(0xFFF59E0B),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'I agree to the standard 8-hour workday, daily material safety protocol, and post-task verification by the Homio project site engineer.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: termsAccepted
                      ? () {
                          final newBooking = LabourBooking(
                            id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
                            labourId: profile.id,
                            labourName: profile.name,
                            trade: profile.trade,
                            siteAddress: 'Palm Heights Villa 402, Custom Interior Scope',
                            startDate: 'Scheduled Next Workday',
                            durationDays: durationDays,
                            dealValue: totalEstimate.toDouble(),
                            taskChecklist: [
                              'Initial site walk-through and tool setup',
                              'Execution of specified ${profile.trade.label} scope',
                              'End-of-day debris cleanup and supervisor checklist signoff',
                            ],
                            status: 'Confirmed',
                            termsAccepted: true,
                            timestamp: 'Just now',
                          );

                          setState(() {
                            globalMarketplaceState.activeBookings.insert(0, newBooking);
                          });

                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFFF59E0B),
                              content: Text(
                                'Booking confirmed for ${profile.name}! Homio site engineer notified for Villa 402.',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Confirm Booking (₹$totalEstimate)',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              'No craftsmen match your search criteria',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing the trade category filter or clearing search keywords.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
