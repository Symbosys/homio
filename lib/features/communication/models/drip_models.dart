class DripStep {
  final String id;
  final int stepIndex;
  final int dayDelay;
  final int hourDelay;
  final String title;
  final String templateName;
  final String messagePreview;
  final String actionCta;

  const DripStep({
    required this.id,
    required this.stepIndex,
    required this.dayDelay,
    this.hourDelay = 0,
    required this.title,
    required this.templateName,
    required this.messagePreview,
    required this.actionCta,
  });

  String get delayLabel {
    if (dayDelay == 0 && hourDelay == 0) return 'Immediately on Trigger';
    if (dayDelay == 0) return 'After $hourDelay hours';
    if (hourDelay == 0) return 'After $dayDelay days';
    return 'After $dayDelay days, $hourDelay hrs';
  }
}

class DripCampaign {
  final String id;
  String name;
  String triggerEvent;
  String description;
  bool isActive;
  int totalEnrolled;
  int completedCount;
  int activeCount;
  double conversionRate;
  List<DripStep> steps;
  DateTime dateCreated;

  DripCampaign({
    required this.id,
    required this.name,
    required this.triggerEvent,
    required this.description,
    this.isActive = true,
    this.totalEnrolled = 0,
    this.completedCount = 0,
    this.activeCount = 0,
    this.conversionRate = 0.0,
    required this.steps,
    required this.dateCreated,
  });
}

class DripMockData {
  static final List<DripCampaign> campaigns = [
    DripCampaign(
      id: 'DRIP-101',
      name: 'High-Net-Worth Inbound Lead Nurture Journey',
      triggerEvent: 'Lead Stage Changed -> "Qualified Prospect"',
      description: '4-step automated WhatsApp sequence introducing our architectural team, 3D Matterport tours, and complimentary consults.',
      isActive: true,
      totalEnrolled: 384,
      completedCount: 290,
      activeCount: 94,
      conversionRate: 34.2,
      dateCreated: DateTime.now().subtract(const Duration(days: 60)),
      steps: [
        const DripStep(
          id: 's1',
          stepIndex: 1,
          dayDelay: 0,
          hourDelay: 2,
          title: 'Welcome Brochure & Design Portfolio',
          templateName: 'intro_homio_brochure_v1',
          messagePreview: 'Namaste {{1}}! Welcome to Homio Luxury Living. Here is our curated 2026 Architectural Lookbook featuring 50+ award-winning villas.',
          actionCta: 'Download Lookbook PDF',
        ),
        const DripStep(
          id: 's2',
          stepIndex: 2,
          dayDelay: 2,
          title: '3D Matterport VR Tour Showcase',
          templateName: 'virtual_tour_showcase_v1',
          messagePreview: 'Hi {{1}}, experience our photo-realistic 3D digital twins before laying a single brick! Tap to walk through our DLF Camellias penthouse.',
          actionCta: 'Launch 3D VR Tour',
        ),
        const DripStep(
          id: 's3',
          stepIndex: 3,
          dayDelay: 5,
          title: 'Vastu Shastra Spatial Planning Guide',
          templateName: 'vastu_handbook_complimentary',
          messagePreview: 'Dear {{1}}, planning an East-facing entrance? Download our complimentary Vedic Spatial Alignment handbook authored by senior consultants.',
          actionCta: 'Read Vastu Guide',
        ),
        const DripStep(
          id: 's4',
          stepIndex: 4,
          dayDelay: 8,
          title: 'Complimentary On-Site Designer Consultation',
          templateName: 'book_free_architect_consult',
          messagePreview: 'Hi {{1}}, our Principal Interior Stylist is visiting properties in your neighborhood this Saturday. Would you like to book a complimentary 1-on-1 slot?',
          actionCta: 'Book Architect Visit',
        ),
      ],
    ),
    DripCampaign(
      id: 'DRIP-102',
      name: 'Quotation & BOQ Approval Fast-Track Followup',
      triggerEvent: 'Quotation Status -> "Sent to Client"',
      description: 'Automated nudge sequence sent after quotation dispatch to clarify questions and accelerate digital sign-off.',
      isActive: true,
      totalEnrolled: 142,
      completedCount: 110,
      activeCount: 32,
      conversionRate: 48.6,
      dateCreated: DateTime.now().subtract(const Duration(days: 40)),
      steps: [
        const DripStep(
          id: 's201',
          stepIndex: 1,
          dayDelay: 1,
          title: 'BOQ Breakdown & Hardware Specifications Decoded',
          templateName: 'boq_breakdown_helper',
          messagePreview: 'Hi {{1}}, we have outlined all premium specifications in your BOQ (IS:710 Marine Ply, Hafele soft-close hinges). Do you have questions on line items?',
          actionCta: 'Message Estimation Lead',
        ),
        const DripStep(
          id: 's202',
          stepIndex: 2,
          dayDelay: 4,
          title: '10-Year Turnkey Warranty & SLA Assurance',
          templateName: 'warranty_sla_assurance',
          messagePreview: 'Dear {{1}}, every Homio project is backed by our 10-Year Water & Termite Warranty with zero hidden escalation clauses.',
          actionCta: 'View Warranty Charter',
        ),
        const DripStep(
          id: 's203',
          stepIndex: 3,
          dayDelay: 7,
          title: 'Early Sign-Off 5% Modular Cabinetry Upgrade Voucher',
          templateName: 'fast_track_signing_voucher',
          messagePreview: 'Exclusive for {{1}}: Approve your BOQ by this Friday to unlock complimentary Blum tandembox drawer upgrades worth ₹45,000!',
          actionCta: 'Claim Upgrade & Approve',
        ),
      ],
    ),
    DripCampaign(
      id: 'DRIP-103',
      name: 'Post-Handover Delight & Referral Nurture',
      triggerEvent: 'Project Milestone -> "Final Handover Completed"',
      description: 'Retention and customer advocacy sequence for delighted homeowners.',
      isActive: false,
      totalEnrolled: 215,
      completedCount: 180,
      activeCount: 35,
      conversionRate: 22.4,
      dateCreated: DateTime.now().subtract(const Duration(days: 90)),
      steps: [
        const DripStep(
          id: 's301',
          stepIndex: 1,
          dayDelay: 30,
          title: '1-Month Living Experience Check-In',
          templateName: 'post_move_in_comfort',
          messagePreview: 'Dear {{1}}, we hope you are thoroughly enjoying your new home! Let us know if any doors or hinges need a quick alignment.',
          actionCta: 'Request Quick Tune-up',
        ),
        const DripStep(
          id: 's302',
          stepIndex: 2,
          dayDelay: 90,
          title: 'Homio VIP Referral Privilege Club',
          templateName: 'client_referral_reward',
          messagePreview: 'Know a friend receiving possession soon? Refer them to Homio and both of you receive ₹50,000 credit towards curated home decor.',
          actionCta: 'Refer a Friend',
        ),
      ],
    ),
  ];

  static void addCampaign(DripCampaign campaign) {
    campaigns.insert(0, campaign);
  }

  static void toggleStatus(String id, bool active) {
    final c = campaigns.firstWhere((item) => item.id == id, orElse: () => campaigns.first);
    c.isActive = active;
  }

  static void deleteCampaign(String id) {
    campaigns.removeWhere((c) => c.id == id);
  }
}
