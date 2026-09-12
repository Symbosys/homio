import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../models/marketplace_enums.dart';
import '../services/order_service.dart';
import '../widgets/marketplace_scaffold.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/empty_marketplace_state.dart';
import 'widgets/order_card.dart';
import 'widgets/order_detail_sheet.dart';

/// Customer Orders & Service Appointment Ledger
class ClientMarketplaceOrdersPage extends StatefulWidget {
  const ClientMarketplaceOrdersPage({super.key});

  @override
  State<ClientMarketplaceOrdersPage> createState() => _ClientMarketplaceOrdersPageState();
}

class _ClientMarketplaceOrdersPageState extends State<ClientMarketplaceOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  int _tabIndex = 0; // 0 = Orders, 1 = Service Bookings
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      activeCategory: MarketplaceCategory.orders,
      title: 'Orders & Appointments',
      subtitle: 'Order tracking, GST tax invoices & tradesman booking appointments',
      body: ListenableBuilder(
        listenable: OrderService(),
        builder: (context, _) {
          final service = OrderService();
          final orders = service.orders.where((o) {
            if (_searchQuery.isEmpty) return true;
            return o.orderNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                o.items.any((i) => i.productTitle.toLowerCase().contains(_searchQuery.toLowerCase()));
          }).toList();

          final bookings = service.labourBookings.where((b) {
            if (_searchQuery.isEmpty) return true;
            return b.bookingNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                b.workerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                b.serviceTitle.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: MarketplaceHeader(
                  title: 'Customer Transaction & Service Ledger',
                  subtitle: 'Track live courier parcels, view official GST tax invoices & review scheduled site appointments',
                  badgeText: 'Unified Receipts',
                  badgeColor: const Color(0xFFEC4899),
                  searchController: _searchController,
                  onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
                  onClearSearch: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  searchHint: 'Search order number, product name, or booking ID...',
                ),
              ),

              // Tab Switcher
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: Text('Product & Material Orders (${orders.length})'),
                        selected: _tabIndex == 0,
                        selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                        onSelected: (val) {
                          if (val) setState(() => _tabIndex = 0);
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: Text('Labour & Service Bookings (${bookings.length})'),
                        selected: _tabIndex == 1,
                        selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                        onSelected: (val) {
                          if (val) setState(() => _tabIndex = 1);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Body Slivers
              if (_tabIndex == 0)
                ..._buildOrdersSlivers(orders)
              else
                ..._buildBookingsSlivers(bookings),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildOrdersSlivers(List<dynamic> orders) {
    if (orders.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyMarketplaceState(
            title: 'No orders found',
            message: 'You haven\'t placed any marketplace orders matching this search.',
            icon: Icons.receipt_long_rounded,
            onResetFilters: () => context.go('/client/marketplace'),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final order = orders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: OrderCard(
                  order: order,
                  onTap: () => OrderDetailSheet.show(context, order),
                ),
              );
            },
            childCount: orders.length,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildBookingsSlivers(List<dynamic> bookings) {
    if (bookings.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyMarketplaceState(
            title: 'No labour appointments found',
            message: 'You haven\'t scheduled any tradesman appointments matching this search.',
            icon: Icons.calendar_month_rounded,
            onResetFilters: () => context.go('/client/marketplace/labour-services'),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final b = bookings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          b.bookingNumber,
                          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: b.status.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            b.status.label.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: b.status.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(b.workerPhoto),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b.serviceTitle,
                                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${b.workerName} • ${b.trade.label}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          b.formattedTotal,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.event_available_rounded, size: 14, color: Color(0xFF10B981)),
                        const SizedBox(width: 6),
                        Text(
                          '${b.scheduledDate.day}/${b.scheduledDate.month}/${b.scheduledDate.year} • ${b.timeSlot}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: bookings.length,
          ),
        ),
      ),
    ];
  }
}
