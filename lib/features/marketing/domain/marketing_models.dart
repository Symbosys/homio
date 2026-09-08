import 'marketing_enums.dart';

/// Top-Level Executive Marketing KPIs
class MarketingKpiSummary {
  final int totalLeads;
  final double leadsGrowthPercent;
  final int qualifiedLeads;
  final int meetingsScheduled;
  final int meetingsDone;
  final int waitingForPayment;
  final int bookings;
  final int notInterested;
  final double adSpendLakhs;
  final double additionalMarketingCostLakhs;
  final double revenueGeneratedLakhs;
  final String dateRangeLabel;

  const MarketingKpiSummary({
    required this.totalLeads,
    this.leadsGrowthPercent = 12.0,
    this.qualifiedLeads = 0,
    this.meetingsScheduled = 0,
    this.meetingsDone = 0,
    this.waitingForPayment = 0,
    int? bookings,
    int? totalConversions,
    this.notInterested = 0,
    double? adSpendLakhs,
    double? totalSpend,
    this.additionalMarketingCostLakhs = 0.0,
    double? revenueGeneratedLakhs,
    double? attributedRevenue,
    this.dateRangeLabel = 'This Month',
  })  : bookings = bookings ?? totalConversions ?? 0,
        adSpendLakhs = adSpendLakhs ?? (totalSpend != null ? totalSpend / 100000.0 : 0.0),
        revenueGeneratedLakhs = revenueGeneratedLakhs ?? (attributedRevenue != null ? attributedRevenue / 100000.0 : 0.0);

  /// PRD Explicit Formula: CPL = Total Ad Spend / Total Leads
  double get cpl => totalLeads > 0 ? (adSpendLakhs * 100000.0) / totalLeads : 0.0;

  /// PRD Explicit Formula: CAC (Cost per conversion / booking) = Total Ad Spend / Bookings
  double get costPerConversion => bookings > 0 ? (adSpendLakhs * 100000.0) / bookings : 0.0;
  double get cac => costPerConversion;

  /// Total Investment (Ad Spend + Marketing Execution Overhead)
  double get totalInvestmentLakhs => adSpendLakhs + additionalMarketingCostLakhs;

  /// Marketing ROI %: ((Revenue - Total Spend) / Total Spend) * 100
  double get roiPercent {
    if (totalInvestmentLakhs <= 0 || revenueGeneratedLakhs <= 0) return 0.0;
    return ((revenueGeneratedLakhs - totalInvestmentLakhs) / totalInvestmentLakhs) * 100.0;
  }

  /// Qualification Rate %
  double get qualificationRate => totalLeads > 0 ? (qualifiedLeads / totalLeads) * 100.0 : 0.0;

  /// Overall Booking Conversion Rate %
  double get conversionRate => totalLeads > 0 ? (bookings / totalLeads) * 100.0 : 0.0;

  int get totalConversions => bookings;
  double get totalSpend => adSpendLakhs * 100000.0;
  String get spendFormatted => '₹${adSpendLakhs.toStringAsFixed(2)} Lakhs';
  String get revenueFormatted => '₹${revenueGeneratedLakhs.toStringAsFixed(2)} Lakhs';
  String get cplFormatted => '₹${cpl.toStringAsFixed(0)}';
  String get cacFormatted => '₹${costPerConversion.toStringAsFixed(0)}';
  double get leadsTrend => leadsGrowthPercent;
  double get spendTrend => 8.4;
  double get cplTrend => -5.2;
  double get conversionsTrend => 14.1;
}

/// Acquisition Funnel Stage Item
class AcquisitionFunnelStage {
  final String id;
  final String label;
  final int count;
  final double dropoffPercent;
  final String dropoffReason;
  final String crmStageRoute;

  const AcquisitionFunnelStage({
    required this.id,
    required this.label,
    required this.count,
    required this.dropoffPercent,
    required this.dropoffReason,
    required this.crmStageRoute,
  });

  String get stageName => label;
  double get conversionRateFromPrevious => (100.0 - dropoffPercent).clamp(0.0, 100.0);
  double get dropOffPercent => dropoffPercent;
}

/// Organic vs Paid Comparison Model
class OrganicVsPaidBreakdown {
  final double organicPercent;
  final double paidPercent;
  final int organicLeads;
  final int paidLeads;
  final int organicQualified;
  final int paidQualified;
  final int organicMeetings;
  final int paidMeetings;
  final int organicBookings;
  final int paidBookings;
  final double organicRevenueLakhs;
  final double paidRevenueLakhs;

  const OrganicVsPaidBreakdown({
    required this.organicPercent,
    required this.paidPercent,
    required this.organicLeads,
    required this.paidLeads,
    required this.organicQualified,
    required this.paidQualified,
    required this.organicMeetings,
    required this.paidMeetings,
    required this.organicBookings,
    required this.paidBookings,
    required this.organicRevenueLakhs,
    required this.paidRevenueLakhs,
  });

  double get organicShare => organicPercent;
  double get paidShare => paidPercent;
  int get organicConversions => organicBookings;
  int get paidConversions => paidBookings;
  double get paidSpend => 524000.0;
  double get paidCpl => paidLeads > 0 ? paidSpend / paidLeads : 0.0;
  double get paidCac => paidBookings > 0 ? paidSpend / paidBookings : 0.0;
}

/// Channel Performance Entry
class ChannelPerformanceItem {
  final MarketingChannel channel;
  final int activeCampaigns;
  final int leads;
  final int qualified;
  final int meetings;
  final int bookings;
  final double spendLakhs;
  final double revenueLakhs;

  const ChannelPerformanceItem({
    required this.channel,
    this.activeCampaigns = 0,
    int? leads,
    int? leadsGenerated,
    this.qualified = 0,
    this.meetings = 0,
    int? bookings,
    int? conversions,
    double? spendLakhs,
    double? spend,
    double? revenueLakhs,
    double? revenue,
  })  : leads = leads ?? leadsGenerated ?? 0,
        bookings = bookings ?? conversions ?? 0,
        spendLakhs = spendLakhs ?? (spend != null ? spend / 100000.0 : 0.0),
        revenueLakhs = revenueLakhs ?? (revenue != null ? revenue / 100000.0 : 0.0);

  int get leadsGenerated => leads;
  int get conversions => bookings;
  double get spend => spendLakhs * 100000.0;
  double get revenue => revenueLakhs * 100000.0;
  double get cpl => leads > 0 ? spend / leads : 0.0;
  double get cac => bookings > 0 ? spend / bookings : 0.0;
  double get conversionRate => leads > 0 ? (bookings / leads) * 100.0 : 0.0;
  double get roi => spend > 0 ? ((revenue - spend) / spend) * 100.0 : 0.0;
  double get roiPercent => roi;
  String get spendFormatted => '₹${spendLakhs.toStringAsFixed(2)}L';
  String get revenueFormatted => '₹${revenueLakhs.toStringAsFixed(2)}L';
  String get cplFormatted => '₹${cpl.toStringAsFixed(0)}';
  String get cacFormatted => '₹${cac.toStringAsFixed(0)}';
}

/// Marketing Lead Ingestion Source
class LeadSourceItem {
  final String id;
  final String name;
  final SourceType type;
  final MarketingChannel platform;
  final int campaignsCount;
  final int leadsGenerated;
  final int qualifiedCount;
  final int meetingsCount;
  final int bookingsCount;
  final double totalSpendLakhs;
  final double revenueLakhs;
  final String status;
  final String lastSync;
  final String trackingCode;
  final Map<String, String> utmParameters;
  final String defaultFunnel;
  final String defaultAssignee;

  const LeadSourceItem({
    required this.id,
    required this.name,
    required this.type,
    MarketingChannel? platform,
    MarketingChannel? channel,
    this.campaignsCount = 0,
    this.leadsGenerated = 0,
    this.qualifiedCount = 0,
    this.meetingsCount = 0,
    int? bookingsCount,
    int? conversions,
    double? totalSpendLakhs,
    double? cost,
    this.revenueLakhs = 0.0,
    required this.status,
    String? lastSync,
    DateTime? lastSynced,
    this.trackingCode = '',
    this.utmParameters = const {},
    this.defaultFunnel = 'General Funnel',
    this.defaultAssignee = 'Unassigned',
    String? syncHealth,
  })  : platform = platform ?? channel ?? MarketingChannel.metaAds,
        bookingsCount = bookingsCount ?? conversions ?? 0,
        totalSpendLakhs = totalSpendLakhs ?? (cost != null ? cost / 100000.0 : 0.0),
        lastSync = lastSync ?? 'Just now';

  MarketingChannel get channel => platform;
  double get cost => totalSpendLakhs * 100000.0;
  int get conversions => bookingsCount;
  String get syncHealth => 'Healthy';
  DateTime get lastSynced => DateTime.now().subtract(const Duration(minutes: 5));
  double get cpl => leadsGenerated > 0 ? cost / leadsGenerated : 0.0;
  double get cac => bookingsCount > 0 ? cost / bookingsCount : 0.0;
  double get conversionRate => leadsGenerated > 0 ? (bookingsCount / leadsGenerated) * 100.0 : 0.0;

  LeadSourceItem copyWith({
    String? status,
    DateTime? lastSynced,
    String? syncHealth,
  }) {
    return LeadSourceItem(
      id: id,
      name: name,
      type: type,
      platform: platform,
      campaignsCount: campaignsCount,
      leadsGenerated: leadsGenerated,
      qualifiedCount: qualifiedCount,
      meetingsCount: meetingsCount,
      bookingsCount: bookingsCount,
      totalSpendLakhs: totalSpendLakhs,
      revenueLakhs: revenueLakhs,
      status: status ?? this.status,
      lastSync: lastSync,
      trackingCode: trackingCode,
      utmParameters: utmParameters,
      defaultFunnel: defaultFunnel,
      defaultAssignee: defaultAssignee,
    );
  }
}

/// Marketing Ad Campaign
class CampaignItem {
  final String id;
  final String name;
  final String code;
  final String description;
  final MarketingChannel platform;
  final CampaignObjective objective;
  final CampaignStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudgetLakhs;
  final double dailyBudgetLakhs;
  final double spendLakhs;
  final int impressions;
  final int clicks;
  final int leads;
  final int qualified;
  final int meetings;
  final int bookings;
  final double revenueLakhs;
  final String owner;
  final String targetAudienceName;
  final String targetLocation;
  final String primaryHeadline;
  final String callToAction;
  final String landingPageUrl;
  final Map<String, String> utmParams;

  const CampaignItem({
    required this.id,
    required this.name,
    this.code = '',
    this.description = '',
    MarketingChannel? platform,
    MarketingChannel? channel,
    required this.objective,
    required this.status,
    required this.startDate,
    required this.endDate,
    double? totalBudgetLakhs,
    double? budget,
    double? dailyBudgetLakhs,
    double? spendLakhs,
    double? spent,
    this.impressions = 0,
    this.clicks = 0,
    int? leads,
    int? leadsGenerated,
    this.qualified = 0,
    this.meetings = 0,
    int? bookings,
    int? conversions,
    this.revenueLakhs = 0.0,
    this.owner = 'Admin',
    this.targetAudienceName = 'Luxury Buyers',
    this.targetLocation = 'Mumbai, Pune',
    this.primaryHeadline = '',
    this.callToAction = 'Get Free Quote',
    this.landingPageUrl = 'https://homio.in',
    this.utmParams = const {},
  })  : platform = platform ?? channel ?? MarketingChannel.metaAds,
        totalBudgetLakhs = totalBudgetLakhs ?? (budget != null ? budget / 100000.0 : 0.0),
        dailyBudgetLakhs = dailyBudgetLakhs ?? 0.05,
        spendLakhs = spendLakhs ?? (spent != null ? spent / 100000.0 : 0.0),
        leads = leads ?? leadsGenerated ?? 0,
        bookings = bookings ?? conversions ?? 0;

  MarketingChannel get channel => platform;
  double get budget => totalBudgetLakhs * 100000.0;
  double get spent => spendLakhs * 100000.0;
  int get leadsGenerated => leads;
  int get conversions => bookings;
  double get ctr => impressions > 0 ? (clicks / impressions) * 100.0 : 0.0;
  double get cpl => leads > 0 ? spent / leads : 0.0;
  double get cac => bookings > 0 ? spent / bookings : 0.0;
  double get roi => spent > 0 ? ((revenueLakhs * 100000 - spent) / spent) * 100.0 : 0.0;
  String get spentFormatted => '₹${spendLakhs.toStringAsFixed(2)}L';
  String get budgetFormatted => '₹${totalBudgetLakhs.toStringAsFixed(2)}L';
  String get cplFormatted => '₹${cpl.toStringAsFixed(0)}';
  String get cacFormatted => '₹${cac.toStringAsFixed(0)}';
  String get cpcFormatted => '₹${(clicks > 0 ? spent / clicks : 0).toStringAsFixed(1)}';
  double get conversionRate => leads > 0 ? (bookings / leads) * 100.0 : 0.0;

  CampaignItem copyWith({
    CampaignStatus? status,
    double? totalBudgetLakhs,
    double? budget,
  }) {
    return CampaignItem(
      id: id,
      name: name,
      code: code,
      description: description,
      platform: platform,
      objective: objective,
      status: status ?? this.status,
      startDate: startDate,
      endDate: endDate,
      totalBudgetLakhs: budget != null ? (budget / 100000.0) : (totalBudgetLakhs ?? this.totalBudgetLakhs),
      dailyBudgetLakhs: dailyBudgetLakhs,
      spendLakhs: spendLakhs,
      impressions: impressions,
      clicks: clicks,
      leads: leads,
      qualified: qualified,
      meetings: meetings,
      bookings: bookings,
      revenueLakhs: revenueLakhs,
      owner: owner,
      targetAudienceName: targetAudienceName,
      targetLocation: targetLocation,
      primaryHeadline: primaryHeadline,
      callToAction: callToAction,
      landingPageUrl: landingPageUrl,
      utmParams: utmParams,
    );
  }
}

/// Platform-Specific Social Media Metrics (Instagram, YouTube, Pinterest)
class SocialPlatformMetric {
  final SocialPlatform platform;
  final int followersCount;
  final int viewsCount;
  final int reachCount;
  final int postsCount;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int savesCount;
  final double engagementRate;
  final List<double> growthTrend;

  const SocialPlatformMetric({
    required this.platform,
    required this.followersCount,
    required this.viewsCount,
    required this.reachCount,
    required this.postsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.savesCount,
    required this.engagementRate,
    required this.growthTrend,
  });

  int get followers => followersCount;
  int get reach => reachCount;
  int get views => viewsCount;
  int get leadsGenerated => (followersCount * 0.008).round();
  double get postFrequency => postsCount / 4.0;
}

/// Social Post Content Performance Entry
class SocialPostItem {
  final String id;
  final SocialPlatform platform;
  final DateTime publishedDate;
  final String title;
  final String caption;
  final String mediaUrl;
  final int views;
  final int reach;
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final double engagementRate;
  final int leadsGenerated;

  const SocialPostItem({
    required this.id,
    required this.platform,
    required this.publishedDate,
    required this.title,
    required this.caption,
    required this.mediaUrl,
    required this.views,
    required this.reach,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.saves,
    required this.engagementRate,
    required this.leadsGenerated,
  });

  String get contentType => 'video';
}

/// Social Engagement Message (Comment / DM) with AI Reply Workflow
class SocialMessageItem {
  final String id;
  final SocialPlatform platform;
  final String userName;
  final String userHandle;
  final String messageText;
  final String postContextTitle;
  final DateTime timestamp;
  final SocialSentiment sentiment;
  final SocialMessageType type;
  final bool isUnread;
  final bool requiresReply;
  final ReplyMode replyMode;
  final String status;
  final String assignedAgent;
  final String aiSuggestedReply;
  final List<String> replyHistory;

  const SocialMessageItem({
    required this.id,
    required this.platform,
    required this.userName,
    required this.userHandle,
    required this.messageText,
    required this.postContextTitle,
    required this.timestamp,
    required this.sentiment,
    required this.type,
    required this.isUnread,
    required this.requiresReply,
    required this.replyMode,
    required this.status,
    required this.assignedAgent,
    required this.aiSuggestedReply,
    required this.replyHistory,
  });

  String get authorName => userName;
  String get authorHandle => userHandle;
  String get postTitle => postContextTitle;
  String? get aiDraftReply => aiSuggestedReply.isEmpty ? null : aiSuggestedReply;
  bool get isReplied => status == 'Replied';
  bool get convertedToLead => status == 'ConvertedToLead';

  SocialMessageItem copyWith({
    String? status,
    bool? isUnread,
    bool? requiresReply,
    List<String>? replyHistory,
  }) {
    return SocialMessageItem(
      id: id,
      platform: platform,
      userName: userName,
      userHandle: userHandle,
      messageText: messageText,
      postContextTitle: postContextTitle,
      timestamp: timestamp,
      sentiment: sentiment,
      type: type,
      isUnread: isUnread ?? this.isUnread,
      requiresReply: requiresReply ?? this.requiresReply,
      replyMode: replyMode,
      status: status ?? this.status,
      assignedAgent: assignedAgent,
      aiSuggestedReply: aiSuggestedReply,
      replyHistory: replyHistory ?? this.replyHistory,
    );
  }
}

/// Declining Reason Analytics Breakdown (PRD Section 6.2)
class DecliningReasonMetric {
  final DecliningReason reason;
  final int count;
  final double percentage;
  final String primarySource;
  final String correctiveAction;

  const DecliningReasonMetric({
    required this.reason,
    required this.count,
    required this.percentage,
    required this.primarySource,
    required this.correctiveAction,
  });

  String get suggestedAction => correctiveAction;
}

/// Actionable Marketing Alert Item
class MarketingAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // High, Warning, Info
  final String actionText;
  final DateTime timestamp;

  const MarketingAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.actionText,
    required this.timestamp,
  });

  String get message => '$title: $description';
  String? get actionLabel => actionText.isEmpty ? null : actionText;
}
