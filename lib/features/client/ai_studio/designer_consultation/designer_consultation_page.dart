import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_studio_mock_data.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class DesignerConsultationPage extends StatefulWidget {
  const DesignerConsultationPage({super.key});

  @override
  State<DesignerConsultationPage> createState() => _DesignerConsultationPageState();
}

class _DesignerConsultationPageState extends State<DesignerConsultationPage> {
  final List<ExpertDesignerProfile> _designers = AiStudioMockData.getDesignerProfiles();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookings = AiStudioService.instance.designerBookings;

    return AiStudioPageScaffold(
      title: '1-on-1 Designer Consultation',
      subtitle: 'Book 30-Minute Video Review Sessions with Senior Interior Architects & Mark Up Blueprints Live',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active / Confirmed Bookings Section
          if (bookings.isNotEmpty) ...[
            Text(
              'Your Scheduled Consultation Sessions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 14),
            ...bookings.map((b) => _buildBookingCard(context, b, isDark)),
            const SizedBox(height: 28),
          ],

          // Designer Profiles Header
          Row(
            children: [
              Text(
                'Available Senior Architects & Stylists',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: AppRadius.xs,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.videocam_rounded, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'Live Video & Whiteboard Ready',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Designer Profiles Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 768;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _designers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isDesktop ? 1.5 : 1.3,
                ),
                itemBuilder: (context, index) {
                  final designer = _designers[index];
                  return ExpertConsultationCard(
                    designer: designer,
                    onBookSlot: (slot) => _showBookingDialog(context, designer, slot),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 28),

          // How It Works Guidance
          _buildHowItWorksBanner(context, isDark),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, DesignerBooking booking, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2433) : const Color(0xFFEFF6FF),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF3B4863) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(Icons.video_camera_front_rounded, color: AppColors.primaryLight, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      booking.designer.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: AppRadius.xs,
                      ),
                      child: Text(
                        'CONFIRMED',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${booking.durationText} · Topic: ${booking.roomTopic}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connecting to live whiteboard session: ${booking.videoMeetingRoomUrl ?? ""}'),
                ),
              );
            },
            icon: const Icon(Icons.call_rounded, size: 16),
            label: Text(
              'Join Video Room',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How 1-on-1 Designer Sessions Work',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepPill('1', 'Select Time Slot', 'Pick a 30-minute opening with your preferred specialist.'),
              const SizedBox(width: 16),
              _buildStepPill('2', 'Link 3D Renders', 'Attach your AI room renders and material specs for review.'),
              const SizedBox(width: 16),
              _buildStepPill('3', 'Live Markup', 'Join the video call to markup blueprints and finalize plans.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepPill(String number, String title, String description) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context, ExpertDesignerProfile designer, String timeSlot) {
    final topicCtrl = TextEditingController(text: 'Living Room 3D Layout Review');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Confirm Video Consultation',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Architect: ${designer.name}',
                style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              Text(
                'Time Slot: Today, $timeSlot (30 Minutes)',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.primaryLight),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: topicCtrl,
                decoration: const InputDecoration(
                  labelText: 'Discussion Focus / Topic',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: AppRadius.md,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Included in your HOMIO Turnkey Project Plan (No extra charge)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
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
              AiStudioService.instance.bookDesignerSession(
                designer: designer,
                scheduledDate: DateTime.now(),
                timeSlot: timeSlot,
                roomTopic: topicCtrl.text.trim().isNotEmpty ? topicCtrl.text.trim() : 'Design Consultation',
              );
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Session booked with ${designer.name} for $timeSlot!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
