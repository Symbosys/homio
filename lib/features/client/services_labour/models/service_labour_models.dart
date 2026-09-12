import 'package:flutter/material.dart';

/// Trade / service category item
class ServiceCategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final int providerCount;
  final String description;

  const ServiceCategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.providerCount,
    required this.description,
  });
}

/// Customer review for a service provider
class ServiceProviderReview {
  final String clientName;
  final double rating;
  final String date;
  final String comment;

  const ServiceProviderReview({
    required this.clientName,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

/// Verified technician / labour profile
class LabourServiceProvider {
  final String id;
  final String name;
  final String trade;
  final bool isVerified;
  final double rating;
  final int completedJobs;
  final int dailyRate; // e.g. 900
  final int hourlyRate; // e.g. 150
  final int experienceYears;
  final String serviceArea;
  final String availabilityStatus; // 'Available Today', 'Busy', 'Scheduled'
  final List<String> skills;
  final String bio;
  final List<ServiceProviderReview> reviews;
  final List<String> portfolioImages;
  final Color avatarColor;
  final String initials;

  const LabourServiceProvider({
    required this.id,
    required this.name,
    required this.trade,
    this.isVerified = true,
    required this.rating,
    required this.completedJobs,
    required this.dailyRate,
    required this.hourlyRate,
    required this.experienceYears,
    required this.serviceArea,
    required this.availabilityStatus,
    required this.skills,
    required this.bio,
    required this.reviews,
    required this.portfolioImages,
    required this.avatarColor,
    required this.initials,
  });
}

/// Step in the 10-stage service booking lifecycle
class ServiceLifecycleStep {
  final int index;
  final String title;
  final String? subtitle;
  final String? timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const ServiceLifecycleStep({
    required this.index,
    required this.title,
    this.subtitle,
    this.timestamp,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

/// Daily photo & note update logged during service execution
class DailyWorkUpdate {
  final String id;
  final String date;
  final String note;
  final int photoCount;
  final List<String> photoLabels;

  const DailyWorkUpdate({
    required this.id,
    required this.date,
    required this.note,
    required this.photoCount,
    required this.photoLabels,
  });
}

/// Active or historical customer service booking
class ServiceBooking {
  final String id; // e.g. SRV-2026-00482
  final String serviceType;
  final LabourServiceProvider provider;
  final String projectName;
  final String projectId;
  final int workerCount;
  final String workDescription;
  final String propertyAddress;
  final String startDate;
  final String? startTime;
  final String estimatedDuration;
  final String requiredCompletionDate;
  final int dealValue;
  final int paidAmount;
  int get pendingAmount => dealValue - paidAmount;
  final String paymentStatus; // 'Partially Paid', 'Paid', 'Pending'
  String status; // 'Work in Progress', 'Completed', 'Awaiting Verification', 'Cancelled'
  final int currentStepIndex; // 0 to 9
  final String? checkInTimestamp;
  final List<DailyWorkUpdate> dailyUpdates;
  final bool isCompletionConfirmed;
  bool isRated;

  ServiceBooking({
    required this.id,
    required this.serviceType,
    required this.provider,
    required this.projectName,
    required this.projectId,
    required this.workerCount,
    required this.workDescription,
    required this.propertyAddress,
    required this.startDate,
    this.startTime,
    required this.estimatedDuration,
    required this.requiredCompletionDate,
    required this.dealValue,
    required this.paidAmount,
    required this.paymentStatus,
    required this.status,
    required this.currentStepIndex,
    this.checkInTimestamp,
    required this.dailyUpdates,
    this.isCompletionConfirmed = false,
    this.isRated = false,
  });

  List<ServiceLifecycleStep> get lifecycleSteps => [
        ServiceLifecycleStep(
          index: 0,
          title: 'Request Submitted',
          subtitle: 'Booking request received by HOMIO dispatch',
          timestamp: '$startDate · 09:00 AM',
          isCompleted: currentStepIndex >= 0,
          isCurrent: currentStepIndex == 0,
        ),
        ServiceLifecycleStep(
          index: 1,
          title: 'Professional Assigned',
          subtitle: '${provider.name} (${provider.trade}) matched',
          timestamp: '$startDate · 09:30 AM',
          isCompleted: currentStepIndex >= 1,
          isCurrent: currentStepIndex == 1,
        ),
        ServiceLifecycleStep(
          index: 2,
          title: 'Accepted',
          subtitle: 'Provider confirmed work schedule & scope',
          timestamp: '$startDate · 09:45 AM',
          isCompleted: currentStepIndex >= 2,
          isCurrent: currentStepIndex == 2,
        ),
        ServiceLifecycleStep(
          index: 3,
          title: 'Checked In',
          subtitle: 'Provider arrived at project site address',
          timestamp: checkInTimestamp ?? '$startDate · 10:05 AM',
          isCompleted: currentStepIndex >= 3,
          isCurrent: currentStepIndex == 3,
        ),
        ServiceLifecycleStep(
          index: 4,
          title: 'Work Started',
          subtitle: 'Site preparation & safety checklist completed',
          timestamp: '$startDate · 10:30 AM',
          isCompleted: currentStepIndex >= 4,
          isCurrent: currentStepIndex == 4,
        ),
        ServiceLifecycleStep(
          index: 5,
          title: 'Work In Progress',
          subtitle: 'Executing daily tasks with supervisor verification',
          timestamp: 'Active Now',
          isCompleted: currentStepIndex >= 5,
          isCurrent: currentStepIndex == 5,
        ),
        ServiceLifecycleStep(
          index: 6,
          title: 'Supervisor Verification',
          subtitle: 'QA audit of joinery and alignment passed',
          timestamp: currentStepIndex >= 6 ? 'Verified' : 'Pending',
          isCompleted: currentStepIndex >= 6,
          isCurrent: currentStepIndex == 6,
        ),
        ServiceLifecycleStep(
          index: 7,
          title: 'Completed',
          subtitle: 'Debris cleared and client handover signoff',
          timestamp: currentStepIndex >= 7 ? requiredCompletionDate : 'Scheduled',
          isCompleted: currentStepIndex >= 7,
          isCurrent: currentStepIndex == 7,
        ),
        ServiceLifecycleStep(
          index: 8,
          title: 'Settlement',
          subtitle: 'Milestone balance payment released',
          timestamp: currentStepIndex >= 8 ? 'Settled' : 'Pending',
          isCompleted: currentStepIndex >= 8,
          isCurrent: currentStepIndex == 8,
        ),
        ServiceLifecycleStep(
          index: 9,
          title: 'Customer Rating',
          subtitle: 'Rate provider workmanship and timeliness',
          timestamp: isRated ? 'Rated 5★' : 'Awaiting Review',
          isCompleted: isRated,
          isCurrent: currentStepIndex >= 7 && !isRated,
        ),
      ];
}

/// Central Repository for Services and Labour Booking
class ServiceRepository {
  ServiceRepository._();
  static final ServiceRepository instance = ServiceRepository._();

  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  final List<ServiceCategoryItem> categories = const [
    ServiceCategoryItem(
      id: 'cat_all',
      name: 'All Trades',
      icon: Icons.grid_view_rounded,
      providerCount: 42,
      description: 'Explore all vetted technicians',
    ),
    ServiceCategoryItem(
      id: 'cat_carpenter',
      name: 'Carpenter',
      icon: Icons.carpenter_rounded,
      providerCount: 14,
      description: 'Modular kitchen, wardrobes, laminate & joinery',
    ),
    ServiceCategoryItem(
      id: 'cat_electrician',
      name: 'Electrician',
      icon: Icons.electrical_services_rounded,
      providerCount: 9,
      description: 'Concealed wiring, DB dressing, track lights & VRV',
    ),
    ServiceCategoryItem(
      id: 'cat_plumber',
      name: 'Plumber',
      icon: Icons.plumbing_rounded,
      providerCount: 8,
      description: 'CP fittings, sanitary ware, pressure pump & piping',
    ),
    ServiceCategoryItem(
      id: 'cat_painter',
      name: 'Painter',
      icon: Icons.format_paint_rounded,
      providerCount: 6,
      description: 'PU finish, duco, royal luxury emulsion & texture',
    ),
    ServiceCategoryItem(
      id: 'cat_mason',
      name: 'Mason & Civil',
      icon: Icons.construction_rounded,
      providerCount: 5,
      description: 'Core drilling, brickwork, tile leveling & plaster',
    ),
    ServiceCategoryItem(
      id: 'cat_pop',
      name: 'POP & False Ceiling',
      icon: Icons.architecture_rounded,
      providerCount: 4,
      description: 'Gypsum board, cove molding & acoustic ceiling',
    ),
  ];

  final List<LabourServiceProvider> providers = [
    const LabourServiceProvider(
      id: 'prov_rajesh',
      name: 'Rajesh Kumar',
      trade: 'Master Carpenter',
      isVerified: true,
      rating: 4.8,
      completedJobs: 124,
      dailyRate: 900,
      hourlyRate: 140,
      experienceYears: 12,
      serviceArea: 'Dhanbad & Bokaro Central',
      availabilityStatus: 'Available Today',
      skills: ['Modular Kitchen', 'Hafele Hardware', 'Veneer Pressing', 'Flush Doors', 'Laser Alignment'],
      bio: 'Over 12 years of specialized experience in high-end residential joinery, modular kitchens, and veneer lamination with laser precision.',
      reviews: [
        ServiceProviderReview(
          clientName: 'Amit Kumar',
          rating: 5.0,
          date: 'Sep 10, 2026',
          comment: 'Outstanding kitchen cabinetry fitting. Completed exactly on time with zero gaps.',
        ),
        ServiceProviderReview(
          clientName: 'Suresh Patel',
          rating: 4.8,
          date: 'Aug 24, 2026',
          comment: 'Very polite, disciplined crew. Cleans up sawdust thoroughly before leaving.',
        ),
      ],
      portfolioImages: ['Kitchen Cabinets', 'TV Console', 'Master Wardrobe'],
      avatarColor: Color(0xFF0EA5E9),
      initials: 'RK',
    ),
    const LabourServiceProvider(
      id: 'prov_sunil',
      name: 'Sunil Sharma',
      trade: 'Senior Electrician',
      isVerified: true,
      rating: 4.9,
      completedJobs: 98,
      dailyRate: 850,
      hourlyRate: 130,
      experienceYears: 10,
      serviceArea: 'Dhanbad Urban & Coal City',
      availabilityStatus: 'Available Today',
      skills: ['Concealed Wiring', 'Schneider DB', 'Magnetic Track Lighting', 'Smart Automation', 'Megger Test'],
      bio: 'Certified electrical technician specializing in modern smart home circuits, three-phase load balancing, and architectural lighting installations.',
      reviews: [
        ServiceProviderReview(
          clientName: 'Priya Mukherjee',
          rating: 5.0,
          date: 'Sep 02, 2026',
          comment: 'Faultless track light installation. Tested load distribution across all rooms.',
        ),
      ],
      portfolioImages: ['DB Panel', 'Cove Lighting', 'Track Lights'],
      avatarColor: Color(0xFFF59E0B),
      initials: 'SS',
    ),
    const LabourServiceProvider(
      id: 'prov_mohan',
      name: 'Mohan Lal',
      trade: 'Master Plumber',
      isVerified: true,
      rating: 4.7,
      completedJobs: 86,
      dailyRate: 800,
      hourlyRate: 120,
      experienceYears: 9,
      serviceArea: 'Dhanbad & Surrounding Hubs',
      availabilityStatus: 'Available Tomorrow',
      skills: ['Grohe Concealed Divers', 'CPVC Piping', 'Geberit Cistern', 'Pressure Testing', 'Shower Enclosures'],
      bio: 'Specialist in concealed sanitary fittings, high-pressure booster systems, and luxury bathroom fixtures with 10-year leakproof guarantees.',
      reviews: [
        ServiceProviderReview(
          clientName: 'Dr. Neha Kulkarni',
          rating: 4.7,
          date: 'Aug 19, 2026',
          comment: 'Tested shower lines at 10 bar pressure with no seepage. Very knowledgeable.',
        ),
      ],
      portfolioImages: ['Concealed Valve', 'Vanity Plumbing'],
      avatarColor: Color(0xFF10B981),
      initials: 'ML',
    ),
    const LabourServiceProvider(
      id: 'prov_ramesh',
      name: 'Ramesh Patel',
      trade: 'Luxury Painting Specialist',
      isVerified: true,
      rating: 4.9,
      completedJobs: 110,
      dailyRate: 850,
      hourlyRate: 130,
      experienceYears: 14,
      serviceArea: 'Dhanbad Metro',
      availabilityStatus: 'Available Today',
      skills: ['PU Polish', 'Duco Finish', 'Asian Paints Royale Luxury', 'Texture Stucco', 'Airless Spray'],
      bio: 'Master of mirror-finish PU on wood, Italian stucco wall textures, and dust-free mechanized wall sanding.',
      reviews: [
        ServiceProviderReview(
          clientName: 'Amit Kumar',
          rating: 5.0,
          date: 'Aug 14, 2026',
          comment: 'PU finish on the main door is showroom quality. Zero brush marks.',
        ),
      ],
      portfolioImages: ['PU Door', 'Texture Wall'],
      avatarColor: Color(0xFF8B5CF6),
      initials: 'RP',
    ),
    const LabourServiceProvider(
      id: 'prov_vinod',
      name: 'Vinod Kumar',
      trade: 'POP & False Ceiling Master',
      isVerified: true,
      rating: 4.8,
      completedJobs: 74,
      dailyRate: 800,
      hourlyRate: 120,
      experienceYears: 8,
      serviceArea: 'Dhanbad Region',
      availabilityStatus: 'Available Today',
      skills: ['Gyproc Channels', 'Laser Leveling', 'Acoustic Insulation', 'Curved Coves', 'Grid Ceilings'],
      bio: 'Expert in Gyproc false ceiling framework, multi-level stepped coves, and acoustic wall panels.',
      reviews: [
        ServiceProviderReview(
          clientName: 'Anil Sinha',
          rating: 4.8,
          date: 'Aug 01, 2026',
          comment: 'Laser leveling was impeccable. Lighting team had zero trouble fitting fixtures.',
        ),
      ],
      portfolioImages: ['Stepped Ceiling', 'Curved Cove'],
      avatarColor: Color(0xFFEC4899),
      initials: 'VK',
    ),
  ];

  late final List<ServiceBooking> bookings = [
    ServiceBooking(
      id: 'SRV-2026-00482',
      serviceType: 'Carpentry Work',
      provider: providers.first,
      projectName: '3BHK Luxury Residence',
      projectId: 'proj_3bhk_dhanbad',
      workerCount: 2,
      workDescription: 'Kitchen cabinet installation, Hafele soft-close hinges and under-counter pull-out baskets.',
      propertyAddress: 'Tower 4, Flat 1202, Palm Heights, Saraidhela, Dhanbad, Jharkhand 828127',
      startDate: '18 Sep 2026',
      startTime: '10:00 AM',
      estimatedDuration: '3 Days',
      requiredCompletionDate: '21 Sep 2026',
      dealValue: 12000,
      paidAmount: 8000,
      paymentStatus: 'Partially Paid',
      status: 'Work in Progress',
      currentStepIndex: 5,
      checkInTimestamp: '18 Sep 2026 · 10:05 AM',
      dailyUpdates: const [
        DailyWorkUpdate(
          id: 'upd_01',
          date: '18 Sep 2026',
          note: 'Lower kitchen carcase leveling completed. Moisture-resistant base plinth anchored to floor.',
          photoCount: 2,
          photoLabels: ['Carcase Leveling', 'Base Plinth Anchorage'],
        ),
        DailyWorkUpdate(
          id: 'upd_02',
          date: '19 Sep 2026',
          note: 'Upper cabinet hanging brackets aligned with laser guide. Hafele tandem drawer runners fitted.',
          photoCount: 3,
          photoLabels: ['Upper Cabinet Laser Alignment', 'Runner Fitment', 'Hardware QA Check'],
        ),
      ],
      isCompletionConfirmed: false,
      isRated: false,
    ),
    ServiceBooking(
      id: 'SRV-2026-00391',
      serviceType: 'Electrical Work',
      provider: providers[1],
      projectName: '3BHK Luxury Residence',
      projectId: 'proj_3bhk_dhanbad',
      workerCount: 2,
      workDescription: 'Concealed conduit wire pulling, distribution board MCB replacement, and magnetic track light fitting.',
      propertyAddress: 'Tower 4, Flat 1202, Palm Heights, Saraidhela, Dhanbad, Jharkhand 828127',
      startDate: '28 Aug 2026',
      startTime: '09:30 AM',
      estimatedDuration: '2 Days',
      requiredCompletionDate: '30 Aug 2026',
      dealValue: 8500,
      paidAmount: 8500,
      paymentStatus: 'Paid',
      status: 'Completed',
      currentStepIndex: 9,
      checkInTimestamp: '28 Aug 2026 · 09:40 AM',
      dailyUpdates: const [
        DailyWorkUpdate(
          id: 'upd_03',
          date: '28 Aug 2026',
          note: 'Cable continuity tested. Distribution panel dressed cleanly with labelled circuits.',
          photoCount: 2,
          photoLabels: ['Panel Wiring', 'Circuit Test Log'],
        ),
      ],
      isCompletionConfirmed: true,
      isRated: true,
    ),
  ];

  void createBooking({
    required LabourServiceProvider provider,
    required String serviceType,
    required String projectName,
    required String projectId,
    required int workerCount,
    required String workDescription,
    required String propertyAddress,
    required String startDate,
    required String startTime,
    required String estimatedDuration,
    required int dealValue,
  }) {
    final newBooking = ServiceBooking(
      id: 'SRV-2026-00${bookings.length + 500}',
      serviceType: serviceType,
      provider: provider,
      projectName: projectName,
      projectId: projectId,
      workerCount: workerCount,
      workDescription: workDescription,
      propertyAddress: propertyAddress,
      startDate: startDate,
      startTime: startTime,
      estimatedDuration: estimatedDuration,
      requiredCompletionDate: 'Scheduled',
      dealValue: dealValue,
      paidAmount: (dealValue * 0.4).round(),
      paymentStatus: 'Partially Paid',
      status: 'Work in Progress',
      currentStepIndex: 3,
      checkInTimestamp: 'Today · 10:00 AM',
      dailyUpdates: [
        DailyWorkUpdate(
          id: 'upd_${DateTime.now().millisecondsSinceEpoch}',
          date: startDate,
          note: 'Technician assigned and checked in at project site.',
          photoCount: 1,
          photoLabels: ['Site Check-in Verification'],
        ),
      ],
    );
    bookings.insert(0, newBooking);
    changeNotifier.value++;
  }

  void payPendingAmount(ServiceBooking booking) {
    // Simulates settlement
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      final updated = ServiceBooking(
        id: booking.id,
        serviceType: booking.serviceType,
        provider: booking.provider,
        projectName: booking.projectName,
        projectId: booking.projectId,
        workerCount: booking.workerCount,
        workDescription: booking.workDescription,
        propertyAddress: booking.propertyAddress,
        startDate: booking.startDate,
        startTime: booking.startTime,
        estimatedDuration: booking.estimatedDuration,
        requiredCompletionDate: booking.requiredCompletionDate,
        dealValue: booking.dealValue,
        paidAmount: booking.dealValue,
        paymentStatus: 'Paid',
        status: booking.status,
        currentStepIndex: booking.currentStepIndex < 8 ? 8 : booking.currentStepIndex,
        checkInTimestamp: booking.checkInTimestamp,
        dailyUpdates: booking.dailyUpdates,
        isCompletionConfirmed: booking.isCompletionConfirmed,
        isRated: booking.isRated,
      );
      bookings[index] = updated;
      changeNotifier.value++;
    }
  }

  void confirmCompletion(ServiceBooking booking) {
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      final updated = ServiceBooking(
        id: booking.id,
        serviceType: booking.serviceType,
        provider: booking.provider,
        projectName: booking.projectName,
        projectId: booking.projectId,
        workerCount: booking.workerCount,
        workDescription: booking.workDescription,
        propertyAddress: booking.propertyAddress,
        startDate: booking.startDate,
        startTime: booking.startTime,
        estimatedDuration: booking.estimatedDuration,
        requiredCompletionDate: booking.requiredCompletionDate,
        dealValue: booking.dealValue,
        paidAmount: booking.paidAmount,
        paymentStatus: booking.paymentStatus,
        status: 'Completed',
        currentStepIndex: 7,
        checkInTimestamp: booking.checkInTimestamp,
        dailyUpdates: booking.dailyUpdates,
        isCompletionConfirmed: true,
        isRated: booking.isRated,
      );
      bookings[index] = updated;
      changeNotifier.value++;
    }
  }
}
