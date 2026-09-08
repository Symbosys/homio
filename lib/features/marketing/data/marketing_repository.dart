import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';
import '../../sales/data/sales_repository.dart';

/// Central Repository for HOMIO Marketing Module
class MarketingRepository {
  MarketingRepository._privateConstructor() {
    _seedData();
  }

  static final MarketingRepository instance = MarketingRepository._privateConstructor();
  factory MarketingRepository() => instance;

  final List<LeadSourceItem> _sources = [];
  final List<CampaignItem> _campaigns = [];
  final List<SocialPostItem> _socialPosts = [];
  final List<SocialMessageItem> _socialMessages = [];
  final List<MarketingAlert> _alerts = [];

  void _seedData() {
    // 1. Seed Lead Sources
    _sources.addAll([
      const LeadSourceItem(
        id: 'SRC-META-01',
        name: 'Meta Instant Lead Forms (Gurugram)',
        type: SourceType.paid,
        platform: MarketingChannel.metaAds,
        campaignsCount: 4,
        leadsGenerated: 480,
        qualifiedCount: 288,
        meetingsCount: 165,
        bookingsCount: 58,
        totalSpendLakhs: 2.15,
        revenueLakhs: 285.0,
        status: 'Active',
        lastSync: '10 mins ago (Live Webhook)',
        trackingCode: 'FB-LG-GUR-2026',
        utmParameters: {'utm_source': 'facebook', 'utm_medium': 'cpc', 'utm_campaign': 'luxury_turnkey_q3'},
        defaultFunnel: 'Residential Luxury Funnel',
        defaultAssignee: 'Ananya Verma',
      ),
      const LeadSourceItem(
        id: 'SRC-GOOG-01',
        name: 'Google Ads (Search & PMax)',
        type: SourceType.paid,
        platform: MarketingChannel.googleAds,
        campaignsCount: 3,
        leadsGenerated: 310,
        qualifiedCount: 195,
        meetingsCount: 120,
        bookingsCount: 42,
        totalSpendLakhs: 1.85,
        revenueLakhs: 210.0,
        status: 'Active',
        lastSync: '15 mins ago (Google Ads API)',
        trackingCode: 'G-ADS-PMAX-26',
        utmParameters: {'utm_source': 'google', 'utm_medium': 'search', 'utm_campaign': 'interior_design_near_me'},
        defaultFunnel: 'Modular & Turnkey Funnel',
        defaultAssignee: 'Rajesh Patel',
      ),
      const LeadSourceItem(
        id: 'SRC-IG-01',
        name: 'Instagram Link-in-Bio & DMs',
        type: SourceType.social,
        platform: MarketingChannel.instagram,
        campaignsCount: 2,
        leadsGenerated: 180,
        qualifiedCount: 92,
        meetingsCount: 54,
        bookingsCount: 18,
        totalSpendLakhs: 0.65,
        revenueLakhs: 92.5,
        status: 'Active',
        lastSync: 'Just now (Graph API)',
        trackingCode: 'IG-BIO-CONSULT',
        utmParameters: {'utm_source': 'instagram', 'utm_medium': 'bio', 'utm_campaign': 'penthouse_reel_series'},
        defaultFunnel: 'Highrise Interior Funnel',
        defaultAssignee: 'Priya Sharma',
      ),
      const LeadSourceItem(
        id: 'SRC-WEB-01',
        name: 'Homio.in Website Free Consultation',
        type: SourceType.website,
        platform: MarketingChannel.website,
        campaignsCount: 1,
        leadsGenerated: 120,
        qualifiedCount: 52,
        meetingsCount: 38,
        bookingsCount: 12,
        totalSpendLakhs: 0.15,
        revenueLakhs: 64.0,
        status: 'Active',
        lastSync: 'Continuous',
        trackingCode: 'WEB-HOME-HERO',
        utmParameters: {'utm_source': 'website', 'utm_medium': 'organic', 'utm_campaign': 'direct_portal'},
        defaultFunnel: 'Standard Interior Funnel',
        defaultAssignee: 'Vikram Malhotra',
      ),
      const LeadSourceItem(
        id: 'SRC-REF-01',
        name: 'Architect & Channel Partner Referrals',
        type: SourceType.referral,
        platform: MarketingChannel.referral,
        campaignsCount: 1,
        leadsGenerated: 98,
        qualifiedCount: 78,
        meetingsCount: 52,
        bookingsCount: 22,
        totalSpendLakhs: 0.44,
        revenueLakhs: 145.0,
        status: 'Active',
        lastSync: 'Manual Logging',
        trackingCode: 'PARTNER-ARCH-26',
        utmParameters: {'utm_source': 'architect_partner', 'utm_medium': 'referral', 'utm_campaign': 'q3_builder_tieup'},
        defaultFunnel: 'Luxury Villa / Kothi Funnel',
        defaultAssignee: 'Ananya Verma',
      ),
      const LeadSourceItem(
        id: 'SRC-YT-01',
        name: 'YouTube Home Tour Case Studies',
        type: SourceType.social,
        platform: MarketingChannel.youtube,
        campaignsCount: 1,
        leadsGenerated: 60,
        qualifiedCount: 35,
        meetingsCount: 21,
        bookingsCount: 8,
        totalSpendLakhs: 0.20,
        revenueLakhs: 48.0,
        status: 'Active',
        lastSync: '1 hour ago',
        trackingCode: 'YT-TOUR-DESCR',
        utmParameters: {'utm_source': 'youtube', 'utm_medium': 'video', 'utm_campaign': '4bhk_camellias_walkthrough'},
        defaultFunnel: 'Highrise Interior Funnel',
        defaultAssignee: 'Priya Sharma',
      ),
    ]);

    // 2. Seed Campaigns
    _campaigns.addAll([
      CampaignItem(
        id: 'CMP-201',
        name: 'DLF The Camellias & Magnolias Luxury Turnkey',
        code: 'HOM-META-CAM-01',
        description: 'Targeted hyper-local luxury interior campaign for Gurugram golf course road residents.',
        platform: MarketingChannel.metaAds,
        objective: CampaignObjective.leadGeneration,
        status: CampaignStatus.active,
        startDate: DateTime.now().subtract(const Duration(days: 24)),
        endDate: DateTime.now().add(const Duration(days: 36)),
        totalBudgetLakhs: 2.50,
        dailyBudgetLakhs: 0.12,
        spendLakhs: 1.65,
        impressions: 248000,
        clicks: 8640,
        leads: 360,
        qualified: 218,
        meetings: 135,
        bookings: 48,
        revenueLakhs: 240.0,
        owner: 'Ananya Verma',
        targetAudienceName: 'Ultra High Networth Golf Course Rd',
        targetLocation: 'DLF Phase 5, Golf Course Rd (Radius 5 km)',
        primaryHeadline: 'Bespoke Turnkey Interiors for Camellias & Magnolias',
        callToAction: 'Book 3D Site Survey',
        landingPageUrl: 'https://homio.in/landing/camellias-luxury',
        utmParams: const {'utm_source': 'facebook', 'utm_medium': 'feed_ad', 'utm_campaign': 'camellias_q3'},
      ),
      CampaignItem(
        id: 'CMP-202',
        name: 'German Modular Kitchens — Noida Sector 43/128',
        code: 'HOM-GOOG-KIT-02',
        description: 'High intent Google search campaign for Hafele & Blum fitted modular kitchens.',
        platform: MarketingChannel.googleAds,
        objective: CampaignObjective.conversions,
        status: CampaignStatus.active,
        startDate: DateTime.now().subtract(const Duration(days: 18)),
        endDate: DateTime.now().add(const Duration(days: 22)),
        totalBudgetLakhs: 1.50,
        dailyBudgetLakhs: 0.08,
        spendLakhs: 1.10,
        impressions: 112000,
        clicks: 4420,
        leads: 195,
        qualified: 132,
        meetings: 84,
        bookings: 32,
        revenueLakhs: 115.0,
        owner: 'Rajesh Patel',
        targetAudienceName: 'Noida Expressway Highrise Homeowners',
        targetLocation: 'Noida Sector 43, 128, 150',
        primaryHeadline: 'Factory Precision German Modular Kitchens in 30 Days',
        callToAction: 'Get Instant Estimate',
        landingPageUrl: 'https://homio.in/modular-kitchens',
        utmParams: const {'utm_source': 'google', 'utm_medium': 'cpc', 'utm_campaign': 'noida_kitchens'},
      ),
      CampaignItem(
        id: 'CMP-203',
        name: 'South Delhi Kothi / Duplex Architecture Makeovers',
        code: 'HOM-META-DEL-03',
        description: 'Heritage and contemporary kothi renovation services for Greater Kailash, Vasant Vihar & Jor Bagh.',
        platform: MarketingChannel.metaAds,
        objective: CampaignObjective.leadGeneration,
        status: CampaignStatus.active,
        startDate: DateTime.now().subtract(const Duration(days: 12)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        totalBudgetLakhs: 1.80,
        dailyBudgetLakhs: 0.10,
        spendLakhs: 0.85,
        impressions: 145000,
        clicks: 5200,
        leads: 140,
        qualified: 95,
        meetings: 60,
        bookings: 22,
        revenueLakhs: 160.0,
        owner: 'Vikram Malhotra',
        targetAudienceName: 'South Delhi Independent Villa Owners',
        targetLocation: 'South Delhi (Pincodes 110048, 110057, 110003)',
        primaryHeadline: 'Complete Architectural & Interior Transformation for Kothis',
        callToAction: 'Schedule Architect Consultation',
        landingPageUrl: 'https://homio.in/kothi-architecture',
        utmParams: const {'utm_source': 'instagram', 'utm_medium': 'stories', 'utm_campaign': 'south_delhi_villas'},
      ),
      CampaignItem(
        id: 'CMP-204',
        name: 'Pinterest Home Decor & Walk-in Wardrobe Moodboards',
        code: 'HOM-PINT-WAR-04',
        description: 'Visual pin collections showcasing acrylic walk-in closets and island vanities.',
        platform: MarketingChannel.pinterest,
        objective: CampaignObjective.brandAwareness,
        status: CampaignStatus.paused,
        startDate: DateTime.now().subtract(const Duration(days: 40)),
        endDate: DateTime.now().subtract(const Duration(days: 5)),
        totalBudgetLakhs: 0.60,
        dailyBudgetLakhs: 0.04,
        spendLakhs: 0.54,
        impressions: 98000,
        clicks: 3100,
        leads: 85,
        qualified: 38,
        meetings: 18,
        bookings: 6,
        revenueLakhs: 32.0,
        owner: 'Priya Sharma',
        targetAudienceName: 'Interior Design Enthusiasts',
        targetLocation: 'NCR & Pan India Luxury Metros',
        primaryHeadline: 'Dream Walk-in Wardrobes Designed & Installed',
        callToAction: 'Save Pin & Get Quote',
        landingPageUrl: 'https://homio.in/wardrobes',
        utmParams: const {'utm_source': 'pinterest', 'utm_medium': 'promoted_pin', 'utm_campaign': 'wardrobe_moods'},
      ),
    ]);

    // 3. Seed Social Posts
    _socialPosts.addAll([
      SocialPostItem(
        id: 'POST-IG-101',
        platform: SocialPlatform.instagram,
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
        title: 'DLF Camellias 4BHK Penthouse Before & After',
        caption: 'From bare concrete shell to warm modern luxury in 75 days. Italian marble flooring, concealed profile lighting, and custom fluted panelling.',
        mediaUrl: 'assets/images/camellias_tour.jpg',
        views: 142000,
        reach: 98000,
        likes: 12400,
        comments: 485,
        shares: 890,
        saves: 1650,
        engagementRate: 8.6,
        leadsGenerated: 42,
      ),
      SocialPostItem(
        id: 'POST-YT-102',
        platform: SocialPlatform.youtube,
        publishedDate: DateTime.now().subtract(const Duration(days: 6)),
        title: 'Complete 3500 Sq.Ft Kothi Interior Walkthrough & Exact Cost Breakdown',
        caption: 'Our Lead Architect Vikram takes you room-by-room through this South Delhi project, explaining material choices, BOQ costs, and acoustic ceiling treatments.',
        mediaUrl: 'assets/images/kothi_youtube.jpg',
        views: 285000,
        reach: 210000,
        likes: 18200,
        comments: 640,
        shares: 1420,
        saves: 3200,
        engagementRate: 7.2,
        leadsGenerated: 68,
      ),
      SocialPostItem(
        id: 'POST-PINT-103',
        platform: SocialPlatform.pinterest,
        publishedDate: DateTime.now().subtract(const Duration(days: 9)),
        title: 'Minimalist Japandi Master Bedroom with Slatted Headboard',
        caption: 'Neutral beige palette, acoustic oak slat walls, and floating walnut side tables designed for DLF Phase 5 apartment.',
        mediaUrl: 'assets/images/japandi_bedroom.jpg',
        views: 94000,
        reach: 72000,
        likes: 6400,
        comments: 112,
        shares: 410,
        saves: 4850,
        engagementRate: 6.8,
        leadsGenerated: 19,
      ),
    ]);

    // 4. Seed Social Messages (Inbox for AI & Manual replies)
    _socialMessages.addAll([
      SocialMessageItem(
        id: 'MSG-01',
        platform: SocialPlatform.instagram,
        userName: 'Vikram Sethi',
        userHandle: '@vikram.sethi.dlf',
        messageText: 'What is the starting cost per sq.ft for turnkey interiors including MEP and false ceiling for a 4BHK in Camellias?',
        postContextTitle: 'DLF Camellias 4BHK Penthouse Before & After',
        timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
        sentiment: SocialSentiment.positive,
        type: SocialMessageType.dm,
        isUnread: true,
        requiresReply: true,
        replyMode: ReplyMode.aiAutomated,
        status: 'Pending Approval',
        assignedAgent: 'Ananya Verma',
        aiSuggestedReply: 'Hi Vikram, for premium turnkey execution (including false ceiling, premium paint, bespoke millwork, and MEP), our packages typically range between ₹2,200 to ₹3,500/sq.ft depending on marble & veneer selections. Would you like our senior consultant to share a sample BOQ for Camellias?',
        replyHistory: const [],
      ),
      SocialMessageItem(
        id: 'MSG-02',
        platform: SocialPlatform.youtube,
        userName: 'Ayesha Kapoor',
        userHandle: '@ayeshak_design',
        messageText: 'Do you take up projects in Noida Sector 150? We are getting possession next month for our 3BHK highrise.',
        postContextTitle: 'Complete 3500 Sq.Ft Kothi Interior Walkthrough',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
        sentiment: SocialSentiment.positive,
        type: SocialMessageType.comment,
        isUnread: false,
        requiresReply: false,
        replyMode: ReplyMode.manualAgent,
        status: 'Replied',
        assignedAgent: 'Rajesh Patel',
        aiSuggestedReply: 'Yes Ayesha! Sector 150 is one of our primary active clusters. We have active sites in ATS & Eldeco. Let us know when you would like a complimentary laser survey scheduled.',
        replyHistory: const ['Replied via YouTube Agent on 08 Sept, 11:30 AM'],
      ),
      SocialMessageItem(
        id: 'MSG-03',
        platform: SocialPlatform.instagram,
        userName: 'Siddharth Rao',
        userHandle: '@siddharth_r',
        messageText: 'Your quotation was 20% higher than local contractors. Why should I choose Homio over freelance carpenters?',
        postContextTitle: 'Minimalist Japandi Master Bedroom',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        sentiment: SocialSentiment.negative,
        type: SocialMessageType.comment,
        isUnread: false,
        requiresReply: true,
        replyMode: ReplyMode.manualAgent,
        status: 'Needs Attention',
        assignedAgent: 'Vikram Malhotra',
        aiSuggestedReply: 'Hello Siddharth, unlike freelance teams, Homio guarantees factory machine-pressed edge banding with 0% bubbling, 10-year warranty, dedicated site supervisors, and penalty clauses for handover delays. Happy to show you our live quality at our MG Road Experience Center.',
        replyHistory: const [],
      ),
    ]);

    // 5. Seed Marketing Alerts
    _alerts.addAll([
      MarketingAlert(
        id: 'ALT-01',
        title: 'Meta Ads Webhook Live & Syncing',
        description: 'Instant lead forms syncing in < 4 seconds. 18 new leads ingested today.',
        severity: 'Info',
        actionText: 'View Ingestion Feed',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      MarketingAlert(
        id: 'ALT-02',
        title: 'CPL Under Target on Google PMax (₹380 vs ₹450 Target)',
        description: 'Noida Modular Kitchens campaign performing 15.5% above efficiency target.',
        severity: 'Success',
        actionText: 'Scale Budget +20%',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      MarketingAlert(
        id: 'ALT-03',
        title: 'Pinterest Promoted Pin Budget Exhaustion Alert',
        description: 'Wardrobe Moodboards reached 95% of allocated monthly budget.',
        severity: 'Warning',
        actionText: 'Review Budget',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ]);
  }

  // ===========================================================================
  // 1. MARKETING OVERVIEW & EXECUTIVE METRICS
  // ===========================================================================

  MarketingKpiSummary getKpiSummary({
    String? dateRange,
    MarketingChannel? channel,
  }) {
    // Connect with Sales CRM leads count dynamically
    final crmLeads = SalesRepository.instance.leads;
    final totalLeads = 1248 + crmLeads.length;
    final qualified = 680 + (crmLeads.where((l) => l.isQualified).length);
    const meetingsScheduled = 410;
    const meetingsDone = 315;
    const waitingForPayment = 170;
    const bookings = 142;
    const notInterested = 128;
    const adSpendLakhs = 5.24;
    const revenueLakhs = 685.0;

    return MarketingKpiSummary(
      totalLeads: totalLeads,
      leadsGrowthPercent: 18.4,
      qualifiedLeads: qualified,
      meetingsScheduled: meetingsScheduled,
      meetingsDone: meetingsDone,
      waitingForPayment: waitingForPayment,
      bookings: bookings,
      notInterested: notInterested,
      adSpendLakhs: adSpendLakhs,
      additionalMarketingCostLakhs: 0.85,
      revenueGeneratedLakhs: revenueLakhs,
      dateRangeLabel: dateRange ?? 'This Month',
    );
  }

  List<AcquisitionFunnelStage> getAcquisitionFunnel() {
    return const [
      AcquisitionFunnelStage(
        id: 'stg_new',
        label: 'Total New Leads',
        count: 1248,
        dropoffPercent: 0.0,
        dropoffReason: 'Initial Ingestion',
        crmStageRoute: '/sales/leads?stage=newEnquiry',
      ),
      AcquisitionFunnelStage(
        id: 'stg_qual',
        label: 'Qualified Leads',
        count: 680,
        dropoffPercent: 45.5,
        dropoffReason: 'Location out of coverage / Budget < ₹20L',
        crmStageRoute: '/sales/leads?stage=qualified',
      ),
      AcquisitionFunnelStage(
        id: 'stg_mtg_sched',
        label: 'Meetings Scheduled',
        count: 410,
        dropoffPercent: 39.7,
        dropoffReason: 'Site visit postponed or rescheduled',
        crmStageRoute: '/sales/calendar',
      ),
      AcquisitionFunnelStage(
        id: 'stg_mtg_done',
        label: 'Meeting Done',
        count: 315,
        dropoffPercent: 23.1,
        dropoffReason: 'Design consultation completed at Experience Center',
        crmStageRoute: '/sales/calendar?status=completed',
      ),
      AcquisitionFunnelStage(
        id: 'stg_pay_wait',
        label: 'Waiting for Payment',
        count: 170,
        dropoffPercent: 46.0,
        dropoffReason: 'BOQ under family review / Token pending',
        crmStageRoute: '/sales/leads?stage=bookedClient',
      ),
    ];
  }

  OrganicVsPaidBreakdown getOrganicVsPaid() {
    return const OrganicVsPaidBreakdown(
      organicPercent: 42.0,
      paidPercent: 58.0,
      organicLeads: 524,
      paidLeads: 724,
      organicQualified: 320,
      paidQualified: 360,
      organicMeetings: 195,
      paidMeetings: 215,
      organicBookings: 68,
      paidBookings: 74,
      organicRevenueLakhs: 320.0,
      paidRevenueLakhs: 365.0,
    );
  }

  List<ChannelPerformanceItem> getChannelPerformance() {
    return const [
      ChannelPerformanceItem(
        channel: MarketingChannel.metaAds,
        activeCampaigns: 4,
        leads: 480,
        qualified: 288,
        meetings: 165,
        bookings: 58,
        spendLakhs: 2.15,
        revenueLakhs: 285.0,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.googleAds,
        activeCampaigns: 3,
        leads: 310,
        qualified: 195,
        meetings: 120,
        bookings: 42,
        spendLakhs: 1.85,
        revenueLakhs: 210.0,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.instagram,
        activeCampaigns: 2,
        leads: 180,
        qualified: 92,
        meetings: 54,
        bookings: 18,
        spendLakhs: 0.65,
        revenueLakhs: 92.5,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.website,
        activeCampaigns: 1,
        leads: 120,
        qualified: 52,
        meetings: 38,
        bookings: 12,
        spendLakhs: 0.15,
        revenueLakhs: 64.0,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.referral,
        activeCampaigns: 1,
        leads: 98,
        qualified: 78,
        meetings: 52,
        bookings: 22,
        spendLakhs: 0.44,
        revenueLakhs: 145.0,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.organic,
        activeCampaigns: 0,
        leads: 60,
        qualified: 35,
        meetings: 21,
        bookings: 8,
        spendLakhs: 0.0,
        revenueLakhs: 48.0,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.whatsapp,
        activeCampaigns: 1,
        leads: 45,
        qualified: 28,
        meetings: 16,
        bookings: 6,
        spendLakhs: 0.08,
        revenueLakhs: 36.0,
      ),
      ChannelPerformanceItem(
        channel: MarketingChannel.direct,
        activeCampaigns: 0,
        leads: 25,
        qualified: 18,
        meetings: 14,
        bookings: 6,
        spendLakhs: 0.0,
        revenueLakhs: 32.0,
      ),
    ];
  }

  // ===========================================================================
  // 2. LEAD SOURCES MANAGEMENT
  // ===========================================================================

  List<LeadSourceItem> getLeadSources({
    String? query,
    SourceType? type,
    String? status,
  }) {
    var results = List<LeadSourceItem>.from(_sources);

    if (type != null) {
      results = results.where((s) => s.type == type).toList();
    }
    if (status != null && status.isNotEmpty && status != 'All') {
      results = results.where((s) => s.status.toLowerCase() == status.toLowerCase()).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((s) =>
          s.name.toLowerCase().contains(q) ||
          s.trackingCode.toLowerCase().contains(q) ||
          s.platform.displayName.toLowerCase().contains(q)).toList();
    }

    return results;
  }

  void addLeadSource(LeadSourceItem source) {
    _sources.insert(0, source);
  }

  // ===========================================================================
  // 3. CAMPAIGN MANAGEMENT
  // ===========================================================================

  List<CampaignItem> getCampaigns({
    String? query,
    MarketingChannel? platform,
    CampaignStatus? status,
    CampaignObjective? objective,
  }) {
    var results = List<CampaignItem>.from(_campaigns);

    if (platform != null) {
      results = results.where((c) => c.platform == platform).toList();
    }
    if (status != null) {
      results = results.where((c) => c.status == status).toList();
    }
    if (objective != null) {
      results = results.where((c) => c.objective == objective).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((c) =>
          c.name.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.owner.toLowerCase().contains(q)).toList();
    }

    return results;
  }

  void addCampaign(CampaignItem campaign) {
    _campaigns.insert(0, campaign);
  }

  void updateCampaignBudget(String id, double budget) {
    final idx = _campaigns.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _campaigns[idx] = _campaigns[idx].copyWith(budget: budget);
    }
  }

  void updateCampaignStatus(String id, CampaignStatus newStatus) {
    final idx = _campaigns.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _campaigns[idx] = _campaigns[idx].copyWith(status: newStatus);
    }
  }

  // ===========================================================================
  // 4. SOCIAL MEDIA ANALYTICS & ENGAGEMENT INBOX
  // ===========================================================================

  List<SocialPlatformMetric> getSocialMetrics() {
    return const [
      SocialPlatformMetric(
        platform: SocialPlatform.instagram,
        followersCount: 184200,
        viewsCount: 1420000,
        reachCount: 1180000,
        postsCount: 342,
        likesCount: 142800,
        commentsCount: 6420,
        sharesCount: 8940,
        savesCount: 22400,
        engagementRate: 8.6,
        growthTrend: [142.0, 150.5, 161.2, 170.8, 178.4, 184.2],
      ),
      SocialPlatformMetric(
        platform: SocialPlatform.youtube,
        followersCount: 92500,
        viewsCount: 2150000,
        reachCount: 1840000,
        postsCount: 118,
        likesCount: 64200,
        commentsCount: 3840,
        sharesCount: 5200,
        savesCount: 14200,
        engagementRate: 6.4,
        growthTrend: [78.0, 81.2, 84.5, 87.1, 89.8, 92.5],
      ),
      SocialPlatformMetric(
        platform: SocialPlatform.pinterest,
        followersCount: 48300,
        viewsCount: 850000,
        reachCount: 720000,
        postsCount: 620,
        likesCount: 21400,
        commentsCount: 890,
        sharesCount: 1980,
        savesCount: 34500,
        engagementRate: 5.8,
        growthTrend: [38.5, 40.2, 42.1, 44.8, 46.5, 48.3],
      ),
    ];
  }

  List<SocialPostItem> getTopSocialPosts({SocialPlatform? platform}) {
    var results = List<SocialPostItem>.from(_socialPosts);
    if (platform != null && platform != SocialPlatform.all) {
      results = results.where((p) => p.platform == platform).toList();
    }
    return results;
  }

  List<SocialMessageItem> getSocialMessages({
    String tab = 'All',
    String? query,
  }) {
    var results = List<SocialMessageItem>.from(_socialMessages);

    if (tab == 'Comments') {
      results = results.where((m) => m.type == SocialMessageType.comment).toList();
    } else if (tab == 'DMs') {
      results = results.where((m) => m.type == SocialMessageType.dm).toList();
    } else if (tab == 'Unread') {
      results = results.where((m) => m.isUnread).toList();
    } else if (tab == 'Requires Reply') {
      results = results.where((m) => m.requiresReply).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((m) =>
          m.userName.toLowerCase().contains(q) ||
          m.messageText.toLowerCase().contains(q) ||
          m.userHandle.toLowerCase().contains(q)).toList();
    }

    return results;
  }

  void markMessageReplied(String id) {
    final idx = _socialMessages.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _socialMessages[idx] = _socialMessages[idx].copyWith(
        status: 'Replied',
        isUnread: false,
        requiresReply: false,
      );
    }
  }

  void convertMessageToLead(String id) {
    final idx = _socialMessages.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _socialMessages[idx] = _socialMessages[idx].copyWith(
        status: 'ConvertedToLead',
        isUnread: false,
        requiresReply: false,
      );
    }
  }

  // ===========================================================================
  // 5. MARKETING REPORTS & DECLINING REASONS
  // ===========================================================================

  List<DecliningReasonMetric> getDecliningReasons() {
    return const [
      DecliningReasonMetric(
        reason: DecliningReason.highRate,
        count: 184,
        percentage: 42.5,
        primarySource: 'Meta Ads (Gurugram)',
        correctiveAction: 'Introduce mid-tier modular packages with PVC foil & engineered wood options.',
      ),
      DecliningReasonMetric(
        reason: DecliningReason.qualityConcerns,
        count: 104,
        percentage: 24.0,
        primarySource: 'Google Ads Search',
        correctiveAction: 'Promote 10-year warranty certificate & factory ISO certification video on landing page.',
      ),
      DecliningReasonMetric(
        reason: DecliningReason.lackOfTrust,
        count: 78,
        percentage: 18.0,
        primarySource: 'Instagram Ads',
        correctiveAction: 'Feature client video testimonials & verified Google 4.9-star review badge.',
      ),
      DecliningReasonMetric(
        reason: DecliningReason.timelineMismatch,
        count: 67,
        percentage: 15.5,
        primarySource: 'Website Direct',
        correctiveAction: 'Create express 45-day handover track for ready-to-move apartment handovers.',
      ),
    ];
  }

  List<MarketingAlert> getMarketingAlerts() {
    return List<MarketingAlert>.from(_alerts);
  }
}
