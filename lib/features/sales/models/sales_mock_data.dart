import 'package:flutter/material.dart';
import 'sales_models.dart';

/// Seed Generator producing rich enterprise data for Homio Sales & CRM.
abstract class SalesMockData {
  // ==========================================================================
  // 1. SALES OVERVIEW KPIS & COMMISSION
  // ==========================================================================

  static const List<SalesKpiMetric> overviewKpis = [
    SalesKpiMetric(
      id: 'sales_new_leads',
      title: 'Active Inbound Leads',
      value: '34 Leads',
      changeText: '+12 today',
      isPositive: true,
      icon: Icons.person_add_alt_1_rounded,
      color: Color(0xFF6366F1),
      subtitle: 'Meta 18 • Google 10 • Organic 6',
    ),
    SalesKpiMetric(
      id: 'sales_followups',
      title: "Today's Followups",
      value: '18 Due',
      changeText: '8 Overdue SLA',
      isPositive: false,
      icon: Icons.access_time_filled_rounded,
      color: Color(0xFFEF4444),
      subtitle: 'Next call in 15 mins (Kunal Singhal)',
    ),
    SalesKpiMetric(
      id: 'sales_meetings_sched',
      title: 'Consultations Booked',
      value: '12 Meets',
      changeText: '4 Site • 6 Studio • 2 Zoom',
      isPositive: true,
      icon: Icons.event_available_rounded,
      color: Color(0xFF10B981),
      subtitle: '100% Slot capacity utilized',
    ),
    SalesKpiMetric(
      id: 'sales_target',
      title: 'Target Achieved',
      value: '₹1.84 Cr',
      changeText: '73.6% of ₹2.50 Cr Target',
      isPositive: true,
      icon: Icons.track_changes_rounded,
      color: Color(0xFFF59E0B),
      subtitle: '142 Closed Deals this Month',
    ),
  ];

  // ==========================================================================
  // 2. FUNNEL STAGES
  // ==========================================================================

  static const List<SalesFunnelStage> interiorStages = [
    SalesFunnelStage(
      id: 'stg_new',
      name: 'Stage 1: New Enquiry',
      stageIndex: 1,
      color: Color(0xFF6366F1),
      description: 'Incoming Meta Ads & Web intake forms',
    ),
    SalesFunnelStage(
      id: 'stg_qual',
      name: 'Stage 2: Qualified',
      stageIndex: 2,
      color: Color(0xFF3B82F6),
      description: 'Budget, location & timeline verified',
    ),
    SalesFunnelStage(
      id: 'stg_meet',
      name: 'Stage 3: Meeting Done',
      stageIndex: 3,
      color: Color(0xFF0EA5E9),
      description: 'Concept & 3D estimation presented',
    ),
    SalesFunnelStage(
      id: 'stg_booked',
      name: 'Stage 4: Booked Clients',
      stageIndex: 4,
      color: Color(0xFF10B981),
      description: 'Token paid & handed to design lead',
    ),
    SalesFunnelStage(
      id: 'stg_not_resp',
      name: 'Stage 5: Not Responding',
      stageIndex: 5,
      color: Color(0xFFF59E0B),
      description: 'In automated 5-day drip nurture',
    ),
    SalesFunnelStage(
      id: 'stg_not_qual',
      name: 'Stage 6: Not Qualified',
      stageIndex: 6,
      color: Color(0xFF94A3B8),
      description: 'Out of service pin-code / budget mismatch',
    ),
    SalesFunnelStage(
      id: 'stg_not_int',
      name: 'Stage 7: Not Interested',
      stageIndex: 7,
      color: Color(0xFFEF4444),
      description: 'Declined with objection logged',
    ),
  ];

  static const List<SalesFunnelStage> hiringStages = [
    SalesFunnelStage(
      id: 'hir_new',
      name: 'Stage 1: New Applicants',
      stageIndex: 1,
      color: Color(0xFF6366F1),
      description: 'Resume & 3D portfolio submitted',
    ),
    SalesFunnelStage(
      id: 'hir_qual',
      name: 'Stage 2: Qualified Portfolio',
      stageIndex: 2,
      color: Color(0xFF3B82F6),
      description: '3ds Max / SketchUp skills verified',
    ),
    SalesFunnelStage(
      id: 'hir_interview',
      name: 'Stage 3: Design Test & Interview',
      stageIndex: 3,
      color: Color(0xFF0EA5E9),
      description: 'Senior Project Manager technical round',
    ),
    SalesFunnelStage(
      id: 'hir_hired',
      name: 'Stage 4: Hired / Offer Sent',
      stageIndex: 4,
      color: Color(0xFF10B981),
      description: 'Offer letter dispatched with joining date',
    ),
    SalesFunnelStage(
      id: 'hir_rejected',
      name: 'Stage 5: Rejected',
      stageIndex: 5,
      color: Color(0xFFEF4444),
      description: 'Candidate skill / experience mismatch',
    ),
  ];

  static const List<SalesFunnelStage> vendorStages = [
    SalesFunnelStage(
      id: 'ven_inflow',
      name: 'Stage 1: Trade Inflow',
      stageIndex: 1,
      color: Color(0xFF6366F1),
      description: 'Contractor application & trade license',
    ),
    SalesFunnelStage(
      id: 'ven_vetted',
      name: 'Stage 2: Work Quality Vetted',
      stageIndex: 2,
      color: Color(0xFF3B82F6),
      description: 'Physical inspection of past client sites',
    ),
    SalesFunnelStage(
      id: 'ven_pricing',
      name: 'Stage 3: Pricing Rate Card Agreed',
      stageIndex: 3,
      color: Color(0xFF0EA5E9),
      description: 'Fixed sqft labour rates & SLA compliance',
    ),
    SalesFunnelStage(
      id: 'ven_signed',
      name: 'Stage 4: Contract Signed',
      stageIndex: 4,
      color: Color(0xFF10B981),
      description: 'Escrow security deposit & agreement',
    ),
  ];

  // ==========================================================================
  // 3. LEADS MASTER SEED
  // ==========================================================================

  static const List<SalesLeadItem> leads = [
    SalesLeadItem(
      id: 'LEAD-9801',
      clientName: 'Vikram Malhotra',
      phone: '+91 98112 44921',
      email: 'vikram.m@gmail.com',
      siteAddress: 'DLF Magnolias, Tower 2, Penthouse 14B, Gurgaon',
      projectType: '4BHK Luxury Penthouse (4,200 sqft)',
      workDescription: 'Full Turnkey Interior + Italian Marble Polishing',
      budgetAmount: 48.5,
      stageId: 'stg_new',
      source: 'Meta Ads',
      assignedConsultant: 'Aarav Singhania',
      meetingPreference: 'Experience Center / Office',
      createdDate: 'Sep 6, 2026',
      nextFollowupTime: 'Today, 02:30 PM',
      isFollowupOverdue: false,
      lastCallAudioUrl: 'https://homio.ai/audio/call-9801.mp3',
      tags: ['High Value', 'Penthouse', 'Hafele'],
    ),
    SalesLeadItem(
      id: 'LEAD-9802',
      clientName: 'Kunal Singhal',
      phone: '+91 98710 99201',
      email: 'kunal.singhal@outlook.com',
      siteAddress: 'Prestige Falcon City, Villa 402, Bangalore',
      projectType: '3BHK Duplex Villa (2,850 sqft)',
      workDescription: 'Modular Kitchen & Woodwork + Smart Automation',
      budgetAmount: 28.0,
      stageId: 'stg_qual',
      source: 'Google Ads',
      assignedConsultant: 'Pooja Hegde',
      meetingPreference: 'Site Visit',
      createdDate: 'Sep 5, 2026',
      nextFollowupTime: 'Today, 11:30 AM',
      isFollowupOverdue: true,
      lastCallAudioUrl: 'https://homio.ai/audio/call-9802.mp3',
      tags: ['Verified Budget', 'Site Visit Needed'],
    ),
    SalesLeadItem(
      id: 'LEAD-9803',
      clientName: 'Ananya & Rohit Sharma',
      phone: '+91 99204 11840',
      email: 'rohit.sharma@tcs.com',
      siteAddress: 'Godrej Woods, Sector 43, Noida',
      projectType: '3BHK Apartment (1,850 sqft)',
      workDescription: 'Full Turnkey (False Ceiling, Kitchen, Wardrobes)',
      budgetAmount: 22.5,
      stageId: 'stg_meet',
      source: 'Website Form',
      assignedConsultant: 'Rohan Deshmukh',
      meetingPreference: 'Zoom / Online',
      createdDate: 'Sep 4, 2026',
      nextFollowupTime: 'Tomorrow, 10:00 AM',
      isFollowupOverdue: false,
      tags: ['Zoom Completed', 'Quotation Under Review'],
    ),
    SalesLeadItem(
      id: 'LEAD-9804',
      clientName: 'Sanjay Dutt & Family',
      phone: '+91 98200 48201',
      email: 'sanjay.dutt@bandra.in',
      siteAddress: 'Pali Hill Residency, Flat 801, Mumbai',
      projectType: '4BHK Sea-Facing Luxury (3,400 sqft)',
      workDescription: 'Complete Turnkey Architectural Overhaul',
      budgetAmount: 65.0,
      stageId: 'stg_booked',
      source: 'Referral',
      assignedConsultant: 'Aarav Singhania',
      meetingPreference: 'Site Visit',
      createdDate: 'Sep 1, 2026',
      nextFollowupTime: 'Sep 8, 2026 (Kickoff)',
      isFollowupOverdue: false,
      tags: ['Booked', 'Advance ₹6.5L Paid', 'VIP Client'],
    ),
    SalesLeadItem(
      id: 'LEAD-9805',
      clientName: 'Pooja Verma',
      phone: '+91 97110 33812',
      email: 'pooja.verma@wipro.com',
      siteAddress: 'Sobha Royal Pavilion, Sarjapur Road, Bangalore',
      projectType: '2BHK Compact (1,150 sqft)',
      workDescription: 'Modular Kitchen & Master Bedroom Wardrobe',
      budgetAmount: 12.0,
      stageId: 'stg_not_resp',
      source: 'Meta Ads',
      assignedConsultant: 'Sneha Kapoor',
      meetingPreference: 'Zoom / Online',
      createdDate: 'Aug 29, 2026',
      nextFollowupTime: 'Drip Day 4: Video sent',
      isFollowupOverdue: false,
      tags: ['Drip Campaign Active', '3 Calls Unanswered'],
    ),
    SalesLeadItem(
      id: 'LEAD-9806',
      clientName: 'Suresh Raina',
      phone: '+91 99102 88471',
      email: 'suresh.raina@gmail.com',
      siteAddress: 'Jaypee Greens, Greater Noida',
      projectType: 'Commercial Retail Boutique (900 sqft)',
      workDescription: 'Commercial Fit-Out',
      budgetAmount: 14.0,
      stageId: 'stg_not_int',
      source: 'Google Ads',
      assignedConsultant: 'Kunal Verma',
      meetingPreference: 'Experience Center / Office',
      createdDate: 'Aug 26, 2026',
      nextFollowupTime: 'Archived',
      isFollowupOverdue: false,
      primaryObjection: 'Quotation 18% higher than local contractor',
      decliningReason: 'High Rate / Commercial Budget Constraint',
      tags: ['Declined', 'Rate Objection'],
    ),
  ];

  // ==========================================================================
  // 4. WHATSAPP CHATS & BROADCAST CAMPAIGNS
  // ==========================================================================

  static const List<WhatsAppChatThread> whatsappThreads = [
    WhatsAppChatThread(
      id: 'wa_01',
      contactName: 'Vikram Malhotra',
      phone: '+91 98112 44921',
      lastMessage: 'Can you please confirm if Hafele soft-close fittings are included in the modular kitchen quote?',
      lastMessageTime: '10:45 AM',
      unreadCount: 2,
      stageTag: 'New Enquiry',
      stageColor: Color(0xFF6366F1),
      messages: [
        WhatsAppMessageBubble(
          id: 'm1',
          sender: 'client',
          text: 'Hi Homio team, saw your DLF Cybercity walkthrough reel. Looking for turnkey interior for my 4BHK.',
          timestamp: '10:30 AM',
          isRead: true,
        ),
        WhatsAppMessageBubble(
          id: 'm2',
          sender: 'ai',
          text: 'Hello Vikram! Welcome to Homio OS. Our design director Aarav Singhania has reserved your slot for a 3D consultation. Here is our luxury villa catalog:',
          timestamp: '10:31 AM',
          isRead: true,
          mediaUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
          mediaCaption: 'Homio_Luxury_Portfolio_2026.pdf',
        ),
        WhatsAppMessageBubble(
          id: 'm3',
          sender: 'client',
          text: 'Can you please confirm if Hafele soft-close fittings are included in the modular kitchen quote?',
          timestamp: '10:45 AM',
          isRead: false,
        ),
      ],
    ),
    WhatsAppChatThread(
      id: 'wa_02',
      contactName: 'Kunal Singhal',
      phone: '+91 98710 99201',
      lastMessage: 'Sharing the villa architectural DWG file here. Please check site survey timing for tomorrow.',
      lastMessageTime: 'Yesterday',
      unreadCount: 0,
      stageTag: 'Qualified',
      stageColor: Color(0xFF3B82F6),
      messages: [
        WhatsAppMessageBubble(
          id: 'm4',
          sender: 'agent',
          text: 'Good evening Kunal! Our site surveyor will arrive at Prestige Villa 402 tomorrow at 11:00 AM with laser dimension tools.',
          timestamp: '05:30 PM',
          isRead: true,
        ),
        WhatsAppMessageBubble(
          id: 'm5',
          sender: 'client',
          text: 'Sharing the villa architectural DWG file here. Please check site survey timing for tomorrow.',
          timestamp: '06:12 PM',
          isRead: true,
        ),
      ],
    ),
    WhatsAppChatThread(
      id: 'wa_03',
      contactName: 'Ananya Sharma',
      phone: '+91 99204 11840',
      lastMessage: 'Thank you for the Zoom meeting! We reviewed the 3D moodboard. Love the Scandinavian oak finish.',
      lastMessageTime: 'Sep 4',
      unreadCount: 0,
      stageTag: 'Meeting Done',
      stageColor: Color(0xFF0EA5E9),
      messages: [],
    ),
  ];

  static const List<BroadcastCampaignItem> broadcastCampaigns = [
    BroadcastCampaignItem(
      id: 'bc_01',
      name: 'Diwali Festive Modular Kitchen Offer (Flat 10% Off)',
      templateName: 'homio_festive_kitchen_2026',
      targetAudience: 'Qualified Leads (Stage 2 & 3)',
      recipientCount: 420,
      deliveredCount: 412,
      readCount: 368,
      repliedCount: 84,
      scheduledDate: 'Sep 5, 2026 • 11:00 AM',
      status: 'Completed',
      statusColor: Color(0xFF10B981),
    ),
    BroadcastCampaignItem(
      id: 'bc_02',
      name: 'Free 3D Vastu Consultation Slot Booking Blast',
      templateName: 'vastu_free_consultation_blast',
      targetAudience: 'Not Responding Leads (Stage 5)',
      recipientCount: 280,
      deliveredCount: 274,
      readCount: 198,
      repliedCount: 42,
      scheduledDate: 'Sep 6, 2026 • 04:00 PM',
      status: 'Active',
      statusColor: Color(0xFF3B82F6),
    ),
  ];

  // ==========================================================================
  // 5. AI CALLING LOGS & TRANSCRIPTS
  // ==========================================================================

  static const List<AiCallRecordItem> aiCalls = [
    AiCallRecordItem(
      callId: 'CALL-AI-401',
      leadId: 'LEAD-9801',
      clientName: 'Vikram Malhotra',
      phone: '+91 98112 44921',
      callDate: 'Sep 6, 2026 • 10:15 AM',
      duration: '3m 42s',
      qualificationStatus: 'Qualified',
      statusColor: Color(0xFF10B981),
      sentiment: 'Positive (92%)',
      sentimentColor: Color(0xFF10B981),
      fullTranscript: '''
AI Voice Agent: Hello Vikram! I'm calling from Homio Interior OS regarding your recent inquiry for the 4BHK Penthouse in DLF Magnolias. Am I speaking with Mr. Vikram?
Customer: Yes, Vikram here.
AI Voice Agent: Wonderful! Are you looking for a full turnkey interior execution including false ceiling, modular woodwork, and finishes?
Customer: Yes, we need complete architectural turnkey interior, around 4,200 square feet. We want German hardware and Italian marble.
AI Voice Agent: Perfect. Our average budget for this luxury turnkey spec is between 45 to 55 Lakhs. Does that align with your planned investment?
Customer: Yes, that is right within our budget. When can someone visit the site?
AI Voice Agent: I can book our Senior Design Lead Aarav Singhania for a site measurement visit today at 2:30 PM or tomorrow at 11 AM. Which works best?
Customer: Today 2:30 PM works great.
AI Voice Agent: Excellent! I have locked in today 2:30 PM. I am sending the confirmation and Aarav's portfolio directly to your WhatsApp. Have a great day!
''',
      recordingUrl: 'https://homio.ai/audio/call-ai-401.mp3',
    ),
    AiCallRecordItem(
      callId: 'CALL-AI-402',
      leadId: 'LEAD-9802',
      clientName: 'Kunal Singhal',
      phone: '+91 98710 99201',
      callDate: 'Sep 6, 2026 • 09:40 AM',
      duration: '2m 18s',
      qualificationStatus: 'Qualified',
      statusColor: Color(0xFF10B981),
      sentiment: 'Hesitant (Price Sensitive)',
      sentimentColor: Color(0xFFF59E0B),
      fullTranscript: '''
AI Voice Agent: Hello Kunal! Calling from Homio Interior Studio for your Prestige Falcon City Villa.
Customer: Yes, but I am comparing quotes with Livspace as well.
AI Voice Agent: Understood Kunal. We offer 10-year factory warranty and zero sub-contractor markups with verified itemized rate-cards. Can we schedule a 15-minute Zoom call to compare specifications?
Customer: Sure, you can send me the comparison breakdown on WhatsApp first.
AI Voice Agent: Dispatched to your WhatsApp right now! Our consultant Pooja will follow up shortly.
''',
      recordingUrl: 'https://homio.ai/audio/call-ai-402.mp3',
    ),
    AiCallRecordItem(
      callId: 'CALL-AI-403',
      leadId: 'LEAD-9805',
      clientName: 'Pooja Verma',
      phone: '+91 97110 33812',
      callDate: 'Sep 5, 2026 • 04:20 PM',
      duration: '0m 45s',
      qualificationStatus: 'Unresponsive',
      statusColor: Color(0xFFEF4444),
      sentiment: 'No Answer / Dropped',
      sentimentColor: Color(0xFF94A3B8),
      fullTranscript: 'Call placed. Rang for 45 seconds. Transferred to automated WhatsApp drip trigger sequence.',
      recordingUrl: 'https://homio.ai/audio/call-ai-403.mp3',
    ),
  ];

  // ==========================================================================
  // 6. MEETING CALENDAR SLOTS
  // ==========================================================================

  static const List<MeetingScheduleSlot> meetingSlots = [
    MeetingScheduleSlot(
      id: 'MEET-101',
      clientName: 'Vikram Malhotra',
      leadId: 'LEAD-9801',
      meetingFormat: 'Site Visit',
      formatIcon: Icons.location_on_rounded,
      formatColor: Color(0xFF3B82F6),
      date: 'Today, Sep 6, 2026',
      timeRange: '02:30 PM - 04:00 PM',
      locationOrLink: 'DLF Magnolias Tower 2, Penthouse 14B, Gurgaon',
      assignedDesigner: 'Aarav Singhania (Deal Closer)',
      status: 'Scheduled',
      statusColor: Color(0xFF10B981),
      reminder24hSent: true,
      reminderMorningSent: true,
      reminder1hSent: false,
    ),
    MeetingScheduleSlot(
      id: 'MEET-102',
      clientName: 'Kunal Singhal',
      leadId: 'LEAD-9802',
      meetingFormat: 'Experience Center / Studio',
      formatIcon: Icons.business_rounded,
      formatColor: Color(0xFF8B5CF6),
      date: 'Today, Sep 6, 2026',
      timeRange: '11:30 AM - 01:00 PM',
      locationOrLink: 'Homio Studio, Level 3, Indiranagar Hub, Bangalore',
      assignedDesigner: 'Pooja Hegde (Senior Designer)',
      status: 'Attended',
      statusColor: Color(0xFF10B981),
      reminder24hSent: true,
      reminderMorningSent: true,
      reminder1hSent: true,
    ),
    MeetingScheduleSlot(
      id: 'MEET-103',
      clientName: 'Ananya Sharma',
      leadId: 'LEAD-9803',
      meetingFormat: 'Zoom / Virtual',
      formatIcon: Icons.videocam_rounded,
      formatColor: Color(0xFF0EA5E9),
      date: 'Tomorrow, Sep 7, 2026',
      timeRange: '10:00 AM - 11:00 AM',
      locationOrLink: 'https://zoom.us/j/9812440192',
      assignedDesigner: 'Rohan Deshmukh (Consultant)',
      status: 'Scheduled',
      statusColor: Color(0xFF3B82F6),
      reminder24hSent: true,
      reminderMorningSent: false,
      reminder1hSent: false,
    ),
  ];

  // ==========================================================================
  // 7. SALES TASKS & SITE SURVEYS
  // ==========================================================================

  static const List<SiteSurveyRecordItem> siteSurveys = [
    SiteSurveyRecordItem(
      surveyId: 'SRV-801',
      leadId: 'LEAD-9801',
      clientName: 'Vikram Malhotra',
      siteAddress: 'DLF Magnolias Tower 2, Penthouse 14B, Gurgaon',
      surveyDate: 'Sep 6, 2026',
      surveyorName: 'Naveen Kumar (Site Coordinator)',
      hasFloorplanAttached: true,
      floorplanName: 'DLF_Magnolias_Penthouse_CAD_Survey.dwg',
      vastuFacing: 'North-East (Ishan Corner)',
      scopeChecklist: [
        'Living Room: Italian Dyna Marble with Mirror Polish',
        'Kitchen: German Hafele Fittings + Fluted Glass Shutters',
        'Master Bedroom: Walk-in Closet with Sensor LED strips',
        'Balcony: Deck Wood Flooring + Glass Railing Planters',
      ],
      clientBudgetConstraint: '₹45L - ₹50L (Turnkey Handover in 60 Days)',
      roomMeasurements: [
        RoomMeasurementEntry(roomName: 'Living & Dining Hall', lengthFeet: 28.5, widthFeet: 18.0, ceilingHeightFeet: 10.5, notes: 'Double height section over foyer area'),
        RoomMeasurementEntry(roomName: 'Master Bedroom Suite', lengthFeet: 20.0, widthFeet: 16.5, ceilingHeightFeet: 10.0, notes: 'Walk-in wardrobe recess depth 7.5 ft'),
        RoomMeasurementEntry(roomName: 'Modular Kitchen', lengthFeet: 16.0, widthFeet: 12.0, ceilingHeightFeet: 9.8, notes: 'Island counter plumbing point marked'),
        RoomMeasurementEntry(roomName: 'Balcony Terrace', lengthFeet: 24.0, widthFeet: 8.0, ceilingHeightFeet: 10.5, notes: 'Outdoor weather-proof power sockets required'),
      ],
    ),
    SiteSurveyRecordItem(
      surveyId: 'SRV-802',
      leadId: 'LEAD-9802',
      clientName: 'Kunal Singhal',
      siteAddress: 'Prestige Falcon City, Villa 402, Bangalore',
      surveyDate: 'Sep 5, 2026',
      surveyorName: 'Rajat Sharma (Site Coordinator)',
      hasFloorplanAttached: true,
      floorplanName: 'Prestige_Villa_402_LaserScan.pdf',
      vastuFacing: 'East Facing Entrance',
      scopeChecklist: [
        'Full Duplex Modular Wardrobes (Merino Laminates)',
        'False Ceiling Cove Lighting in all bedrooms',
        'Kitchen: Tandem drawers + Chimney ducting core cut',
      ],
      clientBudgetConstraint: '₹28L Maximum (Including Appliances)',
      roomMeasurements: [
        RoomMeasurementEntry(roomName: 'Living Hall', lengthFeet: 22.0, widthFeet: 15.0, ceilingHeightFeet: 9.5, notes: 'Beam offset on north wall: 8 inches'),
        RoomMeasurementEntry(roomName: 'Kids Bedroom', lengthFeet: 14.0, widthFeet: 12.0, ceilingHeightFeet: 9.5, notes: 'Study unit wall length 10 ft'),
      ],
    ),
  ];

  static const List<SalesFollowupTaskItem> followupTasks = [
    SalesFollowupTaskItem(
      id: 'TSK-701',
      title: 'Call Vikram Malhotra to confirm 02:30 PM site measurement timing',
      leadId: 'LEAD-9801',
      clientName: 'Vikram Malhotra',
      dueTime: 'Today • 01:45 PM',
      priority: 'Urgent',
      priorityColor: Color(0xFFEF4444),
      isCompleted: false,
    ),
    SalesFollowupTaskItem(
      id: 'TSK-702',
      title: 'Send itemized Hafele hardware comparison matrix on WhatsApp',
      leadId: 'LEAD-9802',
      clientName: 'Kunal Singhal',
      dueTime: 'Today • 03:00 PM',
      priority: 'High',
      priorityColor: Color(0xFFF59E0B),
      isCompleted: false,
    ),
    SalesFollowupTaskItem(
      id: 'TSK-703',
      title: 'Dispatch Zoom link & 3D moodboard PDF for tomorrow 10:00 AM consultation',
      leadId: 'LEAD-9803',
      clientName: 'Ananya Sharma',
      dueTime: 'Today • 05:30 PM',
      priority: 'Medium',
      priorityColor: Color(0xFF3B82F6),
      isCompleted: true,
    ),
    SalesFollowupTaskItem(
      id: 'TSK-704',
      title: 'Handover booked contract files & advance receipt to Project Manager Kriti Sanon',
      leadId: 'LEAD-9804',
      clientName: 'Sanjay Dutt',
      dueTime: 'Tomorrow • 11:00 AM',
      priority: 'High',
      priorityColor: Color(0xFF10B981),
      isCompleted: false,
    ),
  ];
}
