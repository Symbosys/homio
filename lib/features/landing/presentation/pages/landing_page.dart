import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../widgets/ai_design_section.dart';
import '../widgets/ai_vastu_doubt_section.dart';
import '../widgets/business_operations_section.dart';
import '../widgets/ecosystem_closing_section.dart';
import '../widgets/finance_workforce_section.dart';
import '../widgets/hero_showcase_section.dart';
import '../widgets/marketplace_showcase_section.dart';
import '../widgets/mobile_nav_drawer.dart';
import '../widgets/project_execution_section.dart';
import '../widgets/sales_crm_section.dart';
import '../widgets/top_nav_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // GlobalKeys for smooth anchor navigation
  final GlobalKey _section01HeroKey = GlobalKey();
  final GlobalKey _section02AiDesignKey = GlobalKey();
  final GlobalKey _section03AiVastuKey = GlobalKey();
  final GlobalKey _section04BusinessOpsKey = GlobalKey();
  final GlobalKey _section05MarketplaceKey = GlobalKey();
  final GlobalKey _section06SalesCrmKey = GlobalKey();
  final GlobalKey _section07ProjectExecutionKey = GlobalKey();
  final GlobalKey _section08FinanceWorkforceKey = GlobalKey();
  final GlobalKey _section09EcosystemKey = GlobalKey();

  void _scrollToSection(int index) {
    GlobalKey targetKey;
    switch (index) {
      case 0:
        // Platform / Hero
        targetKey = _section01HeroKey;
        break;
      case 1:
        // AI Suite
        targetKey = _section02AiDesignKey;
        break;
      case 2:
        // AI Vastu & Doubt
        targetKey = _section03AiVastuKey;
        break;
      case 3:
        // Operations lifecycle
        targetKey = _section04BusinessOpsKey;
        break;
      case 4:
        // Marketplace
        targetKey = _section05MarketplaceKey;
        break;
      case 5:
        // Projects & Sales CRM
        targetKey = _section06SalesCrmKey;
        break;
      case 6:
        // Project Execution
        targetKey = _section07ProjectExecutionKey;
        break;
      case 7:
        // Finance & Workforce
        targetKey = _section08FinanceWorkforceKey;
        break;
      case 8:
        // Ecosystem & Closing
        targetKey = _section09EcosystemKey;
        break;
      default:
        targetKey = _section01HeroKey;
    }

    final currentContext = targetKey.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFFAFAFA),
      endDrawer: MobileNavDrawer(onSectionSelected: _scrollToSection),
      body: SafeArea(
        child: Column(
          children: [
            // Top Showcase Navigation Bar
            TopNavBar(
              onSectionSelected: _scrollToSection,
              onOpenMobileMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),

            // Scrollable 9-Section Showcase Flow
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Section 01: Hero — The Future of Design & Project Operations
                    KeyedSubtree(
                      key: _section01HeroKey,
                      child: HeroShowcaseSection(
                        onExploreTap: () => _scrollToSection(1),
                      ),
                    ),

                    // Section 02: AI-Powered Design Intelligence
                    KeyedSubtree(
                      key: _section02AiDesignKey,
                      child: const AiDesignSection(),
                    ),

                    // Section 03: AI Vastu & Doubt Solving
                    KeyedSubtree(
                      key: _section03AiVastuKey,
                      child: const AiVastuDoubtSection(),
                    ),

                    // Section 04: Complete Project & Business Operations
                    KeyedSubtree(
                      key: _section04BusinessOpsKey,
                      child: const BusinessOperationsSection(),
                    ),

                    // Section 05: Premium Marketplace
                    KeyedSubtree(
                      key: _section05MarketplaceKey,
                      child: const MarketplaceShowcaseSection(),
                    ),

                    // Section 06: Sales, CRM & Customer Experience
                    KeyedSubtree(
                      key: _section06SalesCrmKey,
                      child: const SalesCrmSection(),
                    ),

                    // Section 07: Project Execution & Design Collaboration
                    KeyedSubtree(
                      key: _section07ProjectExecutionKey,
                      child: const ProjectExecutionSection(),
                    ),

                    // Section 08: Finance, Procurement & Workforce Management
                    KeyedSubtree(
                      key: _section08FinanceWorkforceKey,
                      child: const FinanceWorkforceSection(),
                    ),

                    // Section 09: Unified HOMIO Ecosystem & Closing Showcase
                    KeyedSubtree(
                      key: _section09EcosystemKey,
                      child: EcosystemClosingSection(
                        onSectionSelected: _scrollToSection,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
