import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/designs_vault/index.dart';

void main() {
  group('3D Designs & CAD Vault Domain Models & Data Integrity Tests', () {
    test('DesignAsset model holds complete visualization parameters', () {
      const asset = DesignAsset(
        id: 'asset_test',
        title: 'Grand Living Lounge',
        roomZone: 'Living & Foyer',
        type: AssetType.render3D,
        version: 'v2.1 (Approved)',
        date: 'Aug 18, 2026',
        designer: 'Pooja Hegde',
        resolution: '4K UHD (3840x2160)',
        revisionCount: 2,
        isApproved: true,
        gradientStart: Color(0xFF1E1B4B),
        gradientEnd: Color(0xFF312E81),
        styleTag: 'Italian Minimalist',
        description: 'Living room layout visual.',
      );

      expect(asset.id, 'asset_test');
      expect(asset.type, AssetType.render3D);
      expect(asset.isApproved, isTrue);
      expect(asset.revisionCount, 2);
    });

    test('CadDocument model holds technical metadata and file attributes', () {
      const doc = CadDocument(
        id: 'cad_test',
        fileName: 'Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg',
        fileFormat: 'DWG',
        fileSize: '14.2 MB',
        category: 'Architectural Working Plan',
        uploadDate: 'Aug 04, 2026',
        uploader: 'Ar. Sameer Mehta',
        isApproved: true,
        description: 'AutoCAD 2026 drawing.',
      );

      expect(doc.fileFormat, 'DWG');
      expect(doc.fileSize, '14.2 MB');
      expect(doc.isApproved, isTrue);
      expect(doc.category, 'Architectural Working Plan');
    });
  });

  group('ClientDesignsVaultPage Widget & Responsiveness Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ClientDesignsVaultPage(),
      );
    }

    testWidgets('Renders all sections with zero overflows on desktop viewport (1440x1600)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Header & Project Pill
      expect(find.text('3D Designs & CAD Vault'), findsOneWidget);
      expect(find.text('Skyline Villa Penthouse 402, Worli • 4 BHK Luxury'), findsOneWidget);
      expect(find.text('11 Approved Blueprints • Cloud Synced'), findsOneWidget);
      expect(find.text('Request Design Revision'), findsOneWidget);

      // Metric Strip
      expect(find.text('12 Files'), findsOneWidget);
      expect(find.text('11 Approved'), findsOneWidget);
      expect(find.text('1 Under Review'), findsOneWidget);
      expect(find.text('2 of 3 Used'), findsOneWidget);

      // Filters
      expect(find.text('All Assets'), findsOneWidget);
      expect(find.text('3D Renders'), findsOneWidget);
      expect(find.text('CAD Blueprints'), findsOneWidget);
      expect(find.text('MEP & Electrical'), findsOneWidget);
      expect(find.text('Moodboards & BOQ'), findsOneWidget);

      expect(find.text('All Zones'), findsOneWidget);
      expect(find.text('Living & Foyer'), findsWidgets);
      expect(find.text('Modular Kitchen'), findsWidgets);

      // 3D Render Cards
      expect(find.text('Grand Living Lounge & Double-Height Atrium'), findsOneWidget);
      expect(find.text('Bespoke Island Modular Kitchen & Wet Pantry'), findsOneWidget);

      // CAD Technical Documents
      expect(find.text('Approved CAD Drawings & Technical Blueprint Vault'), findsOneWidget);
      expect(find.text('Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg'), findsOneWidget);

      // Security banner
      expect(find.text('Encrypted Blueprint Vault Policy'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly without overflow on mobile viewport (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('3D Designs & CAD Vault'), findsOneWidget);
      expect(find.text('12 Files'), findsOneWidget);
      expect(find.text('All Assets'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Filters assets by category and room zone',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state has both 3D renders and CAD blueprints
      expect(find.text('Grand Living Lounge & Double-Height Atrium'), findsOneWidget);
      expect(find.text('Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg'), findsOneWidget);

      // Select CAD Blueprints category filter
      final cadFilter = find.text('CAD Blueprints');
      expect(cadFilter, findsOneWidget);
      await tester.tap(cadFilter);
      await tester.pumpAndSettle();

      // 3D Renders section hidden
      expect(find.text('Photorealistic 3D Visualizer Gallery'), findsNothing);
      expect(find.text('Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg'), findsOneWidget);

      // Switch to 3D Renders filter
      await tester.tap(find.text('3D Renders'));
      await tester.pumpAndSettle();

      expect(find.text('Photorealistic 3D Visualizer Gallery'), findsOneWidget);
      expect(find.text('Approved CAD Drawings & Technical Blueprint Vault'), findsNothing);

      // Reset to All Assets
      await tester.tap(find.text('All Assets'));
      await tester.pumpAndSettle();

      expect(find.text('Photorealistic 3D Visualizer Gallery'), findsOneWidget);
      expect(find.text('Approved CAD Drawings & Technical Blueprint Vault'), findsOneWidget);
    });

    testWidgets('Opens 3D Lightbox modal with Day/Night simulation toggle',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap first 3D render card image prompt
      final expandPrompt = find.text('Tap to Expand Lightbox');
      expect(expandPrompt, findsWidgets);
      await tester.ensureVisible(expandPrompt.first);
      await tester.tap(expandPrompt.first);
      await tester.pumpAndSettle();

      // Lightbox modal shown
      expect(find.text('4000K Natural Daylight Simulation'), findsOneWidget);
      expect(find.text('Daylight Mode'), findsOneWidget);

      // Toggle to Evening / Warm lighting
      await tester.tap(find.text('Daylight Mode'));
      await tester.pumpAndSettle();

      expect(find.text('3000K Warm Evening Atmosphere Simulation'), findsOneWidget);
      expect(find.text('Warm Night Mode'), findsOneWidget);

      // Close modal
      final closeIcon = find.byIcon(Icons.close);
      expect(closeIcon, findsWidgets);
      await tester.tap(closeIcon.first);
      await tester.pumpAndSettle();

      expect(find.text('3000K Warm Evening Atmosphere Simulation'), findsNothing);
    });

    testWidgets('Opens CAD Document Viewer modal and displays file specs',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Switch to CAD Blueprints category so the CAD tiles are at the top
      await tester.tap(find.text('CAD Blueprints'));
      await tester.pumpAndSettle();

      final previewButtons = find.byTooltip('Preview Document');
      expect(previewButtons, findsWidgets);

      await tester.ensureVisible(previewButtons.first);
      await tester.tap(previewButtons.first);
      await tester.pumpAndSettle();

      // Document modal visible
      expect(find.text('Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg'), findsWidgets);
      expect(find.textContaining('File Format: DWG'), findsOneWidget);

      final closeBtn = find.byIcon(Icons.close);
      expect(closeBtn, findsWidgets);
      await tester.tap(closeBtn.first);
      await tester.pumpAndSettle();

      expect(find.textContaining('File Format: DWG'), findsNothing);
    });

    testWidgets('Triggers SnackBar when downloading CAD blueprint',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Switch to CAD Blueprints category so the CAD tiles are at the top
      await tester.tap(find.text('CAD Blueprints'));
      await tester.pumpAndSettle();

      final downloadButtons = find.byTooltip('Download File');
      expect(downloadButtons, findsWidgets);

      await tester.ensureVisible(downloadButtons.first);
      await tester.tap(downloadButtons.first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Downloading Skyline_Penthouse_Detailed_Architectural_Floor_Plan_Rev2.dwg'), findsOneWidget);
    });

    testWidgets('Opens Design Revision modal and submits client revision request',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final requestRevisionBtn = find.text('Request Design Revision');
      expect(requestRevisionBtn, findsOneWidget);
      await tester.tap(requestRevisionBtn);
      await tester.pumpAndSettle();

      // Modal is visible
      expect(find.text('Request 3D Design Revision'), findsOneWidget);
      expect(find.text('Revision Focus Area'), findsOneWidget);
      expect(find.textContaining('1 complimentary revision cycle remaining'), findsOneWidget);

      // Enter instructions
      await tester.enterText(
        find.byType(TextField),
        'Please adjust the bar counter height to 42 inches and add wine chiller recess.',
      );
      await tester.pumpAndSettle();

      // Submit
      final submitBtn = find.text('Submit Revision');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Modal closed and SnackBar shown
      expect(find.text('Request 3D Design Revision'), findsNothing);
      expect(find.textContaining('Revision request submitted to Sr. Designer Pooja Hegde!'), findsOneWidget);
    });
  });
}
