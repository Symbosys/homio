import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/marketplace/index.dart';

void main() {
  group('Client Marketplace Domain Models Unit Tests', () {
    test('DigitalGuide stores blueprint properties and tracks unlock status', () {
      final guide = DigitalGuide(
        id: 'dg_test',
        title: 'Modern MEP Schematic Guide',
        subtitle: 'Plumbing and conduit diagrams',
        category: DigitalGuideCategory.materials,
        author: 'Ar. Rajesh Verma',
        authorTitle: 'Chief MEP Consultant',
        mrpPrice: 1999.0,
        clientPrice: 699.0,
        rating: 4.85,
        reviewsCount: 42,
        pageCount: 36,
        fileFormat: 'PDF (Vector)',
        tableOfContents: ['Ch 1. Conduit Sizing', 'Ch 2. 3-Phase DB Dressing'],
        previewExcerpt: 'All residential conduit loops should adhere to NBC standards...',
      );

      expect(guide.isPurchased, isFalse);
      expect(guide.tableOfContents.length, 2);
      expect(guide.fileFormat, 'PDF (Vector)');

      guide.isPurchased = true;
      expect(guide.isPurchased, isTrue);
    });

    test('DecorProduct calculates contractor trade discounts and sample requests', () {
      final product = DecorProduct(
        id: 'decor_test',
        title: 'Italian Botticino Marble',
        brand: 'Simpolo Luxe',
        category: DecorCategory.marbleTiles,
        description: 'Premium imported marble',
        mrpPrice: 360.0,
        tradePrice: 280.0,
        discountPercent: 22,
        leadTimeDays: 7,
        dimensions: '1200 x 2400 mm',
        finish: 'High Gloss Book-Matched',
        affiliateUrl: 'https://materials.homio.com/simpolo-botticino',
        sampleAvailable: true,
      );

      expect(product.sampleAvailable, isTrue);
      expect(product.inSampleCart, isFalse);
      expect(product.discountPercent, 22);
      expect(product.tradePrice, lessThan(product.mrpPrice));

      product.inSampleCart = true;
      expect(product.inSampleCart, isTrue);
    });

    test('PropertyListing verifies luxury rentals and direct owner unlock', () {
      final listing = PropertyListing(
        id: 'prop_test',
        title: '3BHK Duplex Penthouse',
        propertyType: PropertyType.penthouse,
        location: 'Banjara Hills',
        city: 'Hyderabad',
        bhk: 3,
        carpetAreaSqFt: 3100,
        monthlyRent: 145000.0,
        securityDeposit: 435000.0,
        furnishingStatus: 'Designer Furnished',
        availableFrom: 'Immediate',
        keyAmenities: ['Private Plunge Pool', 'Double Height Living'],
        architecturalHighlight: 'Floor-to-ceiling double-glazed soundproof glass',
        hasVideoTour: true,
        verifiedByHomio: true,
        ownerName: 'Vikramaditya K.',
        ownerPhone: '+91 99887 76655',
      );

      expect(listing.isUnlocked, isFalse);
      expect(listing.verifiedByHomio, isTrue);
      expect(listing.hasVideoTour, isTrue);

      listing.isUnlocked = true;
      expect(listing.isUnlocked, isTrue);
    });

    test('LabourProfile and LabourBooking calculate deal values and track site progress', () {
      final profile = LabourProfile(
        id: 'lab_test',
        name: 'Ramvilas Suthar',
        trade: LabourTrade.masterCarpenter,
        experienceYears: 16,
        verifiedKyc: true,
        dayRate: 950,
        sqFtRate: 45,
        homioRating: 4.95,
        completedJobsCount: 140,
        availability: 'Active on Palm Heights',
        skillTags: ['Hettich Hardware', 'Acrylic Shutters'],
        supervisorEndorsement: 'Master craftsman with precision alignment.',
      );

      expect(profile.verifiedKyc, isTrue);
      expect(profile.dayRate, 950);

      const days = 5;
      final expectedDealValue = days * profile.dayRate.toDouble();
      expect(expectedDealValue, 4750.0);

      final booking = LabourBooking(
        id: 'bk_test',
        labourId: profile.id,
        labourName: profile.name,
        trade: profile.trade,
        siteAddress: 'Palm Heights Villa 402',
        startDate: 'Tomorrow',
        durationDays: days,
        dealValue: expectedDealValue,
        taskChecklist: ['Install wardrobe carcass', 'Mount hinges'],
        status: 'Confirmed',
        timestamp: 'Just now',
      );

      expect(booking.dealValue, 4750.0);
      expect(booking.status, 'Confirmed');
      expect(booking.taskChecklist.length, 2);
    });

    test('MarketplaceState singleton initializes default repositories', () {
      expect(globalMarketplaceState.digitalGuides.isNotEmpty, isTrue);
      expect(globalMarketplaceState.decorProducts.isNotEmpty, isTrue);
      expect(globalMarketplaceState.propertyListings.isNotEmpty, isTrue);
      expect(globalMarketplaceState.labourProfiles.isNotEmpty, isTrue);
      expect(globalMarketplaceState.activeBookings.isNotEmpty, isTrue);
    });
  });

  group('Client Marketplace Widget Tests - Responsive & UI Verification', () {
    Widget buildTestApp(Widget child, {Size size = const Size(1440, 900)}) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: child,
          ),
        ),
      );
    }

    testWidgets('ClientMarketplaceNavBar renders tabs and opens activity dialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: ClientMarketplaceNavBar(
              activeRoutePath: '/client/marketplace',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Homio Marketplace & Services'), findsOneWidget);
      expect(find.text('Marketplace Hub'), findsOneWidget);
      expect(find.text('Digital Guides'), findsOneWidget);
      expect(find.text('Decor & Materials'), findsOneWidget);
      expect(find.text('Rental & Properties'), findsOneWidget);
      expect(find.text('Hire On-Demand Labour'), findsOneWidget);

      // Verify and tap activity pill
      final cartPill = find.byKey(const Key('navbar_marketplace_cart_pill'));
      expect(cartPill, findsOneWidget);

      await tester.tap(cartPill);
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('My Marketplace Activity'), findsOneWidget);
      expect(find.text('PURCHASED BLUEPRINTS (1)'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('ClientMarketplaceHubPage renders on desktop without errors', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      await tester.pumpWidget(buildTestApp(const ClientMarketplaceHubPage()));
      await tester.pumpAndSettle();

      expect(find.text('Homio Marketplace & Value-Added Services'), findsOneWidget);
      expect(find.text('DIGITAL VAULT'), findsOneWidget);
      expect(find.text('TRADE DISCOUNTS'), findsOneWidget);
      expect(find.text('VERIFIED RENTALS'), findsOneWidget);
      expect(find.text('ON-DEMAND TRADES'), findsOneWidget);

      expect(find.text('Architectural & Interior Guides'), findsOneWidget);
      expect(find.text('Trade Pricing Decor & Materials'), findsOneWidget);
      expect(find.text('Verified Rental & Properties Network'), findsOneWidget);
      expect(find.text('Hire On-Demand Labour & Craftsmen'), findsOneWidget);
    });

    testWidgets('ClientMarketplaceHubPage renders on 390px mobile with zero overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestApp(const ClientMarketplaceHubPage(), size: const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.text('Homio Marketplace & Value-Added Services'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientDigitalStorePage previews blueprint and unlocks without errors', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      await tester.pumpWidget(buildTestApp(const ClientDigitalStorePage()));
      await tester.pumpAndSettle();

      expect(find.text('Architectural Blueprints & Digital Vault'), findsOneWidget);
      expect(find.text('YOUR UNLOCKED BLUEPRINTS (1)'), findsOneWidget);

      // Tap Read Preview button
      final previewButtons = find.text('Read Preview');
      expect(previewButtons, findsWidgets);
      await tester.tap(previewButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('COMPLETE TABLE OF CONTENTS'), findsOneWidget);
      expect(find.text('WATERMARKED EXCERPT PREVIEW'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('ClientDigitalStorePage renders on 390px mobile with zero overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestApp(const ClientDigitalStorePage(), size: const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.text('Architectural Blueprints & Digital Vault'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientDecorStorePage handles sample order and spec sheet modal', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      await tester.pumpWidget(buildTestApp(const ClientDecorStorePage()));
      await tester.pumpAndSettle();

      expect(find.text('Wholesale Interior Decor & Materials Catalog'), findsOneWidget);
      expect(find.text('Spec Sheet'), findsWidgets);

      // Open spec sheet
      await tester.tap(find.text('Spec Sheet').first);
      await tester.pumpAndSettle();

      expect(find.text('ARCHITECTURAL APPLICATION NOTES'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Request sample
      final sampleButton = find.text('Order Site Sample').first;
      await tester.tap(sampleButton);
      await tester.pumpAndSettle();

      expect(find.text('Sample Requested'), findsWidgets);
    });

    testWidgets('ClientDecorStorePage renders on 390px mobile with zero overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestApp(const ClientDecorStorePage(), size: const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.text('Wholesale Interior Decor & Materials Catalog'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientPropertiesPage opens video tour and unlocks direct owner contact', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      await tester.pumpWidget(buildTestApp(const ClientPropertiesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Verified Rental & Properties Network'), findsOneWidget);

      // Open Video Tour
      final videoButtons = find.text('Video Tour');
      expect(videoButtons, findsWidgets);
      await tester.tap(videoButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Streaming 4K Homio Verified Walkthrough'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Unlock direct owner contact
      final unlockButtons = find.text('Unlock Owner Contact (₹500)');
      expect(unlockButtons, findsWidgets);
      await tester.tap(unlockButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Unlock Direct Owner Contact'), findsOneWidget);
      expect(find.text('Pay ₹500 & Unlock'), findsOneWidget);

      await tester.tap(find.text('Pay ₹500 & Unlock'));
      await tester.pumpAndSettle();

      expect(find.text('Call'), findsWidgets);
    });

    testWidgets('ClientPropertiesPage renders on 390px mobile with zero overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestApp(const ClientPropertiesPage(), size: const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.text('Verified Rental & Properties Network'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientHireLabourPage opens booking dialog and confirms new engagement', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      await tester.pumpWidget(buildTestApp(const ClientHireLabourPage()));
      await tester.pumpAndSettle();

      expect(find.text('Hire On-Demand Labour & Certified Guild'), findsOneWidget);
      expect(find.text('ACTIVE LABOUR ENGAGEMENTS (1)'), findsOneWidget);

      // Find booking button
      final bookButtons = find.textContaining('Book ');
      expect(bookButtons, findsWidgets);

      await tester.tap(bookButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('WORK LOCATION'), findsOneWidget);
      expect(find.text('ESTIMATED CONTRACT VALUE'), findsOneWidget);
      expect(find.textContaining('Confirm Booking'), findsOneWidget);

      await tester.tap(find.textContaining('Confirm Booking'));
      await tester.pumpAndSettle();

      // Verify active engagements updated
      expect(find.text('ACTIVE LABOUR ENGAGEMENTS (2)'), findsOneWidget);
    });

    testWidgets('ClientHireLabourPage renders on 390px mobile with zero overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestApp(const ClientHireLabourPage(), size: const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.text('Hire On-Demand Labour & Certified Guild'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
