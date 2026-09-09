import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';

class ServiceRequestDetailDrawer extends StatefulWidget {
  final ServiceRequest request;
  final VoidCallback? onScheduleVisit;
  final VoidCallback? onResolveRequest;
  final VoidCallback? onAssignTechnician;

  const ServiceRequestDetailDrawer({
    super.key,
    required this.request,
    this.onScheduleVisit,
    this.onResolveRequest,
    this.onAssignTechnician,
  });

  @override
  State<ServiceRequestDetailDrawer> createState() => _ServiceRequestDetailDrawerState();
}

class _ServiceRequestDetailDrawerState extends State<ServiceRequestDetailDrawer> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _noteCtrl = TextEditingController();
  final List<InternalNote> _localNotes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _localNotes.addAll(widget.request.internalNotes);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final req = widget.request;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 580,
        height: double.infinity,
        decoration: BoxDecoration(
          color: surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(bottom: BorderSide(color: borderColor)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: req.status.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              req.status.label.toUpperCase(),
                              style: TextStyle(color: req.status.color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: req.priority.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              req.priority.label,
                              style: TextStyle(color: req.priority.color, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    req.subject,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor, letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${req.requestNumber} • Created on ${req.createdDate.day}/${req.createdDate.month}/${req.createdDate.year} • SLA Due in: ${_formatTimeRemaining(req.dueDate)}',
                    style: TextStyle(fontSize: 12, color: req.isOverdue ? Colors.red : textSecondaryColor, fontWeight: req.isOverdue ? FontWeight.w700 : FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: textSecondaryColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Customer & Project'),
                  Tab(text: 'Warranty & Billing'),
                  Tab(text: 'Tasks & Checklist'),
                  Tab(text: 'Visits & Evidence'),
                  Tab(text: 'Internal Notes'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Overview
                  _buildOverviewTab(req, backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),

                  // Tab 2: Customer & Project Context
                  _buildCustomerProjectTab(req, backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),

                  // Tab 3: Warranty & Billing
                  _buildWarrantyBillingTab(req, backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),

                  // Tab 4: Tasks
                  _buildTasksTab(req, backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),

                  // Tab 5: Visits & Evidence
                  _buildVisitsEvidenceTab(req, backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),

                  // Tab 6: Internal Notes
                  _buildNotesTab(req, backgroundColor, borderColor, textPrimaryColor, textSecondaryColor),
                ],
              ),
            ),

            // Footer Operational Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling customer ${req.customerName} at ${req.customerPhone}...')),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening WhatsApp chat with ${req.customerName}...')),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF25D366),
                      side: const BorderSide(color: Color(0xFF25D366)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const Spacer(),
                  if (widget.onScheduleVisit != null) ...[
                    ElevatedButton.icon(
                      onPressed: widget.onScheduleVisit,
                      icon: const Icon(Icons.calendar_today_rounded, size: 15),
                      label: const Text('Schedule Visit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (widget.onResolveRequest != null && req.status != ServiceRequestStatus.resolved && req.status != ServiceRequestStatus.closed) ...[
                    ElevatedButton.icon(
                      onPressed: widget.onResolveRequest,
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: const Text('Resolve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(ServiceRequest req, Color bg, Color border, Color textPrimary, Color textSecondary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detailed Description
          _buildInfoCard(
            title: 'Issue Description',
            content: req.description,
            icon: Icons.description_outlined,
            bg: bg,
            border: border,
            textPrimary: textPrimary,
          ),
          const SizedBox(height: 14),

          // Area & Location
          Row(
            children: [
              Expanded(
                child: _buildTile('Room / Area', req.areaRoom, Icons.room_preferences_outlined, textPrimary, textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTile('Specific Location', req.specificLocation, Icons.location_on_outlined, textPrimary, textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Customer Expectation
          _buildTile('Customer Expectation', req.customerExpectation, Icons.sentiment_satisfied_alt_outlined, textPrimary, textSecondary),
          const SizedBox(height: 14),

          // Assigned Technician & Role
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: const Icon(Icons.person_pin_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assigned Personnel', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600)),
                      Text(req.assignedToName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                      Text(req.assignedToRole, style: TextStyle(fontSize: 11, color: textSecondary)),
                    ],
                  ),
                ),
                if (widget.onAssignTechnician != null)
                  TextButton.icon(
                    onPressed: widget.onAssignTechnician,
                    icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                    label: const Text('Reassign'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Preferred Schedule
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  'Preferred Date',
                  '${req.preferredServiceDate.day}/${req.preferredServiceDate.month}/${req.preferredServiceDate.year}',
                  Icons.calendar_month_outlined,
                  textPrimary,
                  textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTile(
                  'Preferred Window',
                  req.preferredTime,
                  Icons.schedule_outlined,
                  textPrimary,
                  textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (req.availabilityNotes.isNotEmpty)
            _buildTile('Access & Availability Notes', req.availabilityNotes, Icons.key_outlined, textPrimary, textSecondary),
        ],
      ),
    );
  }

  Widget _buildCustomerProjectTab(ServiceRequest req, Color bg, Color border, Color textPrimary, Color textSecondary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Identity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
            child: Column(
              children: [
                _buildKeyValueRow('Customer Name', req.customerName, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Contact Phone', req.customerPhone, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Email Address', req.customerEmail, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Preferred Channel', req.preferredChannel, textPrimary, textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Project & Handover Dossier', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
            child: Column(
              children: [
                _buildKeyValueRow('Project Name', req.projectName, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Project ID', req.projectId, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Configuration', req.projectType, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Site Location', req.siteAddress, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Handover Date', '${req.handoverDate.day}/${req.handoverDate.month}/${req.handoverDate.year}', textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Project Manager', req.projectManager, textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Site Supervisor', req.supervisor, textPrimary, textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarrantyBillingTab(ServiceRequest req, Color bg, Color border, Color textPrimary, Color textSecondary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: req.isWarrantyCovered ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: req.isWarrantyCovered ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(req.isWarrantyCovered ? Icons.verified_rounded : Icons.monetization_on_outlined, color: req.isWarrantyCovered ? Colors.green : Colors.orange, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.isWarrantyCovered ? 'Active Warranty Coverage' : 'Billable Service Work',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: req.isWarrantyCovered ? Colors.green.shade800 : Colors.orange.shade800),
                      ),
                      Text(
                        req.billingStatus.label,
                        style: TextStyle(fontSize: 11, color: textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('Commercial & Cost Breakdown', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
            child: Column(
              children: [
                _buildKeyValueRow('Labour Cost Waiver', req.isWarrantyCovered ? '100% Free (Under Warranty)' : '₹1,500.00', textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Replacement Parts', req.isWarrantyCovered ? '100% Free (OEM Replacement)' : '₹2,500.00', textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Customer Payable', req.isWarrantyCovered ? '₹0.00' : '₹4,000.00', textPrimary, textSecondary),
                const Divider(height: 16),
                _buildKeyValueRow('Payment Link Status', req.paymentLinkSent ? 'Link Sent via WhatsApp' : 'Not Applicable (Free)', textPrimary, textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(ServiceRequest req, Color bg, Color border, Color textPrimary, Color textSecondary) {
    if (req.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist_rounded, size: 48, color: textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text('No operational sub-tasks created', style: TextStyle(fontSize: 13, color: textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: req.tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final task = req.tasks[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: task.isCompleted ? const Color(0xFF10B981) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                    Text(task.description, style: TextStyle(fontSize: 11, color: textSecondary)),
                    const SizedBox(height: 4),
                    Text('Assigned to: ${task.assignee} • Due: ${task.dueDate.day}/${task.dueDate.month}', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVisitsEvidenceTab(ServiceRequest req, Color bg, Color border, Color textPrimary, Color textSecondary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Linked Service Visits (${req.visitIds.length})', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 8),
          if (req.visitIds.isEmpty)
            Text('No visits recorded yet. Click "Schedule Visit" below.', style: TextStyle(fontSize: 12, color: textSecondary))
          else
            ...req.visitIds.map((vId) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)),
                child: Row(
                  children: [
                    const Icon(Icons.car_repair_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Visit ID: $vId • Scheduled with Technician Team', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 20),

          Text('Photo & Document Evidence (${req.attachments.length})', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 8),
          if (req.attachments.isEmpty)
            Text('No attachments uploaded.', style: TextStyle(fontSize: 12, color: textSecondary))
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: req.attachments.map((att) {
                return Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          att.fileUrl,
                          width: double.infinity,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 90,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, size: 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(att.fileName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(att.uploadedBy, style: TextStyle(fontSize: 9, color: textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(ServiceRequest req, Color bg, Color border, Color textPrimary, Color textSecondary) {
    return Column(
      children: [
        Expanded(
          child: _localNotes.isEmpty
              ? Center(child: Text('No internal notes recorded.', style: TextStyle(color: textSecondary, fontSize: 12)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _localNotes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final note = _localNotes[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(note.authorName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary)),
                              Text('${note.timestamp.day}/${note.timestamp.month} ${note.timestamp.hour}:${note.timestamp.minute.toString().padLeft(2, '0')}', style: TextStyle(fontSize: 10, color: textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(note.note, style: TextStyle(fontSize: 12, color: textPrimary)),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: border))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteCtrl,
                  decoration: InputDecoration(
                    hintText: 'Add internal note (strictly internal, not visible to customer)...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final text = _noteCtrl.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _localNotes.add(
                        InternalNote(
                          id: 'NT-${DateTime.now().millisecondsSinceEpoch}',
                          authorName: 'Support Executive',
                          authorRole: 'After-Sales Team',
                          timestamp: DateTime.now(),
                          note: text,
                        ),
                      );
                      _noteCtrl.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                child: const Text('Add Note'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required String content, required IconData icon, required Color bg, required Color border, required Color textPrimary}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(content, style: TextStyle(fontSize: 13, height: 1.4, color: textPrimary)),
        ],
      ),
    );
  }

  Widget _buildTile(String label, String value, IconData icon, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getBackground(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value, Color textPrimary, Color textSecondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: TextStyle(fontSize: 12, color: textSecondary)),
        Flexible(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary), textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  String _formatTimeRemaining(DateTime due) {
    final diff = due.difference(DateTime.now());
    if (diff.isNegative) return 'SLA BREACHED (${diff.inHours.abs()}h overdue)';
    if (diff.inHours > 24) return '${diff.inDays} days';
    return '${diff.inHours} hours';
  }
}
