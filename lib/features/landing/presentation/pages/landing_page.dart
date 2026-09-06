import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../widgets/access_anywhere_section.dart';
import '../widgets/benefits_section.dart';
import '../widgets/capabilities_grid.dart';
import '../widgets/ecosystem_section.dart';
import '../widgets/final_cta_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/lifecycle_visual.dart';
import '../widgets/mobile_nav_drawer.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/value_strip.dart';
import '../widgets/workflow_steps.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _ecosystemKey = GlobalKey();
  final GlobalKey _capabilitiesKey = GlobalKey();
  final GlobalKey _benefitsKey = GlobalKey();
  final GlobalKey _workflowKey = GlobalKey();
  final GlobalKey _lifecycleKey = GlobalKey();

  void _scrollToSection(int index) {
    GlobalKey targetKey;
    switch (index) {
      case 0:
        targetKey = _heroKey;
        break;
      case 1:
        targetKey = _ecosystemKey;
        break;
      case 2:
        targetKey = _capabilitiesKey;
        break;
      case 3:
        targetKey = _benefitsKey;
        break;
      case 4:
        targetKey = _workflowKey;
        break;
      case 5:
        targetKey = _lifecycleKey;
        break;
      default:
        targetKey = _heroKey;
    }

    final currentContext = targetKey.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 600),
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      endDrawer: MobileNavDrawer(onSectionSelected: _scrollToSection),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Top Navigation
            TopNavBar(
              onSectionSelected: _scrollToSection,
              onOpenMobileMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Section 1 & 2: Hero Section & Interactive Mockup
                    KeyedSubtree(
                      key: _heroKey,
                      child: HeroSection(onExploreTap: () => _scrollToSection(2)),
                    ),

                    // Section 3: Value Strip
                    const ValueStrip(),

                    // Section 4: What is the Platform? (Ecosystem)
                    KeyedSubtree(
                      key: _ecosystemKey,
                      child: const EcosystemSection(),
                    ),

                    // Section 5: Key Capabilities Grid
                    KeyedSubtree(
                      key: _capabilitiesKey,
                      child: const CapabilitiesGrid(),
                    ),

                    // Section 6: Why Businesses Use It (Outcomes)
                    KeyedSubtree(
                      key: _benefitsKey,
                      child: const BenefitsSection(),
                    ),

                    // Section 7: How Easy It Is (4 Steps)
                    KeyedSubtree(
                      key: _workflowKey,
                      child: const WorkflowSteps(),
                    ),

                    // Section 8: Complete Business Continuum Flow
                    KeyedSubtree(
                      key: _lifecycleKey,
                      child: const LifecycleVisual(),
                    ),

                    // Section 9: Access Anywhere / Multi-Device Freedom
                    const AccessAnywhereSection(),

                    // Section 10: Final Call To Action
                    const FinalCtaSection(),

                    // Section 11: Footer
                    FooterSection(onSectionSelected: _scrollToSection),
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
