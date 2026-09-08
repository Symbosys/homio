import 'broadcast_models.dart';

class BroadcastMockData {
  static final List<WhatsAppTemplateOption> templates = [
    const WhatsAppTemplateOption(
      id: 'TMP-001',
      name: 'festival_festive_offer_v2',
      category: 'MARKETING',
      bodyText:
          'Namaste {{1}}! 🪔 Celebrate this season with Homio Luxury Interiors. Enjoy an exclusive 15% VIP discount on all modular wardrobes & German hardware fittings for {{2}}. Book your complimentary 3D walkthrough today: {{3}}',
      placeholders: ['Client Name', 'Project / Villa Type', 'Consultation Booking Link'],
      hasHeaderImage: true,
    ),
    const WhatsAppTemplateOption(
      id: 'TMP-002',
      name: 'site_progress_weekly_digest',
      category: 'UTILITY',
      bodyText:
          'Hello {{1}}, here is your weekly site progress digest for {{2}}. Milestone reached: {{3}}. View updated photos, quality inspection checklists and civil log in your Homio Client Portal.',
      placeholders: ['Client Name', 'Project Code', 'Current Milestone'],
      hasHeaderImage: false,
    ),
    const WhatsAppTemplateOption(
      id: 'TMP-003',
      name: 'quotation_ready_reminder',
      category: 'UTILITY',
      bodyText:
          'Hi {{1}}, your customized interior design quotation & BOQ for {{2}} is ready for review. Total estimated turnkey investment is {{3}}. Tap below to review and approve digitally.',
      placeholders: ['Client Name', 'Property Location', 'Quotation Amount'],
      hasHeaderImage: false,
    ),
    const WhatsAppTemplateOption(
      id: 'TMP-004',
      name: 'material_procurement_dispatch',
      category: 'UTILITY',
      bodyText:
          'Dear {{1}}, your wholesale materials order #{{2}} containing {{3}} has been dispatched from our central hub. Expected delivery at site: {{4}}.',
      placeholders: ['Client / Contractor Name', 'Order ID', 'Key SKU Items', 'Delivery Date'],
      hasHeaderImage: false,
    ),
    const WhatsAppTemplateOption(
      id: 'TMP-005',
      name: 'post_handover_warranty_check',
      category: 'MARKETING',
      bodyText:
          'Dear {{1}}, it has been 6 months since your dream home handover at {{2}}! We hope you are loving every corner. As part of our 10-Year Warranty SLA, our senior inspection team is available for a free tune-up visit.',
      placeholders: ['Client Name', 'Society / Project Name'],
      hasHeaderImage: true,
    ),
  ];

  static final List<String> audienceSegments = [
    'All Active Leads (1,240)',
    'Hot Qualified Prospects (184)',
    'Execution Phase Clients (62)',
    'Completed Handover Alumni (410)',
    'Golf Course Road / DLF High Net-Worth (95)',
    'South Mumbai Luxury Penthouse Owners (48)',
    'Contractors & Interior Tradesmen (320)',
    'Custom CSV Upload List (65)',
  ];

  static final List<BroadcastCampaign> campaigns = [
    BroadcastCampaign(
      id: 'BC-101',
      name: 'Diwali Festive VIP Privilege Campaign',
      templateName: 'festival_festive_offer_v2',
      messageBody:
          'Namaste {{1}}! 🪔 Celebrate this season with Homio Luxury Interiors. Enjoy an exclusive 15% VIP discount on all modular wardrobes & German hardware fittings for {{2}}.',
      audienceSegment: 'Hot Qualified Prospects (184)',
      recipientCount: 184,
      status: CampaignStatus.sent,
      sentAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      deliveredCount: 181,
      readCount: 165,
      repliedCount: 42,
      failedCount: 3,
      headerImageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600',
      tags: ['Festive', 'VIP Promo', 'Hot Leads'],
    ),
    BroadcastCampaign(
      id: 'BC-102',
      name: 'Weekend Site Progress Video Blast',
      templateName: 'site_progress_weekly_digest',
      messageBody:
          'Hello {{1}}, here is your weekly site progress digest for {{2}}. Milestone reached: False ceiling framework & concealed electrical wiring completed.',
      audienceSegment: 'Execution Phase Clients (62)',
      recipientCount: 62,
      status: CampaignStatus.scheduled,
      scheduledAt: DateTime.now().add(const Duration(hours: 18)),
      deliveredCount: 0,
      readCount: 0,
      repliedCount: 0,
      failedCount: 0,
      tags: ['Site Progress', 'Weekly Milestone', 'Client Update'],
    ),
    BroadcastCampaign(
      id: 'BC-103',
      name: 'Q3 Architectural Material Index Release',
      templateName: 'material_procurement_dispatch',
      messageBody:
          'Dear {{1}}, the live wholesale construction index for Q3 is now available on Homio Hub. View direct mill prices for CenturyPly, Kajaria, and Hettich.',
      audienceSegment: 'Contractors & Interior Tradesmen (320)',
      recipientCount: 320,
      status: CampaignStatus.scheduled,
      scheduledAt: DateTime.now().add(const Duration(days: 2, hours: 5)),
      deliveredCount: 0,
      readCount: 0,
      repliedCount: 0,
      failedCount: 0,
      tags: ['B2B Wholesale', 'Materials', 'Live Index'],
    ),
    BroadcastCampaign(
      id: 'BC-104',
      name: 'Monsoon 3D VR Tour Invitation Blast',
      templateName: 'festival_festive_offer_v2',
      messageBody:
          'Namaste {{1}}! Explore our new 3D Matterport VR walkthroughs of completed duplex villas at DLF Phase 1. Schedule your private VR demo session today.',
      audienceSegment: 'Golf Course Road / DLF High Net-Worth (95)',
      recipientCount: 95,
      status: CampaignStatus.sent,
      sentAt: DateTime.now().subtract(const Duration(days: 5)),
      deliveredCount: 94,
      readCount: 88,
      repliedCount: 26,
      failedCount: 1,
      headerImageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
      tags: ['VR Experience', 'Matterport', 'DLF Luxury'],
    ),
    BroadcastCampaign(
      id: 'BC-105',
      name: '6-Month Post Handover Quality Assurance',
      templateName: 'post_handover_warranty_check',
      messageBody:
          'Dear {{1}}, it has been 6 months since your dream home handover! Our senior inspection team is scheduling complimentary warranty tune-ups.',
      audienceSegment: 'Completed Handover Alumni (410)',
      recipientCount: 410,
      status: CampaignStatus.draft,
      deliveredCount: 0,
      readCount: 0,
      repliedCount: 0,
      failedCount: 0,
      tags: ['Warranty', 'Customer Delight', 'Retention'],
    ),
  ];

  static void addCampaign(BroadcastCampaign campaign) {
    campaigns.insert(0, campaign);
  }

  static void cancelScheduled(String id) {
    final c = campaigns.firstWhere((item) => item.id == id, orElse: () => campaigns.first);
    c.status = CampaignStatus.cancelled;
  }

  static void rescheduleCampaign(String id, DateTime newDateTime) {
    final c = campaigns.firstWhere((item) => item.id == id, orElse: () => campaigns.first);
    c.scheduledAt = newDateTime;
    c.status = CampaignStatus.scheduled;
  }

  static void deleteCampaign(String id) {
    campaigns.removeWhere((c) => c.id == id);
  }
}
