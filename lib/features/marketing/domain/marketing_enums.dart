import 'package:flutter/material.dart';

/// Marketing Channel Categories
enum MarketingChannel {
  metaAds,
  googleAds,
  instagram,
  youtube,
  pinterest,
  website,
  referral,
  organic,
  whatsapp,
  direct,
  other,
}

extension MarketingChannelExt on MarketingChannel {
  String get label {
    switch (this) {
      case MarketingChannel.metaAds:
        return 'Meta Ads';
      case MarketingChannel.googleAds:
        return 'Google Ads';
      case MarketingChannel.instagram:
        return 'Instagram';
      case MarketingChannel.youtube:
        return 'YouTube';
      case MarketingChannel.pinterest:
        return 'Pinterest';
      case MarketingChannel.website:
        return 'Website';
      case MarketingChannel.referral:
        return 'Referral';
      case MarketingChannel.organic:
        return 'Organic Search';
      case MarketingChannel.whatsapp:
        return 'WhatsApp Ingestion';
      case MarketingChannel.direct:
        return 'Direct Walk-in';
      case MarketingChannel.other:
        return 'Other Channels';
    }
  }

  String get displayName => label;

  bool get isPaid => this == MarketingChannel.metaAds || this == MarketingChannel.googleAds;

  IconData get icon {
    switch (this) {
      case MarketingChannel.metaAds:
        return Icons.facebook_rounded;
      case MarketingChannel.googleAds:
        return Icons.search_rounded;
      case MarketingChannel.instagram:
        return Icons.camera_alt_rounded;
      case MarketingChannel.youtube:
        return Icons.smart_display_rounded;
      case MarketingChannel.pinterest:
        return Icons.push_pin_rounded;
      case MarketingChannel.website:
        return Icons.language_rounded;
      case MarketingChannel.referral:
        return Icons.people_outline_rounded;
      case MarketingChannel.organic:
        return Icons.eco_rounded;
      case MarketingChannel.whatsapp:
        return Icons.chat_bubble_outline_rounded;
      case MarketingChannel.direct:
        return Icons.storefront_rounded;
      case MarketingChannel.other:
        return Icons.category_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MarketingChannel.metaAds:
        return const Color(0xFF1877F2);
      case MarketingChannel.googleAds:
        return const Color(0xFFEA4335);
      case MarketingChannel.instagram:
        return const Color(0xFFE4405F);
      case MarketingChannel.youtube:
        return const Color(0xFFFF0000);
      case MarketingChannel.pinterest:
        return const Color(0xFFBD081C);
      case MarketingChannel.website:
        return const Color(0xFF0284C7);
      case MarketingChannel.referral:
        return const Color(0xFF8B5CF6);
      case MarketingChannel.organic:
        return const Color(0xFF10B981);
      case MarketingChannel.whatsapp:
        return const Color(0xFF25D366);
      case MarketingChannel.direct:
        return const Color(0xFFF59E0B);
      case MarketingChannel.other:
        return const Color(0xFF6B7280);
    }
  }
}

/// Ingestion Source Type
enum SourceType {
  organic,
  paid,
  referral,
  direct,
  website,
  social,
  marketplace,
  whatsapp,
  other,
}

extension SourceTypeExt on SourceType {
  String get label {
    switch (this) {
      case SourceType.organic:
        return 'Organic';
      case SourceType.paid:
        return 'Paid Media';
      case SourceType.referral:
        return 'Referral Partner';
      case SourceType.direct:
        return 'Direct / Offline';
      case SourceType.website:
        return 'Website Inbound';
      case SourceType.social:
        return 'Social Community';
      case SourceType.marketplace:
        return 'Marketplace Affiliate';
      case SourceType.whatsapp:
        return 'WhatsApp Bot';
      case SourceType.other:
        return 'Other Source';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case SourceType.organic:
        return Colors.green;
      case SourceType.paid:
        return Colors.blue;
      case SourceType.referral:
        return Colors.purple;
      case SourceType.direct:
        return Colors.orange;
      case SourceType.website:
        return Colors.cyan;
      case SourceType.social:
        return Colors.pink;
      case SourceType.marketplace:
        return Colors.indigo;
      case SourceType.whatsapp:
        return Colors.teal;
      case SourceType.other:
        return Colors.grey;
    }
  }
}

/// Campaign Objective
enum CampaignObjective {
  leadGeneration,
  brandAwareness,
  engagement,
  traffic,
  conversions,
  bookings,
  retargeting,
  reactivation,
}

extension CampaignObjectiveExt on CampaignObjective {
  String get label {
    switch (this) {
      case CampaignObjective.leadGeneration:
        return 'Lead Generation';
      case CampaignObjective.brandAwareness:
        return 'Brand Awareness';
      case CampaignObjective.engagement:
        return 'Social Engagement';
      case CampaignObjective.traffic:
        return 'Landing Page Traffic';
      case CampaignObjective.conversions:
        return 'Design Consultations';
      case CampaignObjective.bookings:
        return 'Token Bookings';
      case CampaignObjective.retargeting:
        return 'Warm Retargeting';
      case CampaignObjective.reactivation:
        return 'Cold Reactivation';
    }
  }

  String get displayName => label;
}

/// Campaign Lifecycle Status
enum CampaignStatus {
  draft,
  scheduled,
  active,
  paused,
  completed,
  archived,
}

extension CampaignStatusExt on CampaignStatus {
  String get label {
    switch (this) {
      case CampaignStatus.draft:
        return 'Draft';
      case CampaignStatus.scheduled:
        return 'Scheduled';
      case CampaignStatus.active:
        return 'Active';
      case CampaignStatus.paused:
        return 'Paused';
      case CampaignStatus.completed:
        return 'Completed';
      case CampaignStatus.archived:
        return 'Archived';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case CampaignStatus.draft:
        return Colors.grey;
      case CampaignStatus.scheduled:
        return Colors.amber;
      case CampaignStatus.active:
        return Colors.green;
      case CampaignStatus.paused:
        return Colors.orange;
      case CampaignStatus.completed:
        return Colors.blue;
      case CampaignStatus.archived:
        return Colors.blueGrey;
    }
  }

  IconData get icon {
    switch (this) {
      case CampaignStatus.draft:
        return Icons.edit_note_rounded;
      case CampaignStatus.scheduled:
        return Icons.schedule_rounded;
      case CampaignStatus.active:
        return Icons.play_arrow_rounded;
      case CampaignStatus.paused:
        return Icons.pause_rounded;
      case CampaignStatus.completed:
        return Icons.check_circle_rounded;
      case CampaignStatus.archived:
        return Icons.archive_rounded;
    }
  }
}

/// Social Channels explicitly tracked per PRD
enum SocialPlatform {
  all,
  instagram,
  youtube,
  pinterest,
}

extension SocialPlatformExt on SocialPlatform {
  String get label {
    switch (this) {
      case SocialPlatform.all:
        return 'All Platforms';
      case SocialPlatform.instagram:
        return 'Instagram';
      case SocialPlatform.youtube:
        return 'YouTube';
      case SocialPlatform.pinterest:
        return 'Pinterest';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case SocialPlatform.all:
        return const Color(0xFF4F46E5);
      case SocialPlatform.instagram:
        return const Color(0xFFE4405F);
      case SocialPlatform.youtube:
        return const Color(0xFFFF0000);
      case SocialPlatform.pinterest:
        return const Color(0xFFBD081C);
    }
  }

  IconData get icon {
    switch (this) {
      case SocialPlatform.all:
        return Icons.hub_rounded;
      case SocialPlatform.instagram:
        return Icons.camera_alt_rounded;
      case SocialPlatform.youtube:
        return Icons.smart_display_rounded;
      case SocialPlatform.pinterest:
        return Icons.push_pin_rounded;
    }
  }
}

/// Social Engagement Message Type
enum SocialMessageType {
  comment,
  dm,
  mention,
}

extension SocialMessageTypeExt on SocialMessageType {
  String get label {
    switch (this) {
      case SocialMessageType.comment:
        return 'Comment';
      case SocialMessageType.dm:
        return 'Direct Message (DM)';
      case SocialMessageType.mention:
        return 'Brand Mention';
    }
  }

  String get displayName => label;

  IconData get icon {
    switch (this) {
      case SocialMessageType.comment:
        return Icons.chat_bubble_outline_rounded;
      case SocialMessageType.dm:
        return Icons.send_rounded;
      case SocialMessageType.mention:
        return Icons.alternate_email_rounded;
    }
  }
}

/// Sentiment analysis classification
enum SocialSentiment {
  positive,
  neutral,
  negative,
  needsAttention,
}

extension SocialSentimentExt on SocialSentiment {
  String get label {
    switch (this) {
      case SocialSentiment.positive:
        return 'High Intent / Positive';
      case SocialSentiment.neutral:
        return 'Neutral Inquiry';
      case SocialSentiment.negative:
        return 'Dissatisfied / Negative';
      case SocialSentiment.needsAttention:
        return 'Critical / Escalated';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case SocialSentiment.positive:
        return Colors.green;
      case SocialSentiment.neutral:
        return Colors.blue;
      case SocialSentiment.negative:
        return Colors.orange;
      case SocialSentiment.needsAttention:
        return Colors.redAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case SocialSentiment.positive:
        return Icons.sentiment_satisfied_alt_rounded;
      case SocialSentiment.neutral:
        return Icons.sentiment_neutral_rounded;
      case SocialSentiment.negative:
        return Icons.sentiment_dissatisfied_rounded;
      case SocialSentiment.needsAttention:
        return Icons.warning_amber_rounded;
    }
  }
}

/// Social Response Mode (PRD Requirement)
enum ReplyMode {
  aiAutomated,
  manualAgent,
}

extension ReplyModeExt on ReplyMode {
  String get label {
    switch (this) {
      case ReplyMode.aiAutomated:
        return 'AI Automated Reply';
      case ReplyMode.manualAgent:
        return 'Manual Agent Reply';
    }
  }

  String get displayName => label;
}

/// PRD-defined Lost / Declining Reason Categories
enum DecliningReason {
  highRate,
  qualityConcerns,
  lackOfTrust,
  timelineMismatch,
  other,
}

extension DecliningReasonExt on DecliningReason {
  String get label {
    switch (this) {
      case DecliningReason.highRate:
        return 'High Rate / Budget Out of Range';
      case DecliningReason.qualityConcerns:
        return 'Quality Concerns / Material Doubts';
      case DecliningReason.lackOfTrust:
        return 'Lack of Brand Trust / Credentials';
      case DecliningReason.timelineMismatch:
        return 'Timeline Mismatch / Immediate Handover';
      case DecliningReason.other:
        return 'Location Not Serviceable / Dropped Enquiry';
    }
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case DecliningReason.highRate:
        return const Color(0xFFEF4444); // Red
      case DecliningReason.qualityConcerns:
        return const Color(0xFFF59E0B); // Amber
      case DecliningReason.lackOfTrust:
        return const Color(0xFF8B5CF6); // Purple
      case DecliningReason.timelineMismatch:
        return const Color(0xFF06B6D4); // Cyan
      case DecliningReason.other:
        return const Color(0xFF6B7280); // Grey
    }
  }

  IconData get icon {
    switch (this) {
      case DecliningReason.highRate:
        return Icons.money_off_rounded;
      case DecliningReason.qualityConcerns:
        return Icons.verified_user_outlined;
      case DecliningReason.lackOfTrust:
        return Icons.security_outlined;
      case DecliningReason.timelineMismatch:
        return Icons.schedule_outlined;
      case DecliningReason.other:
        return Icons.help_outline_rounded;
    }
  }
}

/// Report Types available in Marketing Reporting Center
enum ReportType {
  attribution,
  acquisition,
  campaign,
  channel,
  social,
  funnel,
  decliningReasons,
  roi,
}

extension ReportTypeExt on ReportType {
  String get label {
    switch (this) {
      case ReportType.attribution:
        return 'Attribution & Unit Economics';
      case ReportType.acquisition:
        return 'Acquisition & Lead Intake';
      case ReportType.campaign:
        return 'Campaign Spend & Conversion';
      case ReportType.channel:
        return 'Channel Performance & CAC';
      case ReportType.social:
        return 'Social Reach & Follower Growth';
      case ReportType.funnel:
        return 'Multi-Stage Conversion Funnel';
      case ReportType.decliningReasons:
        return 'Declining Reasons & Lost Analysis';
      case ReportType.roi:
        return 'Marketing Financial ROI';
    }
  }

  String get displayName => label;
}
