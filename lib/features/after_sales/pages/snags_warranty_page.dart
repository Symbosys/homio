import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class SnagsWarrantyPage extends StatefulWidget {
  const SnagsWarrantyPage({super.key});

  @override
  State<SnagsWarrantyPage> createState() => _SnagsWarrantyPageState();
}

class _SnagsWarrantyPageState extends State<SnagsWarrantyPage> {
  final List<SnagTicket> _tickets = List.from(AfterSalesMockData.snagTickets);

  String _searchQuery = '';
  SnagCategory? _selectedCategory;
  SnagStatus? _selectedStatus;
  bool _onlyWarrantyCovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredTickets = _tickets.where((t) {
      final matchesSearch = t.ticketNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || t.category == _selectedCategory;
      final matchesStatus = _selectedStatus == null || t.status == _selectedStatus;
      final matchesWarranty = !_onlyWarrantyCovered || t.warrantyStatus.isCovered;

      return matchesSearch && matchesCategory && matchesStatus && matchesWarranty;
    }).toList();

    // Summary counts
    final totalActive = _tickets.where((t) => t.status != SnagStatus.resolved).length;
    final criticalCount = _tickets.where((t) => t.priority == SnagPriority.critical && t.status != SnagStatus.resolved).length;
    final warrantyCoveredCount = _tickets.where((t) => t.warrantyStatus.isCovered).length;
    final resolvedCount = _tickets.where((t) => t.status == SnagStatus.resolved).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, totalActive, criticalCount, warrantyCoveredCount, resolvedCount, width),
            const SizedBox(height: 24),
            _buildTicketsCard(isDark, filteredTickets),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.build_circle_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Snags & Warranty Service',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Post-handover snag resolution, 10-year structural & 1-year comprehensive warranty SLA management.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showCreateSnagModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Report Snag / Claim'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiMetrics(
    bool isDark,
    int totalActive,
    int criticalCount,
    int warrantyCovered,
    int resolvedCount,
    double width,
  ) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Active Snag Tickets',
        value: '$totalActive Tickets',
        sub: 'Pending SLA completion',
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Critical SLA Escalations',
        value: '$criticalCount Urgent',
        sub: '< 4h emergency dispatch',
        icon: Icons.warning_rounded,
        color: const Color(0xFFEF4444),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Warranty Covered',
        value: '$warrantyCovered Claims',
        sub: '10-Yr Structural / 1-Yr Comp.',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Resolved & Signed-Off',
        value: '$resolvedCount Complete',
        sub: 'Photo verified & closed',
        icon: Icons.check_circle_rounded,
        color: AppColors.gold,
      ),
    ];

    if (width < Breakpoints.compact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsCard(bool isDark, List<SnagTicket> tickets) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Snag Tickets & Warranty Claim Register',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedStatus == null && !_onlyWarrantyCovered,
                    onSelected: (_) => setState(() {
                      _selectedStatus = null;
                      _onlyWarrantyCovered = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Open / In-Progress'),
                    selected: _selectedStatus == SnagStatus.inProgress,
                    onSelected: (val) => setState(() => _selectedStatus = val ? SnagStatus.inProgress : null),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Warranty Covered'),
                    selected: _onlyWarrantyCovered,
                    selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                    onSelected: (val) => setState(() => _onlyWarrantyCovered = val),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search by ticket #, project, client name, or snag description...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (tickets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No snag tickets match the selected filter criteria.',
                      style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tickets.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketRow(isDark, ticket);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(bool isDark, SnagTicket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ticket.priority == SnagPriority.critical && ticket.status != SnagStatus.resolved
              ? const Color(0xFFEF4444).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.ticketNumber,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ticket.projectName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${ticket.clientName} (${ticket.clientPhone})',
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildPriorityBadge(ticket.priority),
                  const SizedBox(width: 8),
                  _buildStatusBadge(ticket.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ticket.title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.description,
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCategoryTag(ticket.category),
              const SizedBox(width: 10),
              _buildWarrantyTag(ticket.warrantyStatus),
              const Spacer(),
              if (ticket.assignedTechnician != null) ...[
                Icon(Icons.engineering_rounded, size: 14, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                const SizedBox(width: 5),
                Text(
                  ticket.assignedTechnician!,
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                'SLA: ${DateFormat('dd MMM, hh:mm a').format(ticket.slaDeadline)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ticket.isOverdue ? const Color(0xFFEF4444) : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
          // Photos and Actions
          if (ticket.beforePhotoUrl != null || ticket.afterPhotoUrl != null || ticket.status != SnagStatus.resolved) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (ticket.beforePhotoUrl != null)
                      _buildPhotoPreview(ticket.beforePhotoUrl!, 'Before Proof', isDark),
                    if (ticket.afterPhotoUrl != null) ...[
                      const SizedBox(width: 10),
                      _buildPhotoPreview(ticket.afterPhotoUrl!, 'After Proof', isDark),
                    ],
                  ],
                ),
                Row(
                  children: [
                    if (ticket.status == SnagStatus.open)
                      ElevatedButton.icon(
                        onPressed: () => _dispatchTechnician(ticket),
                        icon: const Icon(Icons.send_rounded, size: 14),
                        label: const Text('Dispatch Technician'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    if (ticket.status == SnagStatus.dispatched || ticket.status == SnagStatus.inProgress)
                      ElevatedButton.icon(
                        onPressed: () => _showResolveModal(isDark, ticket),
                        icon: const Icon(Icons.verified_rounded, size: 14),
                        label: const Text('Resolve & Photo Sign-off'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoPreview(String url, String label, bool isDark) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(url, width: 42, height: 42, fit: BoxFit.cover),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
      ],
    );
  }

  Widget _buildPriorityBadge(SnagPriority priority) {
    Color color;
    switch (priority) {
      case SnagPriority.critical:
        color = const Color(0xFFEF4444);
        break;
      case SnagPriority.high:
        color = const Color(0xFFF59E0B);
        break;
      case SnagPriority.medium:
        color = const Color(0xFF3B82F6);
        break;
      case SnagPriority.low:
        color = const Color(0xFF64748B);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _buildStatusBadge(SnagStatus status) {
    Color color;
    switch (status) {
      case SnagStatus.open:
        color = const Color(0xFFF59E0B);
        break;
      case SnagStatus.dispatched:
        color = const Color(0xFF3B82F6);
        break;
      case SnagStatus.inProgress:
        color = const Color(0xFF8B5CF6);
        break;
      case SnagStatus.resolved:
        color = const Color(0xFF10B981);
        break;
      case SnagStatus.warrantyDenied:
        color = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _buildCategoryTag(SnagCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.category_rounded, size: 12, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(
            category.displayName,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.gold),
          ),
        ],
      ),
    );
  }

  Widget _buildWarrantyTag(WarrantyStatus warranty) {
    final isCovered = warranty.isCovered;
    final color = isCovered ? const Color(0xFF10B981) : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isCovered ? Icons.shield_rounded : Icons.shield_outlined, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            warranty.displayName,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  void _dispatchTechnician(SnagTicket ticket) {
    setState(() {
      final idx = _tickets.indexWhere((t) => t.id == ticket.id);
      if (idx != -1) {
        _tickets[idx] = ticket.copyWith(
          status: SnagStatus.dispatched,
          assignedTechnician: 'Dinesh Carpenter Lead',
          technicianPhone: '+91 98221 44556',
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispatched technician to ${ticket.projectName} for Ticket ${ticket.ticketNumber}'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  void _showResolveModal(bool isDark, SnagTicket ticket) {
    final noteCtrl = TextEditingController(text: 'Replaced defective fitment with OEM spare. Client tested and confirmed resolution.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Resolve Snag & Upload After-Photo',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
        ),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ticket: ${ticket.ticketNumber} • ${ticket.projectName}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Resolution Summary *', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt_rounded, size: 20, color: Color(0xFF10B981)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Simulating camera inspection stamp capture: High-res proof uploaded automatically.',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final idx = _tickets.indexWhere((t) => t.id == ticket.id);
                if (idx != -1) {
                  _tickets[idx] = ticket.copyWith(
                    status: SnagStatus.resolved,
                    afterPhotoUrl: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=300',
                    clientSignoff: true,
                    resolvedDate: DateTime.now(),
                    resolutionNotes: noteCtrl.text.trim(),
                  );
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Marked Ticket ${ticket.ticketNumber} as Resolved with client sign-off.'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
            child: const Text('Complete & Close Ticket'),
          ),
        ],
      ),
    );
  }

  void _showCreateSnagModal(bool isDark) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final clientCtrl = TextEditingController(text: 'Ananya Sharma');
    final phoneCtrl = TextEditingController(text: '+91 98440 55667');
    final projCtrl = TextEditingController(text: 'Villa #18, Palm Meadows');
    SnagCategory category = SnagCategory.carpentry;
    SnagPriority priority = SnagPriority.high;
    WarrantyStatus warranty = WarrantyStatus.active1YrComprehensive;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Report Post-Handover Snag / Claim',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: projCtrl, decoration: const InputDecoration(labelText: 'Project Name / Unit *', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: clientCtrl, decoration: const InputDecoration(labelText: 'Client Name *', border: OutlineInputBorder()))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Client Phone *', border: OutlineInputBorder()))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<SnagCategory>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Snag Category', border: OutlineInputBorder()),
                      items: SnagCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.displayName))).toList(),
                      onChanged: (val) => setDialogState(() => category = val!),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<SnagPriority>(
                            initialValue: priority,
                            decoration: const InputDecoration(labelText: 'Priority / SLA', border: OutlineInputBorder()),
                            items: SnagPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.displayName))).toList(),
                            onChanged: (val) => setDialogState(() => priority = val!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<WarrantyStatus>(
                            initialValue: warranty,
                            decoration: const InputDecoration(labelText: 'Warranty Type', border: OutlineInputBorder()),
                            items: WarrantyStatus.values.map((w) => DropdownMenuItem(value: w, child: Text(w.displayName))).toList(),
                            onChanged: (val) => setDialogState(() => warranty = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Issue Summary *', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Detailed Observations *', border: OutlineInputBorder()), maxLines: 2),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final newTicket = SnagTicket(
                    id: 'SNG-${DateTime.now().millisecondsSinceEpoch}',
                    ticketNumber: 'TKT-2026-${_tickets.length + 8805}',
                    projectId: 'PRJ-NEW',
                    projectName: projCtrl.text.trim(),
                    clientName: clientCtrl.text.trim(),
                    clientPhone: phoneCtrl.text.trim(),
                    handoverDate: DateTime.now().subtract(const Duration(days: 30)),
                    category: category,
                    priority: priority,
                    warrantyStatus: warranty,
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    reportedDate: DateTime.now(),
                    slaDeadline: DateTime.now().add(priority == SnagPriority.critical ? const Duration(hours: 4) : const Duration(hours: 48)),
                    status: SnagStatus.open,
                    beforePhotoUrl: 'https://images.unsplash.com/photo-1558997519-83ea9252def8?w=300',
                  );
                  setState(() {
                    _tickets.insert(0, newTicket);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registered Snag Ticket ${newTicket.ticketNumber} for ${newTicket.projectName}')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Create Ticket'),
              ),
            ],
          );
        },
      ),
    );
  }
}
