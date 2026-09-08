import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/app/router/app_router.dart';
import 'package:client/features/designs/index.dart';

void main() {
  group('Designs Module - Domain Models & Enums Tests', () {
    test('Enums expose correct labels and properties', () {
      expect(DesignStage.concept.label, 'Concept & Moodboard');
      expect(DesignStage.executionHandover.label, 'Execution Handover');

      expect(DesignCategory.twoDCad.label, '2D CAD Drawings');
      expect(DesignCategory.threeDRender.label, '3D Photorealistic Renders');

      expect(DesignReviewStatus.draft.label, contains('Draft'));
      expect(DesignReviewStatus.approved.isApproved, isTrue);
      expect(DesignReviewStatus.sentToExecution.isApproved, isTrue);
      expect(DesignReviewStatus.underClientReview.isPendingReview, isTrue);
      expect(DesignReviewStatus.revisionRequested.isRevisionNeeded, isTrue);

      expect(DesignFileType.dwg.extension, '.dwg');
      expect(DesignFileType.pdf.isBrowserPreviewable, isTrue);

      expect(CloudFolderType.cadDrawings.folderCode, '04_2D_Drawings');
      expect(RevisionStatus.requested.label, contains('Requested'));
      expect(HandoverStatus.accepted.label, contains('Accepted'));
      expect(DesignPriority.urgent.label, 'Urgent');
    });

    test('DesignProject model computed properties', () {
      final project = DesignProject(
        id: 'PRJ-104',
        code: 'PRJ-104',
        name: 'Skyline Penthouse',
        clientName: 'Vikram Malhotra',
        projectManager: 'Suresh Raina',
        designer: 'Ananya Roy',
        stage: DesignStage.clientReview,
        progressPercent: 75.0,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        targetCompletionDate: DateTime.now().add(const Duration(days: 15)),
        lastUpdated: DateTime.now(),
      );

      expect(project.isOverdue, isFalse);
      expect(project.designStage, DesignStage.clientReview);
      expect(project.leadDesigner, 'Ananya Roy');
    });

    test('DesignDeliverable versioning and status checks', () {
      final deliverable = DesignDeliverable(
        id: 'del-1',
        projectCode: 'PRJ-104',
        projectName: 'Skyline Penthouse',
        title: 'Master Layout Plan',
        roomArea: 'Master Suite',
        category: DesignCategory.twoDCad,
        fileType: DesignFileType.dwg,
        currentVersion: 'v2.0',
        status: DesignReviewStatus.underClientReview,
        designerName: 'Ananya Roy',
        clientName: 'Vikram Malhotra',
        createdAt: DateTime.now(),
        clientReviewSlaDeadline: DateTime.now().add(const Duration(days: 2)),
        thumbnailUrl: '',
        fileUrl: '',
        fileSizeBytes: 5242880, // 5 MB
      );

      expect(deliverable.isUnderReview, isTrue);
      expect(deliverable.isApproved, isFalse);
      expect(deliverable.fileSizeBytesFormatted, contains('5.0 MB'));
    });

    test('DesignHandover checklist satisfaction checks', () {
      final handover = DesignHandover(
        id: 'hnd-1',
        projectCode: 'PRJ-104',
        projectName: 'Skyline Penthouse',
        packageVersion: 'PKG-v1.0',
        handoverName: 'GFC Release',
        executionManager: 'Suresh Raina',
        checklist: const [
          HandoverChecklistItem(id: 'c1', title: 'Arch Review', isSatisfied: true),
          HandoverChecklistItem(id: 'c2', title: 'MEP Clearance', isSatisfied: false),
        ],
      );

      expect(handover.isAllChecklistSatisfied, isFalse);
      expect(handover.satisfiedChecklistCount, 1);
    });
  });

  group('Designs Module - Repository Unit Tests', () {
    late DesignsRepository repo;

    setUp(() {
      repo = DesignsRepository();
    });

    test('Repository contains realistic seed data', () {
      expect(repo.projects, isNotEmpty);
      expect(repo.deliverables, isNotEmpty);
      expect(repo.revisions, isNotEmpty);
      expect(repo.approvals, isNotEmpty);
      expect(repo.handovers, isNotEmpty);
      expect(repo.folders, isNotEmpty);
      expect(repo.driveFiles, isNotEmpty);
      expect(repo.designerWorkloads, isNotEmpty);
    });

    test('Workspace KPIs computation', () {
      final kpis = repo.getWorkspaceKpis();
      expect(kpis.activeDesignProjects, greaterThanOrEqualTo(1));
      expect(kpis.totalDesignFiles, greaterThanOrEqualTo(1));
      expect(kpis.averageApprovalTurnaroundHours, greaterThan(0));
    });

    test('Deliverable upload and versioning mutation', () {
      final initialCount = repo.deliverables.length;
      final newDeliverable = DesignDeliverable(
        id: 'test-del-${DateTime.now().millisecondsSinceEpoch}',
        projectCode: 'PRJ-104',
        projectName: 'Skyline Penthouse',
        title: 'Balcony Landscaping Plan',
        roomArea: 'Outdoor Terrace',
        category: DesignCategory.twoDCad,
        fileType: DesignFileType.dwg,
        currentVersion: 'v1.0',
        designerName: 'Ananya Roy',
        clientName: 'Vikram Malhotra',
        createdAt: DateTime.now(),
        thumbnailUrl: '',
        fileUrl: '',
        fileSizeBytes: 2048000,
      );

      repo.uploadDeliverable(newDeliverable);
      expect(repo.deliverables.length, initialCount + 1);

      // Create new version
      final newVer = DesignVersionRecord(
        versionTag: 'v2.0',
        fileName: 'Balcony_v2.dwg',
        fileUrl: '',
        fileSizeBytes: 2100000,
        uploadedAt: DateTime.now(),
        uploadedByName: 'Ananya Roy',
        changelogNote: 'Planter box depth updated to 600mm',
        reviewStatus: DesignReviewStatus.underClientReview,
      );

      repo.createNewVersion(newDeliverable.id, newVer);
      final updated = repo.deliverables.firstWhere((d) => d.id == newDeliverable.id);
      expect(updated.currentVersion, 'v2.0');
      expect(updated.versionHistory.first.versionTag, 'v2.0');
    });

    test('Client approval workflow and webhook update', () {
      final d = repo.deliverables.first;
      repo.clientApprove(d.id, 'Vikram Malhotra', 'Looks perfect, proceed to site!');

      final updated = repo.deliverables.firstWhere((item) => item.id == d.id);
      expect(updated.status, DesignReviewStatus.approved);
    });

    test('Handover package creation and site acknowledgment', () {
      final pkg = DesignHandover(
        id: 'test-hnd-${DateTime.now().millisecondsSinceEpoch}',
        projectCode: 'PRJ-104',
        projectName: 'Skyline Penthouse',
        packageVersion: 'PKG-TEST-v1.0',
        handoverName: 'Test GFC Bundle',
        executionManager: 'Suresh Raina',
        status: HandoverStatus.draft,
        checklist: const [
          HandoverChecklistItem(id: 'chk-t1', title: 'Sign-off', isSatisfied: true),
        ],
      );

      repo.createHandoverPackage(pkg);
      expect(repo.handovers.any((h) => h.id == pkg.id), isTrue);

      repo.sendToExecution(pkg.id);
      final sent = repo.handovers.firstWhere((h) => h.id == pkg.id);
      expect(sent.status, HandoverStatus.pendingReview);

      repo.acknowledgeHandover(pkg.id, true);
      final accepted = repo.handovers.firstWhere((h) => h.id == pkg.id);
      expect(accepted.status, HandoverStatus.accepted);
    });

    test('Cloud Drive Super Admin 2FA Deletion Policy', () {
      final testFile = CloudDriveFile(
        id: 'test-file-${DateTime.now().millisecondsSinceEpoch}',
        projectCode: 'PRJ-104',
        folderId: 'fld-test',
        fileName: 'Draft_Purge_Me.dwg',
        fileType: DesignFileType.dwg,
        fileSizeBytes: 1024,
        uploadedAt: DateTime.now(),
        uploadedBy: 'Tester',
      );

      repo.uploadDriveFile(testFile);
      expect(repo.driveFiles.any((f) => f.id == testFile.id), isTrue);

      // Wrong OTP fails deletion
      final wrongResult = repo.deleteFileWithSuperAdmin2FA(testFile.id, 'Super Admin', '000000', 'Test reason');
      expect(wrongResult, isFalse);
      expect(repo.driveFiles.any((f) => f.id == testFile.id), isTrue);

      // Correct OTP (884129) authorizes deletion and appends to audit log
      final successResult = repo.deleteFileWithSuperAdmin2FA(testFile.id, 'Super Admin', '884129', 'Authorized cleanup');
      expect(successResult, isTrue);
      expect(repo.driveFiles.any((f) => f.id == testFile.id), isFalse);
      expect(repo.deletionAuditLogs.any((log) => log.itemName == testFile.fileName), isTrue);
    });
  });

  group('Designs Module - Widget Smoke Tests (1440x900 Desktop)', () {
    Widget buildTestApp(Widget child) {
      return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF2563EB),
        ),
        home: child,
      );
    }

    void setDesktopSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('Screen 1: DesignWorkspacePage renders with KPIs and deliverables', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const DesignWorkspacePage()));
      await tester.pumpAndSettle();

      expect(find.text('Design Workspace & DAM Hub'), findsOneWidget);
      expect(find.text('ACTIVE PROJECTS'), findsOneWidget);
      expect(find.text('CLIENT REVIEW LOOP'), findsOneWidget);
      expect(find.text('SENT TO EXECUTION'), findsOneWidget);
      expect(find.text('Designer Team Workload'), findsOneWidget);
      expect(find.text('Project Design Progress'), findsOneWidget);
    });

    testWidgets('Screen 2: DesignFilesPage renders folder tree and breadcrumbs', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const DesignFilesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Structured Files & Folder DAM'), findsOneWidget);
      expect(find.text('PRJ-104 Cloud Drive'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_queue_rounded), findsOneWidget);
    });

    testWidgets('Screen 3: DesignRevisionsPage renders revisions and SLA badges', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const DesignRevisionsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Design Revision Control & Change Requests'), findsOneWidget);
      expect(find.text('TOTAL REVISIONS LOGGED'), findsOneWidget);
      expect(find.text('AWAITING ACTION'), findsOneWidget);
    });

    testWidgets('Screen 4: DesignApprovalLoopPage renders tabs and approval cards', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const DesignApprovalLoopPage()));
      await tester.pumpAndSettle();

      expect(find.text('Client Review & Approval Loop'), findsOneWidget);
      expect(find.text('Under Client Review'), findsWidgets);
      expect(find.text('Approved Deliverables'), findsOneWidget);
      expect(find.text('Revisions Requested'), findsOneWidget);
    });

    testWidgets('Screen 5: DesignHandoverPage renders GFC packages and checklist', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const DesignHandoverPage()));
      await tester.pumpAndSettle();

      expect(find.text('Design-to-Execution Handover'), findsOneWidget);
      expect(find.text('TOTAL HANDOVER PACKAGES'), findsOneWidget);
      expect(find.text('DISPATCHED TO SITE'), findsOneWidget);
      expect(find.text('New Handover Package'), findsOneWidget);
    });

    testWidgets('Screen 6: DesignCloudDrivePage renders central vault and 2FA policy', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const DesignCloudDrivePage()));
      await tester.pumpAndSettle();

      expect(find.text('Central Cloud Drive & Digital Asset Management'), findsOneWidget);
      expect(find.text('Strict DAM Deletion Policy Active: Dual-Custody 2FA Authorization Required'), findsOneWidget);
      expect(find.text('TOTAL CLOUD FILES'), findsOneWidget);
      expect(find.text('STORAGE CONSUMED'), findsOneWidget);
    });

    testWidgets('AppRouter resolves /designs/approvals and /designs/drive without default template', (tester) async {
      setDesktopSize(tester);

      // Verify Client Approvals route
      AppRouter.router.go('/designs/approvals');
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: AppRouter.router,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DesignApprovalLoopPage), findsOneWidget);
      expect(find.text('Client Review & Approval Loop'), findsOneWidget);
      expect(find.text('This is Client Approvals'), findsNothing);

      // Verify Cloud Drive route
      AppRouter.router.go('/designs/drive');
      await tester.pumpAndSettle();

      expect(find.byType(DesignCloudDrivePage), findsOneWidget);
      expect(find.text('Central Cloud Drive & Digital Asset Management'), findsOneWidget);
      expect(find.text('This is Cloud Drive'), findsNothing);
    });
  });
}
