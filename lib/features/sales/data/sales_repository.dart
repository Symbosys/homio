import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/sales_enums.dart';
import '../domain/sales_domain_models.dart';

/// Central Sales CRM Repository handling in-memory reactive state,
/// multi-funnel operations, duplicate checking, and audit trails.
class SalesRepository {
  SalesRepository._internal() {
    _seedInitialData();
  }

  static final SalesRepository instance = SalesRepository._internal();

  final List<LeadItem> _leads = [];
  final List<CustomerItem> _customers = [];
  final List<FunnelConfig> _funnels = [];
  final List<FollowUpRecord> _followups = [];
  final List<CallLogRecord> _callLogs = [];
  final List<MeetingRecord> _meetings = [];
  final List<SalesTaskItem> _tasks = [];
  final List<AutomationWorkflow> _automations = [];

  List<LeadItem> get leads => List.unmodifiable(_leads);

  // Pincode eligibility service area rule (PRD Pincode checking)
  static const Set<String> _serviceablePincodes = {
    '122001', '122002', '122003', '122004', '122009', '122011', '122018',
    '110001', '110016', '110019', '110020', '110024', '110048', '110070',
    '201301', '201303', '201304', '201305', '201310',
  };

  void _seedInitialData() {
    // 1. Seed Leads
    _leads.addAll([
      LeadItem(
        id: 'HOM-LD-1024',
        clientName: 'Rahul & Neha Sharma',
        phone: '+91 98101 23456',
        alternatePhone: '+91 98101 23457',
        email: 'rahul.sharma@dlf.in',
        city: 'Gurugram',
        state: 'Haryana',
        pincode: '122002',
        address: 'Tower C, Apt 1402, DLF The Camellias, Golf Course Rd',
        projectType: '4BHK Luxury Turnkey',
        workType: LeadWorkType.fullTurnkey,
        areaSqFt: 3850,
        budgetAmount: 65.0,
        budgetConfidence: 'Confirmed',
        stage: CrmStage.qualified,
        source: LeadSourceType.metaLeadAds,
        assignedTo: 'Ananya Verma',
        meetingPreference: MeetingPreferenceType.siteVisit,
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        lastContactDate: DateTime.now().subtract(const Duration(hours: 3)),
        nextFollowupDate: 'Today, 03:30 PM',
        leadScore: 92.0,
        isQualified: true,
        qualificationReason: 'Verified Camellias possession & ₹65L budget confirmed',
        tags: const ['Hot', 'High Budget', 'VIP Turnkey'],
        activities: [
          LeadActivityItem(
            id: 'ACT-1',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            employeeName: 'System / Meta Ad Engine',
            action: 'Lead Ingested',
            details: 'Captured via Meta Lead Ad Form: Luxury Interior Campaign',
            source: 'Meta Ads',
            icon: Icons.campaign_rounded,
            iconColor: Colors.blue,
          ),
          LeadActivityItem(
            id: 'ACT-2',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            employeeName: 'Ananya Verma',
            action: 'Discovery Call Completed',
            details: 'Client confirmed 3850 sq.ft possession in Oct 2026. Prefers Italian marble & false ceiling.',
            source: 'Calling',
            icon: Icons.phone_callback_rounded,
            iconColor: Colors.green,
          ),
          LeadActivityItem(
            id: 'ACT-3',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            employeeName: 'Ananya Verma',
            action: 'Stage Changed to Qualified',
            details: 'Verified budget eligibility (>₹25L) & serviceable Gurugram pincode (122002).',
            source: 'System',
            icon: Icons.verified_rounded,
            iconColor: Colors.purple,
          ),
        ],
      ),
      LeadItem(
        id: 'HOM-LD-1025',
        clientName: 'Vikramaditya Oberoi',
        phone: '+91 99200 88776',
        email: 'vikram.oberoi@oberoigroup.com',
        city: 'New Delhi',
        state: 'Delhi NCR',
        pincode: '110024',
        address: 'Villa 18, Defence Colony, South Extension',
        projectType: 'Independent Duplex Kothi',
        workType: LeadWorkType.fullTurnkey,
        areaSqFt: 5200,
        budgetAmount: 110.0,
        budgetConfidence: 'Confirmed',
        stage: CrmStage.meetingDone,
        source: LeadSourceType.referral,
        assignedTo: 'Rajesh Patel',
        meetingPreference: MeetingPreferenceType.officeVisit,
        createdDate: DateTime.now().subtract(const Duration(days: 5)),
        lastContactDate: DateTime.now().subtract(const Duration(hours: 6)),
        nextFollowupDate: 'Tomorrow, 11:00 AM',
        leadScore: 98.0,
        isQualified: true,
        qualificationReason: 'High Net Worth client, referral from DLF Magnolias project',
        tags: const ['VIP', 'Full Turnkey', 'Urgent'],
        activities: [
          LeadActivityItem(
            id: 'ACT-4',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            employeeName: 'Rajesh Patel',
            action: 'Client Referral Registered',
            details: 'Referred by Dr. Alok Gupta (Project CAM-104)',
            source: 'Manual',
            icon: Icons.people_alt_rounded,
            iconColor: Colors.teal,
          ),
          LeadActivityItem(
            id: 'ACT-5',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            employeeName: 'Rajesh Patel',
            action: 'Experience Center Meeting Done',
            details: 'Presented preliminary 3D concept render for double-height foyer & master suite.',
            source: 'Meeting',
            icon: Icons.handshake_rounded,
            iconColor: Colors.indigo,
          ),
        ],
      ),
      LeadItem(
        id: 'HOM-LD-1026',
        clientName: 'Sanjay & Sunita Singhal',
        phone: '+91 98188 44332',
        email: 'sanjay.singhal@hdfcbank.com',
        city: 'Noida',
        state: 'Uttar Pradesh',
        pincode: '201301',
        address: 'Tower 4, Apt 803, Godrej Woods, Sector 43',
        projectType: '3BHK Modular Woodwork',
        workType: LeadWorkType.modularKitchen,
        areaSqFt: 2150,
        budgetAmount: 28.5,
        budgetConfidence: 'Flexible',
        stage: CrmStage.newEnquiry,
        source: LeadSourceType.googleAds,
        assignedTo: 'Priya Sharma',
        meetingPreference: MeetingPreferenceType.online,
        createdDate: DateTime.now().subtract(const Duration(hours: 5)),
        lastContactDate: DateTime.now().subtract(const Duration(hours: 5)),
        nextFollowupDate: 'Today, 04:00 PM',
        leadScore: 78.0,
        isQualified: true,
        qualificationReason: 'Serviceable Noida Sector 43 pincode. High interest in German fittings.',
        tags: const ['Hot', 'Modular Kitchen'],
        activities: [
          LeadActivityItem(
            id: 'ACT-6',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            employeeName: 'Google Ad Sync',
            action: 'Google Search Inquiry',
            details: 'Searched "German Modular Kitchen Noida Sector 43"',
            source: 'Google Ads',
            icon: Icons.search_rounded,
            iconColor: Colors.amber,
          ),
        ],
      ),
      LeadItem(
        id: 'HOM-LD-1027',
        clientName: 'Meera Kapoor',
        phone: '+91 98111 65432',
        email: 'meera.kapoor@studio.design',
        city: 'Gurugram',
        state: 'Haryana',
        pincode: '122011',
        address: 'Pioneer Araya, Golf Course Extn Rd',
        projectType: 'Penthouse Renovation',
        workType: LeadWorkType.woodwork,
        areaSqFt: 4600,
        budgetAmount: 48.0,
        budgetConfidence: 'Strict',
        stage: CrmStage.bookedClient,
        source: LeadSourceType.websiteForm,
        assignedTo: 'Vikram Malhotra',
        meetingPreference: MeetingPreferenceType.siteVisit,
        createdDate: DateTime.now().subtract(const Duration(days: 12)),
        lastContactDate: DateTime.now().subtract(const Duration(days: 1)),
        nextFollowupDate: 'Next Week, 10:00 AM',
        leadScore: 95.0,
        isQualified: true,
        qualificationReason: 'Token amount ₹2,50,000 received. Design agreement signed.',
        tags: const ['Booked', 'Contract Signed'],
        activities: [
          LeadActivityItem(
            id: 'ACT-7',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            employeeName: 'Vikram Malhotra',
            action: 'Booking Token Received',
            details: 'Received ₹2.5L token advance via NEFT. Transitioned to Client Execution.',
            source: 'System',
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
          ),
        ],
      ),
      LeadItem(
        id: 'HOM-LD-1028',
        clientName: 'Deepak & Reena Mittal',
        phone: '+91 97110 55443',
        email: 'deepak.mittal@airtel.com',
        city: 'Faridabad',
        state: 'Haryana',
        pincode: '121002',
        address: 'Sector 14, Urban Estate',
        projectType: '3BHK Floor Renovation',
        workType: LeadWorkType.falseCeiling,
        areaSqFt: 1800,
        budgetAmount: 14.0,
        budgetConfidence: 'Strict',
        stage: CrmStage.notQualified,
        source: LeadSourceType.whatsApp,
        assignedTo: 'Kavita Chawla',
        meetingPreference: MeetingPreferenceType.officeVisit,
        createdDate: DateTime.now().subtract(const Duration(days: 4)),
        lastContactDate: DateTime.now().subtract(const Duration(days: 3)),
        leadScore: 32.0,
        isQualified: false,
        qualificationReason: 'Below minimum turnkey threshold (₹20L) & non-serviceable pincode 121002',
        primaryObjection: 'Price / Budget Mismatch',
        decliningReason: 'Budget constrained to ₹14L; our turnkey starting tier is ₹22L',
        tags: const ['Not Qualified', 'Low Budget'],
      ),
      LeadItem(
        id: 'HOM-LD-1029',
        clientName: 'Amanpreet Singh',
        phone: '+91 98765 12340',
        email: 'aman.singh@chd.in',
        city: 'Gurugram',
        state: 'Haryana',
        pincode: '122009',
        address: 'M3M Golfestate, Sector 65',
        projectType: '4BHK Full Turnkey',
        workType: LeadWorkType.fullTurnkey,
        areaSqFt: 3600,
        budgetAmount: 52.0,
        budgetConfidence: 'Confirmed',
        stage: CrmStage.notResponding,
        source: LeadSourceType.metaLeadAds,
        assignedTo: 'Ananya Verma',
        meetingPreference: MeetingPreferenceType.siteVisit,
        createdDate: DateTime.now().subtract(const Duration(days: 7)),
        lastContactDate: DateTime.now().subtract(const Duration(days: 2)),
        nextFollowupDate: 'Today, 05:30 PM',
        leadScore: 68.0,
        isQualified: true,
        qualificationReason: 'High potential M3M lead; client traveling overseas currently',
        primaryObjection: 'Timeline Delay',
        tags: const ['Follow-up Required', 'Unresponsive'],
      ),
    ]);

    // 2. Seed Customers
    _customers.addAll([
      CustomerItem(
        id: 'HOM-CUST-801',
        leadOriginId: 'HOM-LD-1027',
        name: 'Meera Kapoor',
        phone: '+91 98111 65432',
        email: 'meera.kapoor@studio.design',
        address: 'Pioneer Araya, Golf Course Extn Rd',
        city: 'Gurugram',
        pincode: '122011',
        companyName: 'Kapoor Design Studios',
        activeProjectsCount: 1,
        totalContractValueLakhs: 48.0,
        outstandingDuesLakhs: 36.0,
        salesOwner: 'Vikram Malhotra',
        relationshipManager: 'Neha Deshmukh (Project PM)',
        status: 'Design Approval Stage',
        lastContact: DateTime.now().subtract(const Duration(days: 1)),
        tags: const ['VIP', 'Turnkey Execution', 'Pioneer Araya'],
        satisfactionRating: 4.9,
      ),
      CustomerItem(
        id: 'HOM-CUST-802',
        leadOriginId: 'HOM-LD-0988',
        name: 'Dr. Sameer & Shalini Joshi',
        phone: '+91 98200 33221',
        email: 'dr.joshi@medanta.org',
        address: 'Villa #12, The Magnolias, Golf Course Rd',
        city: 'Gurugram',
        pincode: '122002',
        companyName: 'Medanta Healthcare',
        activeProjectsCount: 2,
        totalContractValueLakhs: 145.0,
        outstandingDuesLakhs: 18.5,
        salesOwner: 'Rajesh Patel',
        relationshipManager: 'Sunil Rao (Senior Lead)',
        status: 'Active Execution (Milestone 3)',
        lastContact: DateTime.now().subtract(const Duration(hours: 12)),
        tags: const ['HNW Elite', 'Turnkey Luxury', 'Two Properties'],
        satisfactionRating: 5.0,
      ),
      CustomerItem(
        id: 'HOM-CUST-803',
        leadOriginId: 'HOM-LD-0940',
        name: 'Tanmay & Ritu Bansal',
        phone: '+91 99100 44556',
        email: 'tanmay.bansal@techcorp.io',
        address: 'Flat 1102, Experion Windchants, Sector 112',
        city: 'Gurugram',
        pincode: '122017',
        activeProjectsCount: 1,
        totalContractValueLakhs: 34.0,
        outstandingDuesLakhs: 0.0,
        salesOwner: 'Priya Sharma',
        relationshipManager: 'Aakash Verma',
        status: 'Handover Completed & Warranty',
        lastContact: DateTime.now().subtract(const Duration(days: 8)),
        tags: const ['Completed', 'Referral Source', '5-Star Feedback'],
        satisfactionRating: 4.8,
      ),
    ]);

    // 3. Seed Funnels
    _funnels.addAll([
      FunnelConfig(
        id: 'funnel_interior_client',
        name: 'Interior Client Funnel',
        description: 'Standard residential & luxury commercial turnkey client acquisition pipeline.',
        stageLabels: [
          'New Enquiry',
          'Qualified',
          'Meeting Done',
          'Booked Clients',
          'Not Responding',
          'Not Qualified',
          'Not Interested',
        ],
        activeLeadsCount: 124,
        formFields: [
          const DynamicFormField(id: 'f1', label: 'Client Full Name', key: 'client_name', type: 'text', isRequired: true, placeholder: 'e.g. Rahul Sharma', order: 1),
          const DynamicFormField(id: 'f2', label: 'Contact Phone', key: 'phone', type: 'phone', isRequired: true, placeholder: '+91 98101 23456', order: 2),
          const DynamicFormField(id: 'f3', label: 'Site Pincode', key: 'pincode', type: 'text', isRequired: true, placeholder: '122002', helpText: 'Used for automatic serviceability qualification', order: 3),
          const DynamicFormField(id: 'f4', label: 'Project Property Type', key: 'project_type', type: 'dropdown', isRequired: true, placeholder: 'Select type', options: ['4BHK Villa', '3BHK Apartment', 'Penthouse', 'Builder Floor'], order: 4),
          const DynamicFormField(id: 'f5', label: 'Scope of Work', key: 'work_type', type: 'dropdown', isRequired: true, placeholder: 'Select scope', options: ['Full Turnkey', 'Woodwork & Modular', 'False Ceiling & Paint'], order: 5),
          const DynamicFormField(id: 'f6', label: 'Estimated Budget (₹ Lakhs)', key: 'budget_lakhs', type: 'currency', isRequired: true, placeholder: 'e.g. 35', helpText: 'Minimum ₹20L for turnkey qualification', order: 6),
        ],
      ),
      FunnelConfig(
        id: 'funnel_job_applicant',
        name: 'Job Applicant Funnel',
        description: 'Recruitment funnel for Interior Designers, 3D Visualizers, and Project Managers.',
        stageLabels: [
          'New Applicants',
          'Qualified',
          'Interview Done',
          'Hired',
          'Rejected',
          'Not Interested',
        ],
        activeLeadsCount: 42,
        formFields: [
          const DynamicFormField(id: 'a1', label: 'Candidate Name', key: 'candidate_name', type: 'text', isRequired: true, placeholder: 'Full Name', order: 1),
          const DynamicFormField(id: 'a2', label: 'Years of Experience', key: 'experience_years', type: 'number', isRequired: true, placeholder: 'e.g. 4.5', order: 2),
          const DynamicFormField(id: 'a3', label: 'Core Software Skills', key: 'software_skills', type: 'dropdown', isRequired: true, placeholder: 'Select tool', options: ['3ds Max + Vray', 'SketchUp + Enscape', 'AutoCAD', 'Revit BIM'], order: 3),
        ],
      ),
      FunnelConfig(
        id: 'funnel_vendor_supplier',
        name: 'Vendor / Supplier Funnel',
        description: 'Procurement intake pipeline for Material Suppliers, Trade Contractors, and Millwork Builders.',
        stageLabels: [
          'New Inquiries',
          'Document Verification',
          'Sample Audit Done',
          'Approved Vendor',
          'Blacklisted',
        ],
        activeLeadsCount: 19,
        formFields: [
          const DynamicFormField(id: 'v1', label: 'Vendor Firm Name', key: 'firm_name', type: 'text', isRequired: true, placeholder: 'Company Name', order: 1),
          const DynamicFormField(id: 'v2', label: 'GST Number', key: 'gst_number', type: 'text', isRequired: true, placeholder: '07AAAAA0000A1Z5', order: 2),
          const DynamicFormField(id: 'v3', label: 'Supply Category', key: 'category', type: 'dropdown', isRequired: true, placeholder: 'Category', options: ['Italian Marble', 'Hardware & Hinges', 'Plywood & Laminates', 'Electricals'], order: 3),
        ],
      ),
    ]);

    // 4. Seed Follow-ups
    _followups.addAll([
      const FollowUpRecord(
        id: 'FOL-201',
        leadId: 'HOM-LD-1024',
        clientName: 'Rahul & Neha Sharma',
        phone: '+91 98101 23456',
        assignedTo: 'Ananya Verma',
        type: CrmFollowUpType.call,
        dueDate: 'Today',
        dueTime: '03:30 PM',
        priority: 'Urgent',
        status: 'Pending',
        notes: 'Confirm Site Measurement schedule for DLF Camellias Apt 1402',
        sentiment: 'hot',
        isDone: false,
      ),
      const FollowUpRecord(
        id: 'FOL-202',
        leadId: 'HOM-LD-1025',
        clientName: 'Vikramaditya Oberoi',
        phone: '+91 99200 88776',
        assignedTo: 'Rajesh Patel',
        type: CrmFollowUpType.quotationFollowUp,
        dueDate: 'Tomorrow',
        dueTime: '11:00 AM',
        priority: 'High',
        status: 'Pending',
        notes: 'Present Rev 2 BOQ for South Extension Duplex Kothi with imported veneer specs',
        sentiment: 'hot',
        isDone: false,
      ),
      const FollowUpRecord(
        id: 'FOL-203',
        leadId: 'HOM-LD-1029',
        clientName: 'Amanpreet Singh',
        phone: '+91 98765 12340',
        assignedTo: 'Ananya Verma',
        type: CrmFollowUpType.whatsApp,
        dueDate: 'Today',
        dueTime: '05:30 PM',
        priority: 'Medium',
        status: 'Overdue',
        notes: 'Send video walkthrough of recent M3M Golfestate penthouse to re-engage',
        sentiment: 'warm',
        isDone: false,
      ),
      const FollowUpRecord(
        id: 'FOL-204',
        leadId: 'HOM-LD-1026',
        clientName: 'Sanjay & Sunita Singhal',
        phone: '+91 98188 44332',
        assignedTo: 'Priya Sharma',
        type: CrmFollowUpType.meeting,
        dueDate: 'Yesterday',
        dueTime: '02:00 PM',
        priority: 'High',
        status: 'Completed',
        notes: 'Introductory Zoom consultation completed. Client requested layout options.',
        sentiment: 'hot',
        isDone: true,
      ),
    ]);

    // 5. Seed Call Logs
    _callLogs.addAll([
      CallLogRecord(
        id: 'CALL-501',
        leadId: 'HOM-LD-1024',
        clientName: 'Rahul & Neha Sharma',
        phone: '+91 98101 23456',
        employeeName: 'Ananya Verma',
        direction: CallDirection.outbound,
        category: CallCategory.manualCall,
        durationSeconds: 412,
        outcome: CallOutcome.qualified,
        recordingUrl: 'https://cdn.homio.in/audio/call_rec_1024_01.mp3',
        transcript: 'Agent: Good afternoon Mr. Sharma, calling from Homio Interior Design...\nClient: Yes Ananya, we received possession for Camellias Apt 1402 yesterday. We need full turnkey including false ceiling and Italian marble flooring.\nAgent: Wonderful congratulations! Our senior architect can visit for laser measurement tomorrow at 3 PM.\nClient: Yes, please book that slot.',
        aiSummary: 'Client received key possession of DLF Camellias 3850 sq.ft unit. Confirmed ₹65L budget. Eager for immediate laser measurement site visit.',
        keyPoints: [
          'Possession received yesterday',
          'Turnkey scope: Italian marble, complete woodwork, false ceiling',
          'Confirmed budget of ₹65 Lakhs',
        ],
        nextAction: 'Schedule on-site laser survey with lead designer',
        sentimentScore: 0.92,
        callTime: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CallLogRecord(
        id: 'CALL-502',
        leadId: 'HOM-LD-1026',
        clientName: 'Sanjay & Sunita Singhal',
        phone: '+91 98188 44332',
        employeeName: 'Priya Sharma',
        direction: CallDirection.outbound,
        category: CallCategory.aiCall,
        durationSeconds: 184,
        outcome: CallOutcome.interested,
        recordingUrl: 'https://cdn.homio.in/audio/call_ai_1026.mp3',
        transcript: 'AI Voice: Hello Mr. Singhal, this is Homio Assistant following up on your inquiry for Godrej Woods Modular Kitchen...\nClient: Yes, I wanted to know if you offer Blum and Hafele fittings?\nAI Voice: Yes absolutely, all our modular cabinets use certified German soft-close mechanisms with a 10-year warranty.\nClient: Great, arrange a call with your kitchen designer.',
        aiSummary: 'AI Bot verified requirement for German modular kitchen in Godrej Woods Sector 43. Verified budget eligibility.',
        keyPoints: [
          'Inquired about Blum & Hafele fittings',
          'Possession in 45 days',
        ],
        nextAction: 'Assign to Priya Sharma for 3D layout options',
        sentimentScore: 0.85,
        callTime: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      CallLogRecord(
        id: 'CALL-503',
        leadId: 'HOM-LD-1028',
        clientName: 'Deepak & Reena Mittal',
        phone: '+91 97110 55443',
        employeeName: 'Kavita Chawla',
        direction: CallDirection.outbound,
        category: CallCategory.manualCall,
        durationSeconds: 110,
        outcome: CallOutcome.notQualified,
        recordingUrl: 'https://cdn.homio.in/audio/call_rec_1028.mp3',
        transcript: 'Agent: Hello Mr. Mittal, following up regarding your interior inquiry for Faridabad.\nClient: Yes, our total budget for 3 rooms is strictly ₹12-14 Lakhs.\nAgent: Sir, our minimum turnkey project value is ₹20 Lakhs with factory-finished modular cabinets.\nClient: Oh, then that is out of our budget.',
        aiSummary: 'Client has budget of ₹14L max for full 3-room remodel. Disqualified per minimum threshold of ₹20L.',
        keyPoints: ['Budget ceiling ₹14L', 'Location Faridabad Sector 14'],
        nextAction: 'Marked Not Qualified (Budget Constraint)',
        sentimentScore: 0.35,
        callTime: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);

    // 6. Seed Meetings
    _meetings.addAll([
      MeetingRecord(
        id: 'MTG-301',
        leadId: 'HOM-LD-1024',
        clientName: 'Rahul & Neha Sharma',
        phone: '+91 98101 23456',
        meetingType: MeetingPreferenceType.siteVisit,
        date: DateTime.now(),
        startTime: '03:30 PM',
        endTime: '05:00 PM',
        salesperson: 'Ananya Verma',
        designer: 'Siddharth Roy (Senior Architect)',
        locationOrLink: 'Tower C, Apt 1402, DLF The Camellias, Gurugram',
        meetingRoom: 'Site Survey Unit #1402',
        agenda: 'Laser site measurement, column mapping & civil modification assessment',
        notes: 'Carrying digital laser meter and material swatches (Veneer & Quartz sample kit).',
        isCompleted: false,
        reminder24hSent: true,
        reminderMorningSent: true,
        reminder1hSent: false,
      ),
      MeetingRecord(
        id: 'MTG-302',
        leadId: 'HOM-LD-1025',
        clientName: 'Vikramaditya Oberoi',
        phone: '+91 99200 88776',
        meetingType: MeetingPreferenceType.officeVisit,
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: '11:00 AM',
        endTime: '12:30 PM',
        salesperson: 'Rajesh Patel',
        designer: 'Aanya Sen (Design Lead)',
        locationOrLink: 'Homio HQ Experience Center, Golf Course Rd',
        meetingRoom: 'Executive Boardroom A (Capacity: 8)',
        agenda: 'Presentation of 3D Lumion VR walkthrough & revised marble estimates',
        notes: 'Client requested French chateau style moodboards.',
        isCompleted: false,
        reminder24hSent: true,
        reminderMorningSent: false,
        reminder1hSent: false,
      ),
      MeetingRecord(
        id: 'MTG-303',
        leadId: 'HOM-LD-1026',
        clientName: 'Sanjay & Sunita Singhal',
        phone: '+91 98188 44332',
        meetingType: MeetingPreferenceType.online,
        date: DateTime.now().subtract(const Duration(days: 1)),
        startTime: '02:00 PM',
        endTime: '02:45 PM',
        salesperson: 'Priya Sharma',
        designer: 'Priya Sharma',
        locationOrLink: 'https://meet.google.com/hom-noid-sng',
        meetingRoom: 'Virtual Google Meet',
        agenda: 'Initial discovery & kitchen layout review',
        notes: 'Presented L-shape vs Island kitchen ergonomics.',
        isCompleted: true,
      ),
    ]);

    // 7. Seed Tasks
    _tasks.addAll([
      const SalesTaskItem(
        id: 'TSK-SL-101',
        title: 'Prepare BOQ & 3D Render Presentation for Camellias',
        description: 'Generate preliminary estimate with Italian Statuario marble & factory cabinetry specs',
        leadId: 'HOM-LD-1024',
        clientName: 'Rahul & Neha Sharma',
        assignedTo: 'Ananya Verma',
        priority: 'Urgent',
        status: CrmTaskStatus.inProgress,
        dueDate: 'Today',
        dueTime: '06:00 PM',
        checklist: [
          'Verify site survey laser dimensions',
          'Calculate false ceiling running sq.ft',
          'Apply 10% seasonal contractor incentive',
        ],
        notes: ['Client is price-insensitive but values handover speed before Diwali.'],
      ),
      const SalesTaskItem(
        id: 'TSK-SL-102',
        title: 'Send Revised Veneer Palette to Oberoi Duplex',
        description: 'Courier physical veneer box and brass profile handles to Defence Colony site office',
        leadId: 'HOM-LD-1025',
        clientName: 'Vikramaditya Oberoi',
        assignedTo: 'Rajesh Patel',
        priority: 'High',
        status: CrmTaskStatus.todo,
        dueDate: 'Tomorrow',
        dueTime: '01:00 PM',
        checklist: ['Pack 6 smoked oak samples', 'Attach rate master specifications'],
      ),
      const SalesTaskItem(
        id: 'TSK-SL-103',
        title: 'Complete Handover Document Docket for Meera Kapoor',
        description: 'Verify warranty cards for Hafele hardware and Blum tandem boxes',
        leadId: 'HOM-LD-1027',
        clientName: 'Meera Kapoor',
        customerName: 'Meera Kapoor (HOM-CUST-801)',
        assignedTo: 'Vikram Malhotra',
        priority: 'Medium',
        status: CrmTaskStatus.completed,
        dueDate: 'Yesterday',
        dueTime: '04:00 PM',
        checklist: ['Quality manager signoff', 'Signed completion handover certificate'],
      ),
    ]);

    // 8. Seed Automations
    _automations.addAll([
      const AutomationWorkflow(
        id: 'AUTO-1',
        title: 'Auto-Send Welcome Brochure & Portfolio Video',
        description: 'When lead is marked Qualified, automatically dispatch WhatsApp introduction & company credentials.',
        trigger: AutomationTrigger.leadQualified,
        conditionSummary: 'Budget >= ₹25L AND City in [Gurugram, New Delhi, Noida]',
        actionSummary: 'Send WhatsApp template "luxury_portfolio_v2" + create follow-up task after 24h',
        isActive: true,
        runsToday: 14,
        successfulRuns: 14,
        failedRuns: 0,
      ),
      const AutomationWorkflow(
        id: 'AUTO-2',
        title: 'Post-Meeting Thank You & Quotation Timeline',
        description: 'Triggered upon completing a site or experience center consultation meeting.',
        trigger: AutomationTrigger.meetingCompleted,
        conditionSummary: 'Meeting outcome = "Completed Successfully"',
        actionSummary: 'Send personalized WhatsApp summary with 48-hour quotation delivery commitment',
        isActive: true,
        runsToday: 8,
        successfulRuns: 8,
        failedRuns: 0,
      ),
      const AutomationWorkflow(
        id: 'AUTO-3',
        title: 'Client Booking Onboarding Kit & Handover',
        description: 'Triggered when token booking is closed and agreement signed.',
        trigger: AutomationTrigger.bookingCompleted,
        conditionSummary: 'Token advance >= ₹1,00,000 confirmed by Accounts',
        actionSummary: 'Send "Welcome to Homio Family" kit, auto-provision Customer record & notify Project Manager',
        isActive: true,
        runsToday: 2,
        successfulRuns: 2,
        failedRuns: 0,
      ),
      const AutomationWorkflow(
        id: 'AUTO-4',
        title: 'Unresponsive Lead Nurture Drip Sequence',
        description: 'Re-engage leads in "Not Responding" stage over 7 days with high-value design case studies.',
        trigger: AutomationTrigger.noResponse,
        conditionSummary: 'Stage = "Not Responding" for > 48 hours',
        actionSummary: 'Step 1: Day 2 Case study video -> Step 2: Day 4 Client testimonial -> Step 3: Day 7 Special offer',
        isActive: true,
        runsToday: 22,
        successfulRuns: 21,
        failedRuns: 1,
      ),
    ]);
  }

  // ===========================================================================
  // 1. OVERVIEW & TELEMETRY
  // ===========================================================================

  Future<SalesOverviewSummary> getOverviewSummary({
    String dateFilter = 'This Month',
    String scopeFilter = 'My Work',
    String? funnelId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final totalNewLeads = _leads.length * 20 + 4; // 124 realistic CRM scale
    final activeFollowups = _followups.where((f) => !f.isDone).length;
    final completedFollowups = _followups.where((f) => f.isDone).length;
    final scheduledMeetings = _meetings.where((m) => !m.isCompleted).length * 6;
    final completedMeetings = _meetings.where((m) => m.isCompleted).length * 8;
    final totalBookings = 6;
    final totalBookingValue = 48.5; // Lakhs
    final conversion = 18.6; // %

    final Map<String, int> funnelCounts = {
      'new_enquiry': 124,
      'qualified': 82,
      'meeting_done': 45,
      'booked_client': 18,
    };

    final Map<String, int> distributionCounts = {
      'Qualified': 82,
      'Meeting Done': 45,
      'Booked Client': 18,
      'Not Responding': 28,
      'Not Qualified': 34,
      'Not Interested': 12,
    };

    final teamRankings = [
      const SalesTeamMemberMetric(
        employeeName: 'Ananya Verma',
        role: 'Senior Design Consultant',
        rank: 1,
        leadsAssigned: 38,
        callsCompleted: 142,
        talkTimeMinutes: 480,
        meetingsHosted: 16,
        bookingsClosed: 4,
        revenueGeneratedLakhs: 185.0,
        conversionRate: 22.4,
      ),
      const SalesTeamMemberMetric(
        employeeName: 'Rajesh Patel',
        role: 'Deal Closer (Luxury Kothis)',
        rank: 2,
        leadsAssigned: 26,
        callsCompleted: 98,
        talkTimeMinutes: 340,
        meetingsHosted: 12,
        bookingsClosed: 3,
        revenueGeneratedLakhs: 160.0,
        conversionRate: 20.1,
      ),
      const SalesTeamMemberMetric(
        employeeName: 'Vikram Malhotra',
        role: 'Sales Head (Turnkey Execution)',
        rank: 3,
        leadsAssigned: 30,
        callsCompleted: 110,
        talkTimeMinutes: 390,
        meetingsHosted: 14,
        bookingsClosed: 3,
        revenueGeneratedLakhs: 142.5,
        conversionRate: 19.5,
      ),
      const SalesTeamMemberMetric(
        employeeName: 'Priya Sharma',
        role: 'Consultant (Modular Kitchens)',
        rank: 4,
        leadsAssigned: 30,
        callsCompleted: 125,
        talkTimeMinutes: 310,
        meetingsHosted: 9,
        bookingsClosed: 2,
        revenueGeneratedLakhs: 85.0,
        conversionRate: 14.8,
      ),
    ];

    final recentActivities = [
      LeadActivityItem(
        id: 'ACT-LIVE-1',
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
        employeeName: 'Ananya Verma',
        action: 'Lead Qualified',
        details: 'Verified DLF The Camellias 4BHK enquiry (₹65L confirmed budget)',
        source: 'System',
        icon: Icons.verified_rounded,
        iconColor: Colors.purple,
      ),
      LeadActivityItem(
        id: 'ACT-LIVE-2',
        timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
        employeeName: 'Rajesh Patel',
        action: 'Meeting Scheduled',
        details: 'Executive boardroom presentation booked for Vikramaditya Oberoi tomorrow 11:00 AM',
        source: 'Meeting',
        icon: Icons.calendar_month_rounded,
        iconColor: Colors.blue,
      ),
      LeadActivityItem(
        id: 'ACT-LIVE-3',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
        employeeName: 'Automation Engine',
        action: 'WhatsApp Brochure Sent',
        details: 'Dispatched Luxury Italian Kitchen brochure to Sanjay Singhal (+91 98188 44332)',
        source: 'WhatsApp',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: Colors.green,
      ),
      LeadActivityItem(
        id: 'ACT-LIVE-4',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 25)),
        employeeName: 'Vikram Malhotra',
        action: 'Quotation Created',
        details: 'Generated Rev 1 BOQ (₹48L) for Pioneer Araya penthouse project',
        source: 'Quotation',
        icon: Icons.receipt_long_rounded,
        iconColor: Colors.amber,
      ),
      LeadActivityItem(
        id: 'ACT-LIVE-5',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        employeeName: 'Accounts / Sunil Rao',
        action: 'Lead Converted to Customer',
        details: 'Received ₹2.5L token booking advance for Meera Kapoor (HOM-CUST-801)',
        source: 'Booking',
        icon: Icons.check_circle_outline_rounded,
        iconColor: Colors.teal,
      ),
    ];

    return SalesOverviewSummary(
      newLeads: totalNewLeads,
      newLeadsGrowthPercent: 12.4,
      todayFollowups: activeFollowups,
      pendingFollowups: activeFollowups + completedFollowups,
      meetingsScheduled: scheduledMeetings,
      meetingsCompleted: completedMeetings,
      bookingsClosed: totalBookings,
      bookingValueLakhs: totalBookingValue,
      conversionRate: conversion,
      monthlyBookingTargetCr: 1.50,
      actualBookingLakhs: 96.5,
      targetAchievementPercent: 64.3,
      remainingTargetLakhs: 53.5,
      funnelCounts: funnelCounts,
      distributionCounts: distributionCounts,
      teamRankings: teamRankings,
      recentActivities: recentActivities,
    );
  }

  // ===========================================================================
  // 2. LEADS MANAGEMENT & DUPLICATE CHECKING
  // ===========================================================================

  Future<List<LeadItem>> getLeads({
    String? query,
    CrmStage? stage,
    LeadSourceType? source,
    String? assignedTo,
    double? minBudget,
    double? maxBudget,
    String? tag,
    LeadWorkType? workType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 120));
    var results = List<LeadItem>.from(_leads);

    if (stage != null) {
      results = results.where((l) => l.stage == stage).toList();
    }
    if (source != null) {
      results = results.where((l) => l.source == source).toList();
    }
    if (workType != null) {
      results = results.where((l) => l.workType == workType).toList();
    }
    if (assignedTo != null && assignedTo.isNotEmpty && assignedTo != 'All') {
      results = results.where((l) => l.assignedTo == assignedTo).toList();
    }
    if (minBudget != null) {
      results = results.where((l) => l.budgetAmount >= minBudget).toList();
    }
    if (maxBudget != null) {
      results = results.where((l) => l.budgetAmount <= maxBudget).toList();
    }
    if (tag != null && tag.isNotEmpty && tag != 'All') {
      results = results.where((l) => l.tags.contains(tag)).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((l) {
        return l.clientName.toLowerCase().contains(q) ||
            l.phone.contains(q) ||
            l.email.toLowerCase().contains(q) ||
            l.id.toLowerCase().contains(q) ||
            l.city.toLowerCase().contains(q) ||
            l.address.toLowerCase().contains(q) ||
            l.projectType.toLowerCase().contains(q) ||
            l.assignedTo.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }

  /// Get lead by ID
  LeadItem? getLeadById(String id) {
    try {
      return _leads.firstWhere((l) => l.id == id);
    } catch (_) {
      return _leads.isNotEmpty ? _leads.first : null;
    }
  }

  /// Checks for duplicate leads by phone, email, or name+phone match
  LeadItem? checkDuplicateLead({required String phone, required String email, required String name}) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim().toLowerCase();

    for (final existing in _leads) {
      final existingPhone = existing.phone.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanPhone.isNotEmpty && existingPhone.endsWith(cleanPhone.substring(cleanPhone.length > 8 ? cleanPhone.length - 8 : 0))) {
        return existing;
      }
      if (cleanEmail.isNotEmpty && existing.email.toLowerCase() == cleanEmail) {
        return existing;
      }
      if (cleanName.isNotEmpty && existing.clientName.toLowerCase() == cleanName && existingPhone == cleanPhone) {
        return existing;
      }
    }
    return null;
  }

  /// Automatically tests if lead qualifies based on service area pin code & minimum budget (₹20L)
  bool evaluateLeadQualification({required String pincode, required double budgetAmount}) {
    final cleanPin = pincode.trim();
    final isPincodeServiceable = _serviceablePincodes.contains(cleanPin);
    final isBudgetEligible = budgetAmount >= 20.0;
    return isPincodeServiceable && isBudgetEligible;
  }

  Future<LeadItem> createLead(LeadItem lead, {bool bypassDuplicate = false}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _leads.insert(0, lead);
    return lead;
  }

  Future<LeadItem> updateLeadStage(String leadId, CrmStage newStage, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _leads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final old = _leads[index];
      final newActivity = LeadActivityItem(
        id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        employeeName: 'Current User',
        action: 'Stage Changed to ${newStage.label}',
        details: reason ?? 'Stage updated in CRM Kanban / Table view',
        source: 'Manual',
        icon: newStage.icon,
        iconColor: newStage.color,
      );

      final updated = old.copyWith(
        stage: newStage,
        activities: [newActivity, ...old.activities],
      );
      _leads[index] = updated;

      // If booked, auto-create customer entry
      if (newStage == CrmStage.bookedClient) {
        _createCustomerFromLead(updated);
      }

      return updated;
    }
    throw Exception('Lead not found: $leadId');
  }

  void _createCustomerFromLead(LeadItem lead) {
    final exists = _customers.any((c) => c.leadOriginId == lead.id);
    if (!exists) {
      final newCust = CustomerItem(
        id: 'HOM-CUST-${_customers.length + 804}',
        leadOriginId: lead.id,
        name: lead.clientName,
        phone: lead.phone,
        alternatePhone: lead.alternatePhone,
        email: lead.email,
        address: lead.address,
        city: lead.city,
        pincode: lead.pincode,
        activeProjectsCount: 1,
        totalContractValueLakhs: lead.budgetAmount,
        outstandingDuesLakhs: lead.budgetAmount * 0.85,
        salesOwner: lead.assignedTo,
        relationshipManager: 'Aanya Sen (PM)',
        status: 'Design Approval Stage',
        lastContact: DateTime.now(),
        tags: ['New Customer', ...lead.tags],
      );
      _customers.insert(0, newCust);
    }
  }

  Future<void> bulkAssignLeads(List<String> leadIds, String assignedTo) async {
    await Future.delayed(const Duration(milliseconds: 120));
    for (int i = 0; i < _leads.length; i++) {
      if (leadIds.contains(_leads[i].id)) {
        _leads[i] = _leads[i].copyWith(assignedTo: assignedTo);
      }
    }
  }

  Future<void> bulkUpdateStage(List<String> leadIds, CrmStage stage) async {
    await Future.delayed(const Duration(milliseconds: 120));
    for (int i = 0; i < _leads.length; i++) {
      if (leadIds.contains(_leads[i].id)) {
        _leads[i] = _leads[i].copyWith(stage: stage);
      }
    }
  }

  // ===========================================================================
  // 3. CUSTOMERS DIRECTORY & 360
  // ===========================================================================

  Future<List<CustomerItem>> getCustomers({String? query, String? status}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = List<CustomerItem>.from(_customers);

    if (status != null && status.isNotEmpty && status != 'All') {
      results = results.where((c) => c.status.toLowerCase().contains(status.toLowerCase())).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.phone.contains(q) ||
            c.email.toLowerCase().contains(q) ||
            c.id.toLowerCase().contains(q) ||
            c.address.toLowerCase().contains(q) ||
            c.salesOwner.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }

  // ===========================================================================
  // 4. FUNNELS & DYNAMIC FORMS
  // ===========================================================================

  Future<List<FunnelConfig>> getFunnels() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return List<FunnelConfig>.from(_funnels);
  }

  Future<void> addFunnelStage(String funnelId, String stageName) async {
    final idx = _funnels.indexWhere((f) => f.id == funnelId);
    if (idx != -1) {
      final existing = _funnels[idx];
      final newStages = List<String>.from(existing.stageLabels)..add(stageName);
      _funnels[idx] = FunnelConfig(
        id: existing.id,
        name: existing.name,
        description: existing.description,
        stageLabels: newStages,
        formFields: existing.formFields,
        activeLeadsCount: existing.activeLeadsCount,
      );
    }
  }

  // ===========================================================================
  // 5. FOLLOW-UPS
  // ===========================================================================

  Future<List<FollowUpRecord>> getFollowUps({
    String? dateFilter,
    String? status,
    CrmFollowUpType? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 90));
    var results = List<FollowUpRecord>.from(_followups);

    if (type != null) {
      results = results.where((f) => f.type == type).toList();
    }
    if (status != null && status.isNotEmpty && status != 'All') {
      results = results.where((f) => f.status.toLowerCase() == status.toLowerCase()).toList();
    }

    return results;
  }

  Future<FollowUpRecord> toggleFollowUpDone(String id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final idx = _followups.indexWhere((f) => f.id == id);
    if (idx != -1) {
      final item = _followups[idx];
      final updated = item.copyWith(
        isDone: !item.isDone,
        status: !item.isDone ? 'Completed' : 'Pending',
      );
      _followups[idx] = updated;
      return updated;
    }
    throw Exception('Follow-up not found: $id');
  }

  Future<FollowUpRecord> toggleFollowUpComplete(String id) => toggleFollowUpDone(id);

  Future<void> rescheduleFollowUp(String id, String newDate, String newTime) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final idx = _followups.indexWhere((f) => f.id == id);
    if (idx != -1) {
      _followups[idx] = _followups[idx].copyWith(
        dueDate: newDate,
        dueTime: newTime,
        status: 'Rescheduled',
      );
    }
  }

  // ===========================================================================
  // 6. CALLS & AI AUTODIALER
  // ===========================================================================

  Future<List<CallLogRecord>> getCallLogs({
    String? query,
    CallOutcome? outcome,
    CallCategory? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 90));
    var results = List<CallLogRecord>.from(_callLogs);

    if (outcome != null) {
      results = results.where((c) => c.outcome == outcome).toList();
    }
    if (category != null) {
      results = results.where((c) => c.category == category).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((c) =>
          c.clientName.toLowerCase().contains(q) ||
          c.phone.contains(q) ||
          c.employeeName.toLowerCase().contains(q) ||
          c.aiSummary.toLowerCase().contains(q)).toList();
    }

    return results;
  }

  // ===========================================================================
  // 7. MEETINGS & CALENDAR
  // ===========================================================================

  Future<List<MeetingRecord>> getMeetings({
    DateTime? date,
    MeetingPreferenceType? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 90));
    var results = List<MeetingRecord>.from(_meetings);

    if (type != null) {
      results = results.where((m) => m.meetingType == type).toList();
    }

    return results;
  }

  Future<MeetingRecord> createMeeting(MeetingRecord meeting) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _meetings.insert(0, meeting);
    return meeting;
  }

  Future<MeetingRecord> toggleMeetingCompleted(String id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final idx = _meetings.indexWhere((m) => m.id == id);
    if (idx != -1) {
      final item = _meetings[idx];
      final updated = item.copyWith(isCompleted: !item.isCompleted);
      _meetings[idx] = updated;
      return updated;
    }
    throw Exception('Meeting not found: $id');
  }

  // ===========================================================================
  // 8. SALES TASKS
  // ===========================================================================

  Future<List<SalesTaskItem>> getTasks({
    CrmTaskStatus? status,
    String? priority,
  }) async {
    await Future.delayed(const Duration(milliseconds: 80));
    var results = List<SalesTaskItem>.from(_tasks);

    if (status != null) {
      results = results.where((t) => t.status == status).toList();
    }
    if (priority != null && priority.isNotEmpty && priority != 'All') {
      results = results.where((t) => t.priority.toLowerCase() == priority.toLowerCase()).toList();
    }

    return results;
  }

  Future<SalesTaskItem> updateTaskStatus(String id, CrmTaskStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 70));
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final updated = _tasks[idx].copyWith(status: newStatus);
      _tasks[idx] = updated;
      return updated;
    }
    throw Exception('Task not found: $id');
  }

  Future<SalesTaskItem> createTask(SalesTaskItem task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.insert(0, task);
    return task;
  }

  // ===========================================================================
  // 9. SALES AUTOMATION
  // ===========================================================================

  Future<List<AutomationWorkflow>> getAutomations() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return List<AutomationWorkflow>.from(_automations);
  }

  Future<AutomationWorkflow> toggleAutomation(String id) async {
    await Future.delayed(const Duration(milliseconds: 70));
    final idx = _automations.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final updated = _automations[idx].copyWith(isActive: !_automations[idx].isActive);
      _automations[idx] = updated;
      return updated;
    }
    throw Exception('Automation not found: $id');
  }
}
