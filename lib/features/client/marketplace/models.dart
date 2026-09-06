import 'package:flutter/material.dart';

// ============================================================================
// 1. DIGITAL PRODUCTS & GUIDES MODELS
// ============================================================================

enum DigitalGuideCategory {
  all('All Blueprints', Icons.grid_view_rounded),
  vastu('Vastu Shastra Blueprints', Icons.compass_calibration_rounded),
  tipsTricks('Site Tips & Quality Tricks', Icons.lightbulb_rounded),
  materials('Material Spec Handbooks', Icons.menu_book_rounded);

  final String label;
  final IconData icon;
  const DigitalGuideCategory(this.label, this.icon);
}

class DigitalGuide {
  final String id;
  final String title;
  final String subtitle;
  final DigitalGuideCategory category;
  final String author;
  final String authorTitle;
  final double mrpPrice;
  final double clientPrice;
  final double rating;
  final int reviewsCount;
  final int pageCount;
  final String fileFormat;
  final List<String> tableOfContents;
  final String previewExcerpt;
  bool isPurchased;

  DigitalGuide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.author,
    required this.authorTitle,
    required this.mrpPrice,
    required this.clientPrice,
    required this.rating,
    required this.reviewsCount,
    required this.pageCount,
    required this.fileFormat,
    required this.tableOfContents,
    required this.previewExcerpt,
    this.isPurchased = false,
  });
}

// ============================================================================
// 2. HOME DECOR & MATERIAL CATALOG MODELS
// ============================================================================

enum DecorCategory {
  all('All Materials & Decor', Icons.category_rounded),
  lighting('Architectural Lighting', Icons.light_rounded),
  marbleTiles('Italian Marble & Tiles', Icons.grid_on_rounded),
  wallPanels('Fluted Panels & Veneers', Icons.layers_rounded),
  sanitaryware('Sanitaryware & Bath Fixtures', Icons.bathtub_rounded),
  softFurnishings('Curtains & Fabrics', Icons.curtains_rounded);

  final String label;
  final IconData icon;
  const DecorCategory(this.label, this.icon);
}

class DecorProduct {
  final String id;
  final String title;
  final String brand;
  final DecorCategory category;
  final String description;
  final double mrpPrice;
  final double tradePrice;
  final int discountPercent;
  final int leadTimeDays;
  final String dimensions;
  final String finish;
  final String affiliateUrl;
  final bool sampleAvailable;
  bool inSampleCart;

  DecorProduct({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.description,
    required this.mrpPrice,
    required this.tradePrice,
    required this.discountPercent,
    required this.leadTimeDays,
    required this.dimensions,
    required this.finish,
    required this.affiliateUrl,
    required this.sampleAvailable,
    this.inSampleCart = false,
  });
}

// ============================================================================
// 3. RENTAL & PROPERTIES MODELS
// ============================================================================

enum PropertyType {
  all('All Homes', Icons.home_rounded),
  luxuryVilla('Luxury Villas', Icons.villa_rounded),
  penthouse('Penthouses', Icons.apartment_rounded),
  gatedApartment('Gated 3/4 BHKs', Icons.domain_rounded);

  final String label;
  final IconData icon;
  const PropertyType(this.label, this.icon);
}

class PropertyListing {
  final String id;
  final String title;
  final PropertyType propertyType;
  final String location;
  final String city;
  final int bhk;
  final int carpetAreaSqFt;
  final double monthlyRent;
  final double securityDeposit;
  final String furnishingStatus;
  final String availableFrom;
  final List<String> keyAmenities;
  final String architecturalHighlight;
  final bool hasVideoTour;
  final bool verifiedByHomio;
  final String ownerName;
  final String ownerPhone;
  bool isUnlocked;

  PropertyListing({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.location,
    required this.city,
    required this.bhk,
    required this.carpetAreaSqFt,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.furnishingStatus,
    required this.availableFrom,
    required this.keyAmenities,
    required this.architecturalHighlight,
    required this.hasVideoTour,
    required this.verifiedByHomio,
    required this.ownerName,
    required this.ownerPhone,
    this.isUnlocked = false,
  });
}

// ============================================================================
// 4. HIRE LABOUR & SERVICE BOOKING MODELS
// ============================================================================

enum LabourTrade {
  all('All Trades', Icons.handyman_rounded, 0),
  masterCarpenter('Master Carpenter', Icons.carpenter_rounded, 950),
  certifiedElectrician('Certified Electrician', Icons.electrical_services_rounded, 850),
  plumbingSpecialist('Plumbing Specialist', Icons.plumbing_rounded, 850),
  puPainter('PU / Duco Polish Painter', Icons.format_paint_rounded, 900),
  tileMason('Italian Marble / Tile Mason', Icons.square_foot_rounded, 1000);

  final String label;
  final IconData icon;
  final int standardDayRate;
  const LabourTrade(this.label, this.icon, this.standardDayRate);
}

class LabourProfile {
  final String id;
  final String name;
  final LabourTrade trade;
  final int experienceYears;
  final bool verifiedKyc;
  final int dayRate;
  final int sqFtRate;
  final double homioRating;
  final int completedJobsCount;
  final String availability;
  final List<String> skillTags;
  final String supervisorEndorsement;

  LabourProfile({
    required this.id,
    required this.name,
    required this.trade,
    required this.experienceYears,
    required this.verifiedKyc,
    required this.dayRate,
    required this.sqFtRate,
    required this.homioRating,
    required this.completedJobsCount,
    required this.availability,
    required this.skillTags,
    required this.supervisorEndorsement,
  });
}

class LabourBooking {
  final String id;
  final String labourId;
  final String labourName;
  final LabourTrade trade;
  final String siteAddress;
  final String startDate;
  final int durationDays;
  final double dealValue;
  final List<String> taskChecklist;
  String status; // 'Requested', 'Confirmed', 'Active on Site', 'Completed'
  final bool termsAccepted;
  final String timestamp;

  LabourBooking({
    required this.id,
    required this.labourId,
    required this.labourName,
    required this.trade,
    required this.siteAddress,
    required this.startDate,
    required this.durationDays,
    required this.dealValue,
    required this.taskChecklist,
    this.status = 'Confirmed',
    this.termsAccepted = true,
    required this.timestamp,
  });
}

// ============================================================================
// 5. GLOBAL MOCK DATA REPOSITORY & STATE
// ============================================================================

class MarketplaceState {
  static final MarketplaceState _instance = MarketplaceState._internal();
  factory MarketplaceState() => _instance;
  MarketplaceState._internal();

  // In-memory repositories
  late List<DigitalGuide> digitalGuides;
  late List<DecorProduct> decorProducts;
  late List<PropertyListing> propertyListings;
  late List<LabourProfile> labourProfiles;
  late List<LabourBooking> activeBookings;

  void initMockData() {
    digitalGuides = [
      DigitalGuide(
        id: 'dg_1',
        title: 'Vastu Shastra Complete Architectural Blueprint',
        subtitle: '16-Zone Chakra Analysis, Brahmasthan Cures & Non-Demolition Energy Strip Methods',
        category: DigitalGuideCategory.vastu,
        author: 'Ar. Sameer Mehta',
        authorTitle: 'Principal Architect, Homio',
        mrpPrice: 999.0,
        clientPrice: 399.0,
        rating: 4.9,
        reviewsCount: 142,
        pageCount: 84,
        fileFormat: 'PDF eBook + 16 CAD Layer Blueprints',
        tableOfContents: [
          '1. The 16 MahaVastu™ Directions & Elemental Alignments',
          '2. Brahmasthan (Center of Home) Energy Flow & Structural Guidelines',
          '3. North-East (Ishan) Mandir & Water Reservoir Layouts',
          '4. South-East (Agneya) Kitchen & Electrical Fire Load Positioning',
          '5. Non-Demolition Metallic Strips (Copper, Brass, Stainless Steel) Installation',
        ],
        previewExcerpt:
            'When evaluating multi-story residential villas, the core energy meridian begins with the Brahmasthan. Non-demolition Vedic energy strips can counteract plumbing discrepancies in Agneya zones without altering structural columns.',
        isPurchased: true,
      ),
      DigitalGuide(
        id: 'dg_2',
        title: 'Interior Construction Material Quality & Inspection Handbook',
        subtitle: 'IS 710 vs IS 303 Plywood, Anti-Termite Barriers, Acrylic vs PU Comparison',
        category: DigitalGuideCategory.materials,
        author: 'Er. Rajesh Verma',
        authorTitle: 'Chief Quality Officer & Lead Structural Auditor',
        mrpPrice: 799.0,
        clientPrice: 299.0,
        rating: 4.8,
        reviewsCount: 98,
        pageCount: 112,
        fileFormat: 'High-Res PDF + Material Testing Checklists',
        tableOfContents: [
          '1. Identifying Authentic IS 710 Marine Plywood from Commercial Lookalikes',
          '2. HDHMR vs BWP Plywood: When and Where to Use Each in High-Moisture Rooms',
          '3. 7-Stage Anti-Termite Pre-Construction Soil and Wood Barrier Application',
          '4. Surface Finishes: 1.5mm Acrylic High-Gloss vs Multi-Coat Italian PU Polish',
          '5. Hardware Specs: Concealed Soft-Close Hinges, Tandem Runners & Gas Lifters',
        ],
        previewExcerpt:
            'Commercial MR grade plywood dissolves rapidly when exposed to continuous drain pipe condensation under sinks. The simple 72-hour boiling water test easily distinguishes genuine BWP Marine ply from counterfeit commercial boards.',
        isPurchased: false,
      ),
      DigitalGuide(
        id: 'dg_3',
        title: 'False Ceiling & Cove Lighting Architecture Playbook',
        subtitle: 'Standard Cove Lip Offsets, Continuous LED Profiles, Anti-Crack Saint-Gobain Systems',
        category: DigitalGuideCategory.tipsTricks,
        author: 'Ar. Priya Sharma',
        authorTitle: 'Senior Interior Designer',
        mrpPrice: 599.0,
        clientPrice: 199.0,
        rating: 4.9,
        reviewsCount: 76,
        pageCount: 62,
        fileFormat: 'PDF Guide + Lighting Calculation Sheets',
        tableOfContents: [
          '1. False Ceiling Framing: Perimeter Channels, Rawl Plugs & Intermediate Spacing',
          '2. Cove Light Baffle Engineering: 65mm Lip Height for Zero Dot Reflection',
          '3. Color Temperatures (2700K vs 3000K vs 4000K) Across Villa Zones',
          '4. Seamless Jointing Tape & Crack-Free Gypsum Plaster Finishing',
        ],
        previewExcerpt:
            'Dot reflection happens when the LED strip is placed horizontally instead of at a 45-degree upward tilt inside the cove. Maintain a minimum 65mm lip and use 120-LED/m strips for unbroken architectural diffusion.',
        isPurchased: false,
      ),
    ];

    decorProducts = [
      DecorProduct(
        id: 'dec_1',
        title: 'Nordic Brass Ring Chandelier with Ambient Dimmable LEDs',
        brand: 'Philips Hue Architectural',
        category: DecorCategory.lighting,
        description:
            'Curated suspended architectural brass ring chandelier. Tri-color temperature dimmable with wireless smart home Zigbee integration.',
        mrpPrice: 38500.0,
        tradePrice: 28800.0,
        discountPercent: 25,
        leadTimeDays: 4,
        dimensions: 'Diameter: 900mm • Drop: 1200mm',
        finish: 'Brushed Satin Brass with Opal Silicone Diffuser',
        affiliateUrl: 'https://homio.internal/decor/nordic-brass-ring',
        sampleAvailable: false,
      ),
      DecorProduct(
        id: 'dec_2',
        title: 'Imported Statuario Michelangelo Italian Marble (Selected Slabs)',
        brand: 'Stonex India Verified',
        category: DecorCategory.marbleTiles,
        description:
            'Book-matched luxury Italian marble slab with dramatic grey-gold veining. Precision calibrated 18mm thickness with epoxy mesh backing.',
        mrpPrice: 750.0,
        tradePrice: 595.0,
        discountPercent: 21,
        leadTimeDays: 6,
        dimensions: 'Per Sq.Ft • Average Slab Size: 45 Sq.Ft',
        finish: 'High-Gloss Diamond Mirror Polished',
        affiliateUrl: 'https://homio.internal/decor/statuario-marble',
        sampleAvailable: true,
      ),
      DecorProduct(
        id: 'dec_3',
        title: 'Charcoal Oak Acoustic Fluted Wall Panels (Sound Absorbing)',
        brand: 'Merino Armour Decor',
        category: DecorCategory.wallPanels,
        description:
            'High-density MDF fluted slats on recycled sound-absorbing polyester acoustic felt. Ideal for TV backdrop and Master Suite headboard walls.',
        mrpPrice: 4200.0,
        tradePrice: 3350.0,
        discountPercent: 20,
        leadTimeDays: 3,
        dimensions: '2400mm × 600mm × 21mm per sheet',
        finish: 'Matte Charcoal Oak Natural Wood Veneer',
        affiliateUrl: 'https://homio.internal/decor/fluted-charcoal-panels',
        sampleAvailable: true,
      ),
      DecorProduct(
        id: 'dec_4',
        title: 'Thermostatic Matte Black Concealed Rain Shower System with Spout',
        brand: 'Jaquar Artize Signature',
        category: DecorCategory.sanitaryware,
        description:
            'Anti-scald 38°C thermostatic diverter body with 300mm ceiling-mounted overhead ultra-thin rain shower and brass hand shower.',
        mrpPrice: 46000.0,
        tradePrice: 36800.0,
        discountPercent: 20,
        leadTimeDays: 5,
        dimensions: '300mm Rain Head • 3-Way Thermostatic Diverter',
        finish: 'PVD Anti-Fingerprint Matte Black Brass',
        affiliateUrl: 'https://homio.internal/decor/jaquar-artize-thermostatic',
        sampleAvailable: false,
      ),
    ];

    propertyListings = [
      PropertyListing(
        id: 'prop_1',
        title: '4 BHK Luxury Sovereign Villa with Private Plunge Pool',
        propertyType: PropertyType.luxuryVilla,
        location: 'Palm Hills Estate, Whitefield',
        city: 'Bengaluru',
        bhk: 4,
        carpetAreaSqFt: 4250,
        monthlyRent: 135000.0,
        securityDeposit: 675000.0,
        furnishingStatus: 'Fully Furnished by Homio Designer',
        availableFrom: 'Oct 1, 2026',
        keyAmenities: [
          'Private Heated Plunge Pool',
          '100% DG Power Backup',
          'Private Landscaped Lawn',
          'Dedicated Home Theater Room',
          '2-Car Covered EV Parking',
        ],
        architecturalHighlight:
            '100% Vastu compliant East-facing entrance with double-height 22-foot Italian marble living area and Daikin VRV air conditioning.',
        hasVideoTour: true,
        verifiedByHomio: true,
        ownerName: 'Brig. Alok Deshmukh (Retd.)',
        ownerPhone: '+91 98450 12844',
        isUnlocked: false,
      ),
      PropertyListing(
        id: 'prop_2',
        title: '3 BHK Sky Penthouse with 180° Panoramic Skyline Terrace',
        propertyType: PropertyType.penthouse,
        location: 'Golf Course Road, DLF Phase 5',
        city: 'Gurugram',
        bhk: 3,
        carpetAreaSqFt: 3100,
        monthlyRent: 110000.0,
        securityDeposit: 440000.0,
        furnishingStatus: 'Semi-Furnished (German Modular Kitchen + Wardrobes)',
        availableFrom: 'Immediate Move-in',
        keyAmenities: [
          'Private 800 sq.ft Open Sky Deck',
          'Private Keyed High-Speed Lift',
          'Clubhouse & Olympic Pool',
          'Italian Marble Flooring',
        ],
        architecturalHighlight:
            'Floor-to-ceiling soundproof Saint-Gobain double-glazed windows overlooking the DLF Golf Course with zero external traffic noise.',
        hasVideoTour: true,
        verifiedByHomio: true,
        ownerName: 'Dr. Meenakshi Sundaram',
        ownerPhone: '+91 98102 77419',
        isUnlocked: false,
      ),
      PropertyListing(
        id: 'prop_3',
        title: '3 BHK Premium Lakeview Gated Apartment',
        propertyType: PropertyType.gatedApartment,
        location: 'Bellandur Eco-World Corridor',
        city: 'Bengaluru',
        bhk: 3,
        carpetAreaSqFt: 2150,
        monthlyRent: 68000.0,
        securityDeposit: 300000.0,
        furnishingStatus: 'Designer Furnished',
        availableFrom: 'Sep 15, 2026',
        keyAmenities: [
          'Unobstructed Lake View Balcony',
          'Gymnasium & Tennis Court',
          'Piped Gas Connection',
          '24/7 Gated Security',
        ],
        architecturalHighlight:
            'North-East master suite with cross-ventilation breeze and custom Blum soft-close island modular kitchen.',
        hasVideoTour: false,
        verifiedByHomio: true,
        ownerName: 'Kunal Singhania',
        ownerPhone: '+91 97118 40223',
        isUnlocked: false,
      ),
    ];

    labourProfiles = [
      LabourProfile(
        id: 'lab_1',
        name: 'Ramvilas Suthar',
        trade: LabourTrade.masterCarpenter,
        experienceYears: 16,
        verifiedKyc: true,
        dayRate: 950,
        sqFtRate: 48,
        homioRating: 4.95,
        completedJobsCount: 84,
        availability: 'Available Tomorrow',
        skillTags: [
          'Modular Kitchen Carcass',
          'Acrylic Shutter Edge Banding',
          'Concealed Blum Runners',
          'Veneer Grooving',
        ],
        supervisorEndorsement:
            'Exceptional precision. Lead carpenter for Villa 304 and Villa 402 modular wardrobes. Zero millimeter gaps on carcass alignment.',
      ),
      LabourProfile(
        id: 'lab_2',
        name: 'Mohammad Farooq',
        trade: LabourTrade.certifiedElectrician,
        experienceYears: 12,
        verifiedKyc: true,
        dayRate: 850,
        sqFtRate: 28,
        homioRating: 4.9,
        completedJobsCount: 62,
        availability: 'Active on Palm Heights',
        skillTags: [
          '3-Phase DB Dressing',
          'Continuous LED Cove Strips',
          'Smart Automation Relays',
          'Earthing Loop Testing',
        ],
        supervisorEndorsement:
            'Class A certified wireman. Strict compliance with NBC 2016 safety codes and clean conduit routing.',
      ),
      LabourProfile(
        id: 'lab_3',
        name: 'Chandresh Prajapati',
        trade: LabourTrade.tileMason,
        experienceYears: 18,
        verifiedKyc: true,
        dayRate: 1000,
        sqFtRate: 65,
        homioRating: 4.92,
        completedJobsCount: 95,
        availability: 'Available in 2 Days',
        skillTags: [
          'Italian Marble Book-Matching',
          'Epoxy Grout Filling',
          'Diamond Polishing',
          'Zero-Lippage Spacers',
        ],
        supervisorEndorsement:
            'Master craftsman for 6x4 large format porcelain slabs and Italian Statuario book-match floorings.',
      ),
      LabourProfile(
        id: 'lab_4',
        name: 'Babu Rao Painter',
        trade: LabourTrade.puPainter,
        experienceYears: 14,
        verifiedKyc: true,
        dayRate: 900,
        sqFtRate: 35,
        homioRating: 4.88,
        completedJobsCount: 57,
        availability: 'Available Tomorrow',
        skillTags: [
          'Sayerlack PU High-Gloss',
          'Duco Matte Shutter Spray',
          'Melamine Polish',
          'Wall Putty Level-5',
        ],
        supervisorEndorsement:
            'Pneumatic spray booth finish on site. Mirror gloss with zero orange-peel texture on wardrobe shutters.',
      ),
    ];

    activeBookings = [
      LabourBooking(
        id: 'bk_101',
        labourId: 'lab_1',
        labourName: 'Ramvilas Suthar',
        trade: LabourTrade.masterCarpenter,
        siteAddress: 'Palm Heights Villa 402, Master Bedroom Wardrobe Bay',
        startDate: 'Sep 3, 2026',
        durationDays: 4,
        dealValue: 3800.0,
        taskChecklist: [
          'Align 3-door wardrobe HDHMR carcasses to plumb line',
          'Install Hettich Sensys soft-close 110° hinges',
          'Mount 2.4m acrylic shutters with zero reveal deviation',
          'Final internal accessory drawers and hydraulic lift rod test',
        ],
        status: 'Active on Site',
        termsAccepted: true,
        timestamp: 'Sep 2, 2026',
      ),
    ];
  }
}

final MarketplaceState globalMarketplaceState = MarketplaceState()..initMockData();
