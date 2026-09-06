import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/billing_invoices/index.dart';

void main() {
  group('Billing & Invoices Domain Models Tests', () {
    test('PaymentTranche model computes status flags and formatting correctly', () {
      final tranche = PaymentTranche(
        id: 'test_tranche_1',
        stageNumber: 5,
        stageTitle: 'Stage 5: Modular Kitchen',
        description: 'Lower carcase & quartz',
        trancheAmount: '₹7,50,000',
        gstAmount: '₹1,35,000',
        totalAmount: '₹8,85,000',
        dueDate: 'Due Today (Sep 05)',
        status: TrancheStatus.dueNow,
        invoiceNumber: 'INV-HOMIO-2026-0905',
      );

      expect(tranche.stageNumber, 5);
      expect(tranche.isDueNow, true);
      expect(tranche.isPaid, false);
      expect(tranche.isUpcoming, false);

      tranche.status = TrancheStatus.paid;
      tranche.paidDate = 'Sep 05, 2026';
      expect(tranche.isPaid, true);
    });

    test('CostBreakdownItem and TaxInvoice models hold financial and ledger data', () {
      const costItem = CostBreakdownItem(
        category: 'Material Procurement',
        allocatedAmount: '₹26,50,000',
        spentAmount: '₹19,80,000',
        percentage: 0.747,
        icon: Icons.inventory_2_outlined,
        color: Color(0xFF6366F1),
        vendorNotes: 'Verified manufacturer invoices.',
      );

      const invoice = TaxInvoice(
        invoiceNumber: 'INV-HOMIO-2026-0905',
        title: 'Tax Invoice: Stage 5',
        issueDate: 'Sep 05, 2026',
        taxableAmount: '₹7,50,000',
        gstAmount: '₹1,35,000 (18% IGST)',
        totalAmount: '₹8,85,000',
        isPaid: false,
      );

      expect(costItem.percentage, closeTo(0.747, 0.001));
      expect(invoice.totalAmount, '₹8,85,000');
      expect(invoice.isPaid, false);
    });
  });

  group('Billing & Invoices Widget & Interactive UI Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: ClientBillingInvoicesPage(),
      );
    }

    testWidgets('ClientBillingInvoicesPage renders desktop layout with zero exceptions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Check Header
      expect(find.text('Billing & Invoices'), findsOneWidget);
      expect(find.text('Skyline Villa Penthouse 402, Worli • 4 BHK Luxury'), findsOneWidget);
      expect(find.text('Turnkey Luxury Contract • GST Registered'), findsOneWidget);
      expect(find.text('Make Milestone Payment'), findsOneWidget);

      // Check Financial Metrics
      expect(find.text('Total Contract Value'), findsOneWidget);
      expect(find.text('Total Paid to Date'), findsOneWidget);
      expect(find.text('Current Outstanding'), findsOneWidget);
      expect(find.text('Next Tranche Due'), findsOneWidget);

      // Check Tabs
      expect(find.textContaining('Milestone Tranches'), findsOneWidget);
      expect(find.textContaining('Cost Summary & Ledger'), findsOneWidget);
      expect(find.textContaining('GST Tax Invoices & Receipts'), findsOneWidget);

      // Check Tranche List
      expect(find.text('Stage 5: Modular Kitchen & Joinery Fabrication'), findsOneWidget);
      expect(find.text('Stage 4: Italian Marble Flooring & Wall Cladding'), findsOneWidget);

      // Check Escrow Guarantee
      expect(find.text('Milestone Stage Escrow & Warranty Assurance'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientBillingInvoicesPage renders cleanly on mobile viewport (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Billing & Invoices'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Switching tabs to Cost Summary & Ledger displays itemized categories',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final costTab = find.textContaining('Cost Summary & Ledger');
      expect(costTab, findsOneWidget);
      await tester.ensureVisible(costTab);
      await tester.tap(costTab);
      await tester.pumpAndSettle();

      expect(find.text('Project Financial Ledger Breakdown'), findsOneWidget);
      expect(find.text('Material Procurement (Saint-Gobain, Häfele, Statuario)'), findsOneWidget);
      expect(find.text('Skilled Labour & Fabrication (Carpentry, Masons, Electricians)'), findsOneWidget);
      expect(find.text('Architectural Design & Site Supervision Fees'), findsOneWidget);
    });

    testWidgets('Switching tabs to GST Tax Invoices displays invoice list and download triggers',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final invoicesTab = find.textContaining('GST Tax Invoices & Receipts');
      expect(invoicesTab, findsOneWidget);
      await tester.ensureVisible(invoicesTab);
      await tester.tap(invoicesTab);
      await tester.pumpAndSettle();

      expect(find.text('Official GST Tax Invoices & Payment Certificates'), findsOneWidget);
      expect(find.text('Tax Invoice: Stage 5 Modular Kitchen Joinery Tranche'), findsOneWidget);
      expect(find.text('Tax Invoice: Stage 4 Italian Marble Flooring Tranche'), findsOneWidget);
    });

    testWidgets('Payment modal opens and completing payment marks tranche as Paid',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1600, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap "Pay Now" on the due tranche
      final payNowButtons = find.textContaining('Pay Now');
      expect(payNowButtons, findsWidgets);
      await tester.tap(payNowButtons.first);
      await tester.pumpAndSettle();

      // Modal open verification
      expect(find.text('Milestone Payment: Stage 5'), findsOneWidget);
      expect(find.text('homio.penthouse402@icici'), findsOneWidget);

      // Switch to NEFT / RTGS Bank Transfer payment tab inside dialog
      final neftTab = find.text('NEFT / RTGS Bank Transfer');
      expect(neftTab, findsOneWidget);
      await tester.tap(neftTab);
      await tester.pumpAndSettle();

      expect(find.text('Beneficiary: Homio Projects Private Limited'), findsOneWidget);

      // Confirm payment
      final confirmBtn = find.text('Authorize & Disburse Payment');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Verify modal dismissed and SnackBar shown
      expect(find.text('Milestone Payment: Stage 5'), findsNothing);
      expect(find.textContaining('Payment of ₹8,85,000 verified successfully!'), findsOneWidget);
    });
  });
}
