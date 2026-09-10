import 'package:flutter/material.dart';

/// Primary Marketplace Business Models supported by Homio
enum MarketplaceType {
  digital(label: 'Digital Publications', icon: Icons.menu_book_rounded, color: Color(0xFF3B82F6)),
  homeDecor(label: 'Home Decor & Affiliates', icon: Icons.chair_rounded, color: Color(0xFF8B5CF6)),
  properties(label: 'Verified Properties', icon: Icons.villa_rounded, color: Color(0xFF10B981)),
  materials(label: 'Wholesale Materials', icon: Icons.inventory_2_rounded, color: Color(0xFFF59E0B));

  final String label;
  final IconData icon;
  final Color color;

  const MarketplaceType({
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// Lifecycle publication state for catalogue items
enum ProductPublicationStatus {
  draft(label: 'Draft', color: Color(0xFF6B7280), icon: Icons.edit_note_rounded),
  underReview(label: 'Under Review', color: Color(0xFFF59E0B), icon: Icons.hourglass_empty_rounded),
  approved(label: 'Approved', color: Color(0xFF10B981), icon: Icons.check_circle_outline_rounded),
  published(label: 'Published & Live', color: Color(0xFF059669), icon: Icons.public_rounded),
  unpublished(label: 'Unpublished', color: Color(0xFFEF4444), icon: Icons.visibility_off_rounded),
  archived(label: 'Archived', color: Color(0xFF4B5563), icon: Icons.archive_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const ProductPublicationStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// Visibility scope for customer discovery
enum ProductVisibility {
  public(label: 'Public Catalog', icon: Icons.public_rounded),
  private(label: 'Private / B2B Only', icon: Icons.lock_outline_rounded),
  unlisted(label: 'Unlisted (Direct Link)', icon: Icons.link_rounded),
  restricted(label: 'Restricted Tier', icon: Icons.admin_panel_settings_rounded);

  final String label;
  final IconData icon;

  const ProductVisibility({
    required this.label,
    required this.icon,
  });
}

/// Status of concrete Marketplace Listings
enum ListingStatus {
  active(label: 'Active & In Stock', color: Color(0xFF10B981)),
  draft(label: 'Draft', color: Color(0xFF94A3B8)),
  pendingApproval(label: 'Pending Approval', color: Color(0xFFF59E0B)),
  outOfStock(label: 'Out of Stock', color: Color(0xFFEF4444)),
  discontinued(label: 'Discontinued', color: Color(0xFF64748B)),
  archived(label: 'Archived', color: Color(0xFF475569));

  final String label;
  final Color color;

  const ListingStatus({required this.label, required this.color});
}

/// Formal 7-step verification workflow for properties
enum PropertyVerificationStatus {
  draft(label: 'Draft', color: Color(0xFF94A3B8), icon: Icons.edit_outlined),
  submitted(label: 'Submitted for Verification', color: Color(0xFF3B82F6), icon: Icons.send_rounded),
  inProgress(label: 'Verification In Progress', color: Color(0xFFF59E0B), icon: Icons.verified_user_outlined),
  verified(label: 'Homio Verified', color: Color(0xFF10B981), icon: Icons.verified_rounded),
  rejected(label: 'Verification Rejected', color: Color(0xFFEF4444), icon: Icons.cancel_outlined),
  published(label: 'Published Live', color: Color(0xFF059669), icon: Icons.public_rounded),
  expired(label: 'Listing Expired', color: Color(0xFF6B7280), icon: Icons.timer_off_outlined);

  final String label;
  final Color color;
  final IconData icon;

  const PropertyVerificationStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// Structural category of real estate properties
enum PropertyType {
  luxuryApartment(label: 'Luxury Apartment', icon: Icons.apartment_rounded),
  penthouse(label: 'Duplex Penthouse', icon: Icons.location_city_rounded),
  builderFloor(label: 'Independent Builder Floor', icon: Icons.domain_rounded),
  villa(label: 'Gated Luxury Villa', icon: Icons.home_work_rounded),
  commercialOffice(label: 'Commercial Studio / Office', icon: Icons.business_rounded);

  final String label;
  final IconData icon;

  const PropertyType({
    required this.label,
    required this.icon,
  });
}

/// Transaction intent for property listings
enum ListingIntent {
  rent(label: 'For Rent', color: Color(0xFF10B981)),
  sale(label: 'For Resale', color: Color(0xFF3B82F6));

  final String label;
  final Color color;

  const ListingIntent({
    required this.label,
    required this.color,
  });
}

/// Proprietary Digital Guide File Formats
enum DigitalFileFormat {
  pdf(label: 'PDF Document', extension: '.pdf', icon: Icons.picture_as_pdf_rounded),
  epub(label: 'EPUB E-Book', extension: '.epub', icon: Icons.menu_book_rounded),
  zip(label: 'ZIP Archive', extension: '.zip', icon: Icons.folder_zip_rounded),
  dwg(label: 'AutoCAD DWG Drawing', extension: '.dwg', icon: Icons.architecture_rounded),
  fbx(label: '3D FBX Model', extension: '.fbx', icon: Icons.view_in_ar_rounded);

  final String label;
  final String extension;
  final IconData icon;

  const DigitalFileFormat({
    required this.label,
    required this.extension,
    required this.icon,
  });
}

/// Curated Affiliate Partners for Home Decor
enum AffiliatePartner {
  amazon(label: 'Amazon Associates', domain: 'amazon.in', color: Color(0xFFFF9900)),
  pepperfry(label: 'Pepperfry Partner', domain: 'pepperfry.com', color: Color(0xFFE53935)),
  urbanLadder(label: 'Urban Ladder Affiliate', domain: 'urbanladder.com', color: Color(0xFF1E88E5)),
  westElm(label: 'West Elm Global', domain: 'westelm.com', color: Color(0xFF374151)),
  ikea(label: 'IKEA Affiliate Network', domain: 'ikea.com', color: Color(0xFF0051BA)),
  custom(label: 'Custom Direct Merchant', domain: 'merchant.com', color: Color(0xFF8B5CF6));

  final String label;
  final String domain;
  final Color color;

  const AffiliatePartner({
    required this.label,
    required this.domain,
    required this.color,
  });
}

/// Commission calculation method
enum CommissionType {
  percentage(label: 'Percentage of Sale (%)'),
  fixedAmount(label: 'Fixed Flat Commission (₹)');

  final String label;

  const CommissionType({required this.label});
}

/// Trade Unit of Measurement for Materials
enum MaterialUnit {
  perSheet(label: 'Per Sheet (8x4 ft)', shortLabel: 'sheet'),
  perSqFt(label: 'Per Square Foot', shortLabel: 'sq.ft'),
  perBox(label: 'Per Box / Carton', shortLabel: 'box'),
  perDrum(label: 'Per 20L Drum', shortLabel: 'drum'),
  perPiece(label: 'Per Piece / Unit', shortLabel: 'pc'),
  perTon(label: 'Per Metric Ton', shortLabel: 'ton');

  final String label;
  final String shortLabel;

  const MaterialUnit({required this.label, required this.shortLabel});
}

/// Central Order Lifecycle State
enum OrderStatus {
  placed(label: 'Order Placed', color: Color(0xFF3B82F6), icon: Icons.receipt_rounded),
  confirmed(label: 'Payment Confirmed', color: Color(0xFF6366F1), icon: Icons.verified_rounded),
  processing(label: 'Processing & Pack', color: Color(0xFFF59E0B), icon: Icons.inventory_rounded),
  ready(label: 'Ready for Pickup', color: Color(0xFF06B6D4), icon: Icons.check_box_rounded),
  dispatched(label: 'Dispatched', color: Color(0xFF8B5CF6), icon: Icons.local_shipping_rounded),
  inTransit(label: 'In Transit', color: Color(0xFFEC4899), icon: Icons.alt_route_rounded),
  delivered(label: 'Delivered', color: Color(0xFF10B981), icon: Icons.done_all_rounded),
  completed(label: 'Completed', color: Color(0xFF059669), icon: Icons.task_alt_rounded),
  cancelled(label: 'Cancelled', color: Color(0xFFEF4444), icon: Icons.cancel_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const OrderStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// Transaction Payment Status
enum PaymentStatus {
  pending(label: 'Pending Payment', color: Color(0xFFF59E0B)),
  successful(label: 'Paid & Settled', color: Color(0xFF10B981)),
  failed(label: 'Payment Failed', color: Color(0xFFEF4444)),
  refunded(label: 'Fully Refunded', color: Color(0xFF6B7280)),
  partiallyRefunded(label: 'Partially Refunded', color: Color(0xFF8B5CF6));

  final String label;
  final Color color;

  const PaymentStatus({required this.label, required this.color});
}

/// Delivery & Logistics Fulfillment Status
enum DeliveryStatus {
  unassigned(label: 'Awaiting Delivery Partner', color: Color(0xFFF59E0B)),
  assigned(label: 'Partner Assigned', color: Color(0xFF3B82F6)),
  awaitingPickup(label: 'Awaiting Vendor Pickup', color: Color(0xFF6366F1)),
  inTransit(label: 'In Transit', color: Color(0xFF8B5CF6)),
  outForDelivery(label: 'Out for Delivery', color: Color(0xFFEC4899)),
  delivered(label: 'Delivered', color: Color(0xFF10B981)),
  failed(label: 'Delivery Attempt Failed', color: Color(0xFFEF4444)),
  returned(label: 'Returned to Warehouse', color: Color(0xFF64748B));

  final String label;
  final Color color;

  const DeliveryStatus({required this.label, required this.color});
}

/// Four Distinct Marketplace Order Categories
enum OrderType {
  digital(label: 'Digital Publication', icon: Icons.cloud_download_rounded, color: Color(0xFF3B82F6)),
  decorAffiliate(label: 'Home Decor Order', icon: Icons.chair_rounded, color: Color(0xFF8B5CF6)),
  materialProcurement(label: 'Material Procurement', icon: Icons.precision_manufacturing_rounded, color: Color(0xFFF59E0B)),
  propertyUnlock(label: 'Property Owner Unlock (₹500)', icon: Icons.vpn_key_rounded, color: Color(0xFF10B981));

  final String label;
  final IconData icon;
  final Color color;

  const OrderType({
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// Central Approval Queue Entity Types
enum ApprovalEntityType {
  digitalProduct(label: 'Digital Publication', icon: Icons.menu_book_rounded),
  homeDecor(label: 'Home Decor Product', icon: Icons.chair_rounded),
  material(label: 'Procurement Material', icon: Icons.texture_rounded),
  propertyListing(label: 'Property Listing', icon: Icons.villa_rounded);

  final String label;
  final IconData icon;

  const ApprovalEntityType({required this.label, required this.icon});
}

/// Customer Review Moderation Status
enum ReviewStatus {
  pending(label: 'Pending Moderation', color: Color(0xFFF59E0B)),
  approved(label: 'Approved & Live', color: Color(0xFF10B981)),
  hidden(label: 'Hidden by Admin', color: Color(0xFF64748B)),
  rejected(label: 'Rejected', color: Color(0xFFEF4444));

  final String label;
  final Color color;

  const ReviewStatus({required this.label, required this.color});
}

/// Audit Trail Action Types for Marketplace Governance
enum MarketplaceAuditAction {
  create(label: 'Created Record'),
  update(label: 'Updated Details'),
  delete(label: 'Deleted Record'),
  publish(label: 'Published to Marketplace'),
  unpublish(label: 'Unpublished / Hidden'),
  approve(label: 'Approved Submission'),
  reject(label: 'Rejected Submission'),
  verify(label: 'Homio Verified'),
  priceChange(label: 'Commercial Price Update'),
  unlockAccess(label: 'Owner Contact Unlocked'),
  refund(label: 'Order Refund Processed'),
  assignVendor(label: 'Vendor Assigned'),
  assignDelivery(label: 'Delivery Partner Assigned'),
  statusChange(label: 'Lifecycle Status Change');

  final String label;

  const MarketplaceAuditAction({required this.label});
}
