import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/ai_studio/index.dart';

void main() {
  group('Client AI Studio Domain Models Unit Tests', () {
    test('AiWallet stores balances and designer revenue share', () {
      final wallet = AiWallet(totalTokens: 240, freeDoubtQueriesLeft: 2);
      expect(wallet.totalTokens, 240);
      expect(wallet.freeDoubtQueriesLeft, 2);
      expect(wallet.assignedDesigner, 'Pooja Hegde');
      expect(wallet.designerRevenueSharePercent, 50.0);

      wallet.totalTokens += 50;
      wallet.freeDoubtQueriesLeft -= 1;
      expect(wallet.totalTokens, 290);
      expect(wallet.freeDoubtQueriesLeft, 1);
    });

    test('RoomType and DesignTheme enums provide correct labels and details', () {
      expect(RoomType.livingRoom.label, 'Living Room');
      expect(RoomType.modularKitchen.label, 'Modular Kitchen');
      expect(DesignTheme.modernMinimalist.label, 'Modern Minimalist');
      expect(DesignTheme.luxuryContemporary.desc, contains('Italian marble'));
      expect(LightingCondition.warmEvening.label, 'Warm Ambient');
    });

    test('VastuChakraZone model stores zones, scores and tracks applied remedies', () {
      final zone = VastuChakraZone(
        id: 'z_test',
        zoneName: 'South-East (Agneya)',
        deityRuling: 'Lord Agni',
        element: 'Fire Element',
        elementColor: const Color(0xFFEF4444),
        degrees: '135° SE',
        score: 84,
        currentUsage: 'Kitchen',
        status: VastuStatus.minorDosha,
        doshaDetail: 'Water sink placed adjacent to fire cooktop',
        nonDemolitionRemedy: 'Conceal a green copper strip',
      );

      expect(zone.score, 84);
      expect(zone.status, VastuStatus.minorDosha);
      expect(zone.isRemedyApplied, isFalse);

      zone.isRemedyApplied = true;
      zone.status = VastuStatus.remedied;
      zone.score = 94;
      expect(zone.score, 94);
      expect(zone.status, VastuStatus.remedied);
    });

    test('Furniture budget multipliers calculate correct cost variations', () {
      expect(SubstrateGrade.commercialMr.costMultiplier, 1.0);
      expect(SubstrateGrade.bwpMarine.costMultiplier, 1.55);
      expect(SurfaceFinish.acrylicGloss.costMultiplier, 1.45);
      expect(HardwarePackage.germanPremium.multiplier, 1.35);

      final baseCost = 8 * 7 * 1450.0;
      final total = baseCost *
          SubstrateGrade.hdhmrBoard.costMultiplier *
          SurfaceFinish.acrylicGloss.costMultiplier *
          HardwarePackage.germanPremium.multiplier;
      expect(total, greaterThan(100000));
    });

    test('AiDoubtQuery stores technical verdicts and Indian Standards codes', () {
      final query = AiDoubtQuery(
        id: 'q_test',
        question: 'Can I use 18mm MR ply under kitchen sink?',
        category: 'Carpentry',
        verdict: DoubtVerdict.avoidHazard,
        technicalAdvice: 'Must use IS 710 BWP Marine ply',
        costSavingImpact: 'Prevents ₹42,000 repair',
        isCodeRef: 'IS 710:2010',
        timestamp: 'Sep 2, 2026',
        isFreeQuestion: true,
      );

      expect(query.verdict, DoubtVerdict.avoidHazard);
      expect(query.isCodeRef, 'IS 710:2010');
      expect(query.isFreeQuestion, isTrue);
    });
  });

  group('Client AI Studio Hub Page Widget Tests', () {
    Widget createHubUnderTest() {
      return const MaterialApp(
        home: ClientAiStudioHubPage(),
      );
    }

    testWidgets('Renders hub header, tokens, stats, and 4 tool cards on desktop',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createHubUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Homio AI Architectural Studio'), findsOneWidget);
      expect(find.text('Transform Your Villa with High-Precision AI Tools'), findsOneWidget);
      expect(find.text('AI Studio Tokens'), findsOneWidget);
      expect(find.text('Designer Revenue'), findsOneWidget);

      // Verify all 4 tools are present
      expect(find.text('AI Room 3D Generator (50/50 Dual View)'), findsOneWidget);
      expect(find.text('AI Vastu Shastra Consultant & Chakra'), findsOneWidget);
      expect(find.text('AI Furniture & Interior Budget Estimator'), findsOneWidget);
      expect(find.text('AI Technical Architectural Doubt Solver'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders hub cleanly on mobile viewport (390x844) with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createHubUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Homio AI Architectural Studio'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Opens Buy Tokens dialog and recharges tokens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createHubUnderTest());
      await tester.pumpAndSettle();

      final initialTokens = globalAiWallet.totalTokens;

      // Tap on the token balance pill in the top nav
      final tokenPill = find.byKey(const Key('navbar_token_pill'));
      expect(tokenPill, findsOneWidget);
      await tester.tap(tokenPill);
      await tester.pumpAndSettle();

      expect(find.text('Add AI Studio Tokens'), findsOneWidget);
      expect(find.textContaining('50-50 Partner Commitment'), findsOneWidget);

      // Tap 50 tokens option
      final option50 = find.text('50 AI Tokens');
      expect(option50, findsOneWidget);
      await tester.tap(option50);
      await tester.pumpAndSettle();

      expect(globalAiWallet.totalTokens, initialTokens + 50);
    });
  });

  group('Client AI Room Generator Page Widget Tests', () {
    Widget createRoomGenUnderTest() {
      return const MaterialApp(
        home: ClientAiRoomGeneratorPage(),
      );
    }

    testWidgets('Renders 50/50 comparison visualizer and slider on desktop',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createRoomGenUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('BEFORE: RAW SITE PHOTO'), findsOneWidget);
      expect(find.textContaining('AFTER: AI 4K RENDER'), findsOneWidget);
      expect(find.text('Raw Photo'), findsOneWidget);
      expect(find.textContaining('AI 4K Render'), findsWidgets);

      // Config parameters
      expect(find.text('1. TARGET ROOM ZONE'), findsOneWidget);
      expect(find.text('2. ARCHITECTURAL THEME'), findsOneWidget);
      expect(find.text('3. LIGHTING ATMOSPHERE'), findsOneWidget);
      expect(find.text('4. CURATED COLOR PALETTE'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders room generator cleanly on mobile (390x844) with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createRoomGenUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('BEFORE: RAW SITE PHOTO'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Opens Auto-Generate BOQ Material List modal',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createRoomGenUnderTest());
      await tester.pumpAndSettle();

      final boqBtn = find.text('Auto-Generate BOQ Material List');
      expect(boqBtn, findsOneWidget);
      await tester.ensureVisible(boqBtn);
      await tester.tap(boqBtn);
      await tester.pumpAndSettle();

      expect(find.text('Auto-Generated Material BOQ'), findsOneWidget);
      expect(find.text('₹1,58,400'), findsOneWidget);
      expect(find.text('Save to Project BOQ'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });
  });

  group('Client AI Vastu Consultant Page Widget Tests', () {
    Widget createVastuUnderTest() {
      return const MaterialApp(
        home: ClientAiVastuConsultantPage(),
      );
    }

    testWidgets('Renders Vastu scorecard hero, compass dial, and 16-zone cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createVastuUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('MahaVastu™ Verified Compliance Score'), findsOneWidget);
      expect(find.text('True North Compass Dial:'), findsOneWidget);
      expect(find.text('North-East (Ishanya)'), findsOneWidget);
      expect(find.text('South-East (Agneya)'), findsOneWidget);
      expect(find.text('South-West (Nairutya)'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders Vastu consultant cleanly on mobile (390x844) with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createVastuUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('MahaVastu™ Verified Compliance Score'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Applies Vedic non-demolition remedy and updates zone score',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createVastuUnderTest());
      await tester.pumpAndSettle();

      final applyBtn = find.text('Apply Remedy').first;
      expect(applyBtn, findsOneWidget);
      await tester.tap(applyBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('Vedic Remedy Applied'), findsOneWidget);
    });
  });

  group('Client AI Budget Estimator Page Widget Tests', () {
    Widget createBudgetUnderTest() {
      return const MaterialApp(
        home: ClientAiBudgetEstimatorPage(),
      );
    }

    testWidgets('Renders dynamic cost hero, form, 3-way matrix, and brand cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createBudgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('AI Real-Time Interior Cost Range'), findsOneWidget);
      expect(find.text('Custom Carpentry & Joinery Specifications'), findsOneWidget);
      expect(find.text('3-Way Material Cost Matrix'), findsOneWidget);
      expect(find.text('Top 3 Homio-Approved Brands'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders budget estimator cleanly on mobile (390x844) with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createBudgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('AI Real-Time Interior Cost Range'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Client AI Doubt Solver Page Widget Tests', () {
    Widget createDoubtUnderTest() {
      return const MaterialApp(
        home: ClientAiDoubtSolverPage(),
      );
    }

    testWidgets('Renders freemium query counter banner, input, suggestions and stream',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createDoubtUnderTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('FREE QUESTIONS REMAINING'), findsOneWidget);
      expect(find.text('Ask a Construction, Material or Quality Question'), findsOneWidget);
      expect(find.text('QUICK INQUIRY SUGGESTIONS:'), findsOneWidget);
      expect(find.text('Technical Verdicts & Material Science Evidence'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders doubt solver cleanly on mobile (390x844) with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createDoubtUnderTest());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping a suggestion submits query and presents technical verdict',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createDoubtUnderTest());
      await tester.pumpAndSettle();

      final suggestion = find.text('Is Gypsum false ceiling better than POP for high-humidity coastal areas?');
      expect(suggestion, findsOneWidget);
      await tester.ensureVisible(suggestion);
      await tester.tap(suggestion);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      expect(find.textContaining('Technical verdict verified'), findsOneWidget);
    });
  });
}
