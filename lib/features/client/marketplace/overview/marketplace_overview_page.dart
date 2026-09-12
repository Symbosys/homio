import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/marketplace_enums.dart';
import '../services/marketplace_service.dart';
import '../services/order_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_banner.dart';
import 'widgets/stats_ticker.dart';
import 'widgets/category_tile.dart';
import 'widgets/featured_carousel.dart';

/// Central Marketplace Overview Hub
class ClientMarketplaceOverviewPage extends StatelessWidget {
  const ClientMarketplaceOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      title: 'Marketplace Overview',
      subtitle: 'Discovery, materials, curated decor, verified properties & on-demand services',
      body: ListenableBuilder(
        listenable: MarketplaceService(),
        builder: (context, _) {
          final service = MarketplaceService();
          final counts = service.getCategoryCounts();
          final orderCount = OrderService().orders.length;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              // Hero Ecosystem Banner
              MarketplaceBanner(
                tag: 'HOMIO Integrated Commerce',
                title: 'Architecture, Materials & Verified Services',
                description:
                    'Connect design blueprints directly to construction materials, luxury decor and master craftsmen. Backed by HOMIO trade pricing guarantees and milestone warranties.',
                ctaText: 'Explore Trade Materials',
                icon: Icons.storefront_rounded,
                onCtaPressed: () => context.go('/client/marketplace/materials'),
              ),

              const SizedBox(height: 24),

              // Trust Metrics Ticker
              const StatsTicker(),

              const SizedBox(height: 32),

              // Category Modules Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1100
                      ? 3
                      : (constraints.maxWidth > 700 ? 2 : 1);

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      CategoryTile(
                        category: MarketplaceCategory.digitalProducts,
                        count: counts['digital'] ?? 6,
                        description: 'Vastu blueprints, Revit BIM templates, 3D interior shaders & turnkey BOQs.',
                        highlights: [
                          'Instant download to Design Vault',
                          'Industry standard DWG & RVT files',
                          'Vastu Shastra compliant plans',
                        ],
                        accentColor: const Color(0xFF10B981),
                      ),
                      CategoryTile(
                        category: MarketplaceCategory.homeDecor,
                        count: counts['decor'] ?? 6,
                        description: 'Curated designer lighting, bespoke furniture, rugs & artisanal ceramics.',
                        highlights: [
                          'Direct HOMIO & affiliate fulfillment',
                          'Verified dimensions & 3D compatibility',
                          'Multi-vendor platform integration',
                        ],
                        accentColor: const Color(0xFF8B5CF6),
                      ),
                      CategoryTile(
                        category: MarketplaceCategory.materials,
                        count: counts['materials'] ?? 6,
                        description: 'Direct manufacturer pricing for cement, Italian tiles, paints & sanitaryware.',
                        highlights: [
                          'Save 15-25% with B2B Trade Pricing',
                          'Strict IS & ISO quality test reports',
                          'Direct site delivery with live tracking',
                        ],
                        accentColor: const Color(0xFF3B82F6),
                      ),
                      CategoryTile(
                        category: MarketplaceCategory.properties,
                        count: counts['properties'] ?? 4,
                        description: 'Verified luxury apartments, duplexes, penthouses & commercial studios.',
                        highlights: [
                          '100% RERA verified title clearances',
                          'Direct owner contact unlock (₹500)',
                          'Vastu compliant floorplans',
                        ],
                        accentColor: const Color(0xFFF59E0B),
                      ),
                      CategoryTile(
                        category: MarketplaceCategory.labourServices,
                        count: counts['workers'] ?? 4,
                        description: 'Vetted master carpenters, licensed electricians, plumbers & painters.',
                        highlights: [
                          'Police & skill-tier verified craftsmen',
                          'Transparent daily & hourly rates',
                          'Fixed-scope turnkey booking packages',
                        ],
                        accentColor: const Color(0xFF06B6D4),
                      ),
                      CategoryTile(
                        category: MarketplaceCategory.orders,
                        count: orderCount,
                        description: 'Track orders, download GST invoices, and manage service appointment history.',
                        highlights: [
                          'Unified physical & digital receipt ledger',
                          'Live courier tracking integration',
                          'One-click tax GST invoice generation',
                        ],
                        accentColor: const Color(0xFFEC4899),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 36),

              // Featured & Trending Showcase
              FeaturedCarousel(
                digitalItems: service.digitalProducts,
                decorItems: service.homeDecorItems,
                propertyItems: service.properties,
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
