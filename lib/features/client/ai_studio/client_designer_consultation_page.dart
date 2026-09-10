import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../ai_suite/models/ai_suite_models.dart';
import '../../ai_suite/models/ai_suite_mock_data.dart';
import '../../ai_suite/widgets/video_consultation_room.dart';

class ClientDesignerConsultationPage extends StatefulWidget {
  const ClientDesignerConsultationPage({super.key});

  @override
  State<ClientDesignerConsultationPage> createState() => _ClientDesignerConsultationPageState();
}

class _ClientDesignerConsultationPageState extends State<ClientDesignerConsultationPage> {
  final List<DesignerConsultant> _roster = AiSuiteMockData.designerRoster;
  DesignerConsultant? _activeVideoCall;
  String _selectedSpecialization = 'All';

  void _bookSession(DesignerConsultant expert) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.video_camera_front_rounded, color: Color(0xFF7C3AED), size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                'Confirm Consultation Booking',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are booking an instant 30-minute 1-on-1 video call with ${expert.name} (${expert.title}).',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Duration:'),
                        Text('30 Minutes Live', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Consultation Fee:'),
                        Text(
                          '₹${expert.sessionFee.toInt()} Fixed',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Includes:'),
                        Text('Live Whiteboard + Summary Dossier',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: const Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);

                // Add to booked sessions in shared mock data
                AiSuiteMockData.bookedSessions.insert(
                  0,
                  BookedConsultationSession(
                    id: 'SESS-${DateTime.now().millisecondsSinceEpoch}',
                    clientName: 'You (Current Client)',
                    clientPhone: '+91 98765 43210',
                    expert: expert,
                    scheduledTime: DateTime.now(),
                    feePaid: expert.sessionFee,
                    status: 'Active / In Progress',
                  ),
                );

                setState(() => _activeVideoCall = expert);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
              child: Text('Pay ₹${expert.sessionFee.toInt()} & Join Room'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 800;

    // Active Video Consultation Room View
    if (_activeVideoCall != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0F19),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VideoConsultationRoom(
            designer: _activeVideoCall!,
            onEndCall: () => setState(() => _activeVideoCall = null),
          ),
        ),
      );
    }

    // Extract all unique specializations
    final allSpecs = {'All'};
    for (final exp in _roster) {
      allSpecs.addAll(exp.specializations);
    }

    final filtered = _selectedSpecialization == 'All'
        ? _roster
        : _roster.where((exp) => exp.specializations.contains(_selectedSpecialization)).toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Client Header Banner
                Container(
                  padding: EdgeInsets.all(isMobile ? 18 : 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF2E1065), const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                          : [const Color(0xFFFAF5FF), const Color(0xFFEEF2FF), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.video_camera_front_rounded, size: 14, color: Color(0xFF7C3AED)),
                            const SizedBox(width: 6),
                            Text(
                              'INSTANT 1-ON-1 VIDEO CONSULTATION',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: const Color(0xFF7C3AED),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Book 30-Min Video Call with Certified Interior Architects',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isMobile ? 20 : 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Get instant professional design advice, evaluate floor plans with interactive live sketching whiteboard, and receive actionable BOQ material recommendations.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isMobile ? 13 : 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Filter by Specialization Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: allSpecs.map((spec) {
                      final isSelected = _selectedSpecialization == spec;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(spec),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedSpecialization = spec);
                          },
                          selectedColor: const Color(0xFF7C3AED),
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Experts Available Cards Grid
                Text(
                  'Verified Experts Available for Consultation (${filtered.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 560,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: isMobile ? 320 : 270,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final expert = filtered[i];
                    return _buildClientExpertCard(expert, isDark);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientExpertCard(DesignerConsultant exp, bool isDark) {
    final isOnline = exp.availability == DesignerAvailability.online;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOnline
              ? const Color(0xFF10B981).withValues(alpha: 0.5)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: isOnline ? 1.6 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  exp.avatarUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 56,
                    height: 56,
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                    child: const Icon(Icons.person_rounded, color: Color(0xFF7C3AED)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            exp.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: exp.availability.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            exp.availability.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: exp.availability.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      exp.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                    Text(
                      exp.qualification,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Experience & Rating
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildPill('★ ${exp.rating}', const Color(0xFFF59E0B)),
              _buildPill('${exp.yearsExperience} Yrs Experience', const Color(0xFF6366F1)),
              _buildPill('${exp.totalConsultations} Consults', const Color(0xFF10B981)),
            ],
          ),

          const SizedBox(height: 8),

          // Specializations
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: exp.specializations.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  s,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),

          const Spacer(),

          // Price set by admin & Book button
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SESSION FEE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    '₹${exp.sessionFee.toInt()} / 30 mins',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: isOnline ? () => _bookSession(exp) : null,
                icon: const Icon(Icons.video_call_rounded, size: 18),
                label: Text(isOnline ? 'Book Call (₹${exp.sessionFee.toInt()})' : 'Next Slot at 4 PM'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
