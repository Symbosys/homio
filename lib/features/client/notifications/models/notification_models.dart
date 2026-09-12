import 'package:flutter/material.dart';

/// Notification categories supported by the client portal
enum NotificationCategory {
  all('All'),
  unread('Unread'),
  project('Project'),
  payments('Payments'),
  designs('Designs'),
  meetings('Meetings'),
  services('Services'),
  support('Support');

  final String label;
  const NotificationCategory(this.label);
}

/// A notification item delivered to the customer
class CustomerNotificationItem {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final NotificationCategory category;
  bool isRead;
  final bool isUrgent;
  final String actionLabel;
  final String routePath;
  final IconData icon;
  final Color iconColor;

  CustomerNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    this.isRead = false,
    this.isUrgent = false,
    required this.actionLabel,
    required this.routePath,
    required this.icon,
    required this.iconColor,
  });
}

/// Customer communication channel preferences
class NotificationChannelPreferences {
  bool projectUpdatesInApp;
  bool projectUpdatesPush;
  bool projectUpdatesWhatsApp;
  bool projectUpdatesEmail;

  bool billingInApp;
  bool billingPush;
  bool billingWhatsApp;
  bool billingSms;
  bool billingEmail;

  bool designInApp;
  bool designPush;
  bool designWhatsApp;

  bool serviceUpdatesInApp;
  bool serviceUpdatesWhatsApp;

  bool promotionalEmail;
  bool promotionalWhatsApp;

  NotificationChannelPreferences({
    this.projectUpdatesInApp = true,
    this.projectUpdatesPush = true,
    this.projectUpdatesWhatsApp = true,
    this.projectUpdatesEmail = true,
    this.billingInApp = true,
    this.billingPush = true,
    this.billingWhatsApp = true,
    this.billingSms = true,
    this.billingEmail = true,
    this.designInApp = true,
    this.designPush = true,
    this.designWhatsApp = true,
    this.serviceUpdatesInApp = true,
    this.serviceUpdatesWhatsApp = true,
    this.promotionalEmail = false,
    this.promotionalWhatsApp = false,
  });
}

/// Central Repository for Customer Notifications
class NotificationRepository {
  NotificationRepository._();
  static final NotificationRepository instance = NotificationRepository._();

  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  final NotificationChannelPreferences channelPreferences =
      NotificationChannelPreferences();

  late final List<CustomerNotificationItem> _items = [
    CustomerNotificationItem(
      id: 'notif_001',
      title: 'Digital Approval Required',
      description: 'Living Room 3D Photorealistic Design & Material Spec Sheet is ready for your formal review and sign-off.',
      timestamp: 'Today · 11:30 AM',
      category: NotificationCategory.designs,
      isRead: false,
      isUrgent: true,
      actionLabel: 'Review Design',
      routePath: '/client/approvals',
      icon: Icons.view_in_ar_rounded,
      iconColor: const Color(0xFF8B5CF6),
    ),
    CustomerNotificationItem(
      id: 'notif_002',
      title: 'Milestone Payment Due',
      description: 'Tranche #3 of ₹75,000 for Gypsum False Ceiling & Cove Lighting is due on 20 Sep 2026.',
      timestamp: 'Today · 10:20 AM',
      category: NotificationCategory.payments,
      isRead: false,
      isUrgent: true,
      actionLabel: 'View Payment',
      routePath: '/client/payments',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: const Color(0xFFF59E0B),
    ),
    CustomerNotificationItem(
      id: 'notif_003',
      title: 'Site Progress Updated',
      description: 'Site supervisor Rajesh Verma uploaded 4 new high-resolution inspection photos of marble polishing.',
      timestamp: 'Yesterday · 06:30 PM',
      category: NotificationCategory.project,
      isRead: false,
      isUrgent: false,
      actionLabel: 'View Site Feed',
      routePath: '/client/site-progress',
      icon: Icons.camera_indoor_rounded,
      iconColor: const Color(0xFF10B981),
    ),
    CustomerNotificationItem(
      id: 'notif_004',
      title: 'Service Professional Assigned',
      description: 'Master Carpenter Rajesh Kumar confirmed your booking for kitchen modular cabinetry execution.',
      timestamp: 'Yesterday · 04:15 PM',
      category: NotificationCategory.services,
      isRead: true,
      isUrgent: false,
      actionLabel: 'Track Booking',
      routePath: '/client/services',
      icon: Icons.handyman_rounded,
      iconColor: const Color(0xFF0EA5E9),
    ),
    CustomerNotificationItem(
      id: 'notif_005',
      title: 'Virtual Design Review Scheduled',
      description: 'Video consultation confirmed with Lead Interior Designer Ar. Pooja Hegde for tomorrow at 04:00 PM.',
      timestamp: '11 Sep · 02:40 PM',
      category: NotificationCategory.meetings,
      isRead: true,
      isUrgent: false,
      actionLabel: 'View Meeting',
      routePath: '/client/chat',
      icon: Icons.video_call_rounded,
      iconColor: const Color(0xFF6366F1),
    ),
    CustomerNotificationItem(
      id: 'notif_006',
      title: 'Snag Ticket Resolved',
      description: 'Ticket #DEF-2026-0042 (Guest bathroom tile grout gap) has been rectified by site team and verified by QA.',
      timestamp: '10 Sep · 05:10 PM',
      category: NotificationCategory.support,
      isRead: true,
      isUrgent: false,
      actionLabel: 'View Ticket',
      routePath: '/client/complaints',
      icon: Icons.support_agent_rounded,
      iconColor: const Color(0xFF10B981),
    ),
    CustomerNotificationItem(
      id: 'notif_007',
      title: 'Feedback Requested',
      description: 'Stage 3 False Ceiling work has been verified. Please rate your experience to help us improve.',
      timestamp: '09 Sep · 12:15 PM',
      category: NotificationCategory.project,
      isRead: true,
      isUrgent: false,
      actionLabel: 'Rate Experience',
      routePath: '/client/ratings',
      icon: Icons.star_rate_rounded,
      iconColor: const Color(0xFFF59E0B),
    ),
  ];

  List<CustomerNotificationItem> get items => List.unmodifiable(_items);

  int get unreadCount => _items.where((i) => !i.isRead).length;

  void markAsRead(String id) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1 && !_items[index].isRead) {
      _items[index].isRead = true;
      changeNotifier.value++;
    }
  }

  void markAllAsRead() {
    for (final item in _items) {
      item.isRead = true;
    }
    changeNotifier.value++;
  }

  void deleteNotification(String id) {
    _items.removeWhere((i) => i.id == id);
    changeNotifier.value++;
  }
}
