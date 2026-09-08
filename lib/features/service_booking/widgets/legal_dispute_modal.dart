import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class LegalDisputeModal extends StatefulWidget {
  final ServiceBooking? booking;
  final Function(DisputeCase newCase) onDisputeFiled;

  const LegalDisputeModal({
    super.key,
    this.booking,
    required this.onDisputeFiled,
  });

  @override
  State<LegalDisputeModal> createState() => _LegalDisputeModalState();
}

class _LegalDisputeModalState extends State<LegalDisputeModal> {
  final _formKey = GlobalKey<FormState>();

  DisputeScenario _disputeScenario = DisputeScenario.clientNonPayment;
  String _assignedLawyer = 'Adv. Rajeshwar Swaroop (Supreme Court & Delhi High Court)';
  String _lawyerBarNo = 'D/1492/2004';
  String _courtJurisdiction = 'Labour Court No. 2, Gurugram / Saket Courts';

  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _respondentController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  bool _attachDossier = true;
  bool _sendStatutoryNotice = true;
  bool _applyBlacklistHold = true;

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      _claimAmountController.text = widget.booking!.balanceDue.toStringAsFixed(0);
      _respondentController.text = widget.booking!.clientName;
      _projectController.text = widget.booking!.projectName;
      _summaryController.text = 'Client defaulted on paying verified balance due of ₹${widget.booking!.balanceDue.toStringAsFixed(0)} for ${widget.booking!.tradesmanName} despite signed daily site supervisor checklists. Demanding immediate release with 18% statutory interest.';
    } else {
      _claimAmountController.text = '45000';
      _respondentController.text = 'Defaulting Party';
      _projectController.text = 'PRJ-104 - 4BHK DLF Phase 5';
      _summaryController.text = 'Formal legal dispute escalation regarding breach of contract and unpaid wage settlement.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final bgColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 740,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                border: Border(bottom: BorderSide(color: AppColors.error.withValues(alpha: 0.2))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.gavel_rounded, color: AppColors.error, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Legal Dispute & Labour Court Escalation Hub',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Initiate formal statutory recovery proceedings, panel lawyer assignment, & evidence compilation',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textSecondary),
                  ),
                ],
              ),
            ),

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scenario Selection
                      Text(
                        '1. Dispute Nature & Breach Scenario',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<DisputeScenario>(
                        initialValue: _disputeScenario,
                        dropdownColor: surfaceColor,
                        style: TextStyle(color: textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Dispute Scenario',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: bgColor,
                        ),
                        items: DisputeScenario.values.map((s) {
                          return DropdownMenuItem(value: s, child: Text(s.label, style: TextStyle(color: textPrimary)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _disputeScenario = val;
                              if (val == DisputeScenario.clientNonPayment) {
                                _summaryController.text = 'Client defaulted on paying verified worker dues. Escalating for Section 138 / Labour Court recovery.';
                              } else if (val == DisputeScenario.labourAbandonment) {
                                _summaryController.text = 'Worker absconded from site without notice. Triggering strike penalty, advance forfeiture & emergency backup dispatch.';
                              } else {
                                _summaryController.text = 'Severe craftsmanship defect and material wastage. Initiating mediation for rework or contractor refund.';
                              }
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Project & Respondent Details
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _projectController,
                              style: TextStyle(color: textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Project Reference',
                                prefixIcon: const Icon(Icons.apartment_outlined, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: bgColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _respondentController,
                              style: TextStyle(color: textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Respondent / Defaulting Party',
                                prefixIcon: const Icon(Icons.person_outline, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: bgColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _claimAmountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Claim / Disputed Amount (₹)',
                          prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: bgColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section 2: Empanelled Lawyer Assignment
                      Text(
                        '2. Company Empanelled Legal Counsel',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _assignedLawyer,
                        dropdownColor: surfaceColor,
                        style: TextStyle(color: textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'Assigned Panel Advocate (Zero Upfront Cost to Worker)',
                          prefixIcon: const Icon(Icons.account_balance_rounded, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: bgColor,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Adv. Rajeshwar Swaroop (Supreme Court & Delhi High Court)',
                            child: Text('Adv. Rajeshwar Swaroop (Bar: D/1492/2004 - Labour Specialist)', style: TextStyle(color: textPrimary)),
                          ),
                          DropdownMenuItem(
                            value: 'Adv. Meenakshi Sundaram (Corporate Legal Counsel)',
                            child: Text('Adv. Meenakshi Sundaram (Bar: D/882/2012 - Commercial Arbitration)', style: TextStyle(color: textPrimary)),
                          ),
                          DropdownMenuItem(
                            value: 'Adv. Alok Ranjan Verma',
                            child: Text('Adv. Alok Ranjan Verma (Bar: MAH/3104/2008 - Industrial Law)', style: TextStyle(color: textPrimary)),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _assignedLawyer = val;
                              if (val.contains('Rajeshwar')) {
                                _lawyerBarNo = 'D/1492/2004';
                                _courtJurisdiction = 'Labour Court No. 2, Gurugram / Saket Courts';
                              } else if (val.contains('Meenakshi')) {
                                _lawyerBarNo = 'D/882/2012';
                                _courtJurisdiction = 'Saket District Court & RERA Haryana';
                              } else {
                                _lawyerBarNo = 'MAH/3104/2008';
                                _courtJurisdiction = 'Bombay High Court & City Civil Court';
                              }
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Section 3: Legal Notice & Evidence Dossier
                      Text(
                        '3. Statutory Notice & Evidence Package',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _summaryController,
                        maxLines: 3,
                        style: TextStyle(color: textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Legal Recourse Summary & Evidence Description',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: bgColor,
                        ),
                      ),

                      const SizedBox(height: 14),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _attachDossier,
                        activeColor: AppColors.error,
                        title: Text(
                          'Auto-compile Certified Digital Evidence Dossier (GPS check-ins, signed supervisor checklists, site photos & WhatsApp logs).',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                        onChanged: (val) => setState(() => _attachDossier = val ?? false),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _sendStatutoryNotice,
                        activeColor: AppColors.error,
                        title: Text(
                          'Issue 15-day Statutory Legal Notice to respondent via registered Speed Post & WhatsApp API.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                        onChanged: (val) => setState(() => _sendStatutoryNotice = val ?? false),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _applyBlacklistHold,
                        activeColor: AppColors.error,
                        title: Text(
                          'Downgrade credit rating and place temporary booking freeze / blacklist flag on respondent profile.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                        onChanged: (val) => setState(() => _applyBlacklistHold = val ?? false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      final newCase = DisputeCase(
                        id: 'DSP-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                        caseNumber: 'LEGAL-DISP-2024-${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}',
                        bookingId: widget.booking?.id ?? 'BK-DIRECT',
                        projectId: widget.booking?.projectId ?? 'PRJ-104',
                        projectName: _projectController.text,
                        initiator: widget.booking?.tradesmanName ?? 'Homio Legal Panel',
                        respondent: _respondentController.text,
                        disputeType: _disputeScenario,
                        amountInDispute: double.tryParse(_claimAmountController.text) ?? 45000.0,
                        dateFiled: DateTime.now(),
                        assignedLawyerName: _assignedLawyer,
                        lawyerBarCouncilNo: _lawyerBarNo,
                        courtJurisdiction: _courtJurisdiction,
                        legalStatus: DisputeLegalStatus.legalNoticeSent,
                        evidenceDossierUrl: 'https://docs.homiocrm.com/dossier/LEGAL-DOSSIER-AUTO.pdf',
                        strikesCount: _disputeScenario == DisputeScenario.labourAbandonment ? 1 : 0,
                        replacementDispatched: _disputeScenario == DisputeScenario.labourAbandonment,
                        resolutionSummary: _summaryController.text,
                        auditTrail: [
                          '${DateTime.now().toString().substring(0, 10)}: Formal case registered in Homio Legal Dispute Hub.',
                          '${DateTime.now().toString().substring(0, 10)}: Assigned legal counsel $_assignedLawyer.',
                          if (_sendStatutoryNotice) '${DateTime.now().toString().substring(0, 10)}: 15-Day Statutory Legal Notice drafted and served.',
                        ],
                        isClientBlacklisted: _disputeScenario == DisputeScenario.clientNonPayment && _applyBlacklistHold,
                        isLabourBlacklisted: _disputeScenario == DisputeScenario.labourAbandonment && _applyBlacklistHold,
                      );
                      widget.onDisputeFiled(newCase);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.security_update_warning_rounded, size: 16),
                    label: const Text('File Dispute & Issue Notice'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
