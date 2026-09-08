import 'package:flutter/material.dart';
import 'ai_suite_models.dart';

abstract class AiSuiteMockData {
  // ============================================================================
  // 1. MOCK WALLET & REVENUE SHARING LEDGER
  // ============================================================================
  static final AiWalletModel defaultWallet = AiWalletModel(
    totalTokens: 420,
    freeDoubtQueriesRemaining: 3,
    platformCommissionRate: 50.0,
    designerRevenueShareRate: 50.0,
    transactionHistory: [
      AiRevenueSplitRecord(
        id: 'REV-9801',
        type: RevenueSplitType.roomRenderDebit,
        totalAmount: 100.0,
        platformShare: 50.0,
        designerShare: 50.0,
        designerName: 'Pooja Hegde (Senior Interior Architect)',
        clientName: 'Vikram Malhotra (Penthouse #402)',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AiRevenueSplitRecord(
        id: 'REV-9798',
        type: RevenueSplitType.walkthroughVideoDebit,
        totalAmount: 250.0,
        platformShare: 125.0,
        designerShare: 125.0,
        designerName: 'Aarav Singhania (3D Visualizer)',
        clientName: 'Sunita Mehra (DLF Phase 5)',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AiRevenueSplitRecord(
        id: 'REV-9765',
        type: RevenueSplitType.videoConsultationDebit,
        totalAmount: 300.0,
        platformShare: 150.0,
        designerShare: 150.0,
        designerName: 'Karan Mehra (Principal Architect)',
        clientName: 'Rajesh Khanna (Golf Course Extn)',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      AiRevenueSplitRecord(
        id: 'REV-9740',
        type: RevenueSplitType.doubtSolverDebit,
        totalAmount: 50.0,
        platformShare: 25.0,
        designerShare: 25.0,
        designerName: 'Homio AI Engineering Core',
        clientName: 'Deepak Chopra (Villa #12)',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
  );

  // ============================================================================
  // 2. MOCK ROOM GENERATION GALLERY & BOQ SPECIFICATIONS
  // ============================================================================
  static final List<AiRoomGenerationItem> roomGenerations = [
    AiRoomGenerationItem(
      id: 'GEN-101',
      title: 'Luxury Living Room with Fluted Marble & Brass Accents',
      roomType: AiRoomType.livingRoom,
      theme: AiDesignTheme.modernMinimalist,
      lighting: AiLightingCondition.warmEvening,
      colorPalette: AiColorPalette.warmNeutrals,
      prompt:
          'Staged modern living room with bookmatched Statuario marble TV backdrop, fluted charcoal acoustic wall panelling, concealed 3000K linear warm LED cove, Italian low-profile modular sectional in oat boucle, and brushed brass floating shelving.',
      rawPhotoUrl:
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
      renderPhotoUrl:
          'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80',
      videoWalkthroughUrl:
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=80',
      splitSliderPosition: 0.52,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      designerAssigned: 'Pooja Hegde (Senior Interior Architect)',
      renderCost: 100.0,
      boqItems: [
        BoqSpecificationItem(
          category: 'Wall Panelling',
          itemName: 'Charcoal Charcoal Charcoal Louvers',
          materialSpec: 'HDHMR base with 1.0mm anti-fingerprint fluted polymer sheet',
          quantity: '120 Sq.Ft',
          unitCost: 320.0,
          totalCost: 38400.0,
        ),
        BoqSpecificationItem(
          category: 'Feature Wall',
          itemName: 'Statuario Composite Marble Slab',
          materialSpec: '15mm seamless bookmatched composite tile with brass T-profiles',
          quantity: '85 Sq.Ft',
          unitCost: 650.0,
          totalCost: 55250.0,
        ),
        BoqSpecificationItem(
          category: 'Carpentry Console',
          itemName: 'Floating TV Low-Ledge Unit',
          materialSpec: 'BWP Marine Ply (IS 710) + Smoked Eucalyptus Natural Veneer',
          quantity: '14 R.Ft',
          unitCost: 1850.0,
          totalCost: 25900.0,
        ),
        BoqSpecificationItem(
          category: 'Architectural Lighting',
          itemName: 'Concealed 3000K Linear COB LED Profile',
          materialSpec: 'Philips warm golden 24V strip with frosted diffuser & Meanwell driver',
          quantity: '45 R.Ft',
          unitCost: 240.0,
          totalCost: 10800.0,
        ),
      ],
    ),
    AiRoomGenerationItem(
      id: 'GEN-102',
      title: 'Scandinavian Master Suite with Light Oak Walk-in Wardrobe',
      roomType: AiRoomType.masterBedroom,
      theme: AiDesignTheme.scandinavian,
      lighting: AiLightingCondition.daylight,
      colorPalette: AiColorPalette.lightPastels,
      prompt:
          'Spacious master bedroom with floor-to-ceiling panoramic glass, natural white oak wood flooring, fluted bed back in sage linen fabric, floating nightstands with ribbed glass lamps, and semi-open tinted glass wardrobe.',
      rawPhotoUrl:
          'https://images.unsplash.com/photo-1540518614846-7ede433c4550?auto=format&fit=crop&w=1200&q=80',
      renderPhotoUrl:
          'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=1200&q=80',
      videoWalkthroughUrl:
          'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=1200&q=80',
      splitSliderPosition: 0.48,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      designerAssigned: 'Aarav Singhania (3D Visualizer)',
      renderCost: 100.0,
      boqItems: [
        BoqSpecificationItem(
          category: 'Wardrobe Joinery',
          itemName: 'Full Height Sliding Tinted Wardrobe',
          materialSpec: 'Action TESA HDHMR, Hafele In-Line Soft-Close slider & Bronze glass',
          quantity: '72 Sq.Ft',
          unitCost: 1450.0,
          totalCost: 104400.0,
        ),
        BoqSpecificationItem(
          category: 'Headboard Wall',
          itemName: 'Acoustic Sage Linen Upholstered Panels',
          materialSpec: 'High-density 32D foam backing with stain-proof Belgian linen fabric',
          quantity: '90 Sq.Ft',
          unitCost: 480.0,
          totalCost: 43200.0,
        ),
        BoqSpecificationItem(
          category: 'Nightstands',
          itemName: 'Floating Minimal Bedside Drawers',
          materialSpec: 'BWR Marine Ply with 1mm matte Arctic White laminate & Blum runners',
          quantity: '2 Nos',
          unitCost: 6500.0,
          totalCost: 13000.0,
        ),
      ],
    ),
    AiRoomGenerationItem(
      id: 'GEN-103',
      title: 'Neo-Classical Modular Kitchen with Quartz Island Counter',
      roomType: AiRoomType.modularKitchen,
      theme: AiDesignTheme.neoClassical,
      lighting: AiLightingCondition.studioBright,
      colorPalette: AiColorPalette.warmNeutrals,
      prompt:
          'Luxury parallel island kitchen with slate blue Shaker-style profile shutters, brass knurled handles, Calacatta Gold quartz countertop with 40mm waterfall edge, Blum Aventos bi-fold lift-ups, and built-in Bosch appliance tall unit.',
      rawPhotoUrl:
          'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=1200&q=80',
      renderPhotoUrl:
          'https://images.unsplash.com/photo-1556912173-3bb406ef7e77?auto=format&fit=crop&w=1200&q=80',
      videoWalkthroughUrl:
          'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?auto=format&fit=crop&w=1200&q=80',
      splitSliderPosition: 0.55,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      designerAssigned: 'Karan Mehra (Principal Architect)',
      renderCost: 100.0,
      boqItems: [
        BoqSpecificationItem(
          category: 'Base & Wall Cabinets',
          itemName: 'Shaker Profile PU Coated Shutters',
          materialSpec: '19mm BWP Marine Ply (IS 710) with 6-coat polyurethane satin spray',
          quantity: '185 Sq.Ft',
          unitCost: 1750.0,
          totalCost: 323750.0,
        ),
        BoqSpecificationItem(
          category: 'Countertop',
          itemName: 'Calacatta Gold Engineered Quartz',
          materialSpec: '20mm stain-proof quartz with mitered 40mm seamless waterfall edge',
          quantity: '75 Sq.Ft',
          unitCost: 850.0,
          totalCost: 63750.0,
        ),
        BoqSpecificationItem(
          category: 'Hardware & Drawers',
          itemName: 'Blum Legrabox Heavy Tandem Systems',
          materialSpec: '70kg dynamic load capacity with integrated Tip-on Blumotion',
          quantity: '12 Sets',
          unitCost: 5200.0,
          totalCost: 62400.0,
        ),
      ],
    ),
  ];

  // ============================================================================
  // 3. MOCK VASTU CHAKRA 16-ZONE AUDIT DATA
  // ============================================================================
  static final VastuAuditReport sampleVastuReport = VastuAuditReport(
    id: 'VASTU-AUDIT-2026',
    projectName: 'DLF Crest Villa #402',
    clientName: 'Vikram Malhotra',
    floorPlanImageUrl:
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
    northOrientationDegrees: 28.0,
    overallComplianceScore: 84,
    auditedAt: DateTime.now().subtract(const Duration(days: 1)),
    zones: [
      VastuZoneDetail(
        zoneCode: 'NE',
        zoneName: 'North-East (Ishanya)',
        degreeStart: 33.75,
        degreeEnd: 56.25,
        element: 'Water / Space',
        rulingDeity: 'Lord Shiva (Divine Clarity)',
        recommendedColor: 'Light Blue, Crystal White',
        currentRoomPlacement: 'Pooja Room & Open Meditation Foyer',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Auspicious placement. Free from clutter, heavy structural masonry, or overhead water tanks. Channeling serene morning sun energy.',
        remedyAdvice: 'Maintain water fountain or brass urli with fresh water and camphor.',
      ),
      VastuZoneDetail(
        zoneCode: 'E',
        zoneName: 'East (Purva)',
        degreeStart: 78.75,
        degreeEnd: 101.25,
        element: 'Air / Fire',
        rulingDeity: 'Lord Indra (Social Connect)',
        recommendedColor: 'Light Emerald Green, Mint',
        currentRoomPlacement: 'Living Room Formal Seating & Main Balcony',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Ideal orientation for social networking, government connections, and dynamic family reputation.',
        remedyAdvice: 'Add indoor green plants (bamboo / money plant) along East window sills.',
      ),
      VastuZoneDetail(
        zoneCode: 'SE',
        zoneName: 'South-East (Agneya)',
        degreeStart: 123.75,
        degreeEnd: 146.25,
        element: 'Fire (Agni)',
        rulingDeity: 'Lord Agni (Cash Flow & Health)',
        recommendedColor: 'Warm Coral, Peach, Soft Orange',
        currentRoomPlacement: 'Modular Kitchen (Hob facing East)',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Perfect fire zone synergy. Cooking burner placed with chef facing East ensures family vitality and uninterrupted financial liquidity.',
        remedyAdvice: 'Avoid placing water purifiers or refrigerators within 3 feet of burner.',
      ),
      VastuZoneDetail(
        zoneCode: 'SSW',
        zoneName: 'South-South-West (Nirriti Sub-Zone)',
        degreeStart: 191.25,
        degreeEnd: 213.75,
        element: 'Earth (Depletion Zone)',
        rulingDeity: 'Yama (Disposal / Waste Elimination)',
        recommendedColor: 'Mustard Yellow, Earthy Beige',
        currentRoomPlacement: 'Powder Toilet & Soil Pipe Shaft',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Excellent. SSW is the natural zone of disposal. Drainage pipes here prevent waste retention in health and business.',
        remedyAdvice: 'Keep toilet lid closed; ensure yellow brass strip in entrance sill.',
      ),
      VastuZoneDetail(
        zoneCode: 'SW',
        zoneName: 'South-West (Nairutya)',
        degreeStart: 213.75,
        degreeEnd: 236.25,
        element: 'Earth (Prithvi)',
        rulingDeity: 'Nirriti (Stability & Authority)',
        recommendedColor: 'Warm Ochre, Sand Brown',
        currentRoomPlacement: 'Master Bedroom (Head to South)',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Optimal positioning for head of the household. Heavy wooden wardrobe anchor placed on South-West wall gives grounded stability.',
        remedyAdvice: 'Keep heaviest furniture against SW boundary wall. Avoid mirrors facing the bed.',
      ),
      VastuZoneDetail(
        zoneCode: 'NNE',
        zoneName: 'North-North-East',
        degreeStart: 11.25,
        degreeEnd: 33.75,
        element: 'Water',
        rulingDeity: 'Dhanvantari (Immunity & Healing)',
        recommendedColor: 'Off-White, Sky Blue',
        currentRoomPlacement: 'Guest Bathroom (Wet Enclosure)',
        status: VastuZoneStatus.minorImbalance,
        diagnosticNotes:
            'Wet toilet in NNE may cause seasonal respiratory lethargy or minor health drain for elderly occupants.',
        remedyAdvice:
            'Install 3mm pure copper energetic isolation strip along bathroom threshold door frame. Place rock sea salt bowl.',
      ),
      VastuZoneDetail(
        zoneCode: 'NW',
        zoneName: 'North-West (Vayavya)',
        degreeStart: 303.75,
        degreeEnd: 326.25,
        element: 'Air / Wind',
        rulingDeity: 'Vayu (Support & Banking Relations)',
        recommendedColor: 'Silver Grey, Pearl White',
        currentRoomPlacement: 'Guest Bedroom & Study Ledge',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Encourages supportive external relationships, swift bank loan approvals, and dynamic trade partner connections.',
        remedyAdvice: 'Hang 5-rod silver chime or circular brass clock on North-West wall.',
      ),
      VastuZoneDetail(
        zoneCode: 'N',
        zoneName: 'North (Kuber Sthana)',
        degreeStart: 348.75,
        degreeEnd: 11.25,
        element: 'Water (Jal)',
        rulingDeity: 'Lord Kuber (Treasury & New Opportunities)',
        recommendedColor: 'Emerald Green, Sea Blue',
        currentRoomPlacement: 'Home Office Desk & Financial Locker',
        status: VastuZoneStatus.auspicious,
        diagnosticNotes:
            'Flawless. North opening welcomes steady high-paying client contracts and continuous business expansion.',
        remedyAdvice: 'Ensure safe locker opens towards North or East.',
      ),
    ],
    recommendedRemedies: [
      VastuRemedyItem(
        title: 'NNE Toilet Energy Isolation Copper Threshold Strip',
        targetedDosha: 'Minor health drain from wet bathroom in North-North-East healing quadrant',
        nonDemolitionMethod:
            'Precision 3mm pure electrolysed copper ribbon embedded flush inside the bathroom door threshold under marble transition.',
        materialUsed: '99.9% Pure Copper Vastu Energy Strip (10ft length)',
        estimatedCost: 3500.0,
        isApplied: true,
      ),
      VastuRemedyItem(
        title: 'South-West Wall Heavy Pyramidal Brass Energy Stabilizer',
        targetedDosha: 'Grounding master bedroom authority and mitigating corner structural cut',
        nonDemolitionMethod:
            'Set of 9 Lead and Brass energetic micro-pyramids mounted invisibly behind master bed panel skirting.',
        materialUsed: 'Solid Casted Brass 9-Chamber Pyramid Matrix',
        estimatedCost: 6800.0,
        isApplied: false,
      ),
      VastuRemedyItem(
        title: 'South-East Kitchen Elemental Color Balancing Strip',
        targetedDosha: 'Mitigate sink and gas hob proximity conflict (Water vs Fire)',
        nonDemolitionMethod:
            'Install a 12mm green granite / glass separator barrier between the stainless steel sink and induction hob.',
        materialUsed: 'Toughened Lacquered Green Glass Barricade',
        estimatedCost: 2200.0,
        isApplied: false,
      ),
    ],
  );

  // ============================================================================
  // 4. MOCK BRANDS CATALOGUE & VERIFIED DISTRIBUTORS
  // ============================================================================
  static final List<BrandRecommendation> recommendedBrands = [
    // Plywood Brands
    BrandRecommendation(
      category: 'Plywood & Core Substrates',
      brandName: 'CenturyPly (Club Prime / Architect)',
      tagline: 'India\'s #1 BWP Marine plywood with Firewall & ViroKill technology',
      qualityGrade: 'IS:710 Marine Grade Gurjan Core',
      warrantyYears: '30-Year No-Questions Warranty',
      marketShare: '38% National Tier-1 Share',
      logoText: 'CP',
      brandColor: const Color(0xFFDC2626),
    ),
    BrandRecommendation(
      category: 'Plywood & Core Substrates',
      brandName: 'Greenply (Green Platinum)',
      tagline: 'Zero-emission E-0 compliant calibrated waterproof plywood',
      qualityGrade: 'IS:710 E-0 Formaldehyde Free',
      warrantyYears: 'Lifetime 2X Replacement Warranty',
      marketShare: '32% National Market Share',
      logoText: 'GP',
      brandColor: const Color(0xFF16A34A),
    ),
    BrandRecommendation(
      category: 'Plywood & Core Substrates',
      brandName: 'Austin Plywood (Defender)',
      tagline: '100% Calibrated borer & termite proof marine ply',
      qualityGrade: 'IS:710 4-Times Pressed Ply',
      warrantyYears: '25-Year Guarantee',
      marketShare: '18% National Premium Share',
      logoText: 'AP',
      brandColor: const Color(0xFF2563EB),
    ),

    // Laminates Brands
    BrandRecommendation(
      category: 'Decorative Laminates & Surfaces',
      brandName: 'Greenlam Laminates',
      tagline: 'Anti-bacterial HD matte & textured architectural laminates',
      qualityGrade: '1.0mm Anti-Fingerprint Silky Touch',
      warrantyYears: '10-Year Surface Warranty',
      marketShare: '42% Designer Preferred',
      logoText: 'GL',
      brandColor: const Color(0xFF059669),
    ),
    BrandRecommendation(
      category: 'Decorative Laminates & Surfaces',
      brandName: 'Merino Laminates (Specialty Tuff)',
      tagline: 'High impact scuff-resistant laminates in 500+ finishes',
      qualityGrade: '1.0mm Super Matte & Synchronized',
      warrantyYears: '10-Year Fade Proof Guarantee',
      marketShare: '35% Contractor Volume',
      logoText: 'ML',
      brandColor: const Color(0xFFD97706),
    ),
    BrandRecommendation(
      category: 'Decorative Laminates & Surfaces',
      brandName: 'Royale Touche',
      tagline: 'Luxury 1.25mm deep embossed architectural surfaces',
      qualityGrade: '1.25mm Ultra-High Density',
      warrantyYears: '12-Year Warranty',
      marketShare: '23% Luxury Niche',
      logoText: 'RT',
      brandColor: const Color(0xFF7C3AED),
    ),

    // Hardware Brands
    BrandRecommendation(
      category: 'Hardware & Movement Systems',
      brandName: 'Hafele (Matrix & Free Flap)',
      tagline: 'German engineered silent drawer slides and folding mechanisms',
      qualityGrade: 'Tested to 100,000 Action Cycles',
      warrantyYears: '10-Year Mechanical Warranty',
      marketShare: '45% Modular Market Share',
      logoText: 'HF',
      brandColor: const Color(0xFFBE123C),
    ),
    BrandRecommendation(
      category: 'Hardware & Movement Systems',
      brandName: 'Blum (Aventos & Tandembox)',
      tagline: 'Austrian precision motion fittings for luxury kitchens & wardrobes',
      qualityGrade: 'Lifetime Dynamic Rating (70kg)',
      warrantyYears: 'Lifetime Product Guarantee',
      marketShare: '35% Ultra-Luxury Share',
      logoText: 'BL',
      brandColor: const Color(0xFFEA580C),
    ),
    BrandRecommendation(
      category: 'Hardware & Movement Systems',
      brandName: 'Hettich (Quadro & Sensys)',
      tagline: 'German intelligent furniture fittings with soft-close damping',
      qualityGrade: 'Corrosion Tested to 200h Salt Spray',
      warrantyYears: '10-Year Replacement Warranty',
      marketShare: '20% Architectural Specification',
      logoText: 'HT',
      brandColor: const Color(0xFF0284C7),
    ),
  ];

  static final List<VendorContactCard> verifiedVendors = [
    VendorContactCard(
      vendorName: 'Praveen Goel',
      companyName: 'Timberland Plywood & Hardware Superstore',
      cityRegion: 'Delhi NCR (Sector 29, Gurgaon)',
      phone: '+91 98112 34567',
      wholesaleDiscount: 'Flat 22% Off MRP for Homio Projects',
      rating: 4.9,
      isVerified: true,
      authorizedBrands: ['CenturyPly', 'Hafele', 'Greenlam', 'Blum'],
    ),
    VendorContactCard(
      vendorName: 'Rajeev Singhal',
      companyName: 'Apex Plywood Distributors & Veneer House',
      cityRegion: 'Mumbai Western Suburbs (Andheri West)',
      phone: '+91 98201 88990',
      wholesaleDiscount: 'Flat 24% Off Wholesale Mill Rates',
      rating: 4.8,
      isVerified: true,
      authorizedBrands: ['Greenply', 'Merino', 'Hettich', 'Austin Plywood'],
    ),
    VendorContactCard(
      vendorName: 'Girish Patel',
      companyName: 'South India Hardware & Surface Hub',
      cityRegion: 'Bengaluru (Indiranagar 100ft Rd)',
      phone: '+91 99004 12389',
      wholesaleDiscount: 'Flat 20% Direct Contractor Margin',
      rating: 4.9,
      isVerified: true,
      authorizedBrands: ['Hafele', 'Blum', 'Royale Touche', 'CenturyPly'],
    ),
  ];

  // ============================================================================
  // 5. MOCK AI DOUBT SOLVER Q&A THREAD
  // ============================================================================
  static final List<DoubtQueryMessage> initialDoubtChat = [
    DoubtQueryMessage(
      id: 'MSG-001',
      isFromUser: false,
      content:
          'Welcome to the **Homio AI Construction & Architectural Expert Solver**!\n\nI am trained on official IS/CPWD codes, actual wholesale rate cards, and field snag diagnostics. Your first **3 technical questions are 100% FREE**.\n\nAsk any question regarding material testing, prevailing labour rates, waterproofing snags, or false ceiling framing.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    DoubtQueryMessage(
      id: 'MSG-002',
      isFromUser: true,
      content:
          'How do I test on site whether my plywood delivery is genuine 100% BWP Marine (IS 710) or fake Commercial MR with face veneer?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      category: DoubtCategory.materialQuality,
    ),
    DoubtQueryMessage(
      id: 'MSG-003',
      isFromUser: false,
      content:
          '### 🔍 4 Rapid On-Site Tests for Genuine IS:710 BWP Marine Plywood\n\n'
          '1. **72-Hour Boiling Water Test (Lab Benchmark):** Cut a 2" x 2" sample piece. Boil it in water for 72 continuous hours. Genuine BWP Marine plywood bonded with Phenol Formaldehyde resin will **not delaminate, swell, or separate**. Fake MR ply will disintegrate within 30 minutes.\n\n'
          '2. **Core Veneer Layer Inspection:** Count the alternating plies from the edge. Genuine marine ply has at least 7 to 9 tightly calibrated solid hardwood veneers without internal core gaps or overlapping patches.\n\n'
          '3. **Weight & Calibration Gauge:** Take a digital vernier caliper. Standard 19mm calibrated ply should measure strictly 18.8mm to 19.2mm. A 8x4 sheet of Gurjan marine ply weighs approximately 42kg to 48kg. Anything below 35kg is lightweight commercial timber.\n\n'
          '4. **Chemical Smell Test:** Phenol resin emits a dark reddish/brown glue line between layers. If the glue line is light yellow (Urea Formaldehyde), it is not marine grade.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 19)),
      actionChecklist: [
        'Perform 72-hr boiling test on delivery sample',
        'Verify IS:710 ISI stamp with 7-digit CML license number',
        'Check sheet weight (must be > 40kg for 19mm 8x4)',
        'Inspect cross-section for hollow voids or overlapping plies',
      ],
      mistakeSavedAmountNote:
          'Saved ~Rs. 1,40,000 by preventing premature kitchen cabinet termite decay within 2 years.',
    ),
    DoubtQueryMessage(
      id: 'MSG-004',
      isFromUser: true,
      content:
          'What is the current prevailing carpentry fabrication labour rate per sqft for acrylic modular kitchen in Gurgaon / Delhi NCR?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
      category: DoubtCategory.rateCards,
    ),
    DoubtQueryMessage(
      id: 'MSG-005',
      isFromUser: false,
      content:
          '### 📊 Prevailing Gurgaon / Delhi NCR Carpentry Labour Rates (Q3 2026)\n\n'
          '| Component | Rate Range (Per Sq.Ft / Unit) | Notes |\n'
          '| :--- | :--- | :--- |\n'
          '| **Base Cabinets (BWP + 1mm Laminate)** | Rs. 420 – Rs. 480 / Sq.Ft | Inclusive of carcass cutting & PVC edge banding |\n'
          '| **Acrylic Shutter Fabrication (2mm)** | Rs. 550 – Rs. 650 / Sq.Ft | Requires precision hot-melt edge bander machine |\n'
          '| **Wall Overhead Cabinets** | Rs. 380 – Rs. 440 / Sq.Ft | Includes wall hanging anchors & alignment |\n'
          '| **Tall Pantry Appliance Unit** | Rs. 480 – Rs. 540 / Sq.Ft | Includes cut-outs for oven & microwave |\n'
          '| **Drawer / Tandem Box Installation** | Rs. 350 – Rs. 450 per drawer | Fitting Blum / Hafele runners & damper tuning |\n\n'
          '> ⚠️ **Contractor Tip:** Ensure labour rate contract clearly stipulates whether **edge banding machine charges (Rs. 12/running ft)** are included or extra.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 13)),
      actionChecklist: [
        'Confirm edge banding machine charges in contract',
        'Verify whether handle profile groove routing is included',
        'Fix 10% retention amount payable after snag handover',
      ],
      mistakeSavedAmountNote:
          'Saved ~Rs. 45,000 on contractor overcharging and hidden edge banding extras.',
    ),
  ];

  // ============================================================================
  // 6. MOCK DESIGNER VIDEO CONSULTANTS ROSTER (RS. 300 / SESSION)
  // ============================================================================
  static final List<DesignerConsultant> designerRoster = [
    DesignerConsultant(
      id: 'DES-01',
      name: 'Ar. Pooja Hegde',
      title: 'Senior Interior Architect & Luxury Lead',
      qualification: 'B.Arch (SPA Delhi), M.Des (Domus Academy Milan)',
      rating: 4.96,
      totalConsultations: 248,
      yearsExperience: 9,
      availability: DesignerAvailability.online,
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
      specializations: ['Luxury Contemporary', 'Modular Kitchens', 'Space Optimization', 'Vastu'],
      sessionFee: 300.0,
    ),
    DesignerConsultant(
      id: 'DES-02',
      name: 'Ar. Karan Mehra',
      title: 'Principal Architect & Turnkey Specialist',
      qualification: 'B.Arch (CEPT University), Council of Architecture Certified',
      rating: 4.92,
      totalConsultations: 195,
      yearsExperience: 12,
      availability: DesignerAvailability.online,
      avatarUrl:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=400&q=80',
      specializations: ['Turnkey Contracting', 'Civil Renovations', 'BOQ Cost Engineering'],
      sessionFee: 300.0,
    ),
    DesignerConsultant(
      id: 'DES-03',
      name: 'Aarav Singhania',
      title: '3D Spatial Visualizer & Lighting Designer',
      qualification: 'B.Des (NID Ahmedabad), Unreal Engine Architectural Certified',
      rating: 4.88,
      totalConsultations: 142,
      yearsExperience: 7,
      availability: DesignerAvailability.inCall,
      avatarUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=400&q=80',
      specializations: ['Photorealistic 3D Renders', 'Acoustics & Lighting', 'Scandinavian'],
      sessionFee: 300.0,
    ),
    DesignerConsultant(
      id: 'DES-04',
      name: 'Dr. Radhika Sen',
      title: 'Vastu Shastra Consultant & Bio-Geometry Expert',
      qualification: 'Ph.D. in Vedic Vastu, M.A. Astrological Sciences',
      rating: 4.98,
      totalConsultations: 310,
      yearsExperience: 16,
      availability: DesignerAvailability.offline,
      avatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=400&q=80',
      specializations: ['Non-Demolition Vastu Remedies', 'Commercial Real Estate', 'Energy Chakra'],
      sessionFee: 300.0,
    ),
  ];

  static final List<BookedConsultationSession> bookedSessions = [
    BookedConsultationSession(
      id: 'SESS-201',
      clientName: 'Vikram Malhotra (DLF Crest #402)',
      clientPhone: '+91 98112 99011',
      expert: designerRoster[0],
      scheduledTime: DateTime.now().add(const Duration(minutes: 15)),
      feePaid: 300.0,
      status: 'Active / In Progress',
    ),
    BookedConsultationSession(
      id: 'SESS-202',
      clientName: 'Sunita Mehra (Golf Course Extn)',
      clientPhone: '+91 98201 44552',
      expert: designerRoster[1],
      scheduledTime: DateTime.now().add(const Duration(hours: 2)),
      feePaid: 300.0,
      status: 'Scheduled',
    ),
    BookedConsultationSession(
      id: 'SESS-203',
      clientName: 'Deepak Chopra (Villa #12)',
      clientPhone: '+91 99004 88776',
      expert: designerRoster[2],
      scheduledTime: DateTime.now().subtract(const Duration(days: 1)),
      feePaid: 300.0,
      status: 'Completed',
    ),
  ];
}
