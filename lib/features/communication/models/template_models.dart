import 'package:flutter/material.dart';

enum TemplateCategory {
  marketing(label: 'Marketing & Offers', color: Color(0xFF8B5CF6), icon: Icons.local_offer_rounded),
  utility(label: 'Utility & Milestones', color: Color(0xFF10B981), icon: Icons.notifications_active_rounded),
  authentication(label: 'Authentication / OTP', color: Color(0xFF3B82F6), icon: Icons.security_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const TemplateCategory({required this.label, required this.color, required this.icon});
}

enum TemplateApprovalStatus {
  approved(label: 'Meta Approved', color: Color(0xFF10B981), icon: Icons.verified_rounded),
  pending(label: 'In Review', color: Color(0xFFF59E0B), icon: Icons.hourglass_top_rounded),
  rejected(label: 'Rejected', color: Color(0xFFEF4444), icon: Icons.error_outline_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const TemplateApprovalStatus({required this.label, required this.color, required this.icon});
}

enum TemplateButtonType { quickReply, url, phone }

class TemplateActionButton {
  final String text;
  final TemplateButtonType type;
  final String? urlOrPhone;

  const TemplateActionButton({
    required this.text,
    required this.type,
    this.urlOrPhone,
  });
}

class MetaMessageTemplate {
  final String id;
  String name;
  TemplateCategory category;
  TemplateApprovalStatus status;
  String language;
  String? headerImageUrl;
  String bodyText;
  String? footerText;
  List<TemplateActionButton> buttons;
  List<String> placeholders;
  int totalSent;
  double readRate;
  double responseRate;
  DateTime dateCreated;

  MetaMessageTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    this.language = 'English (en_IN)',
    this.headerImageUrl,
    required this.bodyText,
    this.footerText = 'Homio Luxury Interiors • Reply STOP to opt out',
    this.buttons = const [],
    this.placeholders = const [],
    this.totalSent = 0,
    this.readRate = 0.0,
    this.responseRate = 0.0,
    required this.dateCreated,
  });
}

class TemplateMockData {
  static final List<MetaMessageTemplate> templates = [
    MetaMessageTemplate(
      id: 'TPL-101',
      name: 'festive_diwali_vip_offer_v2',
      category: TemplateCategory.marketing,
      status: TemplateApprovalStatus.approved,
      headerImageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600',
      bodyText:
          'Namaste {{1}}! 🪔 Celebrate this season with Homio Luxury Interiors. Enjoy an exclusive 15% VIP discount on all modular wardrobes & German hardware fittings for your property at {{2}}. Tap below to claim your personalized offer:',
      placeholders: ['Client Name', 'Property Location'],
      buttons: const [
        TemplateActionButton(text: 'Book 3D VR Tour', type: TemplateButtonType.url, urlOrPhone: 'https://homiocrm.com/book-vr'),
        TemplateActionButton(text: 'Call Design Team', type: TemplateButtonType.phone, urlOrPhone: '+919810122849'),
      ],
      totalSent: 1840,
      readRate: 92.4,
      responseRate: 24.8,
      dateCreated: DateTime.now().subtract(const Duration(days: 45)),
    ),
    MetaMessageTemplate(
      id: 'TPL-102',
      name: 'site_progress_weekly_update',
      category: TemplateCategory.utility,
      status: TemplateApprovalStatus.approved,
      bodyText:
          'Hello {{1}}, here is your verified site milestone report for {{2}}. Current Stage: {{3}}. Our QA engineer has approved the civil alignment checklists. Tap to view the high-res 360° progress photos:',
      placeholders: ['Client Name', 'Project Code', 'Completed Milestone'],
      buttons: const [
        TemplateActionButton(text: 'View Progress Photos', type: TemplateButtonType.url, urlOrPhone: 'https://homiocrm.com/portal/progress'),
        TemplateActionButton(text: 'Message Site Supervisor', type: TemplateButtonType.quickReply),
      ],
      totalSent: 3410,
      readRate: 98.2,
      responseRate: 31.5,
      dateCreated: DateTime.now().subtract(const Duration(days: 90)),
    ),
    MetaMessageTemplate(
      id: 'TPL-103',
      name: 'quotation_ready_notification',
      category: TemplateCategory.utility,
      status: TemplateApprovalStatus.approved,
      bodyText:
          'Hi {{1}}, your customized interior design quotation & BOQ for {{2}} is ready! Total estimated turnkey investment is {{3}} with premium IS:710 marine plywood and Blum fittings. Review and sign off digitally:',
      placeholders: ['Client Name', 'Property Name', 'BOQ Total Amount'],
      buttons: const [
        TemplateActionButton(text: 'Review & Sign BOQ', type: TemplateButtonType.url, urlOrPhone: 'https://homiocrm.com/boq/review'),
      ],
      totalSent: 1250,
      readRate: 95.6,
      responseRate: 42.1,
      dateCreated: DateTime.now().subtract(const Duration(days: 30)),
    ),
    MetaMessageTemplate(
      id: 'TPL-104',
      name: 'materials_procurement_dispatch',
      category: TemplateCategory.utility,
      status: TemplateApprovalStatus.approved,
      bodyText:
          'Dear {{1}}, wholesale materials order #{{2}} containing {{3}} has been dispatched from our central hub. Expected delivery at site: {{4}}.',
      placeholders: ['Client / Contractor Name', 'Order ID', 'Key Materials', 'Delivery ETA'],
      buttons: const [
        TemplateActionButton(text: 'Track Vehicle Live', type: TemplateButtonType.url, urlOrPhone: 'https://homiocrm.com/track/order'),
      ],
      totalSent: 890,
      readRate: 88.5,
      responseRate: 14.2,
      dateCreated: DateTime.now().subtract(const Duration(days: 20)),
    ),
    MetaMessageTemplate(
      id: 'TPL-105',
      name: 'post_handover_warranty_checkin',
      category: TemplateCategory.marketing,
      status: TemplateApprovalStatus.approved,
      headerImageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
      bodyText:
          'Dear {{1}}, it has been 6 months since your dream home handover at {{2}}! As part of our 10-Year Warranty SLA, our senior inspection team is available for a free tune-up visit.',
      placeholders: ['Client Name', 'Society Name'],
      buttons: const [
        TemplateActionButton(text: 'Book Free Tune-Up', type: TemplateButtonType.url, urlOrPhone: 'https://homiocrm.com/warranty/visit'),
      ],
      totalSent: 620,
      readRate: 94.0,
      responseRate: 28.5,
      dateCreated: DateTime.now().subtract(const Duration(days: 60)),
    ),
    MetaMessageTemplate(
      id: 'TPL-106',
      name: 'promotional_zero_cost_emi_blast',
      category: TemplateCategory.marketing,
      status: TemplateApprovalStatus.pending,
      bodyText:
          'Exciting news {{1}}! Now furnish your complete 3BHK home with 0% interest EMI options starting at just ₹24,999/month through Homio Finance Partners. Pre-approve your credit line in 2 minutes.',
      placeholders: ['Client Name'],
      buttons: const [
        TemplateActionButton(text: 'Check EMI Eligibility', type: TemplateButtonType.url, urlOrPhone: 'https://homiocrm.com/finance'),
      ],
      totalSent: 0,
      readRate: 0.0,
      responseRate: 0.0,
      dateCreated: DateTime.now().subtract(const Duration(hours: 14)),
    ),
  ];

  static void addTemplate(MetaMessageTemplate template) {
    templates.insert(0, template);
  }

  static void deleteTemplate(String id) {
    templates.removeWhere((t) => t.id == id);
  }
}
