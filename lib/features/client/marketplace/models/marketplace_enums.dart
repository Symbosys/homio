import 'package:flutter/material.dart';

/// Top-level marketplace sub-modules
enum MarketplaceCategory {
  digitalProducts('Digital Products', Icons.menu_book_rounded, '/client/marketplace/digital-products'),
  homeDecor('Home Decor', Icons.chair_rounded, '/client/marketplace/home-decor'),
  materials('Materials & Supplies', Icons.layers_rounded, '/client/marketplace/materials'),
  properties('Properties & Rentals', Icons.apartment_rounded, '/client/marketplace/properties'),
  labourServices('Labour & Services', Icons.engineering_rounded, '/client/marketplace/labour-services'),
  orders('My Orders', Icons.receipt_long_rounded, '/client/marketplace/orders');

  final String label;
  final IconData icon;
  final String routePath;

  const MarketplaceCategory(this.label, this.icon, this.routePath);
}

/// Digital product classification
enum DigitalProductCategory {
  all('All Formats'),
  vastuHandbooks('Vastu & Planning'),
  cadBimTemplates('CAD & BIM Templates'),
  interiorPresets('3D & Render Presets'),
  vrWalkthroughs('VR Walkthroughs'),
  legalChecklists('Legal & Approvals'),
  boqSpreadsheets('BOQ & Costing');

  final String label;
  const DigitalProductCategory(this.label);
}

/// Home decor & curated interior item categories
enum HomeDecorCategory {
  all('All Decor'),
  lighting('Lighting & Chandeliers'),
  furniture('Accent Furniture'),
  wallArt('Wall Art & Mirrors'),
  carpetsRugs('Carpets & Rugs'),
  plantersVases('Planters & Greenery'),
  softFurnishing('Cushions & Throws'),
  decorAccents('Sculptures & Accents');

  final String label;
  const HomeDecorCategory(this.label);
}

/// Construction & interior finish materials categories
enum MaterialCategory {
  all('All Materials'),
  civilCement('Cement & Structural'),
  tilesFlooring('Tiles & Italian Marble'),
  paintsFinishes('Paints & Textures'),
  plyHardware('Plywood & Hardware'),
  electricals('Switches & Electricals'),
  sanitaryBath('Sanitaryware & Bath'),
  woodenFlooring('Hardwood & Laminate');

  final String label;
  const MaterialCategory(this.label);
}

/// Unit of measurement for bulk materials
enum MaterialUnit {
  bag('bag', 'Bags'),
  sqft('sq.ft', 'Square Feet'),
  piece('pc', 'Pieces'),
  liter('L', 'Liters'),
  box('box', 'Boxes'),
  meter('m', 'Meters');

  final String symbol;
  final String label;
  const MaterialUnit(this.symbol, this.label);
}

/// Property marketplace listing type
enum PropertyListingType {
  all('All Listings'),
  rental('Verified Rentals'),
  sale('Properties for Sale'),
  commercial('Commercial & Studio'),
  plot('Residential Plots');

  final String label;
  const PropertyListingType(this.label);
}

/// Property structural category
enum PropertyCategory {
  luxuryApartment('Luxury Apartment'),
  penthouse('Penthouse'),
  independentVilla('Independent Villa'),
  builderFloor('Builder Floor'),
  studioApartment('Studio Apartment'),
  farmHouse('Farmhouse / Plot');

  final String label;
  const PropertyCategory(this.label);
}

/// Labour & on-demand contractor trades
enum LabourTradeCategory {
  all('All Trades'),
  masterCarpenter('Carpentry & Woodwork'),
  plumber('Plumbing & Drainage'),
  electrician('Electrical & Automation'),
  painter('Wall Painting & PU Polish'),
  falseCeiling('False Ceiling & Gypsum'),
  masonTiler('Tiling & Stonework'),
  hvacTechnician('HVAC & AC Installation'),
  deepCleaning('Deep Cleaning & Sanitization');

  final String label;
  const LabourTradeCategory(this.label);
}

/// Labour pricing calculation
enum LabourPricingModel {
  dailyWage('Per Day (8 Hrs)'),
  hourly('Per Hour'),
  squareFootage('Per Sq.Ft'),
  taskBased('Fixed Scope Quote');

  final String label;
  const LabourPricingModel(this.label);
}

/// Worker skill tier
enum LabourSkillLevel {
  apprentice('Junior Assistant', Color(0xFF64748B)),
  skilledWorker('Skilled Craftsman', Color(0xFF3B82F6)),
  masterCraftsman('Master Guild Artisan', Color(0xFF10B981)),
  siteSupervisor('Lead Site Supervisor', Color(0xFF8B5CF6));

  final String label;
  final Color badgeColor;
  const LabourSkillLevel(this.label, this.badgeColor);
}

/// Universal order status
enum MarketplaceOrderStatus {
  placed('Order Placed', Icons.receipt_outlined, Color(0xFF3B82F6)),
  confirmed('Confirmed', Icons.check_circle_outline, Color(0xFF0EA5E9)),
  processing('Processing', Icons.inventory_2_outlined, Color(0xFFF59E0B)),
  dispatched('Dispatched', Icons.local_shipping_outlined, Color(0xFF8B5CF6)),
  delivered('Delivered', Icons.task_alt_rounded, Color(0xFF10B981)),
  cancelled('Cancelled', Icons.cancel_outlined, Color(0xFFEF4444)),
  refunded('Refunded', Icons.replay_rounded, Color(0xFF64748B));

  final String label;
  final IconData icon;
  final Color color;
  const MarketplaceOrderStatus(this.label, this.icon, this.color);
}

/// Booking status for Labour & Site visits
enum BookingStatus {
  requested('Booking Requested', Color(0xFFF59E0B)),
  workerAssigned('Worker Assigned', Color(0xFF3B82F6)),
  inProgress('Work in Progress', Color(0xFF8B5CF6)),
  completed('Completed & Verified', Color(0xFF10B981)),
  cancelled('Cancelled', Color(0xFFEF4444));

  final String label;
  final Color color;
  const BookingStatus(this.label, this.color);
}

/// Direct sale vs Affiliate vendor platform
enum AffiliatePlatform {
  homioDirect('HOMIO Fulfillment', 'Direct verified fulfillment with HOMIO warranty', Icons.verified_rounded),
  amazonIndia('Amazon India', 'Delivered via Amazon Prime India', Icons.open_in_new_rounded),
  ikeaIndia('IKEA India', 'Official IKEA India catalog partner', Icons.open_in_new_rounded),
  pepperfry('Pepperfry', 'Fulfillable by Pepperfry Studio', Icons.open_in_new_rounded),
  urbanLadder('Urban Ladder', 'Urban Ladder verified designer piece', Icons.open_in_new_rounded),
  directVendor('Manufacturer Partner', 'Direct from manufacturer factory floor', Icons.storefront_rounded);

  final String displayName;
  final String description;
  final IconData icon;
  const AffiliatePlatform(this.displayName, this.description, this.icon);
}
