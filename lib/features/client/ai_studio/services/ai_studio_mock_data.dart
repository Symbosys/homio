import 'package:flutter/material.dart';
import '../../../../app/router/route_names.dart';
import '../models/models.dart';

class AiStudioMockData {
  static List<AiToolDefinition> getToolDefinitions() {
    return const [
      // 1. Room Designer (5-Step)
      AiToolDefinition(
        id: 'room_designer',
        title: '3D Room Designer',
        subtitle: '5-Step Architectural Visualizer',
        description:
            'Upload a photo or configure dimensions to generate photorealistic 3D room transformations with custom palettes and materials.',
        icon: Icons.meeting_room_rounded,
        accentColor: Color(0xFF6366F1),
        routePath: RouteNames.clientAiRoomGenPath,
        routeName: RouteNames.clientAiRoomGen,
        creditCost: 3,
        costLabel: '3 Credits',
        category: AiToolCategory.design3D,
        badgeText: 'Flagship Tool',
        isFeatured: true,
      ),

      // 2. Image Generator
      AiToolDefinition(
        id: 'image_generator',
        title: 'Visual Asset Generator',
        subtitle: 'Interior & Architectural Renders',
        description:
            'Generate high-definition material swatches, isometric dollhouse cutaways, moodboards, and photorealistic design concepts.',
        icon: Icons.image_rounded,
        accentColor: Color(0xFF8B5CF6),
        routePath: '/client/ai-image-generator',
        routeName: 'clientAiImageGenerator',
        creditCost: 2,
        costLabel: '2 Credits',
        category: AiToolCategory.design3D,
      ),

      // 3. Video Walkthrough
      AiToolDefinition(
        id: 'video_walkthrough',
        title: 'Cinematic Video Flythrough',
        subtitle: '360° AI Camera Animations',
        description:
            'Transform static room designs into smooth 60fps cinematic flythroughs, dolly reveals, and circular architectural orbits.',
        icon: Icons.videocam_rounded,
        accentColor: Color(0xFFEC4899),
        routePath: '/client/ai-video-generator',
        routeName: 'clientAiVideoGenerator',
        creditCost: 8,
        costLabel: '8 Credits',
        category: AiToolCategory.design3D,
        badgeText: 'New',
      ),

      // 4. Material Specification AI
      AiToolDefinition(
        id: 'material_spec',
        title: 'Material Intelligence',
        subtitle: 'Brand Specs & Indian Standards',
        description:
            'Explore certified Indian brand specifications (CenturyPly, Hafele, Asian Paints, Simpolo) with durability ratings and live BOQ sync.',
        icon: Icons.texture_rounded,
        accentColor: Color(0xFF10B981),
        routePath: '/client/ai-material-specs',
        routeName: 'clientAiMaterialSpecs',
        creditCost: 1,
        costLabel: '1 Credit',
        category: AiToolCategory.technical,
      ),

      // 5. Vastu Consultant
      AiToolDefinition(
        id: 'vastu_consultant',
        title: 'AI Vastu Consultant',
        subtitle: '8-Direction Energy Audit',
        description:
            'Audit floor plan directions, check element alignment (Ishanya, Agneya, Nairutya), and get non-demolition Vedic remedies.',
        icon: Icons.compass_calibration_rounded,
        accentColor: Color(0xFFF59E0B),
        routePath: RouteNames.clientAiVastuPath,
        routeName: RouteNames.clientAiVastu,
        creditCost: 2,
        costLabel: '2 Credits',
        category: AiToolCategory.technical,
      ),

      // 6. Budget Estimator
      AiToolDefinition(
        id: 'budget_calculator',
        title: 'Budget & Scope Estimator',
        subtitle: 'Tiered Package Cost Comparison',
        description:
            'Accurate cost breakdowns comparing Economy Commercial Ply vs HDHMR Acrylic vs Luxury Veneer with scope percentages.',
        icon: Icons.calculate_rounded,
        accentColor: Color(0xFF06B6D4),
        routePath: RouteNames.clientAiBudgetPath,
        routeName: RouteNames.clientAiBudget,
        creditCost: 1,
        costLabel: '1 Credit',
        category: AiToolCategory.financial,
      ),

      // 7. Doubt Solver
      AiToolDefinition(
        id: 'doubt_solver',
        title: 'Civil & Tech Doubt Solver',
        subtitle: 'IS Codes & Execution Advisory',
        description:
            'Instant technical answers on waterproofing, carpentry warping, electrical loads, and gypsum channel tolerances.',
        icon: Icons.psychology_rounded,
        accentColor: Color(0xFF3B82F6),
        routePath: RouteNames.clientAiDoubtSolverPath,
        routeName: RouteNames.clientAiDoubtSolver,
        creditCost: 1,
        costLabel: '1 Credit',
        category: AiToolCategory.technical,
      ),

      // 8. Human Designer Consultation
      AiToolDefinition(
        id: 'designer_call',
        title: '1-on-1 Designer Consultation',
        subtitle: 'Live Video Call & Whiteboard',
        description:
            'Book a 30-minute private video review session with senior interior architects. Screen-share AI renders and mark up blueprints live.',
        icon: Icons.video_call_rounded,
        accentColor: Color(0xFF14B8A6),
        routePath: RouteNames.clientDesignerCallPath,
        routeName: RouteNames.clientDesignerCall,
        creditCost: 0,
        costLabel: 'Direct Booking',
        category: AiToolCategory.financial,
        badgeText: 'Expert Human',
      ),

      // 9. Saved Designs & Moodboards
      AiToolDefinition(
        id: 'saved_designs',
        title: 'Saved Studio Vault',
        subtitle: 'Moodboards & Bookmarks',
        description:
            'Organize your favorite renders, color palettes, and material swatches. Tag items directly for your project contractor and designer.',
        icon: Icons.bookmark_border_rounded,
        accentColor: Color(0xFF8B5CF6),
        routePath: '/client/ai-saved-designs',
        routeName: 'clientAiSavedDesigns',
        creditCost: 0,
        costLabel: 'Free',
        category: AiToolCategory.design3D,
      ),

      // 10. AI Credits & Wallet
      AiToolDefinition(
        id: 'ai_credits',
        title: 'AI Studio Wallet & Credits',
        subtitle: 'Usage Ledger & Pack Top-Up',
        description:
            'Monitor real-time credit balances, view itemized generation invoices, and top up credit bundles with instant UPI or card checkout.',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: Color(0xFFF97316),
        routePath: '/client/ai-credits',
        routeName: 'clientAiCredits',
        creditCost: 0,
        costLabel: 'Wallet',
        category: AiToolCategory.financial,
      ),
    ];
  }

  static List<MaterialSpecificationItem> getInitialMaterials() {
    return const [
      MaterialSpecificationItem(
        id: 'MAT-001',
        category: MaterialCategory.carcassCore,
        productName: 'Club Prime 710 BWP Marine Plywood',
        brand: 'CenturyPly',
        gradeOrCode: 'IS:710 Marine Grade (Calibrated)',
        applicationArea: 'Kitchen Undersink & Wet Area Carcasses',
        durabilityLevel: 'Extreme Boiling Waterproof (72hr boiling tested)',
        costPerUnit: 145.0,
        unit: 'sq.ft',
        warrantyYears: 25,
        maintenanceTips: 'Impervious to termites and water. Ideal for humid Indian conditions.',
        alternativeBrands: ['Greenply Gold Marine', 'Austin Club Plus'],
        isEcoCertified: true,
        isSavedToProjectBOQ: true,
      ),
      MaterialSpecificationItem(
        id: 'MAT-002',
        category: MaterialCategory.surfaceFinish,
        productName: 'Senosan High Gloss 1.5mm Acrylic Sheet',
        brand: 'Rehau / Senosan',
        gradeOrCode: 'Scratch-Resistant Anti-UV Series',
        applicationArea: 'Kitchen Overhead & Loft Shutters',
        durabilityLevel: 'Mirror Glass Finish, Seamless Edge Banded',
        costPerUnit: 260.0,
        unit: 'sq.ft',
        warrantyYears: 10,
        maintenanceTips: 'Wipe with microfiber cloth and diluted soapy water. Avoid abrasive scrubs.',
        alternativeBrands: ['Euro Pratik Acrylic', 'Stylam Gloss'],
        isEcoCertified: true,
        isSavedToProjectBOQ: true,
      ),
      MaterialSpecificationItem(
        id: 'MAT-003',
        category: MaterialCategory.hardwareFittings,
        productName: 'Sensys 8645i Soft-Close Concealed Hinge',
        brand: 'Hettich',
        gradeOrCode: '110° Opening with Integrated Silent System',
        applicationArea: 'All Wardrobe and Base Cabinet Doors',
        durabilityLevel: 'Tested for 200,000 opening cycles (EN 15570)',
        costPerUnit: 340.0,
        unit: 'pair',
        warrantyYears: 15,
        maintenanceTips: 'Periodic dusting; factory-sealed lubrication requires no external oiling.',
        alternativeBrands: ['Blum Clip Top Blumotion', 'Hafele Metalla 300'],
        isEcoCertified: true,
        isSavedToProjectBOQ: true,
      ),
      MaterialSpecificationItem(
        id: 'MAT-004',
        category: MaterialCategory.countertops,
        productName: 'Calacatta Gold Engineered Quartz (20mm)',
        brand: 'KalingaStone',
        gradeOrCode: 'Nano-Polished Seamless Slab',
        applicationArea: 'Kitchen Countertop & Waterfall Edge Island',
        durabilityLevel: 'Mohs Hardness 7, Zero-Porosity Stain Resistant',
        costPerUnit: 480.0,
        unit: 'sq.ft',
        warrantyYears: 12,
        maintenanceTips: 'Non-porous; does not absorb turmeric or curry spills. Clean with warm water.',
        alternativeBrands: ['Caesarstone', 'Silestone by Cosentino'],
        isEcoCertified: true,
        isSavedToProjectBOQ: false,
      ),
      MaterialSpecificationItem(
        id: 'MAT-005',
        category: MaterialCategory.paintsPolishes,
        productName: 'Royale Aspira Anti-Bacterial Interior Emulsion',
        brand: 'Asian Paints',
        gradeOrCode: 'Teflon Surface Protector (Low VOC)',
        applicationArea: 'Living, Dining & Master Bedroom Walls',
        durabilityLevel: 'Hydrophobic, washable up to 10,000 scrub cycles',
        costPerUnit: 48.0,
        unit: 'sq.ft (2 coats)',
        warrantyYears: 5,
        maintenanceTips: 'Stains can be cleaned effortlessly with damp sponge and mild detergent.',
        alternativeBrands: ['Berger Silk Glamor', 'Dulux Velvet Touch'],
        isEcoCertified: true,
        isSavedToProjectBOQ: false,
      ),
    ];
  }

  static VastuAnalysisReport getInitialVastuReport() {
    return VastuAnalysisReport(
      id: 'VASTU-2026-104',
      propertyTitle: 'Aura Heights Apt 1402 (East-Facing 3BHK)',
      overallScore: 84,
      chakraLevel: 'Harmonious & Auspicious with Minor Remedies',
      primaryDosha: 'Kitchen Hob slightly skewed towards South instead of pure Agneya',
      floorPlanImageUrl: 'assets/images/vastu_sample_plan.png',
      analyzedAt: DateTime.now().subtract(const Duration(days: 1)),
      zones: const [
        VastuZoneResult(
          direction: 'North-East (Ishanya)',
          governingElement: 'Water / Jal (Wisdom & Spiritual Growth)',
          currentRoomPlacement: 'Pooja Mandir & Open Living Balcony',
          status: VastuStatus.optimal,
          compliancePercent: 96,
          energyAnalysis:
              'Outstanding light penetration and sacred energy flow. Kept uncluttered and pristine.',
          nonDestructiveRemedies: [
            'Maintain a pure brass urli bowl with fresh water and floating jasmine daily.',
          ],
        ),
        VastuZoneResult(
          direction: 'South-East (Agneya)',
          governingElement: 'Fire / Agni (Vitality & Financial Digestion)',
          currentRoomPlacement: 'Modular Kitchen (Cooktop Facing East)',
          status: VastuStatus.optimal,
          compliancePercent: 92,
          energyAnalysis:
              'Kitchen burner faces the morning sun. Promotes abundant health and vitality for the household.',
          nonDestructiveRemedies: [
            'Introduce subtle coral or terracotta warm tone accents on backsplash tiles.',
          ],
        ),
        VastuZoneResult(
          direction: 'South-West (Nairutya)',
          governingElement: 'Earth / Prithvi (Stability, Authority & Leadership)',
          currentRoomPlacement: 'Master Bedroom with King Bed',
          status: VastuStatus.optimal,
          compliancePercent: 90,
          energyAnalysis:
              'Headboard placed against the South wall ensures restful sleep and grounding stability.',
          nonDestructiveRemedies: [
            'Use solid wood or heavy earthen ceramics on nightstands to anchor earth element.',
          ],
        ),
        VastuZoneResult(
          direction: 'North-West (Vayavya)',
          governingElement: 'Air / Vayu (Movement & Social Connections)',
          currentRoomPlacement: 'Guest Bedroom & Dining Nook',
          status: VastuStatus.moderate,
          compliancePercent: 78,
          energyAnalysis:
              'Air flow is healthy, but guest wardrobe placement requires balancing to prevent restlessness.',
          nonDestructiveRemedies: [
            'Hang a gentle 5-pipe metallic wind chime near the window to harmonize air currents.',
            'Keep curtains in pearl white or light grey pastel textures.',
          ],
        ),
        VastuZoneResult(
          direction: 'Center (Brahmasthan)',
          governingElement: 'Ether / Akasha (Cosmic Equilibrium)',
          currentRoomPlacement: 'Open Living Circulation Foyer',
          status: VastuStatus.optimal,
          compliancePercent: 98,
          energyAnalysis:
              'Brahmasthan is completely free from heavy pillars, toilets, or beam loads.',
          nonDestructiveRemedies: [
            'Ensure no heavy storage cabinets or heavy metal statues are positioned in this zone.',
          ],
        ),
      ],
      topPriorityRecommendations: const [
        'Place a pure copper strip under the kitchen entrance threshold to seal Agni chakra.',
        'Keep the North-East living room corner free from heavy exercise equipment or dark paint.',
        'Ensure the master bedroom dressing mirror does not reflect the bed while sleeping.',
      ],
    );
  }

  static BudgetCalculationResult getInitialBudgetEstimate() {
    return BudgetCalculationResult(
      id: 'BUDGET-2026-554',
      carpetAreaSqFt: 1850.0,
      bhkConfiguration: '3BHK Luxury Turnkey Interior',
      calculatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      recommendedPackageId: 'pkg_premium',
      savingsOpportunities: const [
        'Save ₹1,40,000 by using Anti-Fingerprint Matte Laminate on internal wardrobes instead of full acrylic.',
        'Save ₹65,000 by optimizing false ceiling to perimeter cove profiles instead of full drop-down gypsum.',
        'Save ₹45,000 by selecting Kalinga Stone Quartz instead of imported Italian Statuario Marble for vanity counters.',
      ],
      packageComparisons: const [
        BudgetPackageOption(
          id: 'pkg_economy',
          title: 'Standard Essential',
          targetSegment: 'Budget-Conscious / Rental Investment',
          totalCost: 1680000.0,
          perSqFtRate: 908.0,
          warrantyYears: 5,
          highlightPoints: [
            'MR Grade Calibrated Commercial Plywood',
            '0.8mm Gloss/Suede Laminate finishes',
            'Standard soft-close hinges (Ebco / Godrej)',
            'Asian Paints Tractor Emulsion finish',
          ],
          scopeBreakdown: [
            BudgetScopeItem(
              categoryName: 'Modular Kitchen (10ft x 8ft)',
              amount: 320000,
              percentage: 19.0,
              specifications: 'MR Ply carcass + 0.8mm Laminate + Granite counter',
            ),
            BudgetScopeItem(
              categoryName: '3 Wardrobes & Storage Units',
              amount: 580000,
              percentage: 34.5,
              specifications: 'Swing doors with standard hardware & mirror panel',
            ),
            BudgetScopeItem(
              categoryName: 'Living & Dining Furniture',
              amount: 340000,
              percentage: 20.2,
              specifications: 'TV console, shoe cabinet, 6-seater engineered table',
            ),
            BudgetScopeItem(
              categoryName: 'False Ceiling & Electrical',
              amount: 220000,
              percentage: 13.1,
              specifications: 'Basic perimeter ceiling with warm white spotlights',
            ),
            BudgetScopeItem(
              categoryName: 'Painting & Surface Finish',
              amount: 220000,
              percentage: 13.2,
              specifications: 'Full putty priming + 2 coats tractor emulsion',
            ),
          ],
        ),
        BudgetPackageOption(
          id: 'pkg_premium',
          title: 'Premium Modern (Recommended)',
          targetSegment: 'Homeowner Preferred / High Durability',
          totalCost: 2450000.0,
          perSqFtRate: 1324.0,
          warrantyYears: 10,
          highlightPoints: [
            'CenturyPly Club Prime BWP 710 Marine Ply Kitchen',
            'HDHMR Moisture-Resistant Wardrobes with 1mm Acrylic',
            'Hettich / Hafele Soft-Close Tandem Drawers',
            'Kalinga Stone Quartz Countertop & Profile LEDs',
            'Asian Paints Royale Luxury Emulsion Washable',
          ],
          scopeBreakdown: [
            BudgetScopeItem(
              categoryName: 'Modular Island Kitchen',
              amount: 540000,
              percentage: 22.0,
              specifications: 'BWP Marine carcass + 1.5mm Acrylic + Quartz counter',
            ),
            BudgetScopeItem(
              categoryName: '3 Floor-to-Ceiling Wardrobes',
              amount: 880000,
              percentage: 35.9,
              specifications: 'Fluted panels, tinted glass shutters, built-in sensor lights',
            ),
            BudgetScopeItem(
              categoryName: 'Living & Dining Accentuation',
              amount: 460000,
              percentage: 18.8,
              specifications: 'Floating marble TV console, fluted rafters, custom bar cabinet',
            ),
            BudgetScopeItem(
              categoryName: 'Designer Gypsum Ceiling & Lighting',
              amount: 290000,
              percentage: 11.8,
              specifications: 'Saint-Gobain gypsum, magnetic track lights, 3000K indirect coves',
            ),
            BudgetScopeItem(
              categoryName: 'Royale Aspira Paint & Texture Walls',
              amount: 280000,
              percentage: 11.5,
              specifications: 'Washable anti-bacterial emulsion + 2 accent texture walls',
            ),
          ],
        ),
        BudgetPackageOption(
          id: 'pkg_luxury',
          title: 'Ultra-Luxury Bespoke',
          targetSegment: 'Villa & Penthouse Architectural Grade',
          totalCost: 3850000.0,
          perSqFtRate: 2081.0,
          warrantyYears: 15,
          highlightPoints: [
            'Natural Smoked Teak & Walnut Veneer with PU Polish',
            'Imported Italian Statuario Marble Top Island',
            'Blum Servo-Drive Motorized Touch Drawers',
            'Smart Home KNX / Zigbee Automated Lighting Integration',
            'Microcement Wall Cladding & Acoustic Wood Panels',
          ],
          scopeBreakdown: [
            BudgetScopeItem(
              categoryName: 'Chef Island Kitchen & Pantry',
              amount: 890000,
              percentage: 23.1,
              specifications: 'Motorized Blum servo drawers + Italian Statuario + Lacquered glass',
            ),
            BudgetScopeItem(
              categoryName: 'Walk-in Closets & Wardrobes',
              amount: 1420000,
              percentage: 36.9,
              specifications: 'Full Italian aluminum profile glass walk-in with suede velvet lining',
            ),
            BudgetScopeItem(
              categoryName: 'Bespoke Paneling & Partitions',
              amount: 720000,
              percentage: 18.7,
              specifications: 'Smoked oak fluted paneling with brass inlay and concealed pivot doors',
            ),
            BudgetScopeItem(
              categoryName: 'Architectural Ceiling & Automation',
              amount: 440000,
              percentage: 11.4,
              specifications: 'Seamless stretch ceiling + Dali dimmable automation tracks',
            ),
            BudgetScopeItem(
              categoryName: 'Artisan Microcement & PU Polish',
              amount: 380000,
              percentage: 9.9,
              specifications: 'Zero-VOC Italian microcement finish + High-solid PU matte clear',
            ),
          ],
        ),
      ],
    );
  }

  static List<DoubtQuery> getInitialDoubtQueries() {
    return [
      DoubtQuery(
        id: 'DBT-101',
        domain: DoubtDomain.waterproofing,
        question:
            'How can I ensure my bathroom sunken slab never leaks into the apartment below, and what chemical membrane is recommended?',
        confidencePercent: 99,
        humanVerifierName: 'Er. Sandeep Menon, Chief MEP Auditor',
        creditsUsed: 1,
        askedAt: DateTime.now().subtract(const Duration(hours: 4)),
        aiDetailedAnswer:
            'Bathroom sunken slabs require a 3-layer elastomeric waterproofing system to guarantee zero leakage:\n\n'
            '1. **Surface Preparation**: Mechanically grind concrete slab to remove laitance, dust, and grease. Treat any cold joints or honeycomb pockets with non-shrink polymer repair mortar (Fosroc Renderoc RG).\n'
            '2. **Core Membrane Application**: Apply a 2-coat heavy-duty acrylic/cementitious elastomeric membrane such as **Dr. Fixit Fastflex** or **SikaTop Seal-107**. Ensure the coating extends at least 300mm up the vertical parapet/brick wall to form a seamless water basin.\n'
            '3. **Curing & Pond Testing**: Allow 48 hours of curing, then conduct a mandatory **72-hour standing water pond test** with at least 50mm of water depth before backfilling with light-weight cinder or foam concrete.\n'
            '4. **Drain Collar Sealing**: Seal around all PVC drain traps with polyurethane sealant (Sikaflex Construction+) to prevent capillary leakage between the pipe exterior and the concrete slab.',
        immediateChecklistSteps: const [
          'Verify contractor performs 72-hour water ponding test before laying floor tiles.',
          'Ensure 45-degree angle fillets (coving) are cast at all wall-to-floor junctions.',
          'Do not puncture the membrane with anchor bolts for plumbing pipe supports.',
        ],
        standardIndianCodesReferenced: const [
          'IS 1346: Code of practice for waterproofing of roofs and sunken slabs',
          'IS 3067: General design details and preparatory work for damp-proofing',
        ],
      ),
      DoubtQuery(
        id: 'DBT-102',
        domain: DoubtDomain.carpentry,
        question:
            'Should I use HDHMR or BWP Plywood for my 8-foot tall bedroom wardrobe shutters to prevent warping over time?',
        confidencePercent: 97,
        humanVerifierName: 'Ananya Deshmukh, Principal Interior Designer',
        creditsUsed: 1,
        askedAt: DateTime.now().subtract(const Duration(days: 1)),
        aiDetailedAnswer:
            'For wardrobe shutters measuring 8 feet (2440mm) in height, the primary engineering concern is vertical bowing and warping:\n\n'
            '• **HDHMR (High Density High Moisture Resistance, Density > 850 kg/m³)**: HDHMR from Action TESA or Greenpanel is homogeneous and does not have natural grain stress. However, at 8 feet height, unsupported single panels can bow over time if not counter-balanced.\n'
            '• **Recommendation**: Use **18mm Calibrated BWP Plywood (IS:710)** with equal thickness balancing sheets on both sides (e.g., 1mm laminate outside + 0.8mm balancing laminate inside).\n'
            '• **Essential Hardware**: Install an internal **anti-warp shutter straightener tension rod (Hafele or Hettich)** routed inside the back of each 8ft door. This allows mechanical tension adjustment over the years to keep the door 100% laser-straight.',
        immediateChecklistSteps: const [
          'Never leave the internal face of the shutter in bare paint or thin 0.5mm paper foil; always use 0.8mm laminate balance.',
          'Install at least 4 hinges (or 5 hinges for heavy shutters) per 8ft shutter door.',
          'Insist on factory-fitted shutter straightening tension rods for any shutter exceeding 7 feet.',
        ],
        standardIndianCodesReferenced: const [
          'IS 710: Marine Plywood Specification',
          'IS 1658: Fibre hardboard and high density board standards',
        ],
      ),
    ];
  }

  static List<ExpertDesignerProfile> getDesignerProfiles() {
    return const [
      ExpertDesignerProfile(
        id: 'des_01',
        name: 'Ar. Vikramaditya Sen',
        designation: 'Principal Architectural Designer (Gold Medalist, CEPT)',
        experienceYears: 14,
        avatarUrl: 'assets/images/designer_vikram.png',
        designSpecialties: [
          'Japandi Warm Minimalism',
          'Villa Spatial Planning',
          'Vedic Vastu Integration',
        ],
        rating: 4.96,
        reviewCount: 142,
        consultationFeeInr: 999,
        availableSlotsToday: ['04:00 PM', '05:30 PM', '07:00 PM'],
      ),
      ExpertDesignerProfile(
        id: 'des_02',
        name: 'Meera Nambiar',
        designation: 'Senior Interior Stylist & Color Consultant',
        experienceYears: 9,
        avatarUrl: 'assets/images/designer_meera.png',
        designSpecialties: [
          'Contemporary Luxury Living',
          'Custom Fluted Woodwork',
          'Modular Kitchen Ergonomics',
        ],
        rating: 4.92,
        reviewCount: 98,
        consultationFeeInr: 799,
        availableSlotsToday: ['03:30 PM', '06:00 PM'],
      ),
      ExpertDesignerProfile(
        id: 'des_03',
        name: 'Kavita Sundaram',
        designation: 'Lighting & Acoustic Architecture Specialist',
        experienceYears: 11,
        avatarUrl: 'assets/images/designer_kavita.png',
        designSpecialties: [
          'Architectural Profile Lighting',
          'False Ceiling Design',
          'Home Theatre Acoustics',
        ],
        rating: 4.88,
        reviewCount: 86,
        consultationFeeInr: 899,
        availableSlotsToday: ['05:00 PM', '06:30 PM', '08:00 PM'],
      ),
    ];
  }

  static List<SavedDesignItem> getInitialSavedDesigns() {
    return [
      SavedDesignItem(
        id: 'SAV-001',
        title: 'Japandi Living Room with Fluted Oak & Cove Light',
        category: 'Living Room',
        imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=900&auto=format&fit=crop&q=80',
        colorPalette: const ['#2C2A29', '#EAE6DF', '#C5A880', '#534B46'],
        keyMaterials: const ['Smoked Oak Rafters', 'Microcement Wall', 'Warm Linen Curtains'],
        personalNotes: 'Client loved the floating console and hidden LED track lights.',
        isSharedWithDesigner: true,
        savedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      SavedDesignItem(
        id: 'SAV-002',
        title: 'Minimalist Modular Kitchen with Quartz Island Counter',
        category: 'Modular Kitchen',
        imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=900&auto=format&fit=crop&q=80',
        colorPalette: const ['#1F2421', '#F4F4F2', '#D8B18A', '#9B9B9B'],
        keyMaterials: const ['Kalinga Stone Quartz', 'Rehau Acrylic', 'Hettich Sensys Hinges'],
        personalNotes: 'Need 3000K LED profile under overhead cabinets.',
        isSharedWithDesigner: false,
        savedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SavedDesignItem(
        id: 'SAV-003',
        title: 'Master Bedroom with Fluted Acoustic Headboard & Sconces',
        category: 'Master Bedroom',
        imageUrl: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=900&auto=format&fit=crop&q=80',
        colorPalette: const ['#1E2022', '#F0ECE9', '#A67B5B', '#686D76'],
        keyMaterials: const ['BWP Plywood Headboard', 'Velvet Upholstery', 'Brushed Brass Sconces'],
        personalNotes: 'Check bed clearance with wardrobe swing doors.',
        isSharedWithDesigner: true,
        savedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  static List<AiGenerationHistoryItem> getInitialHistory() {
    return [
      AiGenerationHistoryItem(
        id: 'HIST-001',
        type: AiArtifactType.roomRender,
        title: 'Master Bedroom 3D Transformation',
        subtitle: 'Japandi Warm Minimalist with King Bed & Fluted Panels',
        previewImageUrl:
            'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800&auto=format&fit=crop&q=80',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        creditsUsed: 3,
        isBookmarked: true,
        destinationRoute: RouteNames.clientAiRoomGenPath,
      ),
      AiGenerationHistoryItem(
        id: 'HIST-002',
        type: AiArtifactType.vastuAudit,
        title: 'Aura Heights Apt 1402 Vastu Floorplan Audit',
        subtitle: 'Score 84/100 · Harmonious with 3 Non-Destructive Remedies',
        previewImageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        creditsUsed: 2,
        isBookmarked: false,
        destinationRoute: RouteNames.clientAiVastuPath,
      ),
      AiGenerationHistoryItem(
        id: 'HIST-003',
        type: AiArtifactType.budgetSpec,
        title: '3BHK Comprehensive Interior Cost Breakdown',
        subtitle: 'Estimated ₹24,50,000 (Premium Package Preferred)',
        previewImageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        creditsUsed: 1,
        isBookmarked: true,
        destinationRoute: RouteNames.clientAiBudgetPath,
      ),
      AiGenerationHistoryItem(
        id: 'HIST-004',
        type: AiArtifactType.technicalDoubt,
        title: 'Bathroom Sunken Slab Waterproofing System',
        subtitle: 'Elastomeric membrane + 72-hr pond testing verified',
        previewImageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
        creditsUsed: 1,
        isBookmarked: false,
        destinationRoute: RouteNames.clientAiDoubtSolverPath,
      ),
    ];
  }
}
