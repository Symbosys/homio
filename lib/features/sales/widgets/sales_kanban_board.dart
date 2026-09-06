import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../dashboard/widgets/compact_data_table.dart';
import '../models/sales_models.dart';
import 'lead_detail_modal.dart';

/// Interactive Multi-Stage Kanban Board for Sales Pipelines
class SalesKanbanBoard extends StatelessWidget {
  final List<SalesFunnelStage> stages;
  final List<SalesLeadItem> leads;
  final ValueChanged<SalesLeadItem> onLeadUpdated;

  const SalesKanbanBoard({
    super.key,
    required this.stages,
    required this.leads,
    required this.onLeadUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 640,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stages.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final stage = stages[index];
          final stageLeads = leads.where((l) => l.stageId == stage.id).toList();
          final totalValue = stageLeads.fold(0.0, (sum, l) => sum + l.budgetAmount);

          return Container(
            width: 280,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Column Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: stage.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          stage.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: stage.color.withValues(alpha: isDark ? 0.2 : 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${stageLeads.length}',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: stage.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stage Value Summary Strip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pipeline Value:',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        '₹${totalValue.toStringAsFixed(1)}L',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Cards List
                Expanded(
                  child: stageLeads.isEmpty
                      ? Center(
                          child: Text(
                            'No leads in stage',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.6) : AppColors.lightTextSecondary.withValues(alpha: 0.6),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          itemCount: stageLeads.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, leadIndex) {
                            final lead = stageLeads[leadIndex];
                            return _buildKanbanCard(context, lead, stage, isDark);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKanbanCard(BuildContext context, SalesLeadItem lead, SalesFunnelStage stage, bool isDark) {
    return InkWell(
      onTap: () {
        LeadDetailModal.show(
          context,
          lead: lead,
          stages: stages,
          onLeadUpdated: onLeadUpdated,
        );
      },
      borderRadius: AppRadius.sm,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.sm,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Client Name + Budget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    lead.clientName,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '₹${lead.budgetAmount}L',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),

            // Project Type
            Text(
              lead.projectType,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    lead.siteAddress,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Source & Tags
            Row(
              children: [
                DashboardBadge(label: lead.source, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    lead.nextFollowupTime,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: lead.isFollowupOverdue ? FontWeight.w700 : FontWeight.w500,
                      color: lead.isFollowupOverdue ? const Color(0xFFEF4444) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 6),

            // Action Bar: Quick Call & WhatsApp & Stage Mover
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dialing ${lead.phone}...'), behavior: SnackBarBehavior.floating),
                        );
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.phone, size: 12, color: Color(0xFF10B981)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening WhatsApp with ${lead.clientName}'), behavior: SnackBarBehavior.floating),
                        );
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.chat, size: 12, color: Color(0xFF25D366)),
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.drive_file_move_outlined, size: 15),
                  tooltip: 'Move Stage',
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) {
                    return stages.map((s) {
                      return PopupMenuItem<String>(
                        value: s.id,
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(s.name, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (newStageId) {
                    final updated = lead.copyWith(stageId: newStageId);
                    onLeadUpdated(updated);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
