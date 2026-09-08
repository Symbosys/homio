import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/projects/index.dart';

void main() {
  group('Projects Domain Models Tests', () {
    test('Project model calculations', () {
      final now = DateTime.now();
      final project = Project(
        id: 'test-p1',
        name: 'Villa Royale',
        code: 'PRJ-VIL-001',
        type: ProjectType.turnkey,
        status: ProjectStatus.execution,
        health: ProjectHealth.healthy,
        currentStage: ProjectStage.execution,
        clientId: 'c1',
        clientName: 'Sunita Sharma',
        createdDate: now.subtract(const Duration(days: 30)),
        plannedStartDate: now.subtract(const Duration(days: 20)),
        expectedCompletion: now.add(const Duration(days: 100)),
        lastUpdated: now,
        progressPercent: 65.0,
        contractAmountLakhs: 50.0,
        totalReceivedLakhs: 35.0,
        totalOutstandingLakhs: 15.0,
      );

      expect(project.id, 'test-p1');
      expect(project.code, 'PRJ-VIL-001');
      expect(project.progressPercent, 65.0);
      expect(project.status.isActive, true);
      expect(project.health, ProjectHealth.healthy);
    });

    test('ProjectCommercialSummary calculations', () {
      const summary = ProjectCommercialSummary(
        contractAmount: 5000000,
        additionalWork: 500000,
        discount: 200000,
        materialCost: 2000000,
        labourCost: 1000000,
        supervisionFees: 300000,
        consultingFees: 200000,
        totalReceived: 4000000,
      );

      expect(summary.revisedContract, 5300000);
      expect(summary.totalExpenses, 3500000);
      expect(summary.totalOutstanding, 1300000);
      expect(summary.grossMargin, closeTo(33.96, 0.1));
    });

    test('ProjectTask overdue and delay calculation', () {
      final overdueTask = ProjectTask(
        id: 't-overdue',
        projectId: 'p1',
        name: 'Overdue task',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        status: ProjectTaskStatus.inProgress,
      );

      expect(overdueTask.isOverdue, true);
      expect(overdueTask.delayDays >= 2, true);

      final completedTask = overdueTask.copyWith(status: ProjectTaskStatus.completed);
      expect(completedTask.isOverdue, false);
    });

    test('WorkApproval status checks', () {
      final approval = WorkApproval(
        id: 'app-1',
        projectId: 'p1',
        type: ApprovalType.design,
        submittedDate: DateTime.now(),
        status: ApprovalStatus.pending,
      );

      expect(approval.status, ApprovalStatus.pending);
      expect(approval.type.label, 'Design Approval');
    });

    test('Complaint resolved flag', () {
      final complaint = Complaint(
        id: 'c-1',
        projectId: 'p1',
        type: ComplaintType.quality,
        title: 'Paint chip',
        description: 'Chipped edge on skirting',
        date: DateTime.now(),
        status: ComplaintStatus.open,
      );

      expect(complaint.isResolved, false);

      final resolved = complaint.copyWith(status: ComplaintStatus.resolved);
      expect(resolved.isResolved, true);
    });
  });

  group('Projects Repository Tests', () {
    late ProjectsRepository repo;

    setUp(() {
      repo = ProjectsRepository();
    });

    test('Repository seeds initial data', () {
      expect(repo.projects.isNotEmpty, true);
      expect(repo.milestones.isNotEmpty, true);
      expect(repo.tasks.isNotEmpty, true);
      expect(repo.siteVisits.isNotEmpty, true);
      expect(repo.siteProgressEntries.isNotEmpty, true);
      expect(repo.approvals.isNotEmpty, true);
      expect(repo.complaints.isNotEmpty, true);
    });

    test('Repository KPI computation', () {
      final kpis = repo.getProjectKpis();
      expect(kpis.totalProjects, greaterThan(0));
      expect(kpis.ongoingProjects, greaterThan(0));
    });

    test('Mutating task status works', () {
      final firstTask = repo.tasks.first;
      repo.updateTaskStatus(firstTask.id, ProjectTaskStatus.completed);

      final updated = repo.tasks.firstWhere((t) => t.id == firstTask.id);
      expect(updated.status, ProjectTaskStatus.completed);
    });

    test('Adding and resolving complaint works', () {
      final newC = Complaint(
        id: 'test-complaint-99',
        projectId: repo.projects.first.id,
        type: ComplaintType.quality,
        title: 'Loose tile in kitchen',
        description: 'Grouting missing on two corners',
        date: DateTime.now(),
      );

      repo.addComplaint(newC);
      expect(repo.complaints.any((c) => c.id == 'test-complaint-99'), true);

      repo.resolveComplaint(
        'test-complaint-99',
        ComplaintResolution(
          description: 'Regrouted and sealed',
          resolvedBy: 'Tile Specialist',
          resolvedDate: DateTime.now(),
          customerConfirmed: true,
        ),
      );

      final resolved = repo.complaints.firstWhere((c) => c.id == 'test-complaint-99');
      expect(resolved.status, ComplaintStatus.resolved);
      expect(resolved.resolution?.resolvedBy, 'Tile Specialist');
    });
  });

  group('Projects Screens Smoke Tests', () {
    void setupDesktopSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Widget testHarness(Widget child) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: child,
      );
    }

    testWidgets('AllProjectsPage renders header and search', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const AllProjectsPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('All Projects'), findsWidgets);
      expect(find.text('New Project'), findsOneWidget);
    });

    testWidgets('ProjectOverviewPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectOverviewPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Project Overview'), findsOneWidget);
    });

    testWidgets('ProjectGanttPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectGanttPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Gantt / Timeline'), findsOneWidget);
    });

    testWidgets('ProjectMilestonesPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectMilestonesPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Project Milestones'), findsOneWidget);
      expect(find.text('New Milestone'), findsOneWidget);
    });

    testWidgets('ProjectTasksPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectTasksPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Project Tasks'), findsOneWidget);
      expect(find.text('New Task'), findsOneWidget);
    });

    testWidgets('ProjectSiteProgressPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectSiteProgressPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Site Progress'), findsOneWidget);
      expect(find.text('Post Update'), findsOneWidget);
    });

    testWidgets('ProjectSiteVisitsPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectSiteVisitsPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Site Visits'), findsOneWidget);
      expect(find.text('Schedule Visit'), findsOneWidget);
    });

    testWidgets('ProjectApprovalsPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectApprovalsPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Work Approvals'), findsOneWidget);
      expect(find.text('Request Approval'), findsOneWidget);
    });

    testWidgets('ProjectComplaintsPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectComplaintsPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Complaints / Snags'), findsOneWidget);
      expect(find.text('Report Snag'), findsOneWidget);
    });

    testWidgets('ProjectCommercialsPage renders', (tester) async {
      setupDesktopSize(tester);
      await tester.pumpWidget(testHarness(const ProjectCommercialsPage()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Project Commercials'), findsOneWidget);
      expect(find.text('Record Payment'), findsOneWidget);
    });
  });
}
