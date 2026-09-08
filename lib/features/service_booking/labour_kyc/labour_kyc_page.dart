import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/labour_kyc_modal.dart';
import '../widgets/labour_id_card_modal.dart';

class LabourKycPage extends StatefulWidget {
  const LabourKycPage({super.key});

  @override
  State<LabourKycPage> createState() => _LabourKycPageState();
}

class _LabourKycPageState extends State<LabourKycPage> {
  final List<LabourKycDocument> _kycList = List.from(LabourMockData.kycDocuments);
  String _searchQuery = '';
  KycStatus? _selectedKycStatus;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    var filtered = _kycList.where((doc) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = doc.workerName.toLowerCase().contains(q) ||
            doc.workerId.toLowerCase().contains(q) ||
            doc.aadhaarNumber.toLowerCase().contains(q) ||
            doc.policeStationName.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedKycStatus != null && doc.status != _selectedKycStatus) return false;
      return true;
    }).toList();

    final approvedCount = _kycList.where((d) => d.status == KycStatus.approved).length;
    final reviewCount = _kycList.where((d) => d.status == KycStatus.underReview || d.status == KycStatus.pending).length;
    final biometricCount = _kycList.where((d) => d.status == KycStatus.biometricsVerified).length;
    final rejectedCount = _kycList.where((d) => d.status == KycStatus.rejected).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Labour KYC Onboarding & Biometrics',
              subtitle: 'Mandatory Aadhaar OCR verification, live facial biometric matching, police clearance checks, and trade skill testing.',
              activeTab: 'Labour KYC & Security',
              trailing: ElevatedButton.icon(
                onPressed: () => _openNewWorkerRegistration(context),
                icon: const Icon(Icons.person_add_alt_rounded, size: 16),
                label: const Text('Onboard New Tradesman'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Scoreboard
                  Row(
                    children: [
                      _buildKycMetric(
                        title: 'Total Onboarding Files',
                        value: '${_kycList.length}',
                        subtitle: 'Registered tradesmen',
                        icon: Icons.folder_shared_outlined,
                        color: AppColors.primary,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildKycMetric(
                        title: 'Approved & Verified',
                        value: '$approvedCount',
                        subtitle: '100% compliant badge',
                        icon: Icons.verified_user_rounded,
                        color: const Color(0xFF10B981),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildKycMetric(
                        title: 'Biometric Verified',
                        value: '$biometricCount',
                        subtitle: 'Face match passed',
                        icon: Icons.face_retouching_natural_rounded,
                        color: const Color(0xFF06B6D4),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildKycMetric(
                        title: 'Under OCR Review',
                        value: '$reviewCount',
                        subtitle: 'Pending admin sign',
                        icon: Icons.pending_actions_rounded,
                        color: const Color(0xFFF59E0B),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildKycMetric(
                        title: 'Rejected / High Risk',
                        value: '$rejectedCount',
                        subtitle: 'Absconded / Discrepancy',
                        icon: Icons.gavel_rounded,
                        color: AppColors.error,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search and Filter Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search by worker name, worker ID, Aadhaar number, or police station...',
                                  prefixIcon: const Icon(Icons.search, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<KycStatus?>(
                                initialValue: _selectedKycStatus,
                                decoration: InputDecoration(
                                  labelText: 'KYC Status Filter',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Verification Stages')),
                                  ...KycStatus.values.map((st) {
                                    return DropdownMenuItem(value: st, child: Text(st.label));
                                  }),
                                ],
                                onChanged: (val) => setState(() => _selectedKycStatus = val),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Filter Pills
                        Row(
                          children: [
                            _buildFilterPill('All Applications (${_kycList.length})', null, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterPill('Under Review ($reviewCount)', KycStatus.underReview, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterPill('Biometrics Done ($biometricCount)', KycStatus.biometricsVerified, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterPill('Approved ($approvedCount)', KycStatus.approved, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterPill('Rejected ($rejectedCount)', KycStatus.rejected, surfaceColor, borderColor, textSecondaryColor),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // KYC Records Table
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            border: Border(bottom: BorderSide(color: borderColor)),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text('Worker & Identity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor))),
                              Expanded(flex: 2, child: Text('Government Aadhaar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor))),
                              Expanded(flex: 2, child: Text('Police Clearance & PS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor))),
                              Expanded(flex: 2, child: Text('Skill Test Score', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor))),
                              Expanded(flex: 2, child: Text('KYC Stage & Risk', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor))),
                              SizedBox(width: 140, child: Text('Verification Action', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor))),
                            ],
                          ),
                        ),

                        // Table Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => Divider(height: 1, color: borderColor),
                          itemBuilder: (context, index) {
                            final doc = filtered[index];
                            final statusColor = doc.status.color;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              child: Row(
                                children: [
                                  // Worker Info
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            doc.selfiePhotoUrl,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => Container(
                                              height: 40,
                                              width: 40,
                                              color: borderColor,
                                              child: const Icon(Icons.person, size: 20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doc.workerName,
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'ID: ${doc.workerId} • Submitted ${_formatDate(doc.submissionDate)}',
                                                style: TextStyle(fontSize: 11, color: textMutedColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Aadhaar
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.credit_card, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 6),
                                        Text(
                                          doc.aadhaarNumber,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Police Verification
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.policeStationName,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Text(
                                          'CCTNS Sync Verified',
                                          style: TextStyle(fontSize: 10, color: Color(0xFF10B981)),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Trade Score
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${doc.tradeTestScore}% Score',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                        ),
                                        Text(
                                          doc.tradeGrade,
                                          style: TextStyle(fontSize: 11, color: textSecondaryColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Status & Risk
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            doc.status.label,
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          doc.riskLevel,
                                          style: TextStyle(fontSize: 10, color: textMutedColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action Buttons
                                  SizedBox(
                                    width: 140,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () => _openKycModal(context, doc),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            side: const BorderSide(color: AppColors.primary),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          ),
                                          child: const Text('Review KYC', style: TextStyle(fontSize: 11)),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          icon: Icon(Icons.badge_outlined, size: 18, color: textSecondaryColor),
                                          tooltip: 'View Digital ID Card',
                                          onPressed: () => _openIdCardForWorkerId(context, doc.workerId),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _buildKycMetric({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color textMutedColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: textMutedColor)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, KycStatus? status, Color surfaceColor, Color borderColor, Color textSecondaryColor) {
    final isSelected = _selectedKycStatus == status;
    return InkWell(
      onTap: () => setState(() => _selectedKycStatus = status),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : textSecondaryColor,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _openKycModal(BuildContext context, LabourKycDocument doc) {
    showDialog(
      context: context,
      builder: (ctx) => LabourKycModal(
        kycDoc: doc,
        onVerify: (status, notes) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('KYC record for ${doc.workerName} updated to $status.')),
          );
        },
      ),
    );
  }

  void _openIdCardForWorkerId(BuildContext context, String workerId) {
    final worker = LabourMockData.profiles.firstWhere(
      (w) => w.id == workerId,
      orElse: () => LabourMockData.profiles.first,
    );
    showDialog(
      context: context,
      builder: (ctx) => LabourIdCardModal(worker: worker),
    );
  }

  void _openNewWorkerRegistration(BuildContext context) {
    context.push(RouteNames.srvOnboardLabourPath);
  }
}
