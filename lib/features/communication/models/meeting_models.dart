enum MeetingType {
  siteInspection,
  designReviewVideo,
  showroomVisit,
  milestoneSignoff,
  snagWalkthrough,
}

enum MeetingStatus {
  upcoming,
  completed,
  cancelled,
  rescheduled,
}

class ScheduledMeeting {
  final String id;
  final String title;
  final String projectTitle;
  final String clientName;
  final String clientPhone;
  final MeetingType type;
  DateTime dateTime;
  final int durationMinutes;
  final String locationOrLink;
  final bool isOnline;
  MeetingStatus status;
  final List<String> assignedStaff;
  final String agenda;
  String? outcomeNotes;
  final List<String> actionItems;
  bool whatsappReminderSent;

  ScheduledMeeting({
    required this.id,
    required this.title,
    required this.projectTitle,
    required this.clientName,
    required this.clientPhone,
    required this.type,
    required this.dateTime,
    required this.durationMinutes,
    required this.locationOrLink,
    required this.isOnline,
    required this.status,
    required this.assignedStaff,
    required this.agenda,
    this.outcomeNotes,
    required this.actionItems,
    this.whatsappReminderSent = false,
  });

  String get typeLabel {
    switch (type) {
      case MeetingType.siteInspection:
        return 'Site Inspection';
      case MeetingType.designReviewVideo:
        return '3D Design Review (Video)';
      case MeetingType.showroomVisit:
        return 'Showroom / Material Selection';
      case MeetingType.milestoneSignoff:
        return 'Milestone Signoff';
      case MeetingType.snagWalkthrough:
        return 'Snag Walkthrough & Handover';
    }
  }
}

class MeetingMockData {
  static final List<ScheduledMeeting> meetings = [
    ScheduledMeeting(
      id: 'mtg_001',
      title: 'False Ceiling & Electrical Conduit On-Site Walkthrough',
      projectTitle: 'Villa #42 - Palm Meadows',
      clientName: 'Vikram Malhotra',
      clientPhone: '+91 98201 44521',
      type: MeetingType.siteInspection,
      dateTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      durationMinutes: 45,
      locationOrLink: 'Site: Plot 42, Palm Meadows, Whitefield',
      isOnline: false,
      status: MeetingStatus.upcoming,
      assignedStaff: ['Ar. Rohan Sen', 'Kishore Kumar (Site Eng)'],
      agenda: 'Inspect gypsum channel framework, mark perimeter cove light drivers, and check living room speaker conduit runs.',
      actionItems: [],
      whatsappReminderSent: true,
    ),
    ScheduledMeeting(
      id: 'mtg_002',
      title: 'Living Room 3D Photorealistic Lighting & Furniture Walkthrough',
      projectTitle: 'Skyline Towers #14B',
      clientName: 'Ananya Deshmukh',
      clientPhone: '+91 97654 32190',
      type: MeetingType.designReviewVideo,
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      durationMinutes: 60,
      locationOrLink: 'https://meet.google.com/hmo-arch-skyline',
      isOnline: true,
      status: MeetingStatus.upcoming,
      assignedStaff: ['Neha Kulkarni (Visualizer)', 'Priya Sharma'],
      agenda: 'Screen-share 4K Unreal 5 interactive render. Review modular sofa upholstery fabric options and dining pendant height.',
      actionItems: [],
      whatsappReminderSent: false,
    ),
    ScheduledMeeting(
      id: 'mtg_003',
      title: 'Italian Marble Quarry Batch Selection & Vein Matching',
      projectTitle: 'Greenwood Penthouse 901',
      clientName: 'Rajesh Gupta',
      clientPhone: '+91 94480 12345',
      type: MeetingType.showroomVisit,
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 5)),
      durationMinutes: 90,
      locationOrLink: 'Homio Luxury Experience Centre, MG Road, Bengaluru',
      isOnline: false,
      status: MeetingStatus.upcoming,
      assignedStaff: ['Deepak Rao', 'Sunil Patil'],
      agenda: 'Physical review of slab lots A1 to A4. Mark cutting layout for book-match master foyer.',
      actionItems: [],
      whatsappReminderSent: true,
    ),
    ScheduledMeeting(
      id: 'mtg_004',
      title: 'Civil Demolition & Partition Wall Inspection',
      projectTitle: 'Prestige Lakeside #304',
      clientName: 'Sameer Joshi',
      clientPhone: '+91 98112 76543',
      type: MeetingType.siteInspection,
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      durationMinutes: 40,
      locationOrLink: 'Prestige Lakeside Flat 304',
      isOnline: false,
      status: MeetingStatus.completed,
      assignedStaff: ['Amit Verma (Site Ops)'],
      agenda: 'Verify structural column clearances before knocking down kitchen divider wall.',
      outcomeNotes: 'Structural clearance verified. Approved removal of non-load bearing 4-inch aerocon block partition. Heavy duty dust zipper screen deployed.',
      actionItems: [
        'Commence block removal with low-vibration cutter',
        'Deploy air scrubber in adjoining corridor',
      ],
      whatsappReminderSent: true,
    ),
    ScheduledMeeting(
      id: 'mtg_005',
      title: 'Pre-Handover Snag List & Polish Touchup Signoff',
      projectTitle: 'Sobha Royal 4BHK Duplex',
      clientName: 'Kavita Nair',
      clientPhone: '+91 99001 88765',
      type: MeetingType.snagWalkthrough,
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      durationMinutes: 75,
      locationOrLink: 'Sobha Royal Penthouse #2101',
      isOnline: false,
      status: MeetingStatus.completed,
      assignedStaff: ['Ar. Rohan Sen', 'Priya Sharma'],
      agenda: 'Walkthrough of 32 snag points logged in Homio CRM. Verify touchups on PU paint and wardrobe soft-close hinges.',
      outcomeNotes: '30 of 32 items passed. 2 minor silicone beadings in master shower glass to be redone tomorrow morning.',
      actionItems: [
        'Re-caulk master shower cubicle with anti-fungal clear silicone',
        'Prepare final key handover warranty package',
      ],
      whatsappReminderSent: true,
    ),
  ];
}
