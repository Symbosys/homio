import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models/notification_models.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_prefs_modal.dart';

/// Screen 3: NOTIFICATIONS CENTER (/client/notifications)
/// Centralized customer notification hub:
/// - Filter tabs: All, Unread, Project, Payments, Designs, Meetings, Services, Support
/// - Unread indicators with priority styling
/// - Direct routing action buttons to target context
/// - Mark as read & Mark all as read
/// - Multi-channel preferences modal (WhatsApp, Push, SMS, Email)
/// - 100% Dark & Light mode compatible
class ClientNotificationsPage extends StatefulWidget {
  const ClientNotificationsPage({super.key});

  @override
  State<ClientNotificationsPage> createState() =>
      _ClientNotificationsPageState();
}

class _ClientNotificationsPageState extends State<ClientNotificationsPage> {
  final NotificationRepository _repo = NotificationRepository.instance;
  NotificationCategory _selectedCategory = NotificationCategory.all;

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isCompact(context);

    final allItems = _repo.items;
    final unreadCount = _repo.unreadCount;

    // Filter items
    final filteredItems = allItems.where((item) {
      if (_selectedCategory == NotificationCategory.all) return true;
      if (_selectedCategory == NotificationCategory.unread) return !item.isRead;
      return item.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          children: [
            // Page Header Hero
            _buildPageHeader(isDark, isMobile, unreadCount),
            const SizedBox(height: 20),

            // Filter Tabs
            _buildFilterTabs(isDark, unreadCount),
            const SizedBox(height: 18),

            // Notification List
            if (filteredItems.isEmpty)
              _buildEmptyState(isDark)
            else
              ...filteredItems.map((item) {
                return NotificationCard(
                  item: item,
                  onMarkAsRead: () => _repo.markAsRead(item.id),
                  onDelete: () => _repo.deleteNotification(item.id),
                );
              }),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isDark, bool isMobile, int unreadCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFEF4444), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'NOTIFICATIONS CENTER',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$unreadCount unread',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Live Milestone & Project Alerts',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Keep track of stage milestone sign-offs, billing tranches, live site progress photos, technician arrivals and design reviews in real time.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Action Toolbar: Mark All Read & Channels Preferences
          Row(
            children: [
              if (unreadCount > 0)
                OutlinedButton.icon(
                  onPressed: () => _repo.markAllAsRead(),
                  icon: const Icon(Icons.done_all_rounded, size: 16),
                  label: Text(
                    'Mark all as read',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                    ),
                  ),
                ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => NotificationPreferencesModal.show(context),
                icon: const Icon(Icons.tune_rounded, size: 16),
                label: Text(
                  'Preferences',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                  foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(bool isDark, int unreadCount) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: NotificationCategory.values.map((cat) {
          final isSelected = _selectedCategory == cat;

          String label = cat.label;
          if (cat == NotificationCategory.unread && unreadCount > 0) {
            label = 'Unread ($unreadCount)';
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = cat),
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 40,
              color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications found',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "You're completely caught up! We'll notify you when actions are required.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
