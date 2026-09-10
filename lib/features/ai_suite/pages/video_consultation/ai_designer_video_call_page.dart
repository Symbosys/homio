import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/compact_ai_suite_actions.dart';
import '../../widgets/video_consultation_room.dart';

class AiDesignerVideoCallPage extends StatefulWidget {
  const AiDesignerVideoCallPage({super.key});

  @override
  State<AiDesignerVideoCallPage> createState() => _AiDesignerVideoCallPageState();
}

class _AiDesignerVideoCallPageState extends State<AiDesignerVideoCallPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _selectedSpecializationFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = AiSuiteRepository.instance;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          return Column(
            children: [
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF111827) : Colors.white,
                  border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Designer Video Calls',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20, child: VerticalDivider(width: 1, thickness: 1)),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFFEC4899),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFFEC4899),
                        indicatorWeight: 2,
                        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                        tabs: [
                          Tab(icon: const Icon(Icons.people_outline_rounded, size: 15), text: 'Find Designer (${repo.designers.length})'),
                          const Tab(icon: Icon(Icons.calendar_month_outlined, size: 15), text: 'Availability'),
                          Tab(icon: const Icon(Icons.video_call_outlined, size: 15), text: 'Upcoming Calls (${repo.consultations.where((c) => c.meetingStatus == 'Scheduled').length})'),
                          Tab(icon: const Icon(Icons.history_outlined, size: 15), text: 'Past Calls (${repo.consultations.where((c) => c.meetingStatus == 'Completed').length})'),
                          const Tab(icon: Icon(Icons.currency_rupee_rounded, size: 15), text: 'History & 50/50 Splits'),
                        ],
                      ),
                    ),
                    const CompactAiSuiteActions(),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFindDesignerTab(context, isDark, repo),
                    _buildAvailabilityTab(context, isDark, repo),
                    _buildUpcomingCallsTab(context, isDark, repo),
                    _buildPastCallsTab(context, isDark, repo),
                    _buildSplitsLedgerTab(context, isDark, repo),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================================
  // TAB 1: FIND DESIGNER (MARKETPLACE GRID)
  // ==========================================================================
  Widget _buildFindDesignerTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ['All', 'Luxury Contemporary', 'Modular Kitchens', 'Scandinavian', 'Vastu Compliance'].map((f) {
              final isSel = _selectedSpecializationFilter == f;
              return ChoiceChip(
                visualDensity: VisualDensity.compact,
                selected: isSel,
                label: Text(f, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)), fontWeight: FontWeight.w600)),
                selectedColor: const Color(0xFFEC4899),
                onSelected: (_) => setState(() => _selectedSpecializationFilter = f),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Designer Cards Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repo.designers.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 215,
            ),
            itemBuilder: (context, index) {
              final d = repo.designers[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 20, backgroundImage: NetworkImage(d.avatarUrl)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        d.name,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                                  ],
                                ),
                                Text(d.specialization, style: const TextStyle(fontSize: 11, color: Color(0xFFEC4899), fontWeight: FontWeight.w600)),
                                Text('${d.experienceYears}y exp • ${d.consultationsCount} calls • ★ ${d.rating}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(d.bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₹${d.consultationFee.toInt()} / 30m', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                              Text('50% Designer / 50% Homio', style: GoogleFonts.plusJakartaSans(fontSize: 8, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _openBookingModal(context, d, repo),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEC4899),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text('Book Call'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 8-Step Booking Modal
  void _openBookingModal(BuildContext context, DesignerProfile designer, AiSuiteRepository repo) {
    String type = 'Interior Design';
    String timeSlot = designer.availableSlots.first;
    final topicCtrl = TextEditingController(text: '3BHK Living Room & Kitchen Review');
    final descCtrl = TextEditingController(text: 'Need senior designer opinion on space optimization and material selection.');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Book 30-Min Call with ${designer.name}', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consultation Type', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8))),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  isDense: true,
                  initialValue: type,
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Interior Design', child: Text('Interior Design Review', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Vastu', child: Text('Vastu Energy Review', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Material Selection', child: Text('Material & Hardware Review', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Budget Review', child: Text('Budget & Quotation Audit', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) => type = v!,
                ),
                const SizedBox(height: 10),
                Text('Select Available Time Slot', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8))),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  isDense: true,
                  initialValue: timeSlot,
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder()),
                  items: designer.availableSlots.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => timeSlot = v!,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: topicCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(labelText: 'Meeting Topic', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(labelText: 'Description / Questions', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payable Fee (30 Mins):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('₹${designer.consultationFee.toInt()} (Incl. GST)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                repo.bookConsultation(
                  designer: designer,
                  clientName: 'Rahul Sharma',
                  clientPhone: '+91 98765 43210',
                  clientEmail: 'rahul.sharma@gmail.com',
                  projectName: 'DLF Phase 5 Penthouse',
                  consultationType: type,
                  scheduledDate: DateTime.now().add(const Duration(hours: 4)),
                  timeSlot: timeSlot,
                  topic: topicCtrl.text,
                  description: descCtrl.text,
                  fee: designer.consultationFee,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Video Consultation with ${designer.name} booked successfully!'), backgroundColor: const Color(0xFF10B981)),
                );
                _tabController.animateTo(2); // Jump to Upcoming Calls
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC4899),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              child: const Text('Confirm & Pay ₹300'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================================
  // TAB 2: AVAILABILITY CALENDAR
  // ==========================================================================
  Widget _buildAvailabilityTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.designers.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final d = repo.designers[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${d.name} (${d.specialization})', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: d.availableSlots.map((slot) {
                    return ActionChip(
                      visualDensity: VisualDensity.compact,
                      avatar: const Icon(Icons.access_time_rounded, size: 12),
                      label: Text(slot, style: const TextStyle(fontSize: 11)),
                      onPressed: () => _openBookingModal(context, d, repo),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 3: UPCOMING CALLS & ROOM SIMULATION
  // ==========================================================================
  Widget _buildUpcomingCallsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final upcoming = repo.consultations.where((c) => c.meetingStatus == 'Scheduled').toList();

    if (upcoming.isEmpty) {
      return Center(
        child: Text('No upcoming video consultations scheduled.', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: upcoming.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final c = upcoming[index];
        return Card(
          child: ListTile(
            dense: true,
            leading: CircleAvatar(radius: 18, backgroundImage: NetworkImage(c.designer.avatarUrl)),
            title: Text(c.topic, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text('Designer: ${c.designer.name} • ${c.timeSlot} • Status: ${c.meetingStatus}', style: const TextStyle(fontSize: 11)),
            trailing: Wrap(
              spacing: 6,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoConsultationRoom(
                          designerName: c.designer.name,
                          consultationTopic: c.topic,
                          clientName: c.clientName,
                          onEndCall: () {
                            repo.submitConsultationFeedback(bookingId: c.id, rating: 5, feedback: 'Great call!');
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.video_call_rounded, size: 14),
                  label: const Text('Join Video Room'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    textStyle: const TextStyle(fontSize: 11),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => repo.cancelConsultation(bookingId: c.id, reason: 'Client requested cancellation'),
                  style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, textStyle: const TextStyle(fontSize: 11)),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 4: PAST CALLS & FEEDBACK
  // ==========================================================================
  Widget _buildPastCallsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final past = repo.consultations.where((c) => c.meetingStatus == 'Completed').toList();

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: past.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final c = past[index];
        return Card(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 18),
            title: Text(c.topic, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text('Designer: ${c.designer.name} • Rating: ${c.ratingGiven ?? 5} ★ • Feedback: "${c.feedbackText ?? 'Great guidance'}"', style: const TextStyle(fontSize: 11)),
            trailing: ElevatedButton(
              onPressed: () => _openBookingModal(context, c.designer, repo),
              style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact, textStyle: const TextStyle(fontSize: 11)),
              child: const Text('Book Again'),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 5: 50/50 REVENUE SPLITS
  // ==========================================================================
  Widget _buildSplitsLedgerTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.consultations.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final c = repo.consultations[index];
        return Card(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.handshake_outlined, color: Color(0xFF8B5CF6), size: 18),
            title: Text('${c.topic} (${c.designer.name})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Total: ₹${c.fee.toInt()} • Platform (50%): ₹${c.platformShare.toInt()} • Designer (50%): ₹${c.designerShare.toInt()}', style: const TextStyle(fontSize: 11)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
              child: const Text('Settled (50/50)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
            ),
          ),
        );
      },
    );
  }
}
