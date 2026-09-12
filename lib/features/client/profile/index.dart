import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models/profile_models.dart';
import 'widgets/address_book_section.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/security_activity_view.dart';

/// Screen 4: PROFILE & ACCOUNT CENTER (/client/profile)
/// Comprehensive homeowner account & property profile dashboard:
/// - Profile Header with verified homeowner tier & masked credentials
/// - Personal & Contact Information
/// - Multi-site Address Book (Home, Office, Project Sites)
/// - Linked Projects Dossier & Payment Profile
/// - Security & Device Activity (Change Password with live rules)
/// - Service History & Support links
/// - Logout confirmation dialog
/// - 100% Dark & Light mode compatible
class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final ProfileRepository _repo = ProfileRepository.instance;
  String _activeSection = 'Personal & Address'; // 'Personal & Address', 'Projects & Billing', 'Security', 'Support'

  @override
  void initState() {
    super.initState();
    _repo.changeNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _repo.changeNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Text(
          'Log Out of HOMIO?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to log out? You will need to re-authenticate to view your project updates and approvals.',
          style: GoogleFonts.inter(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isCompact(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          children: [
            // Profile Header Hero
            ProfileHeaderCard(profile: _repo.profile),
            const SizedBox(height: 20),

            // Section Navigation Chips (Mobile & Desktop)
            _buildSectionSelector(isDark),
            const SizedBox(height: 20),

            // Selected Section Content
            if (_activeSection == 'Personal & Address') ...[
              AddressBookSection(
                addresses: _repo.addresses,
                onAddressUpdated: () => setState(() {}),
              ),
            ] else if (_activeSection == 'Projects & Billing') ...[
              _buildProjectsBillingSection(isDark),
            ] else if (_activeSection == 'Security') ...[
              SecurityActivityView(logs: _repo.securityLogs),
            ] else if (_activeSection == 'Support') ...[
              _buildSupportLegalSection(isDark),
            ],

            const SizedBox(height: 28),

            // Logout Footer Button
            _buildLogoutFooter(isDark),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSelector(bool isDark) {
    final sections = [
      ('Personal & Address', Icons.contact_mail_rounded),
      ('Projects & Billing', Icons.business_center_rounded),
      ('Security', Icons.shield_rounded),
      ('Support', Icons.help_outline_rounded),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: sections.map((sec) {
          final isSelected = _activeSection == sec.$1;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(
                sec.$2,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              label: Text(
                sec.$1,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _activeSection = sec.$1),
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProjectsBillingSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Linked Projects
        Text(
          'Linked Projects (${_repo.linkedProjects.length})',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        ..._repo.linkedProjects.map((p) {
          final isActive = p.status.contains('Active');
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isActive ? const Color(0xFF10B981) : AppColors.primary).withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    Icons.home_work_rounded,
                    size: 20,
                    color: isActive ? const Color(0xFF10B981) : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '${p.status} · ${p.role}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/client/projects'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                    foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.md,
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Workspace',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 18),

        // Commercial & Tax Profile Card
        Text(
          'Tax & Commercial Billing Profile',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow('Billing Entity', _repo.profile.billingName, isDark),
              _buildDetailRow('GSTIN Number', _repo.profile.billingGstin, isDark),
              _buildDetailRow('Company Name', _repo.profile.billingCompany, isDark),
              _buildDetailRow('Saved Payment Mode', 'UPI ID (amitkumar@okaxis) & ICICI Netbanking', isDark),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'View all milestone invoices & receipts in Billing module',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/client/payments'),
                    child: const Text('Open Invoices'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Service History Shortcut
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.handyman_rounded, size: 20, color: Color(0xFF0EA5E9)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service & Labour Hiring History',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'Manage bookings for carpenters, electricians & plumbers',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => context.go('/client/services'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                  elevation: 0,
                ),
                child: const Text('My Services'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportLegalSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Help, Support & Warranty',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              _buildActionTile(
                'Snags & Warranty Claim Hub',
                'Log defects, track 48-hour SLA resolutions and 10-year warranty coverage',
                Icons.support_agent_rounded,
                () => context.go('/client/complaints'),
                isDark,
              ),
              const Divider(height: 1),
              _buildActionTile(
                'Feedback & Ratings Center',
                'Rate your project milestones, interior designer and execution supervisor',
                Icons.star_rate_rounded,
                () => context.go('/client/ratings'),
                isDark,
              ),
              const Divider(height: 1),
              _buildActionTile(
                'HOMIO Client Support Hotline',
                'Direct phone & WhatsApp concierge support (+91 94311 00000)',
                Icons.headset_mic_rounded,
                () => context.go('/client/chat'),
                isDark,
              ),
              const Divider(height: 1),
              _buildActionTile(
                'Terms of Service & Turnkey Agreement',
                'Official contract clauses, payment schedule & delay penalty terms',
                Icons.description_outlined,
                () {},
                isDark,
              ),
              const Divider(height: 1),
              _buildActionTile(
                'Privacy Policy & Data Security',
                'How your architectural drawings and property data are safeguarded',
                Icons.privacy_tip_outlined,
                () {},
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isDark,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.logout_rounded, size: 18, color: const Color(0xFFEF4444)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End Customer Portal Session',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
                Text(
                  'Safely log out from this browser session',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _confirmLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.12),
              foregroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.md,
                side: const BorderSide(color: Color(0xFFEF4444)),
              ),
              elevation: 0,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
