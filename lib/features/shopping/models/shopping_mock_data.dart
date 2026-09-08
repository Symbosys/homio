import 'shopping_models.dart';

/// Centralized in-memory mock repository for Shopping & Marketplace
class ShoppingMockData {
  // ---------------------------------------------------------------------------
  // 1. DIGITAL PRODUCTS & HANDBOOKS
  // ---------------------------------------------------------------------------
  static final List<DigitalProduct> digitalProducts = [
    DigitalProduct(
      id: 'DP-001',
      title: 'Vastu Shastra Comprehensive Guide Book',
      subtitle: 'Complete directional layout blueprints, energy zones, and remedies for modern apartments & villas.',
      category: GuideCategory.vastu,
      price: 499.0,
      originalPrice: 1499.0,
      rating: 4.9,
      reviewsCount: 342,
      pageCount: 168,
      fileSize: '24.8 MB (High-Res PDF)',
      coverImageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400',
      description: 'The definitive architectural guide to Vastu Shastra authored for contemporary interior designers and homeowners. Covers directional entrance alignments, master bedroom Brahmasthan rules, kitchen fire-zone positioning, water element flow, and non-demolition remedial solutions.',
      chapters: [
        'Chapter 1: Foundations of Vedic Spatial Geometry & Energy Grids',
        'Chapter 2: Main Entrance & Foyer Vastu for Positive Prana Flow',
        'Chapter 3: Master Bedroom, Children Room & Guest Room Placement',
        'Chapter 4: Agni Corner (South-East) Modular Kitchen Planning',
        'Chapter 5: Water Tanks, Septic Lines & Bathroom Vastu Alignment',
        'Chapter 6: Non-Destructive Remedial Pyramids, Mirrors & Metals',
      ],
      sampleSnippets: [
        'The South-East direction represents the Agneya (Fire) corner. Positioning the cooking hob in this quadrant facing East ensures prosperity and metabolic vitality.',
        'Avoid positioning heavy wardrobes in the North-East Ishanya zone. Keep this quadrant lightweight, clutter-free, and well-lit with natural sunlight.',
      ],
      authorName: 'Acharya Vidyadhar Joshi',
      authorTitle: 'Senior Architectural Vastu Consultant & Vedic Scholar',
      downloadsCount: 1890,
      downloadUrl: 'https://cdn.homiocrm.com/guides/homio-vastu-master-guide.pdf',
      tags: ['Vastu', 'Energy Flow', 'Architectural Layout', 'Remedies', 'E-Book'],
      isPurchased: false,
    ),
    DigitalProduct(
      id: 'DP-002',
      title: 'Interior Design Tips & Tricks Handbook',
      subtitle: 'Professional color harmonies, luxury lighting layering, optical space expansion, and styling formulas.',
      category: GuideCategory.interiorStyling,
      price: 299.0,
      originalPrice: 999.0,
      rating: 4.8,
      reviewsCount: 512,
      pageCount: 142,
      fileSize: '32.1 MB (Visual Guide PDF)',
      coverImageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=400',
      description: 'Master the secrets of luxury interior styling used by India’s top architectural firms. Learn the 60-30-10 color rule, 3-layer lighting (ambient, task, accent), rug sizing formulas, gallery wall spacing, and how to make compact 2BHK spaces look like expansive penthouses.',
      chapters: [
        'Chapter 1: The 60-30-10 Color Harmonization Principle',
        'Chapter 2: Lighting Layers: Kelvin Temperatures, CRI > 95 & Cove Glow',
        'Chapter 3: Furniture Proportions & Optical Room Expansion',
        'Chapter 4: Soft Furnishing Textures: Linen, Velvet, Bouclé & Jute',
        'Chapter 5: Styling Vignettes: Coffee Tables, Credenzas & Consoles',
      ],
      sampleSnippets: [
        'Always anchor your living room seating with a rug where at least the front two legs of every sofa and accent chair rest on the weave.',
        'Use 3000K warm-white ambient illumination with 2700K accent spotlights for art pieces to create a five-star hotel boutique ambiance.',
      ],
      authorName: 'Ar. Sanjana Kapoor',
      authorTitle: 'Principal Interior Stylist & Lead Creative Director',
      downloadsCount: 3120,
      downloadUrl: 'https://cdn.homiocrm.com/guides/homio-interior-styling-handbook.pdf',
      tags: ['Interior Styling', 'Color Harmony', 'Lighting Design', 'Luxury Living'],
      isPurchased: true,
    ),
    DigitalProduct(
      id: 'DP-003',
      title: 'Premium Material Selection & Brand Comparison Guide',
      subtitle: 'Detailed technical benchmark of Plywood (IS:710 vs IS:303), HDHMR, Acrylic vs PU vs Laminates, and Hardware.',
      category: GuideCategory.materials,
      price: 599.0,
      originalPrice: 1999.0,
      rating: 4.95,
      reviewsCount: 420,
      pageCount: 210,
      fileSize: '45.6 MB (Specs PDF)',
      coverImageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=400',
      description: 'Never get misled by substandard contractor materials. This exhaustive technical manual breaks down boiling waterproof (BWP) plywood brands, calibers of calibrated marine ply, HDHMR density thresholds, acrylic scratch resistance, and hardware warranty comparisons between Hettich, Hafele, and Blum.',
      chapters: [
        'Chapter 1: Plywood Grades Decoded: BWP Marine vs Moisture Resistant',
        'Chapter 2: Substrate Wars: Calibrated Ply vs HDHMR vs MDF vs WPC',
        'Chapter 3: Shutter Finishes: 1.5mm Acrylic vs 0.8mm Laminate vs PU Polish',
        'Chapter 4: Countertops: Quartz vs Nanotech Granite vs Composite Marble',
        'Chapter 5: Architectural Hardware: Concealed Hinges & Soft-Close Drawers',
      ],
      sampleSnippets: [
        'Always demand IS:710 Marine Grade Calibrated Plywood for wet zones (kitchen under-sink & bathroom vanities) to prevent delamination and termite infests.',
        'PU (Polyurethane) coating offers seamless edge profiling without black joinery lines seen in standard laminates.',
      ],
      authorName: 'Er. Rajeshwar Menon',
      authorTitle: 'Chief Materials Engineer & Turnkey Procurement Specialist',
      downloadsCount: 2450,
      downloadUrl: 'https://cdn.homiocrm.com/guides/homio-materials-comparison-bible.pdf',
      tags: ['Material Guide', 'Plywood', 'Hardware', 'Paints', 'Procurement'],
      isPurchased: false,
    ),
    DigitalProduct(
      id: 'DP-004',
      title: 'Modular Kitchen & Wardrobe Ergonomics Manual',
      subtitle: 'Standard dimensions, kitchen work triangle golden ratio, Blum tandem box layouts, and walk-in wardrobe modules.',
      category: GuideCategory.kitchenErgonomics,
      price: 399.0,
      originalPrice: 1199.0,
      rating: 4.7,
      reviewsCount: 280,
      pageCount: 124,
      fileSize: '19.4 MB (CAD Details PDF)',
      coverImageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=400',
      description: 'Step-by-step ergonomic drafting blueprints for luxury Indian kitchens and wardrobes. Covers countertop heights optimized for 5’2” to 5’10” Indian posture, spice rack pull-out positioning, corner carousel solutions, tall larder units, and concealed LED channel joinery.',
      chapters: [
        'Chapter 1: The Kitchen Work Triangle: Hob, Sink & Refrigerator Spacing',
        'Chapter 2: Countertop Ergonomics: 850mm vs 880mm Height Benchmarks',
        'Chapter 3: Deep Drawers vs Shutters: Tandembox & Glassbox Engineering',
        'Chapter 4: Wardrobe Internal Anatomy: Long Hang, Short Hang & Jewelry Trays',
      ],
      sampleSnippets: [
        'The ideal total distance between the Cooktop, Refrigerator, and Sink should be between 12 to 26 feet with no obstruction intersecting the triangle lines.',
      ],
      authorName: 'Ar. Devika Nair',
      authorTitle: 'Modular Kitchen Architect & Ergonomic Design Fellow',
      downloadsCount: 1650,
      downloadUrl: 'https://cdn.homiocrm.com/guides/homio-kitchen-ergonomics-cad.pdf',
      tags: ['Modular Kitchen', 'Wardrobe Design', 'Ergonomics', 'CAD Blueprints'],
      isPurchased: false,
    ),
    DigitalProduct(
      id: 'DP-005',
      title: 'Turnkey Contractor Cost Optimization Playbook',
      subtitle: 'Rate analysis formulas, BOQ leak prevention, labour productivity metrics, and vendor negotiation masterclass.',
      category: GuideCategory.contractorPlaybook,
      price: 799.0,
      originalPrice: 2499.0,
      rating: 4.9,
      reviewsCount: 195,
      pageCount: 180,
      fileSize: '28.5 MB (Excel Formulas & PDF)',
      coverImageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400',
      description: 'The ultimate commercial execution playbook for interior contractors and project managers. Eliminate wastage in carpentry woodwork, optimize plaster of paris (POP) false ceiling channeling, negotiate 35%+ dealer margins with wholesale plywood distributors, and protect cash flows.',
      chapters: [
        'Chapter 1: Granular BOQ Cost Breakdown: Material vs Labour vs Overheads',
        'Chapter 2: Plywood Sheet Optimization: 8x4 Cutting Nesting Algorithms',
        'Chapter 3: Preventing False Ceiling Cracks & GI Channel Gauge Standards',
        'Chapter 4: Milestone Billing & Retainage Cash Flow Safeguards',
      ],
      sampleSnippets: [
        'Utilize nesting software for 8x4 sheet cutting to reduce plywood offcut wastage from the industry average of 18% down to sub-6%.',
      ],
      authorName: 'Vikramaditya Singhal',
      authorTitle: 'Turnkey Commercial Director & Real Estate Estimator',
      downloadsCount: 1420,
      downloadUrl: 'https://cdn.homiocrm.com/guides/homio-contractor-cost-playbook.pdf',
      tags: ['BOQ Estimator', 'Contractor Guide', 'Cost Optimization', 'Commercials'],
      isPurchased: false,
    ),
  ];

  // ---------------------------------------------------------------------------
  // 2. CURATED HOME DECOR SHOWCASE (AFFILIATES)
  // ---------------------------------------------------------------------------
  static final List<DecorItem> decorItems = [
    DecorItem(
      id: 'DEC-101',
      title: 'Nordic Curved Bouclé Accent Lounge Chair',
      category: DecorCategory.furniture,
      brand: 'West Elm Luxury',
      price: 38999.0,
      originalPrice: 52000.0,
      rating: 4.9,
      reviewsCount: 84,
      imageUrl: 'https://images.unsplash.com/photo-1580481077197-0f8286a63581?w=400',
      affiliatePartner: 'West Elm Direct',
      affiliateUrl: 'https://www.westelm.in/nordic-boucle-chair?ref=homio_affiliate',
      commissionPercent: 8.5,
      inStock: true,
      specifications: {
        'Upholstery': 'High-Density Premium White Bouclé Yarn',
        'Frame': 'Kiln-Dried Solid Teakwood Inner Skeleton',
        'Dimensions': '34"W x 32"D x 30"H',
        'Weight Capacity': '180 kg',
      },
      leadTimeDays: 5,
    ),
    DecorItem(
      id: 'DEC-102',
      title: 'Mid-Century Grand Sputnik Chandelier (12-Light Brass)',
      category: DecorCategory.lighting,
      brand: 'Artemide Signature',
      price: 24500.0,
      originalPrice: 35000.0,
      rating: 4.8,
      reviewsCount: 126,
      imageUrl: 'https://images.unsplash.com/photo-1540932239986-30128078f3c5?w=400',
      affiliatePartner: 'Pepperfry Exclusive',
      affiliateUrl: 'https://www.pepperfry.com/sputnik-brass-chandelier?ref=homio_affiliate',
      commissionPercent: 10.0,
      inStock: true,
      specifications: {
        'Finish': 'Brushed Satin Gold Electroplated Brass',
        'Bulb Base': '12 x E27 Warm 2700K Dimmable Filament LED',
        'Diameter': '38 inches (Adjustable Rod)',
        'Voltage': '220V - 240V Indian Standard',
      },
      leadTimeDays: 3,
    ),
    DecorItem(
      id: 'DEC-103',
      title: 'Handcrafted Hammered Brass Mandala Wall Art',
      category: DecorCategory.wallArt,
      brand: 'FabIndia Heritage Living',
      price: 18900.0,
      originalPrice: 26000.0,
      rating: 4.9,
      reviewsCount: 92,
      imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=400',
      affiliatePartner: 'Amazon Home Luxury',
      affiliateUrl: 'https://amazon.in/dp/B08XYZ1234?tag=homio-affiliate-21',
      commissionPercent: 9.0,
      inStock: true,
      specifications: {
        'Material': '100% Pure Embossed Solid Brass with Antique Lacquer',
        'Diameter': '42 Inches Diameter Circle',
        'Weight': '8.2 kg',
        'Mounting': 'Concealed Heavy-Duty French Cleat Bracket',
      },
      leadTimeDays: 4,
    ),
    DecorItem(
      id: 'DEC-104',
      title: 'Hand-Knotted Oushak Wool & Silk Persian Rug (8x10 Ft)',
      category: DecorCategory.softFurnishings,
      brand: 'Jaipur Rugs Heritage',
      price: 74999.0,
      originalPrice: 110000.0,
      rating: 4.95,
      reviewsCount: 65,
      imageUrl: 'https://images.unsplash.com/photo-1600121848594-d8644e57abab?w=400',
      affiliatePartner: 'Jaipur Rugs Official',
      affiliateUrl: 'https://www.jaipurrugs.com/oushak-rug-8x10?ref=homio_affiliate',
      commissionPercent: 12.0,
      inStock: true,
      specifications: {
        'Weave': 'Hand-Knotted 180 Knots Per Square Inch (KPSI)',
        'Yarn': '60% New Zealand Carded Wool + 40% Mulberry Silk',
        'Size': '8 Feet x 10 Feet (Living Room Center)',
        'Pile Height': '8mm Luxury Soft Touch',
      },
      leadTimeDays: 7,
    ),
    DecorItem(
      id: 'DEC-105',
      title: 'Italian Statuario Marble Fluted Round Center Table',
      category: DecorCategory.furniture,
      brand: 'Urban Ladder Masterpiece',
      price: 46999.0,
      originalPrice: 65000.0,
      rating: 4.75,
      reviewsCount: 48,
      imageUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=400',
      affiliatePartner: 'Urban Ladder',
      affiliateUrl: 'https://www.urbanladder.com/statuario-marble-table?ref=homio_affiliate',
      commissionPercent: 7.5,
      inStock: true,
      specifications: {
        'Top': '20mm Polished Italian Statuario Natural Marble with Chamfered Edge',
        'Base': 'Solid Steam-Bent Oak Fluted Pillar Column',
        'Dimensions': '36" Diameter x 18" Height',
        'Sealer': 'Anti-Stain Penetrating Nanotech Resin Coated',
      },
      leadTimeDays: 6,
    ),
  ];

  // ---------------------------------------------------------------------------
  // 3. WHOLESALE MATERIAL CATALOGUE (DIRECT RFQ & ORDERS)
  // ---------------------------------------------------------------------------
  static List<MaterialItem> get materials => wholesaleMaterials;
  static final List<MaterialItem> wholesaleMaterials = [
    MaterialItem(
      id: 'MAT-201',
      name: 'Century Club Prime Calibrated Marine Plywood (19mm)',
      brand: 'CenturyPly',
      category: MaterialCategory.plywoodBoards,
      tradeUnit: 'Per 8x4 Sheet (32 Sq.Ft)',
      wholesalePrice: 4250.0,
      retailMrp: 5600.0,
      minOrderQuantity: 15,
      stockAvailable: '450 Sheets in Gurugram Depot',
      specSheetUrl: 'https://cdn.homiocrm.com/specs/centuryply-club-prime-710.pdf',
      supplierName: 'Gupta Timber & Plywood Hub (Authorized Distributor)',
      supplierCity: 'Sector 37, Gurugram',
      deliveryDays: 1,
      rating: 4.95,
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=400',
      keyFeatures: [
        'IS:710 Marine Grade with 25-Year Anti-Borer Warranty',
        '4-Times Calibrated Core for Zero Thickness Variation in CNC Milling',
        'ViroKill Nano-Technology 99.99% Antimicrobial Surface',
      ],
    ),
    MaterialItem(
      id: 'MAT-202',
      name: 'Kajaria 4x2 Ft Glazed Vitrified Tiles (GVT Statuario White)',
      brand: 'Kajaria Ceramics',
      category: MaterialCategory.tilesMarble,
      tradeUnit: 'Per Box (2 Pcs = 16 Sq.Ft)',
      wholesalePrice: 980.0,
      retailMrp: 1450.0,
      minOrderQuantity: 40,
      stockAvailable: '1,200 Boxes in Bhiwadi Central Warehouse',
      specSheetUrl: 'https://cdn.homiocrm.com/specs/kajaria-gvt-statuario.pdf',
      supplierName: 'Kajaria Galaxy Flagship Depot',
      supplierCity: 'Manesar, Haryana',
      deliveryDays: 2,
      rating: 4.85,
      imageUrl: 'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=400',
      keyFeatures: [
        'High-Gloss Mirror Polish with <0.05% Water Absorption',
        'Rectified Precision Cut Edges for Seamless 1mm Grout Spacers',
        'Stain-Resistant Nano-Shield Surface Glaze',
      ],
    ),
    MaterialItem(
      id: 'MAT-203',
      name: 'Hettich Sensys 110° Soft-Close Concealed Hinge with Base Plate',
      brand: 'Hettich Germany',
      category: MaterialCategory.hardwareFittings,
      tradeUnit: 'Per Pair (2 Hinges + Screws)',
      wholesalePrice: 420.0,
      retailMrp: 650.0,
      minOrderQuantity: 50,
      stockAvailable: '800 Pairs in Stock',
      specSheetUrl: 'https://cdn.homiocrm.com/specs/hettich-sensys-hinge.pdf',
      supplierName: 'Continental Architectural Hardware Importers',
      supplierCity: 'Okhla Phase 2, New Delhi',
      deliveryDays: 1,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400',
      keyFeatures: [
        'Integrated Silent System with Wide 35° Soft-Closing Angle',
        'Tested for 200,000 Opening Cycles (German LGA Certified)',
        'Clip-On Fast Assembly without Screwing into Shutter Body',
      ],
    ),
    MaterialItem(
      id: 'MAT-204',
      name: 'Asian Paints Royale Aspira Luxury Emulsion (20L Drum)',
      brand: 'Asian Paints',
      category: MaterialCategory.paintsFinishes,
      tradeUnit: 'Per 20-Litre Drum',
      wholesalePrice: 11400.0,
      retailMrp: 14800.0,
      minOrderQuantity: 3,
      stockAvailable: '90 Drums in Delhi NCR Hub',
      specSheetUrl: 'https://cdn.homiocrm.com/specs/royale-aspira-tds.pdf',
      supplierName: 'Delhi Paint Traders & Wholesale Syndicate',
      supplierCity: 'Kirti Nagar, New Delhi',
      deliveryDays: 1,
      rating: 4.95,
      imageUrl: 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=400',
      keyFeatures: [
        'Crack-Bridging Elastomeric Membrane Technology (upto 2mm)',
        'Hydrophobic Teflon Surface Shield for Scrub Resistance',
        'Ultra-Smooth Sheen with Anti-Bacterial Silver Ion Shield',
      ],
    ),
    MaterialItem(
      id: 'MAT-205',
      name: 'Hafele Matrix Box S35 Slim Drawer System (Anthracite 500mm)',
      brand: 'Hafele Germany',
      category: MaterialCategory.hardwareFittings,
      tradeUnit: 'Per Set (Side Panels + Soft-Close Runners)',
      wholesalePrice: 2850.0,
      retailMrp: 3900.0,
      minOrderQuantity: 10,
      stockAvailable: '160 Sets in Stock',
      specSheetUrl: 'https://cdn.homiocrm.com/specs/hafele-matrix-box-s35.pdf',
      supplierName: 'Hafele Direct Channel Partner',
      supplierCity: 'Golf Course Road, Gurugram',
      deliveryDays: 1,
      rating: 4.88,
      imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=400',
      keyFeatures: [
        '13mm Ultra-Slim Double Wall Profile in Premium Matt Anthracite',
        'Synchronized Full-Extension Runners with 35kg Dynamic Load Capacity',
        'Toolless 3D Front Panel Alignment Mechanism',
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // 4. VERIFIED RENTAL & REAL ESTATE PROPERTIES (Rs. 500 PAYWALL)
  // ---------------------------------------------------------------------------
  static final List<PropertyListing> properties = [
    PropertyListing(
      id: 'PROP-901',
      title: '4BHK Ultra-Luxury Designer Apartment in DLF The Magnolias',
      propertyType: PropertyType.luxuryApartment,
      intent: ListingIntent.rent,
      monthlyRent: 380000.0,
      securityDeposit: 1140000.0,
      salePrice: 0.0,
      bedrooms: 4,
      bathrooms: 5,
      superAreaSqft: 6400,
      carpetAreaSqft: 5200,
      floorInfo: '18th Floor of 24 (Panoramic Golf Course Facing)',
      furnishing: 'Fully Furnished (Italian Designer Modulars + Miele Appliances)',
      societyName: 'DLF The Magnolias',
      address: 'Golf Course Road, Sector 42',
      city: 'Gurugram',
      zone: 'DLF Phase 5',
      images: [
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600',
        'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=600',
      ],
      walkthroughVideoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      amenities: [
        'Olympic Size Temperature-Controlled Swimming Pool',
        'Private Elevator Lobby',
        'Clubhouse with Concierge & Cigar Lounge',
        '3 Covered Reserved Basement Car Parks',
        '100% 24x7 Power Backup & VRV Air Conditioning',
      ],
      isVerified: true,
      ownerName: 'Col. Raghavendra Rathore (Retd.)',
      ownerMaskedPhone: '+91 9811X XXXXX',
      ownerRealPhone: '+91 98112 49182',
      ownerEmail: 'raghav.rathore.dlf@gmail.com',
      isUnlocked: false,
      dateListed: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PropertyListing(
      id: 'PROP-902',
      title: '3BHK Sea-Facing Penthouse with Private Deck in Bandra West',
      propertyType: PropertyType.penthouse,
      intent: ListingIntent.rent,
      monthlyRent: 240000.0,
      securityDeposit: 720000.0,
      salePrice: 0.0,
      bedrooms: 3,
      bathrooms: 4,
      superAreaSqft: 2850,
      carpetAreaSqft: 2300,
      floorInfo: '14th & 15th Duplex Penthouse (Arabian Sea Facing)',
      furnishing: 'Fully Furnished (Custom Scandinavian Teakwood & Smart Home)',
      societyName: 'Beau Monde Ocean Towers',
      address: 'Pali Hill / Carter Road Promenade',
      city: 'Mumbai',
      zone: 'Bandra West',
      images: [
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=600',
        'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=600',
      ],
      walkthroughVideoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      amenities: [
        'Private Rooftop Jacuzzi & Barbecue Deck',
        'Direct Unobstructed Sunset Sea View',
        'Biometric Smart Door Access & Automation',
        '2 Covered Mechanical Parking Slots',
      ],
      isVerified: true,
      ownerName: 'Dr. Avantika Merchant',
      ownerMaskedPhone: '+91 9820X XXXXX',
      ownerRealPhone: '+91 98201 88472',
      ownerEmail: 'avantika.merchant.md@outlook.com',
      isUnlocked: true,
      dateListed: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PropertyListing(
      id: 'PROP-903',
      title: '5BHK Triplex Gated Luxury Villa in Epsilon Villas',
      propertyType: PropertyType.villa,
      intent: ListingIntent.sale,
      monthlyRent: 0.0,
      securityDeposit: 0.0,
      salePrice: 185000000.0, // 18.5 Cr
      bedrooms: 5,
      bathrooms: 6,
      superAreaSqft: 7200,
      carpetAreaSqft: 6100,
      floorInfo: 'Independent Triplex G+2 with Private Heated Pool',
      furnishing: 'Bare-Shell Ready for Custom Interior Fitout',
      societyName: 'Epsilon Residential Villa Community',
      address: 'Old Airport Road, Yemalur',
      city: 'Bengaluru',
      zone: 'Indiranagar / Marathahalli Corridor',
      images: [
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=600',
        'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=600',
      ],
      walkthroughVideoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      amenities: [
        'Private 40ft Swimming Pool & Manicured Lawn',
        '2-Car Covered Garage + EV Fast Charger',
        'Helipad Access in Community',
        '24/7 CISF-Trained Armed Security Patrol',
      ],
      isVerified: true,
      ownerName: 'Shri Narayana Murthy Hegde',
      ownerMaskedPhone: '+91 9900X XXXXX',
      ownerRealPhone: '+91 99004 77291',
      ownerEmail: 'nmhegde.ventures@yahoo.com',
      isUnlocked: false,
      dateListed: DateTime.now().subtract(const Duration(days: 8)),
    ),
    PropertyListing(
      id: 'PROP-904',
      title: '3BHK Modern Corner Builder Floor in DLF Phase 1',
      propertyType: PropertyType.builderFloor,
      intent: ListingIntent.rent,
      monthlyRent: 95000.0,
      securityDeposit: 190000.0,
      salePrice: 0.0,
      bedrooms: 3,
      bathrooms: 3,
      superAreaSqft: 2250,
      carpetAreaSqft: 1850,
      floorInfo: '1st Floor with Stilt Parking & Private Lift',
      furnishing: 'Semi-Furnished (Modular Kitchen, Wardrobes & Split ACs)',
      societyName: 'DLF City Phase 1 Exclusive Floors',
      address: 'A-Block, Near Sikanderpur Metro',
      city: 'Gurugram',
      zone: 'DLF Phase 1',
      images: [
        'https://images.unsplash.com/photo-1600585152220-90363fe7e115?w=600',
        'https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?w=600',
      ],
      walkthroughVideoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      amenities: [
        'Private Otis Stilt-to-Terrace Elevator',
        '2 Covered Reserved Car Parking Slots',
        'Walking Distance to Cyber City Rapid Metro',
        'Separate Servant Room with Toilet',
      ],
      isVerified: true,
      ownerName: 'Pradeep Goel',
      ownerMaskedPhone: '+91 9810X XXXXX',
      ownerRealPhone: '+91 98102 33190',
      ownerEmail: 'pradeep.goel1972@gmail.com',
      isUnlocked: false,
      dateListed: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ---------------------------------------------------------------------------
  // 5. TRANSACTION HISTORY & UNLOCK RECORDS
  // ---------------------------------------------------------------------------
  static final List<PropertyUnlockRecord> unlockRecords = [
    PropertyUnlockRecord(
      id: 'UNL-801',
      propertyId: 'PROP-902',
      propertyTitle: '3BHK Sea-Facing Penthouse with Private Deck in Bandra West',
      unlockedByName: 'Amitabh Sen',
      unlockedByPhone: '+91 98205 11920',
      paidAmount: 500.0,
      unlockedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      transactionId: 'PAY-UNL-992019482',
      ownerName: 'Dr. Avantika Merchant',
      ownerPhone: '+91 98201 88472',
    ),
    PropertyUnlockRecord(
      id: 'UNL-802',
      propertyId: 'PROP-901',
      propertyTitle: '4BHK Ultra-Luxury High-Rise Residence at The Camellias',
      unlockedByName: 'Rohan Deshmukh',
      unlockedByPhone: '+91 98110 55412',
      paidAmount: 500.0,
      unlockedAt: DateTime.now().subtract(const Duration(days: 2, hours: 7)),
      transactionId: 'PAY-UNL-884102914',
      ownerName: 'Capt. Vikramaditya Singhania',
      ownerPhone: '+91 98101 22849',
    ),
    PropertyUnlockRecord(
      id: 'UNL-803',
      propertyId: 'PROP-904',
      propertyTitle: '3BHK Modern Corner Builder Floor in DLF Phase 1',
      unlockedByName: 'Megha Agarwal',
      unlockedByPhone: '+91 98712 33490',
      paidAmount: 500.0,
      unlockedAt: DateTime.now().subtract(const Duration(hours: 14)),
      transactionId: 'PAY-UNL-771920481',
      ownerName: 'Pradeep Goel',
      ownerPhone: '+91 98102 33190',
    ),
  ];

  static final List<DigitalOrderRecord> digitalOrders = [
    DigitalOrderRecord(
      id: 'ORD-701',
      productId: 'DP-002',
      productTitle: 'Interior Design Tips & Tricks Handbook',
      amountPaid: 299.0,
      purchasedAt: DateTime.now().subtract(const Duration(days: 3)),
      customerName: 'Karan Mehra',
      customerPhone: '+91 98111 22334',
      downloadToken: 'HOMIO-TOKEN-X892-SECURE',
    ),
    DigitalOrderRecord(
      id: 'ORD-702',
      productId: 'DP-001',
      productTitle: 'Vastu Shastra Comprehensive Guide Book',
      amountPaid: 499.0,
      purchasedAt: DateTime.now().subtract(const Duration(days: 1)),
      customerName: 'Ritika Saxena',
      customerPhone: '+91 99200 44556',
      downloadToken: 'HOMIO-TOKEN-V391-SECURE',
    ),
    DigitalOrderRecord(
      id: 'ORD-703',
      productId: 'DP-003',
      productTitle: 'Premium Material Selection & Brand Comparison Guide',
      amountPaid: 599.0,
      purchasedAt: DateTime.now().subtract(const Duration(hours: 18)),
      customerName: 'Sanjay Dutt Gupta',
      customerPhone: '+91 98199 88123',
      downloadToken: 'HOMIO-TOKEN-M901-SECURE',
    ),
  ];

  // ---------------------------------------------------------------------------
  // 6. ADMIN CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  // Properties CRUD
  static void addProperty(PropertyListing property) {
    properties.insert(0, property);
  }

  static void updateProperty(PropertyListing updated) {
    final idx = properties.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      properties[idx] = updated;
    }
  }

  static void deleteProperty(String id) {
    properties.removeWhere((p) => p.id == id);
  }

  static void togglePropertyStatus(String id, ListingStatus newStatus) {
    final p = properties.firstWhere((item) => item.id == id, orElse: () => properties.first);
    p.status = newStatus;
  }

  static List<PropertyUnlockRecord> getLeadsForProperty(String propertyId) {
    return unlockRecords.where((r) => r.propertyId == propertyId).toList();
  }

  // Digital Products CRUD
  static void addDigitalProduct(DigitalProduct product) {
    digitalProducts.insert(0, product);
  }

  static void updateDigitalProduct(DigitalProduct updated) {
    final idx = digitalProducts.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      digitalProducts[idx] = updated;
    }
  }

  static void deleteDigitalProduct(String id) {
    digitalProducts.removeWhere((p) => p.id == id);
  }

  static void toggleDigitalStatus(String id, ListingStatus newStatus) {
    final dp = digitalProducts.firstWhere((item) => item.id == id, orElse: () => digitalProducts.first);
    dp.status = newStatus;
  }

  // Decor Items CRUD
  static void addDecorItem(DecorItem item) {
    decorItems.insert(0, item);
  }

  static void updateDecorItem(DecorItem updated) {
    final idx = decorItems.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      decorItems[idx] = updated;
    }
  }

  static void deleteDecorItem(String id) {
    decorItems.removeWhere((d) => d.id == id);
  }

  // Material Items CRUD
  static void addMaterial(MaterialItem material) {
    materials.insert(0, material);
  }

  static void updateMaterial(MaterialItem updated) {
    final idx = materials.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      materials[idx] = updated;
    }
  }

  static void deleteMaterial(String id) {
    materials.removeWhere((m) => m.id == id);
  }

  static void updateMaterialPrice(String id, double wholesalePrice, double retailMrp) {
    final m = materials.firstWhere((item) => item.id == id, orElse: () => materials.first);
    m.wholesalePrice = wholesalePrice;
    m.retailMrp = retailMrp;
    m.lastPriceUpdated = DateTime.now();
  }
}
