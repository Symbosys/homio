import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/marketing/index.dart';

void main() {
  group('Marketing Domain & Unit Economics Formulas Test', () {
    test('PRD CPL and CAC mathematical formulas compute correctly', () {
      final kpis = MarketingKpiSummary(
        totalLeads: 1000,
        totalSpend: 400000,
        totalConversions: 100,
        attributedRevenue: 5000000,
      );

      // CPL = Total Spend / Total Leads (400000 / 1000 = 400)
      expect(kpis.cpl, equals(400.0));
      expect(kpis.cplFormatted, equals('₹400'));

      // CAC = Total Spend / Bookings (400000 / 100 = 4000)
      expect(kpis.cac, equals(4000.0));
      expect(kpis.cacFormatted, equals('₹4000'));

      // Conversion Rate = Bookings / Total Leads * 100 (100 / 1000 * 100 = 10%)
      expect(kpis.conversionRate, equals(10.0));

      // ROI = (Revenue - Spend) / Spend * 100% ((5000000 - 400000) / 400000 * 100 = 1150%)
      expect(kpis.roiPercent, equals(1150.0));
    });

    test('Zero leads and conversions handle gracefully without divide by zero', () {
      final zeroKpis = MarketingKpiSummary(
        totalLeads: 0,
        totalSpend: 50000,
        totalConversions: 0,
        attributedRevenue: 0,
      );

      expect(zeroKpis.cpl, equals(0.0));
      expect(zeroKpis.cac, equals(0.0));
      expect(zeroKpis.conversionRate, equals(0.0));
      expect(zeroKpis.roiPercent, equals(0.0));
    });

    test('Channel performance calculations are strictly accurate', () {
      final channelItem = ChannelPerformanceItem(
        channel: MarketingChannel.metaAds,
        spend: 200000,
        leadsGenerated: 500,
        conversions: 50,
        revenue: 2500000,
      );

      expect(channelItem.cpl, equals(400.0));
      expect(channelItem.cac, equals(4000.0));
      expect(channelItem.conversionRate, equals(10.0));
      // ROI = (2500000 - 200000) / 200000 * 100 = 1150%
      expect(channelItem.roiPercent, equals(1150.0));
    });
  });

  group('Marketing Repository Operations Test', () {
    late MarketingRepository repo;

    setUp(() {
      repo = MarketingRepository();
    });

    test('Initial repository data has realistic production values', () {
      final kpis = repo.getKpiSummary();
      expect(kpis.totalLeads, greaterThan(1000));
      expect(kpis.totalSpend, greaterThan(500000));
      expect(kpis.totalConversions, greaterThan(100));

      final funnel = repo.getAcquisitionFunnel();
      expect(funnel.length, equals(5));
      expect(funnel.first.stageName, equals('Total New Leads'));
      expect(funnel.last.stageName, equals('Waiting for Payment'));

      final organicVsPaid = repo.getOrganicVsPaid();
      expect(organicVsPaid.organicShare + organicVsPaid.paidShare, closeTo(100.0, 0.1));

      final sources = repo.getLeadSources();
      expect(sources.length, greaterThanOrEqualTo(5));

      final campaigns = repo.getCampaigns();
      expect(campaigns.length, greaterThanOrEqualTo(4));

      final socialMetrics = repo.getSocialMetrics();
      expect(socialMetrics.length, equals(3)); // Instagram, YouTube, Pinterest
    });

    test('Campaign state mutation updates status and budget', () {
      final campaigns = repo.getCampaigns();
      final target = campaigns.first;

      repo.updateCampaignStatus(target.id, CampaignStatus.paused);
      expect(repo.getCampaigns().firstWhere((c) => c.id == target.id).status, equals(CampaignStatus.paused));

      repo.updateCampaignBudget(target.id, 999999);
      expect(repo.getCampaigns().firstWhere((c) => c.id == target.id).budget, equals(999999.0));
    });

    test('Social message AI approval and lead conversion mutation works', () {
      final messages = repo.getSocialMessages();
      final target = messages.first;

      repo.markMessageReplied(target.id);
      expect(repo.getSocialMessages().firstWhere((m) => m.id == target.id).isReplied, isTrue);

      repo.convertMessageToLead(target.id);
      expect(repo.getSocialMessages().firstWhere((m) => m.id == target.id).convertedToLead, isTrue);
    });
  });

  group('Marketing Screens Widget Tests', () {
    Widget buildTestApp(Widget home) {
      return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(body: home),
      );
    }

    testWidgets('MarketingOverviewPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const MarketingOverviewPage()));
      await tester.pumpAndSettle();

      expect(find.text('Marketing Overview'), findsOneWidget);
      expect(find.text('Total Leads Generated'), findsOneWidget);
      expect(find.text('Multi-Stage Acquisition Funnel'), findsOneWidget);
      expect(find.text('Channel Performance & Unit Economics'), findsOneWidget);
    });

    testWidgets('MarketingSourcesPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const MarketingSourcesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Lead Sources & Integrations'), findsOneWidget);
      expect(find.text('Sync All Now'), findsOneWidget);
      expect(find.text('Connect Source'), findsOneWidget);
    });

    testWidgets('MarketingCampaignsPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const MarketingCampaignsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Ad Campaigns'), findsOneWidget);
      expect(find.text('Launch Campaign'), findsOneWidget);
    });

    testWidgets('MarketingSocialPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const MarketingSocialPage()));
      await tester.pumpAndSettle();

      expect(find.text('Social Analytics & AI Engagement'), findsOneWidget);
      expect(find.text('Top Performing Social Content & Video Showcase'), findsOneWidget);
      expect(find.text('Social Engagement & AI Response Inbox'), findsOneWidget);
    });

    testWidgets('MarketingReportsPage renders without crashing', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const MarketingReportsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Marketing Reports & Audits'), findsOneWidget);
      expect(find.text('Export PDF Report'), findsOneWidget);
      expect(find.text('Select Report Preset'), findsOneWidget);
    });
  });
}
