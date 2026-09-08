import 'package:flutter/material.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';

/// Central Projects Repository — Singleton managing all project-related
/// in-memory reactive state, seed data, filtered getters, mutations,
/// and computed aggregations.
class ProjectsRepository {
  ProjectsRepository._internal() {
    _seedInitialData();
  }

  static final ProjectsRepository _instance = ProjectsRepository._internal();
  factory ProjectsRepository() => _instance;

  // ===========================================================================
  // DATA STORES
  // ===========================================================================
  final List<Project> _projects = [];
  final List<ProjectMilestone> _milestones = [];
  final List<ProjectTask> _tasks = [];
  final List<SiteVisit> _siteVisits = [];
  final List<SiteProgressEntry> _siteProgressEntries = [];
  final List<WorkApproval> _approvals = [];
  final List<Complaint> _complaints = [];
  final List<MaterialExpense> _materialExpenses = [];
  final List<LabourExpense> _labourExpenses = [];
  final List<FeeRecord> _feeRecords = [];
  final List<ProjectPayment> _payments = [];
  final List<ProjectTimelineEvent> _timelineEvents = [];
  final List<ProjectAlert> _alerts = [];

  // ===========================================================================
  // DIRECT GETTERS
  // ===========================================================================
  List<Project> get projects => List.unmodifiable(_projects);
  List<ProjectMilestone> get milestones => List.unmodifiable(_milestones);
  List<ProjectTask> get tasks => List.unmodifiable(_tasks);
  List<SiteVisit> get siteVisits => List.unmodifiable(_siteVisits);
  List<SiteProgressEntry> get siteProgressEntries =>
      List.unmodifiable(_siteProgressEntries);
  List<WorkApproval> get approvals => List.unmodifiable(_approvals);
  List<Complaint> get complaints => List.unmodifiable(_complaints);
  List<MaterialExpense> get materialExpenses =>
      List.unmodifiable(_materialExpenses);
  List<LabourExpense> get labourExpenses => List.unmodifiable(_labourExpenses);
  List<FeeRecord> get feeRecords => List.unmodifiable(_feeRecords);
  List<ProjectPayment> get payments => List.unmodifiable(_payments);
  List<ProjectTimelineEvent> get timelineEvents =>
      List.unmodifiable(_timelineEvents);
  List<ProjectAlert> get alerts => List.unmodifiable(_alerts);

  // ===========================================================================
  // FILTERED GETTERS
  // ===========================================================================
  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ProjectMilestone> getMilestonesForProject(String projectId) =>
      _milestones.where((m) => m.projectId == projectId).toList();

  List<ProjectTask> getTasksForProject(String projectId) =>
      _tasks.where((t) => t.projectId == projectId).toList();

  List<ProjectTask> getTasksForMilestone(String milestoneId) =>
      _tasks.where((t) => t.milestoneId == milestoneId).toList();

  List<SiteVisit> getSiteVisitsForProject(String projectId) =>
      _siteVisits.where((v) => v.projectId == projectId).toList();

  List<SiteProgressEntry> getSiteProgressForProject(String projectId) =>
      _siteProgressEntries.where((e) => e.projectId == projectId).toList();

  List<WorkApproval> getApprovalsForProject(String projectId) =>
      _approvals.where((a) => a.projectId == projectId).toList();

  List<Complaint> getComplaintsForProject(String projectId) =>
      _complaints.where((c) => c.projectId == projectId).toList();

  List<MaterialExpense> getMaterialExpensesForProject(String projectId) =>
      _materialExpenses.where((e) => e.projectId == projectId).toList();

  List<LabourExpense> getLabourExpensesForProject(String projectId) =>
      _labourExpenses.where((e) => e.projectId == projectId).toList();

  List<FeeRecord> getFeeRecordsForProject(String projectId) =>
      _feeRecords.where((f) => f.projectId == projectId).toList();

  List<ProjectPayment> getPaymentsForProject(String projectId) =>
      _payments.where((p) => p.projectId == projectId).toList();

  List<ProjectTimelineEvent> getTimelineForProject(String projectId) {
    final events =
        _timelineEvents.where((e) => e.projectId == projectId).toList();
    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  List<ProjectAlert> getAlertsForProject(String projectId) =>
      _alerts.where((a) => a.projectId == projectId).toList();

  // ===========================================================================
  // COMPUTED AGGREGATIONS
  // ===========================================================================
  ProjectKpiSummary getProjectKpis() {
    final ongoing = _projects
        .where(
            (p) => p.status.isActive || p.status == ProjectStatus.onHold)
        .length;
    final completed =
        _projects.where((p) => p.status == ProjectStatus.completed).length;
    final delayed =
        _projects.where((p) => p.health == ProjectHealth.delayed || p.health == ProjectHealth.critical).length;
    final onTime =
        _projects.where((p) => p.health == ProjectHealth.healthy).length;
    final pendingApprovals =
        _approvals.where((a) => a.status == ApprovalStatus.pending).length;
    final openComplaints = _complaints
        .where(
            (c) => c.status != ComplaintStatus.resolved && c.status != ComplaintStatus.closed)
        .length;
    final pendingTasks = _tasks
        .where((t) =>
            t.status != ProjectTaskStatus.completed &&
            t.status != ProjectTaskStatus.cancelled)
        .length;
    final outstanding = _projects.fold<double>(
        0, (sum, p) => sum + p.totalOutstandingLakhs);

    return ProjectKpiSummary(
      totalProjects: _projects.length,
      ongoingProjects: ongoing,
      completedProjects: completed,
      onTimeProjects: onTime,
      delayedProjects: delayed,
      pendingApprovals: pendingApprovals,
      openComplaints: openComplaints,
      pendingTasks: pendingTasks,
      outstandingAmountLakhs: outstanding,
    );
  }

  ProjectCommercialSummary getCommercialSummary(String projectId) {
    final materials = getMaterialExpensesForProject(projectId);
    final labour = getLabourExpensesForProject(projectId);
    final fees = getFeeRecordsForProject(projectId);
    final received = getPaymentsForProject(projectId);
    final project = getProjectById(projectId);

    final materialCost =
        materials.fold<double>(0, (sum, m) => sum + m.amount);
    final labourCost = labour.fold<double>(0, (sum, l) => sum + l.amount);
    final supervisionFees = fees
        .where((f) => f.feeType == CommercialRecordType.supervisionFee)
        .fold<double>(0, (sum, f) => sum + f.amount);
    final consultingFees = fees
        .where((f) =>
            f.feeType == CommercialRecordType.consultingFee ||
            f.feeType == CommercialRecordType.designFee)
        .fold<double>(0, (sum, f) => sum + f.amount);
    final totalReceived =
        received.fold<double>(0, (sum, p) => sum + p.amount);
    final totalCommission = materials.fold<double>(
            0, (sum, m) => sum + m.calculatedCommission) +
        labour.fold<double>(0, (sum, l) => sum + l.calculatedCommission) +
        fees.fold<double>(0, (sum, f) => sum + f.calculatedCommission);

    return ProjectCommercialSummary(
      contractAmount: project?.contractAmountLakhs ?? 0,
      materialCost: materialCost,
      labourCost: labourCost,
      supervisionFees: supervisionFees,
      consultingFees: consultingFees,
      totalReceived: totalReceived,
      totalCommission: totalCommission,
    );
  }

  List<GanttTaskItem> getGanttItems(String projectId) {
    final projectMilestones = getMilestonesForProject(projectId);
    final projectTasks = getTasksForProject(projectId);
    final items = <GanttTaskItem>[];

    for (final m in projectMilestones) {
      items.add(GanttTaskItem(
        id: m.id,
        title: m.name,
        startDate: m.startDate,
        endDate: m.dueDate,
        progress: m.completionPercent / 100,
        assignee: m.assignee,
        status: _milestoneStatusToTaskStatus(m.status),
        isMilestone: true,
      ));
    }

    for (final t in projectTasks) {
      items.add(GanttTaskItem(
        id: t.id,
        title: t.name,
        startDate: t.startDate,
        endDate: t.dueDate,
        progress: t.status == ProjectTaskStatus.completed ? 1.0 : 0,
        assignee: t.assignee,
        status: t.status,
        dependencyIds: t.dependencies.map((d) => d.fromTaskId).toList(),
        isRescheduled: t.isRescheduled,
        originalEndDate: t.originalDueDate,
        rescheduleReason: t.rescheduleReason,
      ));
    }

    items.sort((a, b) => a.startDate.compareTo(b.startDate));
    return items;
  }

  ProjectTaskStatus _milestoneStatusToTaskStatus(MilestoneStatus ms) {
    switch (ms) {
      case MilestoneStatus.notStarted:
        return ProjectTaskStatus.toDo;
      case MilestoneStatus.inProgress:
        return ProjectTaskStatus.inProgress;
      case MilestoneStatus.pendingApproval:
        return ProjectTaskStatus.waiting;
      case MilestoneStatus.completed:
        return ProjectTaskStatus.completed;
      case MilestoneStatus.delayed:
        return ProjectTaskStatus.blocked;
      case MilestoneStatus.blocked:
        return ProjectTaskStatus.blocked;
      case MilestoneStatus.cancelled:
        return ProjectTaskStatus.cancelled;
    }
  }

  // ===========================================================================
  // STATE MUTATIONS
  // ===========================================================================
  void addProject(Project project) {
    _projects.add(project);
  }

  void updateProjectStatus(String projectId, ProjectStatus newStatus) {
    final idx = _projects.indexWhere((p) => p.id == projectId);
    if (idx != -1) {
      _projects[idx] = _projects[idx].copyWith(
        status: newStatus,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void updateProjectStage(String projectId, ProjectStage newStage) {
    final idx = _projects.indexWhere((p) => p.id == projectId);
    if (idx != -1) {
      _projects[idx] = _projects[idx].copyWith(
        currentStage: newStage,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void addMilestone(ProjectMilestone milestone) {
    _milestones.add(milestone);
  }

  void updateMilestoneStatus(
      String milestoneId, MilestoneStatus newStatus, double completionPercent) {
    final idx = _milestones.indexWhere((m) => m.id == milestoneId);
    if (idx != -1) {
      _milestones[idx] = _milestones[idx].copyWith(
        status: newStatus,
        completionPercent: completionPercent,
      );
    }
  }

  void addTask(ProjectTask task) {
    _tasks.add(task);
  }

  void updateTaskStatus(String taskId, ProjectTaskStatus newStatus) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx] = _tasks[idx].copyWith(status: newStatus);
    }
  }

  void addSiteVisit(SiteVisit visit) {
    _siteVisits.add(visit);
  }

  void completeSiteVisit(
      String visitId, SiteVisitOutcome outcome, String notes) {
    final idx = _siteVisits.indexWhere((v) => v.id == visitId);
    if (idx != -1) {
      _siteVisits[idx] = _siteVisits[idx].copyWith(
        outcome: outcome,
        notes: notes,
      );
    }
  }

  void addSiteProgress(SiteProgressEntry entry) {
    _siteProgressEntries.add(entry);
  }

  void createApproval(WorkApproval approval) {
    _approvals.add(approval);
  }

  void approveRequest(String approvalId, String approvedBy) {
    final idx = _approvals.indexWhere((a) => a.id == approvalId);
    if (idx != -1) {
      _approvals[idx] = _approvals[idx].copyWith(
        status: ApprovalStatus.approved,
        approvedDate: DateTime.now(),
        approvedBy: approvedBy,
      );
    }
  }

  void rejectRequest(
      String approvalId, String rejectedBy, String reason) {
    final idx = _approvals.indexWhere((a) => a.id == approvalId);
    if (idx != -1) {
      _approvals[idx] = _approvals[idx].copyWith(
        status: ApprovalStatus.rejected,
        rejectedDate: DateTime.now(),
        rejectedBy: rejectedBy,
        rejectionReason: reason,
      );
    }
  }

  void addComplaint(Complaint complaint) {
    _complaints.add(complaint);
  }

  void resolveComplaint(String complaintId, ComplaintResolution resolution) {
    final idx = _complaints.indexWhere((c) => c.id == complaintId);
    if (idx != -1) {
      _complaints[idx] = _complaints[idx].copyWith(
        status: ComplaintStatus.resolved,
        resolution: resolution,
      );
    }
  }

  void addMaterialExpense(MaterialExpense expense) {
    _materialExpenses.add(expense);
  }

  void addLabourExpense(LabourExpense expense) {
    _labourExpenses.add(expense);
  }

  void addFeeRecord(FeeRecord fee) {
    _feeRecords.add(fee);
  }

  void addPayment(ProjectPayment payment) {
    _payments.add(payment);
  }

  // ===========================================================================
  // SEED DATA
  // ===========================================================================
  void _seedInitialData() {
    _seedProjects();
    _seedMilestones();
    _seedTasks();
    _seedSiteVisits();
    _seedSiteProgress();
    _seedApprovals();
    _seedComplaints();
    _seedCommercials();
    _seedTimeline();
    _seedAlerts();
  }

  void _seedProjects() {
    final now = DateTime.now();
    _projects.addAll([
      Project(
        id: 'HOM-PRJ-001',
        name: 'DLF Camellias 4BHK Luxury Turnkey',
        code: 'CAM-1402',
        type: ProjectType.turnkey,
        status: ProjectStatus.execution,
        health: ProjectHealth.healthy,
        currentStage: ProjectStage.execution,
        description:
            'Complete 4BHK luxury turnkey interior execution for DLF The Camellias, Tower C, Apt 1402. Italian marble flooring, German modular kitchen, custom millwork, false ceiling with cove lighting.',
        category: 'Luxury Residential',
        clientId: 'HOM-CUST-801',
        clientName: 'Rahul & Neha Sharma',
        clientPhone: '+91 98101 23456',
        clientEmail: 'rahul.sharma@dlf.in',
        siteName: 'DLF The Camellias',
        siteAddress: 'Tower C, Apt 1402, DLF The Camellias, Golf Course Road',
        siteCity: 'Gurugram',
        siteState: 'Haryana',
        sitePincode: '122002',
        siteContactPerson: 'Mr. Suresh (Security In-charge)',
        siteContactNumber: '+91 98100 33221',
        totalAreaSqFt: 3850,
        areas: [
          const ProjectArea(id: 'A1', name: 'Master Bedroom', length: 18, width: 16, height: 10.5, areaSqFt: 288, floor: '14th', roomType: 'Bedroom'),
          const ProjectArea(id: 'A2', name: 'Living & Dining', length: 32, width: 20, height: 10.5, areaSqFt: 640, floor: '14th', roomType: 'Living'),
          const ProjectArea(id: 'A3', name: 'Kitchen', length: 14, width: 12, height: 10, areaSqFt: 168, floor: '14th', roomType: 'Kitchen'),
          const ProjectArea(id: 'A4', name: 'Guest Bedroom', length: 14, width: 14, height: 10, areaSqFt: 196, floor: '14th', roomType: 'Bedroom'),
          const ProjectArea(id: 'A5', name: 'Kids Room', length: 14, width: 12, height: 10, areaSqFt: 168, floor: '14th', roomType: 'Bedroom'),
          const ProjectArea(id: 'A6', name: 'Study / Home Office', length: 12, width: 10, height: 10, areaSqFt: 120, floor: '14th', roomType: 'Study'),
        ],
        team: [
          ProjectTeamMember(userId: 'U01', name: 'Neha Deshmukh', role: 'Project Manager', assignmentDate: now.subtract(const Duration(days: 30)), responsibilities: 'Overall project coordination, client communication, milestone tracking'),
          ProjectTeamMember(userId: 'U02', name: 'Siddharth Roy', role: 'Senior Architect', assignmentDate: now.subtract(const Duration(days: 30)), responsibilities: '3D design, material selection, vendor coordination'),
          ProjectTeamMember(userId: 'U03', name: 'Arun Kumar', role: 'Site Supervisor', assignmentDate: now.subtract(const Duration(days: 20)), responsibilities: 'Daily site execution, labour management, quality control'),
          ProjectTeamMember(userId: 'U04', name: 'Ananya Verma', role: 'Sales Owner', assignmentDate: now.subtract(const Duration(days: 45)), responsibilities: 'Client relationship, upsell, payment follow-ups'),
        ],
        projectManager: 'Neha Deshmukh',
        designer: 'Siddharth Roy',
        siteSupervisor: 'Arun Kumar',
        salesOwner: 'Ananya Verma',
        createdDate: now.subtract(const Duration(days: 35)),
        plannedStartDate: now.subtract(const Duration(days: 28)),
        expectedCompletion: now.add(const Duration(days: 62)),
        lastUpdated: now.subtract(const Duration(hours: 2)),
        progressPercent: 42,
        designProgress: 95,
        executionProgress: 38,
        procurementProgress: 55,
        paymentProgress: 40,
        contractAmountLakhs: 65.0,
        totalReceivedLakhs: 26.0,
        totalOutstandingLakhs: 39.0,
        totalMilestones: 5,
        completedMilestones: 1,
        totalTasks: 28,
        completedTasks: 10,
        pendingTasks: 14,
        overdueTasks: 2,
        pendingApprovals: 2,
        openComplaints: 1,
        ratings: const [
          ProjectRating(category: 'Design', score: 9.2),
          ProjectRating(category: 'Communication', score: 8.8),
          ProjectRating(category: 'Timeline', score: 7.5),
        ],
      ),
      Project(
        id: 'HOM-PRJ-002',
        name: 'Defence Colony Duplex Kothi',
        code: 'DEF-V18',
        type: ProjectType.turnkey,
        status: ProjectStatus.design,
        health: ProjectHealth.healthy,
        currentStage: ProjectStage.design,
        description:
            'Premium independent duplex kothi full interior execution with imported Italian marble, custom brass fixtures, and French chateau-inspired design theme.',
        category: 'Ultra-Luxury Residential',
        clientId: 'HOM-CUST-802',
        clientName: 'Vikramaditya Oberoi',
        clientPhone: '+91 99200 88776',
        clientEmail: 'vikram.oberoi@oberoigroup.com',
        siteName: 'Private Kothi',
        siteAddress: 'Villa 18, Defence Colony, South Extension',
        siteCity: 'New Delhi',
        siteState: 'Delhi NCR',
        sitePincode: '110024',
        siteContactPerson: 'Mr. Rajan (Caretaker)',
        siteContactNumber: '+91 98100 55000',
        totalAreaSqFt: 5200,
        areas: [
          const ProjectArea(id: 'B1', name: 'Grand Foyer (Double Height)', length: 24, width: 18, height: 22, areaSqFt: 432, floor: 'Ground + First', roomType: 'Foyer'),
          const ProjectArea(id: 'B2', name: 'Master Suite', length: 22, width: 18, height: 12, areaSqFt: 396, floor: 'First', roomType: 'Bedroom'),
          const ProjectArea(id: 'B3', name: 'Formal Living', length: 28, width: 22, height: 12, areaSqFt: 616, floor: 'Ground', roomType: 'Living'),
          const ProjectArea(id: 'B4', name: 'Entertainment Lounge', length: 20, width: 16, height: 12, areaSqFt: 320, floor: 'Basement', roomType: 'Lounge'),
        ],
        team: [
          ProjectTeamMember(userId: 'U05', name: 'Sunil Rao', role: 'Project Manager', assignmentDate: now.subtract(const Duration(days: 15)), responsibilities: 'VIP client management, design presentation coordination'),
          ProjectTeamMember(userId: 'U06', name: 'Aanya Sen', role: 'Design Lead', assignmentDate: now.subtract(const Duration(days: 15)), responsibilities: 'French chateau concept, imported material sourcing'),
        ],
        projectManager: 'Sunil Rao',
        designer: 'Aanya Sen',
        siteSupervisor: 'TBD',
        salesOwner: 'Rajesh Patel',
        createdDate: now.subtract(const Duration(days: 18)),
        plannedStartDate: now.subtract(const Duration(days: 10)),
        expectedCompletion: now.add(const Duration(days: 120)),
        lastUpdated: now.subtract(const Duration(hours: 6)),
        progressPercent: 15,
        designProgress: 60,
        executionProgress: 0,
        procurementProgress: 10,
        paymentProgress: 20,
        contractAmountLakhs: 110.0,
        totalReceivedLakhs: 22.0,
        totalOutstandingLakhs: 88.0,
        totalMilestones: 6,
        completedMilestones: 0,
        totalTasks: 32,
        completedTasks: 4,
        pendingTasks: 24,
        overdueTasks: 0,
        pendingApprovals: 1,
        openComplaints: 0,
      ),
      Project(
        id: 'HOM-PRJ-003',
        name: 'Godrej Woods 3BHK Modular Kitchen',
        code: 'GDJ-803',
        type: ProjectType.consulting,
        status: ProjectStatus.approvalPending,
        health: ProjectHealth.atRisk,
        currentStage: ProjectStage.approval,
        description:
            'German modular kitchen with Blum soft-close fittings, Hafele accessories, quartz countertop, and integrated appliance setup for Godrej Woods.',
        category: 'Modular Kitchen',
        clientId: 'HOM-CUST-803',
        clientName: 'Sanjay & Sunita Singhal',
        clientPhone: '+91 98188 44332',
        clientEmail: 'sanjay.singhal@hdfcbank.com',
        siteName: 'Godrej Woods',
        siteAddress: 'Tower 4, Apt 803, Godrej Woods, Sector 43',
        siteCity: 'Noida',
        siteState: 'Uttar Pradesh',
        sitePincode: '201301',
        siteContactPerson: 'Mrs. Sunita Singhal',
        siteContactNumber: '+91 98188 44333',
        totalAreaSqFt: 168,
        areas: [
          const ProjectArea(id: 'C1', name: 'Kitchen', length: 14, width: 12, height: 10, areaSqFt: 168, floor: '8th', roomType: 'Kitchen'),
        ],
        team: [
          ProjectTeamMember(userId: 'U07', name: 'Priya Sharma', role: 'Kitchen Design Consultant', assignmentDate: now.subtract(const Duration(days: 8)), responsibilities: 'Kitchen layout, ergonomics, fitting specification'),
        ],
        projectManager: 'Priya Sharma',
        designer: 'Priya Sharma',
        siteSupervisor: 'TBD',
        salesOwner: 'Priya Sharma',
        createdDate: now.subtract(const Duration(days: 10)),
        plannedStartDate: now.subtract(const Duration(days: 5)),
        expectedCompletion: now.add(const Duration(days: 30)),
        lastUpdated: now.subtract(const Duration(days: 1)),
        progressPercent: 25,
        designProgress: 85,
        executionProgress: 0,
        procurementProgress: 15,
        paymentProgress: 30,
        contractAmountLakhs: 12.5,
        totalReceivedLakhs: 3.75,
        totalOutstandingLakhs: 8.75,
        totalMilestones: 3,
        completedMilestones: 1,
        totalTasks: 12,
        completedTasks: 4,
        pendingTasks: 6,
        overdueTasks: 1,
        pendingApprovals: 1,
        openComplaints: 0,
      ),
      Project(
        id: 'HOM-PRJ-004',
        name: 'Pioneer Araya Penthouse Renovation',
        code: 'PNR-PH',
        type: ProjectType.turnkey,
        status: ProjectStatus.execution,
        health: ProjectHealth.delayed,
        currentStage: ProjectStage.execution,
        description:
            'Complete penthouse renovation with custom woodwork, wardrobes, floating shelves, engineered wood flooring, and premium false ceiling.',
        category: 'Premium Renovation',
        clientId: 'HOM-CUST-804',
        clientName: 'Meera Kapoor',
        clientPhone: '+91 98111 65432',
        clientEmail: 'meera.kapoor@studio.design',
        siteName: 'Pioneer Araya',
        siteAddress: 'Penthouse, Pioneer Araya, Golf Course Extension Rd',
        siteCity: 'Gurugram',
        siteState: 'Haryana',
        sitePincode: '122011',
        siteContactPerson: 'Ms. Meera Kapoor',
        siteContactNumber: '+91 98111 65432',
        totalAreaSqFt: 4600,
        areas: [
          const ProjectArea(id: 'D1', name: 'Master Bedroom Suite', length: 20, width: 18, height: 11, areaSqFt: 360, floor: 'Penthouse Upper', roomType: 'Bedroom'),
          const ProjectArea(id: 'D2', name: 'Open Plan Living', length: 36, width: 24, height: 14, areaSqFt: 864, floor: 'Penthouse Lower', roomType: 'Living'),
          const ProjectArea(id: 'D3', name: 'Home Theater', length: 18, width: 14, height: 10, areaSqFt: 252, floor: 'Penthouse Lower', roomType: 'Entertainment'),
        ],
        team: [
          ProjectTeamMember(userId: 'U08', name: 'Aakash Verma', role: 'Project Manager', assignmentDate: now.subtract(const Duration(days: 50)), responsibilities: 'Overall execution, vendor coordination, quality audit'),
          ProjectTeamMember(userId: 'U09', name: 'Vikram Malhotra', role: 'Sales Owner', assignmentDate: now.subtract(const Duration(days: 60)), responsibilities: 'Client relationship, upsell, payment collection'),
        ],
        projectManager: 'Aakash Verma',
        designer: 'Ritu Mehra',
        siteSupervisor: 'Dinesh Yadav',
        salesOwner: 'Vikram Malhotra',
        createdDate: now.subtract(const Duration(days: 55)),
        plannedStartDate: now.subtract(const Duration(days: 45)),
        expectedCompletion: now.subtract(const Duration(days: 5)),
        lastUpdated: now.subtract(const Duration(hours: 4)),
        progressPercent: 82,
        designProgress: 100,
        executionProgress: 78,
        procurementProgress: 90,
        paymentProgress: 75,
        contractAmountLakhs: 48.0,
        totalReceivedLakhs: 36.0,
        totalOutstandingLakhs: 12.0,
        totalMilestones: 5,
        completedMilestones: 4,
        totalTasks: 22,
        completedTasks: 18,
        pendingTasks: 3,
        overdueTasks: 3,
        pendingApprovals: 0,
        openComplaints: 2,
        ratings: const [
          ProjectRating(category: 'Design', score: 8.5),
          ProjectRating(category: 'Communication', score: 7.2),
          ProjectRating(category: 'Timeline', score: 5.0),
          ProjectRating(category: 'Quality', score: 8.0),
        ],
      ),
      Project(
        id: 'HOM-PRJ-005',
        name: 'Experion Windchants 3BHK Handover',
        code: 'EXP-1102',
        type: ProjectType.turnkey,
        status: ProjectStatus.completed,
        health: ProjectHealth.completed,
        currentStage: ProjectStage.afterSales,
        description:
            'Completed 3BHK turnkey interior project with full woodwork, modular kitchen, false ceiling, and paint work. Under warranty period.',
        category: 'Residential Turnkey',
        clientId: 'HOM-CUST-805',
        clientName: 'Tanmay & Ritu Bansal',
        clientPhone: '+91 99100 44556',
        clientEmail: 'tanmay.bansal@techcorp.io',
        siteName: 'Experion Windchants',
        siteAddress: 'Flat 1102, Experion Windchants, Sector 112',
        siteCity: 'Gurugram',
        siteState: 'Haryana',
        sitePincode: '122017',
        siteContactPerson: 'Mr. Tanmay Bansal',
        siteContactNumber: '+91 99100 44556',
        totalAreaSqFt: 1850,
        team: [
          ProjectTeamMember(userId: 'U10', name: 'Priya Sharma', role: 'Sales Owner', assignmentDate: now.subtract(const Duration(days: 120)), responsibilities: 'After-sales support'),
        ],
        projectManager: 'Aakash Verma',
        designer: 'Kavita Chawla',
        siteSupervisor: 'Ramesh Singh',
        salesOwner: 'Priya Sharma',
        createdDate: now.subtract(const Duration(days: 120)),
        plannedStartDate: now.subtract(const Duration(days: 105)),
        expectedCompletion: now.subtract(const Duration(days: 15)),
        actualCompletion: now.subtract(const Duration(days: 8)),
        lastUpdated: now.subtract(const Duration(days: 8)),
        progressPercent: 100,
        designProgress: 100,
        executionProgress: 100,
        procurementProgress: 100,
        paymentProgress: 100,
        contractAmountLakhs: 34.0,
        totalReceivedLakhs: 34.0,
        totalOutstandingLakhs: 0,
        totalMilestones: 5,
        completedMilestones: 5,
        totalTasks: 20,
        completedTasks: 20,
        pendingTasks: 0,
        overdueTasks: 0,
        pendingApprovals: 0,
        openComplaints: 0,
        ratings: const [
          ProjectRating(category: 'Design', score: 9.5),
          ProjectRating(category: 'Communication', score: 9.0),
          ProjectRating(category: 'Timeline', score: 8.0),
          ProjectRating(category: 'Quality', score: 9.2),
        ],
      ),
      Project(
        id: 'HOM-PRJ-006',
        name: 'M3M Golfestate 4BHK Turnkey',
        code: 'M3M-S65',
        type: ProjectType.turnkey,
        status: ProjectStatus.planned,
        health: ProjectHealth.healthy,
        currentStage: ProjectStage.planning,
        description:
            'Upcoming full turnkey interior project for M3M Golfestate, Sector 65. Client currently traveling overseas. Planning stage pending site measurement.',
        category: 'Luxury Residential',
        clientId: 'HOM-CUST-806',
        clientName: 'Amanpreet Singh',
        clientPhone: '+91 98765 12340',
        clientEmail: 'aman.singh@chd.in',
        siteName: 'M3M Golfestate',
        siteAddress: 'M3M Golfestate, Sector 65',
        siteCity: 'Gurugram',
        siteState: 'Haryana',
        sitePincode: '122009',
        siteContactPerson: 'Mr. Amanpreet Singh',
        siteContactNumber: '+91 98765 12340',
        totalAreaSqFt: 3600,
        team: [
          ProjectTeamMember(userId: 'U04', name: 'Ananya Verma', role: 'Sales Owner', assignmentDate: now.subtract(const Duration(days: 7)), responsibilities: 'Client engagement, booking, site measurement scheduling'),
        ],
        projectManager: 'TBD',
        designer: 'TBD',
        siteSupervisor: 'TBD',
        salesOwner: 'Ananya Verma',
        createdDate: now.subtract(const Duration(days: 7)),
        plannedStartDate: now.add(const Duration(days: 14)),
        expectedCompletion: now.add(const Duration(days: 104)),
        lastUpdated: now.subtract(const Duration(days: 2)),
        progressPercent: 5,
        designProgress: 0,
        executionProgress: 0,
        procurementProgress: 0,
        paymentProgress: 10,
        contractAmountLakhs: 52.0,
        totalReceivedLakhs: 5.2,
        totalOutstandingLakhs: 46.8,
        totalMilestones: 5,
        completedMilestones: 0,
        totalTasks: 0,
        completedTasks: 0,
        pendingTasks: 0,
        overdueTasks: 0,
        pendingApprovals: 0,
        openComplaints: 0,
      ),
    ]);
  }

  void _seedMilestones() {
    final now = DateTime.now();
    _milestones.addAll([
      // PRJ-001 Milestones
      ProjectMilestone(
        id: 'MS-001-01', projectId: 'HOM-PRJ-001', name: 'Design Freeze & Client Approval',
        stage: ProjectStage.design, description: 'Finalize all 2D/3D designs, material selections, and get client sign-off',
        startDate: now.subtract(const Duration(days: 28)), dueDate: now.subtract(const Duration(days: 14)),
        completionPercent: 100, status: MilestoneStatus.completed, assignee: 'Siddharth Roy',
        approvalRequired: true, paymentRequired: true, budgetLakhs: 6.5,
        checklist: [
          MilestoneChecklistItem(id: 'CK1', label: 'Master bedroom 3D render approved', isDone: true),
          MilestoneChecklistItem(id: 'CK2', label: 'Kitchen layout finalized with Hafele spec', isDone: true),
          MilestoneChecklistItem(id: 'CK3', label: 'Material sample board signed', isDone: true),
        ],
      ),
      ProjectMilestone(
        id: 'MS-001-02', projectId: 'HOM-PRJ-001', name: 'Civil & False Ceiling',
        stage: ProjectStage.execution, description: 'Complete all civil modifications, column cladding, and false ceiling installation',
        startDate: now.subtract(const Duration(days: 14)), dueDate: now.add(const Duration(days: 7)),
        completionPercent: 65, status: MilestoneStatus.inProgress, assignee: 'Arun Kumar',
        priority: ProjectTaskPriority.high, budgetLakhs: 13.0,
        checklist: [
          MilestoneChecklistItem(id: 'CK4', label: 'Column cladding completed', isDone: true),
          MilestoneChecklistItem(id: 'CK5', label: 'False ceiling framing done', isDone: true),
          MilestoneChecklistItem(id: 'CK6', label: 'Cove lighting wiring roughed in', isDone: false),
          MilestoneChecklistItem(id: 'CK7', label: 'Gypsum board finishing', isDone: false),
        ],
      ),
      ProjectMilestone(
        id: 'MS-001-03', projectId: 'HOM-PRJ-001', name: 'Flooring & Wall Finishes',
        stage: ProjectStage.execution, description: 'Italian marble flooring installation, wall paneling, and paint work',
        startDate: now.add(const Duration(days: 7)), dueDate: now.add(const Duration(days: 28)),
        completionPercent: 0, status: MilestoneStatus.notStarted, assignee: 'Arun Kumar',
        budgetLakhs: 19.5,
        checklist: [
          MilestoneChecklistItem(id: 'CK8', label: 'Marble received at site'),
          MilestoneChecklistItem(id: 'CK9', label: 'Waterproofing bathrooms completed'),
          MilestoneChecklistItem(id: 'CK10', label: 'Living room marble laid'),
          MilestoneChecklistItem(id: 'CK11', label: 'Wall panel installation'),
        ],
      ),
      ProjectMilestone(
        id: 'MS-001-04', projectId: 'HOM-PRJ-001', name: 'Woodwork & Kitchen Installation',
        stage: ProjectStage.procurement, description: 'Factory-finished modular kitchen, wardrobes, TV unit, and millwork installation',
        startDate: now.add(const Duration(days: 28)), dueDate: now.add(const Duration(days: 49)),
        completionPercent: 0, status: MilestoneStatus.notStarted, assignee: 'Siddharth Roy',
        paymentRequired: true, budgetLakhs: 16.25,
      ),
      ProjectMilestone(
        id: 'MS-001-05', projectId: 'HOM-PRJ-001', name: 'Final QC, Snagging & Handover',
        stage: ProjectStage.handover, description: 'Quality audit, snag resolution, client walkthrough, and formal handover',
        startDate: now.add(const Duration(days: 49)), dueDate: now.add(const Duration(days: 62)),
        completionPercent: 0, status: MilestoneStatus.notStarted, assignee: 'Neha Deshmukh',
        approvalRequired: true, paymentRequired: true, budgetLakhs: 9.75,
      ),
      // PRJ-004 Milestones (delayed project)
      ProjectMilestone(
        id: 'MS-004-04', projectId: 'HOM-PRJ-004', name: 'Home Theater & Lighting',
        stage: ProjectStage.execution, description: 'Acoustic paneling, projector mount, ambient lighting, and AV wiring',
        startDate: now.subtract(const Duration(days: 14)), dueDate: now.subtract(const Duration(days: 3)),
        completionPercent: 70, status: MilestoneStatus.delayed, assignee: 'Aakash Verma',
        priority: ProjectTaskPriority.urgent, budgetLakhs: 8.0,
      ),
      ProjectMilestone(
        id: 'MS-004-05', projectId: 'HOM-PRJ-004', name: 'Final Snagging & Handover',
        stage: ProjectStage.handover, description: 'Punch list completion, client walkthrough, warranty handover',
        startDate: now.subtract(const Duration(days: 3)), dueDate: now.add(const Duration(days: 10)),
        completionPercent: 0, status: MilestoneStatus.notStarted, assignee: 'Aakash Verma',
        approvalRequired: true, paymentRequired: true, budgetLakhs: 4.8,
      ),
    ]);
  }

  void _seedTasks() {
    final now = DateTime.now();
    _tasks.addAll([
      // PRJ-001 Tasks
      ProjectTask(
        id: 'TSK-001-01', projectId: 'HOM-PRJ-001', milestoneId: 'MS-001-02',
        name: 'Complete false ceiling cove lighting wiring', description: 'Route LED strip wiring in cove channels for living & dining area',
        areaRoom: 'Living & Dining', assignee: 'Arun Kumar', priority: ProjectTaskPriority.high,
        status: ProjectTaskStatus.inProgress,
        startDate: now.subtract(const Duration(days: 5)), dueDate: now.add(const Duration(days: 2)),
        estimatedHours: 16, actualHours: 10,
        checklist: ['Route wiring left cove', 'Route wiring right cove', 'Junction box connection', 'Test LED strips'],
        checklistChecked: [true, true, false, false],
      ),
      ProjectTask(
        id: 'TSK-001-02', projectId: 'HOM-PRJ-001', milestoneId: 'MS-001-02',
        name: 'Gypsum board false ceiling finishing', description: 'Level, tape, joint, and prime all gypsum board sections',
        areaRoom: 'Master Bedroom', assignee: 'Arun Kumar', priority: ProjectTaskPriority.medium,
        status: ProjectTaskStatus.toDo,
        startDate: now.add(const Duration(days: 2)), dueDate: now.add(const Duration(days: 7)),
        estimatedHours: 24,
        dependencies: [const TaskDependency(fromTaskId: 'TSK-001-01', toTaskId: 'TSK-001-02')],
      ),
      ProjectTask(
        id: 'TSK-001-03', projectId: 'HOM-PRJ-001', milestoneId: 'MS-001-03',
        name: 'Receive Italian Statuario marble at site', description: 'Coordinate delivery, unloading, and inspection of imported marble consignment',
        areaRoom: 'Site Storage', assignee: 'Siddharth Roy', priority: ProjectTaskPriority.urgent,
        status: ProjectTaskStatus.waiting,
        startDate: now.subtract(const Duration(days: 2)), dueDate: now.add(const Duration(days: 5)),
        estimatedHours: 4,
      ),
      ProjectTask(
        id: 'TSK-001-04', projectId: 'HOM-PRJ-001', milestoneId: 'MS-001-02',
        name: 'Column cladding final polish', description: 'Apply final coat sealer on column stone cladding in living room',
        areaRoom: 'Living & Dining', assignee: 'Arun Kumar', priority: ProjectTaskPriority.medium,
        status: ProjectTaskStatus.completed,
        startDate: now.subtract(const Duration(days: 10)), dueDate: now.subtract(const Duration(days: 6)),
        estimatedHours: 8, actualHours: 7,
      ),
      ProjectTask(
        id: 'TSK-001-05', projectId: 'HOM-PRJ-001',
        name: 'Client progress update presentation', description: 'Prepare photo/video montage of site progress for client review meeting',
        assignee: 'Neha Deshmukh', priority: ProjectTaskPriority.low,
        status: ProjectTaskStatus.toDo,
        startDate: now, dueDate: now.add(const Duration(days: 3)),
        estimatedHours: 2,
      ),
      // PRJ-004 Tasks (delayed)
      ProjectTask(
        id: 'TSK-004-01', projectId: 'HOM-PRJ-004', milestoneId: 'MS-004-04',
        name: 'Complete acoustic panel installation in theater', description: 'Mount remaining 12 acoustic absorption panels on side walls',
        areaRoom: 'Home Theater', assignee: 'Dinesh Yadav', priority: ProjectTaskPriority.urgent,
        status: ProjectTaskStatus.inProgress,
        startDate: now.subtract(const Duration(days: 8)), dueDate: now.subtract(const Duration(days: 2)),
        estimatedHours: 12, actualHours: 9,
        isRescheduled: true, originalDueDate: now.subtract(const Duration(days: 5)),
        rescheduleReason: 'Acoustic panel delivery delayed by vendor', rescheduledBy: 'Aakash Verma',
      ),
      ProjectTask(
        id: 'TSK-004-02', projectId: 'HOM-PRJ-004', milestoneId: 'MS-004-04',
        name: 'AV system wiring and projector mount', description: 'Complete 7.1 surround sound wiring and ceiling projector bracket installation',
        areaRoom: 'Home Theater', assignee: 'Dinesh Yadav', priority: ProjectTaskPriority.high,
        status: ProjectTaskStatus.blocked,
        startDate: now.subtract(const Duration(days: 3)), dueDate: now.add(const Duration(days: 1)),
        estimatedHours: 8,
        dependencies: [const TaskDependency(fromTaskId: 'TSK-004-01', toTaskId: 'TSK-004-02')],
      ),
    ]);
  }

  void _seedSiteVisits() {
    final now = DateTime.now();
    _siteVisits.addAll([
      SiteVisit(
        id: 'SV-001', projectId: 'HOM-PRJ-001', clientName: 'Rahul & Neha Sharma',
        visitType: SiteVisitType.execution, date: now,
        startTime: '10:00 AM', endTime: '12:30 PM', assignedEmployee: 'Arun Kumar',
        purpose: 'Daily execution supervision — false ceiling and cove lighting',
        siteAddress: 'Tower C, Apt 1402, DLF The Camellias', contactPerson: 'Mr. Suresh', contactNumber: '+91 98100 33221',
        outcome: SiteVisitOutcome.completed,
        notes: 'Living area cove channel routing 90% complete. Need electrician for junction box tomorrow.',
      ),
      SiteVisit(
        id: 'SV-002', projectId: 'HOM-PRJ-001', clientName: 'Rahul & Neha Sharma',
        visitType: SiteVisitType.client, date: now.add(const Duration(days: 3)),
        startTime: '03:00 PM', endTime: '04:30 PM', assignedEmployee: 'Neha Deshmukh',
        purpose: 'Client progress review walkthrough with photo documentation',
        siteAddress: 'Tower C, Apt 1402, DLF The Camellias', contactPerson: 'Mrs. Neha Sharma', contactNumber: '+91 98101 23457',
        outcome: SiteVisitOutcome.pending,
        notes: 'Prepare before/after comparison photos for client presentation.',
        followUpRequired: true,
      ),
      SiteVisit(
        id: 'SV-003', projectId: 'HOM-PRJ-002', clientName: 'Vikramaditya Oberoi',
        visitType: SiteVisitType.measurement, date: now.add(const Duration(days: 5)),
        startTime: '11:00 AM', endTime: '02:00 PM', assignedEmployee: 'Aanya Sen',
        purpose: 'Detailed laser measurement of double-height foyer and master suite',
        siteAddress: 'Villa 18, Defence Colony', contactPerson: 'Mr. Rajan', contactNumber: '+91 98100 55000',
        outcome: SiteVisitOutcome.pending,
      ),
      SiteVisit(
        id: 'SV-004', projectId: 'HOM-PRJ-004', clientName: 'Meera Kapoor',
        visitType: SiteVisitType.inspection, date: now.subtract(const Duration(days: 1)),
        startTime: '02:00 PM', endTime: '04:00 PM', assignedEmployee: 'Aakash Verma',
        purpose: 'Inspect acoustic panel alignment and projector bracket position',
        siteAddress: 'Penthouse, Pioneer Araya', contactPerson: 'Ms. Meera Kapoor', contactNumber: '+91 98111 65432',
        outcome: SiteVisitOutcome.issuesFound,
        notes: 'Found 3 acoustic panels with misaligned mounting brackets. Need rework.',
        issuesFound: '3 acoustic panels misaligned, projector bracket angle off by 5°',
        workRequired: 'Remount panels #4, #7, #11. Adjust projector bracket angle.',
        followUpRequired: true, nextVisitDate: now.add(const Duration(days: 2)),
      ),
    ]);
  }

  void _seedSiteProgress() {
    final now = DateTime.now();
    _siteProgressEntries.addAll([
      SiteProgressEntry(
        id: 'SP-001', projectId: 'HOM-PRJ-001', areaRoom: 'Living & Dining',
        progressDate: now.subtract(const Duration(days: 1)), progressTime: '05:30 PM',
        submittedBy: 'Arun Kumar', workStage: 'False Ceiling - Framing',
        progressPercent: 65,
        description: 'Metal framing complete for main living area false ceiling. Cove channel routing in progress.',
        workCompleted: 'Metal framework installed for 640 sq.ft living-dining ceiling. L-channel cove profiles fixed on 3 walls.',
        workPending: 'Complete east wall cove channel. Begin gypsum board fixing.',
        issues: 'Minor delay in LED strip delivery from vendor. Expected tomorrow.',
        nextAction: 'Start gypsum board installation after cove wiring is complete.',
        images: ['site_progress_living_ceiling_01.jpg', 'site_progress_living_ceiling_02.jpg'],
        visibility: FileVisibility.clientVisible,
        approvalStatus: SiteProgressApprovalStatus.supervisorVerified,
      ),
      SiteProgressEntry(
        id: 'SP-002', projectId: 'HOM-PRJ-001', areaRoom: 'Master Bedroom',
        progressDate: now.subtract(const Duration(days: 2)), progressTime: '04:45 PM',
        submittedBy: 'Arun Kumar', workStage: 'Column Cladding',
        progressPercent: 100,
        description: 'Natural stone column cladding completed with final sealer coat applied.',
        workCompleted: 'All 4 structural columns clad with Carrara marble strips. Final polyurethane sealer applied.',
        workPending: 'None — task complete.',
        nextAction: 'Move team to guest bedroom civil work.',
        images: ['site_progress_column_clad_01.jpg'],
        visibility: FileVisibility.clientVisible,
        approvalStatus: SiteProgressApprovalStatus.clientVisible,
      ),
      SiteProgressEntry(
        id: 'SP-003', projectId: 'HOM-PRJ-004', areaRoom: 'Home Theater',
        progressDate: now.subtract(const Duration(days: 1)), progressTime: '06:00 PM',
        submittedBy: 'Dinesh Yadav', workStage: 'Acoustic Panel Installation',
        progressPercent: 70,
        description: 'Acoustic absorption panels installation ongoing. 3 panels need remounting due to alignment issues.',
        workCompleted: '9 out of 12 panels mounted. Ceiling diffuser panels done.',
        workPending: 'Remount panels #4, #7, #11. Projector bracket adjustment.',
        issues: 'Mounting bracket alignment off — need precision laser level for correction.',
        nextAction: 'Procure laser level tool. Schedule rework for day after tomorrow.',
        images: ['theater_panel_progress_01.jpg', 'theater_panel_issue_01.jpg'],
        visibility: FileVisibility.internal,
        approvalStatus: SiteProgressApprovalStatus.submitted,
      ),
    ]);
  }

  void _seedApprovals() {
    final now = DateTime.now();
    _approvals.addAll([
      WorkApproval(
        id: 'APR-001', projectId: 'HOM-PRJ-001', projectName: 'DLF Camellias 4BHK',
        milestoneId: 'MS-001-02', milestoneName: 'Civil & False Ceiling',
        type: ApprovalType.executionStage, clientName: 'Rahul & Neha Sharma',
        submittedBy: 'Arun Kumar', submittedDate: now.subtract(const Duration(days: 1)),
        status: ApprovalStatus.pending,
        description: 'False ceiling metal framing complete. Requesting approval to proceed with gypsum board installation.',
        images: ['ceiling_framing_complete_01.jpg', 'ceiling_framing_complete_02.jpg'],
        dueDate: now.add(const Duration(days: 2)),
        message: 'Dear Mr. Sharma, the ceiling framework is complete as per the approved 3D design. Please review the site photos and approve progression to gypsum board fixing.',
      ),
      WorkApproval(
        id: 'APR-002', projectId: 'HOM-PRJ-001', projectName: 'DLF Camellias 4BHK',
        type: ApprovalType.material, clientName: 'Rahul & Neha Sharma',
        submittedBy: 'Siddharth Roy', submittedDate: now.subtract(const Duration(days: 3)),
        status: ApprovalStatus.approved,
        description: 'Italian Statuario marble slab selection — Lot #IT-2026-0845. Approved by client during site visit.',
        images: ['marble_slab_selection_01.jpg'],
        approvedDate: now.subtract(const Duration(days: 2)), approvedBy: 'Rahul Sharma (Client)',
      ),
      WorkApproval(
        id: 'APR-003', projectId: 'HOM-PRJ-002', projectName: 'Defence Colony Duplex',
        type: ApprovalType.design, clientName: 'Vikramaditya Oberoi',
        submittedBy: 'Aanya Sen', submittedDate: now.subtract(const Duration(days: 2)),
        status: ApprovalStatus.pending,
        description: 'French chateau-inspired master suite 3D Lumion render — Version 2 with imported brass fixtures.',
        images: ['master_suite_render_v2_01.jpg', 'master_suite_render_v2_02.jpg'],
        dueDate: now.add(const Duration(days: 5)),
        message: 'Mr. Oberoi, please review the updated master suite design with the brass chandelier and mirror console specifications.',
      ),
      WorkApproval(
        id: 'APR-004', projectId: 'HOM-PRJ-003', projectName: 'Godrej Woods Kitchen',
        type: ApprovalType.design, clientName: 'Sanjay & Sunita Singhal',
        submittedBy: 'Priya Sharma', submittedDate: now.subtract(const Duration(days: 4)),
        status: ApprovalStatus.revisionRequested,
        description: 'L-shaped modular kitchen 3D layout with German Blum fittings.',
        images: ['kitchen_layout_v1_01.jpg'],
        rejectionReason: 'Client requested island counter option instead of L-shape. Revise with both options side-by-side.',
      ),
    ]);
  }

  void _seedComplaints() {
    final now = DateTime.now();
    _complaints.addAll([
      Complaint(
        id: 'CMP-001', projectId: 'HOM-PRJ-001', projectName: 'DLF Camellias 4BHK',
        clientId: 'HOM-CUST-801', clientName: 'Rahul & Neha Sharma',
        type: ComplaintType.execution, title: 'False ceiling junction box exposed wiring',
        description: 'Exposed wiring visible at junction box near guest bedroom entry. Safety concern raised by client during site visit.',
        priority: ComplaintPriority.high, areaRoom: 'Guest Bedroom', date: now.subtract(const Duration(days: 1)),
        reportedBy: 'Neha Sharma (Client)', assignedTo: 'Arun Kumar',
        status: ComplaintStatus.assigned,
        expectedResolution: now.add(const Duration(days: 2)),
        images: ['complaint_exposed_wire_01.jpg'],
      ),
      Complaint(
        id: 'CMP-002', projectId: 'HOM-PRJ-004', projectName: 'Pioneer Araya Penthouse',
        clientId: 'HOM-CUST-804', clientName: 'Meera Kapoor',
        type: ComplaintType.quality, title: 'Acoustic panel mounting brackets misaligned',
        description: 'Three acoustic absorption panels (positions #4, #7, #11) have visibly misaligned mounting brackets. Client noticed during inspection visit.',
        priority: ComplaintPriority.medium, areaRoom: 'Home Theater', date: now.subtract(const Duration(days: 1)),
        reportedBy: 'Meera Kapoor (Client)', assignedTo: 'Dinesh Yadav',
        status: ComplaintStatus.inProgress,
        expectedResolution: now.add(const Duration(days: 3)),
        images: ['complaint_panel_misalign_01.jpg', 'complaint_panel_misalign_02.jpg'],
      ),
      Complaint(
        id: 'CMP-003', projectId: 'HOM-PRJ-004', projectName: 'Pioneer Araya Penthouse',
        clientId: 'HOM-CUST-804', clientName: 'Meera Kapoor',
        type: ComplaintType.timeline, title: 'Project completion delayed by 5 days',
        description: 'Original handover date was passed 5 days ago. Client unhappy with the delay caused by acoustic panel vendor issues.',
        priority: ComplaintPriority.high, date: now.subtract(const Duration(days: 5)),
        reportedBy: 'Meera Kapoor (Client)', assignedTo: 'Aakash Verma',
        status: ComplaintStatus.acknowledged,
        expectedResolution: now.add(const Duration(days: 10)),
        escalationLevel: 1,
      ),
    ]);
  }

  void _seedCommercials() {
    final now = DateTime.now();
    // PRJ-001 Expenses
    _materialExpenses.addAll([
      MaterialExpense(
        id: 'MAT-001', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 20)),
        vendor: 'Italica Marble Imports', material: 'Italian Statuario Marble (Lot #IT-2026-0845)',
        invoiceNumber: 'IMI-2026-1845', amount: 8.5, paid: 8.5, due: 0,
        paymentDate: now.subtract(const Duration(days: 18)), commissionPercent: 8,
      ),
      MaterialExpense(
        id: 'MAT-002', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 15)),
        vendor: 'Gyproc India Ltd', material: 'Gypsum Board & Metal Framework',
        invoiceNumber: 'GYP-26-4420', amount: 2.8, paid: 2.8, due: 0,
        paymentDate: now.subtract(const Duration(days: 12)), commissionPercent: 5,
      ),
      MaterialExpense(
        id: 'MAT-003', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 5)),
        vendor: 'Havells India', material: 'LED Strip Lights & Drivers',
        invoiceNumber: 'HAV-26-8812', amount: 1.2, paid: 0, due: 1.2,
        paymentDate: now.add(const Duration(days: 10)), commissionPercent: 6,
      ),
    ]);

    _labourExpenses.addAll([
      LabourExpense(
        id: 'LAB-001', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 14)),
        labourName: 'Rajesh Carpenter Team', work: 'False Ceiling Metal Framework Installation',
        amount: 1.8, paid: 1.8, due: 0,
        paymentDate: now.subtract(const Duration(days: 7)), commissionPercent: 10,
      ),
      LabourExpense(
        id: 'LAB-002', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 7)),
        labourName: 'Suresh Electric Works', work: 'Electrical Wiring & Junction Box Routing',
        amount: 0.95, paid: 0.5, due: 0.45,
        paymentDate: now.add(const Duration(days: 7)), commissionPercent: 10,
      ),
    ]);

    _feeRecords.addAll([
      FeeRecord(
        id: 'FEE-001', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 28)),
        feeType: CommercialRecordType.designFee, receivedBy: 'Siddharth Roy',
        amount: 3.25, paid: 3.25, due: 0, commissionPercent: 15,
      ),
      FeeRecord(
        id: 'FEE-002', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 14)),
        feeType: CommercialRecordType.supervisionFee, receivedBy: 'Arun Kumar',
        amount: 1.5, paid: 1.0, due: 0.5, commissionPercent: 12,
      ),
    ]);

    _payments.addAll([
      ProjectPayment(
        id: 'PAY-001', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 30)),
        amount: 6.5, mode: 'NEFT', reference: 'UTR-CAM-001', notes: 'Token advance / 10% booking amount',
      ),
      ProjectPayment(
        id: 'PAY-002', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 14)),
        amount: 13.0, mode: 'RTGS', reference: 'UTR-CAM-002', notes: 'Design freeze milestone payment (20%)',
      ),
      ProjectPayment(
        id: 'PAY-003', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 3)),
        amount: 6.5, mode: 'UPI', reference: 'UPI-CAM-003', notes: 'Partial civil milestone payment',
      ),
    ]);
  }

  void _seedTimeline() {
    final now = DateTime.now();
    _timelineEvents.addAll([
      ProjectTimelineEvent(
        id: 'TL-001', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 35)),
        user: 'System', action: 'Project Created',
        description: 'DLF Camellias 4BHK project created from booking HOM-LD-1024.',
        icon: Icons.add_circle_rounded, iconColor: const Color(0xFF10B981),
      ),
      ProjectTimelineEvent(
        id: 'TL-002', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 28)),
        user: 'Siddharth Roy', action: 'Design Phase Started',
        description: 'Started 3D concept rendering for all 6 rooms using 3ds Max + V-Ray.',
        icon: Icons.design_services_rounded, iconColor: const Color(0xFF8B5CF6),
      ),
      ProjectTimelineEvent(
        id: 'TL-003', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 14)),
        user: 'Rahul Sharma (Client)', action: 'Design Approved',
        description: 'Client signed off on all room designs. Material sample board approved.',
        icon: Icons.check_circle_rounded, iconColor: const Color(0xFF10B981),
      ),
      ProjectTimelineEvent(
        id: 'TL-004', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 14)),
        user: 'Finance System', action: 'Payment Received ₹13.0L',
        description: 'Design freeze milestone payment received via RTGS.',
        icon: Icons.payments_rounded, iconColor: const Color(0xFF0EA5E9),
      ),
      ProjectTimelineEvent(
        id: 'TL-005', projectId: 'HOM-PRJ-001', date: now.subtract(const Duration(days: 1)),
        user: 'Arun Kumar', action: 'Site Progress Updated',
        description: 'False ceiling framing 65% complete. Cove lighting wiring in progress.',
        icon: Icons.engineering_rounded, iconColor: const Color(0xFF3B82F6),
      ),
      ProjectTimelineEvent(
        id: 'TL-006', projectId: 'HOM-PRJ-004', date: now.subtract(const Duration(days: 5)),
        user: 'System', action: 'Project Marked Delayed',
        description: 'Pioneer Araya project exceeded expected completion date by 5 days.',
        icon: Icons.warning_amber_rounded, iconColor: const Color(0xFFEF4444),
      ),
    ]);
  }

  void _seedAlerts() {
    _alerts.addAll([
      const ProjectAlert(
        id: 'ALT-001', projectId: 'HOM-PRJ-001',
        type: 'approval', message: '2 approvals pending client response for DLF Camellias',
        severity: 'warning', icon: Icons.pending_actions_rounded, color: Color(0xFFF59E0B),
      ),
      const ProjectAlert(
        id: 'ALT-002', projectId: 'HOM-PRJ-001',
        type: 'payment', message: '₹39L outstanding — next milestone payment due in 7 days',
        severity: 'info', icon: Icons.payments_outlined, color: Color(0xFF3B82F6),
      ),
      const ProjectAlert(
        id: 'ALT-003', projectId: 'HOM-PRJ-004',
        type: 'delay', message: 'Pioneer Araya project delayed by 5 days — handover overdue',
        severity: 'critical', icon: Icons.error_outline_rounded, color: Color(0xFFEF4444),
      ),
      const ProjectAlert(
        id: 'ALT-004', projectId: 'HOM-PRJ-004',
        type: 'complaint', message: '2 open complaints for Pioneer Araya — 1 escalated to Level 1',
        severity: 'warning', icon: Icons.report_problem_outlined, color: Color(0xFFF59E0B),
      ),
      const ProjectAlert(
        id: 'ALT-005', projectId: 'HOM-PRJ-003',
        type: 'approval', message: 'Kitchen layout revision requested — client waiting for updated design',
        severity: 'warning', icon: Icons.rate_review_outlined, color: Color(0xFFEA580C),
      ),
    ]);
  }
}
