import 'package:flutter/material.dart';

/// Platform-wide constants, copy definitions, and capability metadata.
abstract class AppConstants {
  static const String appName = 'Homio';
  static const String appTagline = 'Intelligent Workspace & CRM';
  static const String appSubtitle =
      'The unified operating system for high-growth businesses. Connect leads, sales pipelines, site execution, team hierarchy, WhatsApp automation, finance, and AI intelligence.';

  // Demo credentials for evaluator convenience
  static const String demoEmail = 'alex@homioworkspace.com';
  static const String demoPassword = 'Password123!';

  // Value proposition pillars
  static const List<Map<String, dynamic>> valuePillars = [
    {
      'icon': Icons.hub_rounded,
      'title': 'One Unified Workspace',
      'description': 'Say goodbye to 6+ fragmented apps. Leads, projects, staff, and payments live together.',
    },
    {
      'icon': Icons.visibility_rounded,
      'title': 'Real-Time Visibility',
      'description': 'Live site milestone tracking, photo progress logs, and instant client approvals.',
    },
    {
      'icon': Icons.bolt_rounded,
      'title': 'Smarter Automation',
      'description': 'Automated WhatsApp follow-ups, scheduled broadcasts, and intelligent drip campaigns.',
    },
    {
      'icon': Icons.groups_rounded,
      'title': 'Team Accountability',
      'description': 'Multi-tier hierarchy, geo-attendance, task velocity, and transparent performance scores.',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'title': 'Total Cashflow Clarity',
      'description': 'Dynamic quotation pricing, client milestone invoicing, and labour/vendor ledgers.',
    },
  ];

  // 7 High-Level Capability Categories
  static const List<Map<String, dynamic>> capabilities = [
    {
      'category': 'CRM & SALES',
      'title': 'Lead Funnels & Conversions',
      'icon': Icons.trending_up_rounded,
      'badge': 'High Velocity',
      'color': Color(0xFF4F46E5),
      'description':
          'Capture leads from Meta & Google Ads, qualify with custom scoring, assign to teams automatically, and monitor conversion stages in an interactive Kanban pipeline.',
      'features': [
        'Lead qualification & stage funnels',
        'Automatic salesperson assignment',
        'Meeting scheduler & follow-up alerts',
        'Call recording & conversation history',
      ],
    },
    {
      'category': 'PROJECT MANAGEMENT',
      'title': 'Site Milestones & Execution',
      'icon': Icons.assignment_rounded,
      'badge': 'Live Tracking',
      'color': Color(0xFF0D9488),
      'description':
          'Deliver projects on time with interactive Gantt schedules, milestone checklist sign-offs, site photo progress feeds, and client dispute resolution.',
      'features': [
        'Gantt & interactive timeline views',
        'Live site progress photo logs',
        'Client digital approvals & feedback',
        'Complaint & issue ticketing',
      ],
    },
    {
      'category': 'OMNICHANNEL & COMMS',
      'title': 'WhatsApp & Drip Automation',
      'icon': Icons.chat_rounded,
      'badge': '10x Engagement',
      'color': Color(0xFF10B981),
      'description':
          'Engage prospects directly on WhatsApp. Run automated onboarding drips, broadcast promotional updates, and resolve routine queries with 24/7 AI calling and bots.',
      'features': [
        'Official WhatsApp Business integration',
        'Trigger-based automated drip messaging',
        'Bulk campaign scheduler with analytics',
        'AI chatbot & automated voice calls',
      ],
    },
    {
      'category': 'TEAM & HR',
      'title': 'Hierarchy, Roles & Attendance',
      'icon': Icons.badge_rounded,
      'badge': 'Governance',
      'color': Color(0xFF7C3AED),
      'description':
          'Structure your company into departments with granular role permissions. Track daily attendance, travel claims, productivity scores, and automated incentive payouts.',
      'features': [
        'Multi-tier department roles & permissions',
        'Geo-tagged attendance & leave approvals',
        'Travel expense tracking & mileage logs',
        'Performance scorecards & incentives',
      ],
    },
    {
      'category': 'FINANCE & BILLING',
      'title': 'Quotations & Vendor Ledgers',
      'icon': Icons.payments_rounded,
      'badge': 'Cashflow',
      'color': Color(0xFFF59E0B),
      'description':
          'Build dynamic quotations with customized margin calculators. Track customer payment milestones, material supplier orders, and contractor labour payouts in real time.',
      'features': [
        'Dynamic quotation builder with margin rules',
        'Client milestone billing & receipt generation',
        'Material vendor purchase orders',
        'Labour wage disbursements & ratings',
      ],
    },
    {
      'category': 'AI & INTELLIGENCE',
      'title': 'Generative Design & Advisory',
      'icon': Icons.auto_awesome_rounded,
      'badge': 'Next-Gen AI',
      'color': Color(0xFFEC4899),
      'description':
          'Supercharge your workflow with specialized AI assistants: instant interior design concepts, AI Vastu compliance checking, smart project budget estimators, and business copilot.',
      'features': [
        'AI concept design generator',
        'AI Vastu layout consultant',
        'Automated project budget calculator',
        '24/7 intelligent operational copilot',
      ],
    },
    {
      'category': 'REPORTING & METRICS',
      'title': 'Executive BI & Dashboards',
      'icon': Icons.analytics_rounded,
      'badge': 'Real-Time BI',
      'color': Color(0xFF06B6D4),
      'description':
          'Make confident data-driven decisions with executive dashboard analytics: revenue run-rates, stage conversion drop-offs, team productivity rankings, and project health indices.',
      'features': [
        'Executive revenue & cashflow forecasting',
        'Funnel conversion drop-off analytics',
        'Employee leaderboard & SLA reports',
        'Custom exportable date-range audits',
      ],
    },
  ];

  // Business Outcomes
  static const List<Map<String, dynamic>> businessOutcomes = [
    {
      'stat': '72%',
      'label': 'Software Cost Reduction',
      'description': 'Consolidate multiple point solutions into a single, affordable SaaS subscription.',
    },
    {
      'stat': '3.5x',
      'label': 'Faster Lead Turnaround',
      'description': 'Automated WhatsApp routing and instant quotation templates close clients before competitors respond.',
    },
    {
      'stat': '100%',
      'label': 'Site Execution Visibility',
      'description': 'Daily photo progress, digital sign-offs, and Gantt milestones eliminate blind spots and delays.',
    },
    {
      'stat': '0',
      'label': 'Missed Customer Follow-Ups',
      'description': 'Intelligent reminders and automated drip schedules ensure no opportunity slips through.',
    },
  ];

  // 4-Step Onboarding Workflow
  static const List<Map<String, String>> workflowSteps = [
    {
      'step': '01',
      'title': 'Choose Your Plan & Workspace',
      'description': 'Sign up in under 60 seconds. Pick a tier tailored to your team size and operational complexity.',
    },
    {
      'step': '02',
      'title': 'Set Up Organization & Roles',
      'description': 'Configure department hierarchies, staff permission tiers, sales pipelines, and quotation margin rules.',
    },
    {
      'step': '03',
      'title': 'Bring Operations Into One Place',
      'description': 'Connect Meta/Google lead sources, import clients, set up active site milestones, and invite team members.',
    },
    {
      'step': '04',
      'title': 'Scale with Automation & AI',
      'description': 'Trigger automated WhatsApp nurture drips, generate instant AI quotes, and track growth with live analytics.',
    },
  ];
}
