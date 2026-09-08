import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/app/router/app_router.dart';
import 'package:client/features/quotation/index.dart';

void main() {
  group('Quotation Module - Domain Models & Calculations', () {
    test('Enums expose correct labels, symbols, and values', () {
      expect(UnitOfMeasurement.sqft.symbol, 'Sq.Ft');
      expect(UnitOfMeasurement.nos.symbol, 'Nos');
      expect(UnitOfMeasurement.runningFt.symbol, 'R.Ft');
      expect(UnitOfMeasurement.lumpSum.symbol, 'LS');

      expect(MaterialTier.budget.title, contains('Budget'));
      expect(MaterialTier.premium.title, contains('Premium'));
      expect(MaterialTier.luxury.title, contains('Luxury'));

      expect(QuotationStatus.draft.label, 'Draft');
      expect(QuotationStatus.submitted.label, 'Submitted');
      expect(QuotationStatus.underReview.label, 'Under Review');
      expect(QuotationStatus.accepted.label, 'Accepted');
      expect(QuotationStatus.expired.label, 'Discount Expired');
      expect(QuotationStatus.revised.label, 'Revised');

      expect(ItemCategory.civil.label, 'Civil & Masonry');
      expect(ItemCategory.carpentry.label, 'Carpentry & Woodwork');
      expect(ItemCategory.modularKitchen.label, 'Modular Kitchen');
    });

    test('ItemMasterEntry computes selling rate with markup correctly', () {
      const item = ItemMasterEntry(
        id: 'ITM-TEST-001',
        name: 'Test Plywood Item',
        category: ItemCategory.carpentry,
        technicalSpecs: '18mm BWP calibrated ply',
        imageUrl: 'https://example.com/ply.jpg',
        uom: UnitOfMeasurement.sqft,
        baseCostRate: 1000.0,
        marginPercent: 25.0,
        approvedBrands: ['Century', 'Greenply'],
      );

      // baseCostRate 1000 + 25% margin = 1250
      expect(item.sellingRate, 1250.0);
    });

    test('Quotation models compute carpet area, discounts, taxes and grand total accurately', () {
      const room = RoomArea(
        id: 'RM-1',
        roomName: 'Living Room',
        lengthFt: 20.0,
        widthFt: 15.0,
        heightFt: 10.0,
        tier: MaterialTier.premium,
        items: [
          QuotationItem(
            id: 'QI-1',
            itemMasterId: 'ITM-TEST-001',
            name: 'False Ceiling',
            category: ItemCategory.falseCeiling,
            materialSpecs: 'Gyproc boards',
            uom: UnitOfMeasurement.sqft,
            quantity: 300.0,
            rate: 200.0,
            marginPercent: 25.0,
          ),
          QuotationItem(
            id: 'QI-2',
            itemMasterId: 'ITM-TEST-002',
            name: 'Console',
            category: ItemCategory.carpentry,
            materialSpecs: 'Veneer',
            uom: UnitOfMeasurement.runningFt,
            quantity: 10.0,
            rate: 4000.0,
            marginPercent: 30.0,
          ),
        ],
      );

      // Carpet area = 20 * 15 = 300 sqft
      expect(room.carpetSqft, 300.0);
      // Perimeter wall area = 2 * (20 + 15) * 10 = 700 sqft
      expect(room.wallSqft, 700.0);
      // Subtotal = (300 * 200) + (10 * 4000) = 60,000 + 40,000 = 100,000
      expect(room.roomSubtotal, 100000.0);

      final quotation = Quotation(
        id: 'QUO-TEST-001',
        quoteNumber: 'QUO-TEST-001',
        leadId: 'LD-1',
        clientName: 'Test Client',
        clientPhone: '+91 99999 88888',
        clientEmail: 'test@example.com',
        projectTitle: 'Test Apartment',
        projectLocation: 'Bangalore',
        designerName: 'Test Designer',
        coverImageUrl: 'https://example.com/cover.jpg',
        submissionDate: DateTime.now(),
        discountExpiryDate: DateTime.now().add(const Duration(days: 5)),
        rooms: const [room],
        discountPercent: 10.0,
        gstPercent: 18.0,
      );

      expect(quotation.grossSubtotal, 100000.0);
      expect(quotation.discountAmount, 10000.0); // 10% of 100k
      expect(quotation.taxableAmount, 90000.0); // 100k - 10k
      expect(quotation.gstAmount, 16200.0); // 18% of 90k
      expect(quotation.grandTotal, 106200.0); // 90k + 16.2k
      expect(quotation.isDiscountExpired, isFalse);
    });

    test('QuotationMockData contains rich seed data for all requirements', () {
      expect(QuotationMockData.masterItems.length, greaterThanOrEqualTo(10));
      expect(QuotationMockData.quotations.length, greaterThanOrEqualTo(8));
      expect(QuotationMockData.urgencyLogs.length, greaterThanOrEqualTo(3));
      expect(QuotationMockData.selfEstimateLeads.length, greaterThanOrEqualTo(3));

      // Verify all statuses are represented
      final statuses = QuotationMockData.quotations.map((q) => q.status).toSet();
      expect(statuses.contains(QuotationStatus.draft), isTrue);
      expect(statuses.contains(QuotationStatus.submitted), isTrue);
      expect(statuses.contains(QuotationStatus.underReview), isTrue);
      expect(statuses.contains(QuotationStatus.accepted), isTrue);
      expect(statuses.contains(QuotationStatus.expired), isTrue);
      expect(statuses.contains(QuotationStatus.revised), isTrue);
    });
  });

  group('Quotation Module - Widget Rendering Tests', () {
    void setDesktopSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    Widget buildTestApp(Widget child) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(body: child),
      );
    }

    testWidgets('Screen 1: QuotationAllPage renders KPI cards, tabs, and data table', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const QuotationAllPage()));
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('All Quotations & Cost Estimations'), findsOneWidget);
      expect(find.text('Create Quotation'), findsOneWidget);

      // Verify KPI Metrics
      expect(find.text('TOTAL PIPELINE VALUE'), findsOneWidget);
      expect(find.text('WON & ACCEPTED'), findsOneWidget);
      expect(find.text('PENDING CLIENT REVIEWS'), findsOneWidget);
      expect(find.text('DISCOUNT URGENCY / EXPIRED'), findsOneWidget);

      // Verify Status Tabs
      expect(find.text('All Quotations'), findsOneWidget);
      expect(find.text('Draft'), findsWidgets);
      expect(find.text('Submitted'), findsWidgets);
      expect(find.text('Under Review'), findsWidgets);
      expect(find.text('Accepted'), findsWidgets);

      // Verify Table Columns
      expect(find.text('QUOTE #'), findsOneWidget);
      expect(find.text('CLIENT & CONTACT'), findsOneWidget);
      expect(find.text('PROJECT & LOCATION'), findsOneWidget);
      expect(find.text('NET VALUE'), findsOneWidget);
      expect(find.text('STATUS'), findsOneWidget);
    });

    testWidgets('Screen 2: QuotationBuilderPage renders room BOQ builder', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const QuotationBuilderPage()));
      await tester.pumpAndSettle();

      expect(find.text('Quotation Builder & Estimation Engine'), findsOneWidget);
      expect(find.text('Room-by-Room BOQ Builder'), findsOneWidget);
      expect(find.text('Executive Commercial Summary'), findsOneWidget);
    });

    testWidgets('Screen 3: QuotationItemMasterPage renders catalogue items and metrics', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const QuotationItemMasterPage()));
      await tester.pumpAndSettle();

      expect(find.text('Centralized Item & Rate Master Catalogue'), findsOneWidget);
      expect(find.text('TOTAL CATALOGUE ITEMS'), findsOneWidget);
      expect(find.text('AVERAGE PROFIT MARGIN'), findsOneWidget);
      expect(find.text('Add Catalogue Item'), findsOneWidget);
    });

    testWidgets('Screen 4: QuotationDocumentsPage renders PDF studio and options', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const QuotationDocumentsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Quotation Documents & Client Presentation Studio'), findsOneWidget);
      expect(find.text('Share on WhatsApp'), findsOneWidget);
      expect(find.text('Download PDF Dossier'), findsOneWidget);
    });

    testWidgets('Screen 5: QuotationUrgencyPage renders urgency countdown and logs', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const QuotationUrgencyPage()));
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Pricing & 24h Expiry Urgency Hub'), findsOneWidget);
      expect(find.text('CRITICAL 24H EXPIRING'), findsOneWidget);
      expect(find.text('DISCOUNT SAVINGS AT STAKE'), findsOneWidget);
    });

    testWidgets('Screen 6: QuotationSelfServicePage renders customer self-estimation calculator', (tester) async {
      setDesktopSize(tester);
      await tester.pumpWidget(buildTestApp(const QuotationSelfServicePage()));
      await tester.pumpAndSettle();

      expect(find.text('Customer Self-Quotation Portal & B2C Lead Magnet'), findsOneWidget);
      expect(find.text('1. Select Property Configuration'), findsOneWidget);
    });

    testWidgets('AppRouter resolves all 6 quotation routes without default template', (tester) async {
      setDesktopSize(tester);

      // 1. /quotations/all -> QuotationAllPage
      AppRouter.router.go('/quotations/all');
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: AppRouter.router,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(QuotationAllPage), findsOneWidget);
      expect(find.text('All Quotations & Cost Estimations'), findsOneWidget);
      expect(find.text('This is All Quotations'), findsNothing);

      // 2. /quotations/create -> QuotationBuilderPage
      AppRouter.router.go('/quotations/create');
      await tester.pumpAndSettle();

      expect(find.byType(QuotationBuilderPage), findsOneWidget);
      expect(find.text('Quotation Builder & Estimation Engine'), findsOneWidget);

      // 3. /quotations/rate-master -> QuotationItemMasterPage
      AppRouter.router.go('/quotations/rate-master');
      await tester.pumpAndSettle();

      expect(find.byType(QuotationItemMasterPage), findsOneWidget);
      expect(find.text('Centralized Item & Rate Master Catalogue'), findsOneWidget);

      // 4. /quotations/documents -> QuotationDocumentsPage
      AppRouter.router.go('/quotations/documents');
      await tester.pumpAndSettle();

      expect(find.byType(QuotationDocumentsPage), findsOneWidget);
      expect(find.text('Quotation Documents & Client Presentation Studio'), findsOneWidget);

      // 5. /quotations/expiry-reminders -> QuotationUrgencyPage
      AppRouter.router.go('/quotations/expiry-reminders');
      await tester.pumpAndSettle();

      expect(find.byType(QuotationUrgencyPage), findsOneWidget);
      expect(find.text('Dynamic Pricing & 24h Expiry Urgency Hub'), findsOneWidget);

      // 6. /quotations/self-quotation -> QuotationSelfServicePage
      AppRouter.router.go('/quotations/self-quotation');
      await tester.pumpAndSettle();

      expect(find.byType(QuotationSelfServicePage), findsOneWidget);
      expect(find.text('Customer Self-Quotation Portal & B2C Lead Magnet'), findsOneWidget);
    });
  });
}
