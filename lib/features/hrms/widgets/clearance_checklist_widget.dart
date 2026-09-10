import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_enums.dart';
import 'hrms_status_badge.dart';

class ClearanceChecklistWidget extends StatefulWidget {
  final String resignationId;

  const ClearanceChecklistWidget({super.key, required this.resignationId});

  @override
  State<ClearanceChecklistWidget> createState() => _ClearanceChecklistWidgetState();
}

class _ClearanceChecklistWidgetState extends State<ClearanceChecklistWidget> {
  final _repo = HrmsRepository();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clearances = _repo.clearances.where((c) => c.resignationId == widget.resignationId).toList();
    final handovers = _repo.handoverChecklists.where((h) => h.resignationId == widget.resignationId).toList();

    final totalClearances = clearances.length;
    final approvedCount = clearances.where((c) => c.status == ClearanceStatus.approved).length;
    final progress = totalClearances > 0 ? (approvedCount / totalClearances) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: AppRadius.md,
                    ),
                    child: const Icon(Icons.fact_check_outlined, size: 20, color: Color(0xFF8B5CF6)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Departmental Exit Clearance & No-Dues',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '$approvedCount of $totalClearances Departments Signed Off (${(progress * 100).toInt()}%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 120,
                height: 8,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: progress == 1.0 ? const Color(0xFF10B981) : const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Clearances list
          ...clearances.map((clr) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clr.department,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        if (clr.remarks.isNotEmpty)
                          Text(
                            clr.remarks,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Signed by: ${clr.clearedBy}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  HrmsStatusBadge.clearance(clr.status),
                  const SizedBox(width: 8),
                  if (clr.status == ClearanceStatus.pending)
                    OutlinedButton(
                      onPressed: () {
                        _repo.updateClearanceStatus(
                          clr.id,
                          ClearanceStatus.approved,
                          remarks: 'Verified and signed off by authorized department lead.',
                        );
                        setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: Color(0xFF10B981)),
                        foregroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text('Signoff', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
            );
          }),

          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),

          // Handover Items Checklist
          Text(
            'Physical & Digital Handover Tasks',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          ...handovers.map((h) {
            return CheckboxListTile(
              value: h.isCompleted,
              onChanged: (_) {
                _repo.toggleHandoverItem(h.id);
                setState(() {});
              },
              title: Text(
                h.item,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  decoration: h.isCompleted ? TextDecoration.lineThrough : null,
                  color: h.isCompleted
                      ? (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))
                      : (isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
              ),
              subtitle: Text(
                'Assignee: ${h.assigneeName} (${h.category})',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8)),
              ),
              dense: true,
              activeColor: const Color(0xFF10B981),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
        ],
      ),
    );
  }
}
