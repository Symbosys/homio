import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ai_suite_models.dart';

class VideoConsultationRoom extends StatefulWidget {
  final DesignerConsultant? designer;
  final String? designerName;
  final String? consultationTopic;
  final String? clientName;
  final VoidCallback onEndCall;

  const VideoConsultationRoom({
    super.key,
    this.designer,
    this.designerName,
    this.consultationTopic,
    this.clientName,
    required this.onEndCall,
  });

  @override
  State<VideoConsultationRoom> createState() => _VideoConsultationRoomState();
}

class _VideoConsultationRoomState extends State<VideoConsultationRoom> {
  String get _designerName => widget.designer?.name ?? widget.designerName ?? 'Ar. Pooja Mehta';
  String get _designerAvatar => widget.designer?.avatarUrl ?? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80';
  String get _clientName => widget.clientName ?? 'You (Client)';

  // Timer State (30 mins = 1800 seconds)
  int _secondsRemaining = 1800;
  Timer? _timer;

  // Media Controls
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isScreenSharing = false;

  // Whiteboard Strokes
  final List<WhiteboardStroke> _strokes = [];
  Color _selectedColor = const Color(0xFFEF4444);
  double _strokeWidth = 3.0;

  // In-Call Notes
  final TextEditingController _notesController = TextEditingController(
    text: '• Client desires warm oak fluted TV console with 3000K recessed cove\n'
        '• Recommended BWP Marine Ply (IS:710) for balcony planter partition\n'
        '• Next step: Designer Ar. Pooja to share 3D moodboard revision in DAM vault',
  );

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _showCallEndedDialog();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Consultation Room Top Header Bar
          _buildTopBar(context),

          // 2. Main Workspace (Video Streams + Interactive Whiteboard Canvas)
          Expanded(
            child: isMobile
                ? Column(
                    children: [
                      Expanded(flex: 3, child: _buildVideoGrid()),
                      Expanded(flex: 4, child: _buildWhiteboardArea()),
                    ],
                  )
                : Row(
                    children: [
                      // Video Feeds Sidebar (Left)
                      SizedBox(
                        width: 320,
                        child: _buildVideoGrid(),
                      ),
                      // Whiteboard & Shared Floor Plan Canvas (Right)
                      Expanded(
                        child: _buildWhiteboardArea(),
                      ),
                    ],
                  ),
          ),

          // 3. In-Call Bottom Controls Dock
          _buildControlDock(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Session Title
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Live Consultation: $_designerName',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '₹300 Session Paid',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFA78BFA),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          // Countdown Timer & End Button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _secondsRemaining < 300
                      ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                      : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _secondsRemaining < 300
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF475569),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: _secondsRemaining < 300
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTimer(_secondsRemaining),
                      style: GoogleFonts.plusJakartaSans(
                        color: _secondsRemaining < 300
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF10B981),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton.icon(
                onPressed: _showCallEndedDialog,
                icon: const Icon(Icons.call_end_rounded, size: 16),
                label: const Text('End Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

  Widget _buildVideoGrid() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 1. Designer Video Feed
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _designerAvatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.person_rounded, size: 48, color: Colors.white38),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mic_rounded, size: 12, color: Color(0xFF10B981)),
                          const SizedBox(width: 5),
                          Text(
                            '$_designerName (Architect)',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Client Self Camera Feed
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _isCameraOff
                      ? Container(
                          color: const Color(0xFF1E293B),
                          child: const Center(
                            child: Icon(Icons.videocam_off_rounded, size: 40, color: Colors.white38),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Center(
                              child: Icon(Icons.person_rounded, size: 40, color: Colors.white38),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                            size: 12,
                            color: _isMicMuted ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _clientName,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteboardArea() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(left: BorderSide(color: Color(0xFF334155))),
      ),
      child: Column(
        children: [
          // Whiteboard Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                const Icon(Icons.draw_rounded, size: 16, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 8),
                Text(
                  'Live Shared Whiteboard & Drawing Canvas',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),

                // Color Pickers
                _buildColorCircle(const Color(0xFFEF4444)),
                const SizedBox(width: 6),
                _buildColorCircle(const Color(0xFF3B82F6)),
                const SizedBox(width: 6),
                _buildColorCircle(const Color(0xFF10B981)),
                const SizedBox(width: 6),
                _buildColorCircle(const Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                _buildColorCircle(Colors.white),
                const SizedBox(width: 14),

                // Stroke Width
                IconButton(
                  onPressed: () {
                    setState(() {
                      _strokeWidth = _strokeWidth == 3.0 ? 6.0 : 3.0;
                    });
                  },
                  icon: Icon(
                    Icons.line_weight_rounded,
                    size: 18,
                    color: _strokeWidth == 6.0 ? const Color(0xFF8B5CF6) : Colors.white70,
                  ),
                  tooltip: 'Toggle Pen Thickness',
                ),

                // Undo
                IconButton(
                  onPressed: () {
                    if (_strokes.isNotEmpty) {
                      setState(() => _strokes.removeLast());
                    }
                  },
                  icon: const Icon(Icons.undo_rounded, size: 18, color: Colors.white70),
                  tooltip: 'Undo',
                ),

                // Clear
                IconButton(
                  onPressed: () {
                    setState(() => _strokes.clear());
                  },
                  icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFEF4444)),
                  tooltip: 'Clear Canvas',
                ),
              ],
            ),
          ),

          // Interactive Whiteboard CustomPaint Canvas
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                final box = context.findRenderObject() as RenderBox?;
                if (box == null) return;
                setState(() {
                  _strokes.add(WhiteboardStroke(
                    points: [details.localPosition],
                    color: _selectedColor,
                    strokeWidth: _strokeWidth,
                  ));
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  if (_strokes.isNotEmpty) {
                    _strokes.last.points.add(details.localPosition);
                  }
                });
              },
              child: ClipRect(
                child: CustomPaint(
                  painter: _WhiteboardPainter(strokes: _strokes),
                  child: Container(
                    color: const Color(0xFF111827),
                    width: double.infinity,
                    height: double.infinity,
                    child: _strokes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.gesture_rounded, size: 42, color: Colors.white24),
                                const SizedBox(height: 8),
                                Text(
                                  'Draw or sketch space plans directly on this shared screen',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),

          // In-call Consultation Notes Accordion
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF0F172A),
            child: Row(
              children: [
                const Icon(Icons.edit_note_rounded, size: 18, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Notes: ${_notesController.text.split('\n').first}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFFCBD5E1),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _showNotesModal,
                  child: const Text('View All Notes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
            width: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _buildControlDock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(top: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mic Toggle
          IconButton(
            onPressed: () => setState(() => _isMicMuted = !_isMicMuted),
            icon: Icon(
              _isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
              color: _isMicMuted ? const Color(0xFFEF4444) : Colors.white,
            ),
            tooltip: _isMicMuted ? 'Unmute Microphone' : 'Mute Microphone',
          ),
          const SizedBox(width: 14),

          // Camera Toggle
          IconButton(
            onPressed: () => setState(() => _isCameraOff = !_isCameraOff),
            icon: Icon(
              _isCameraOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
              color: _isCameraOff ? const Color(0xFFEF4444) : Colors.white,
            ),
            tooltip: _isCameraOff ? 'Turn On Camera' : 'Turn Off Camera',
          ),
          const SizedBox(width: 14),

          // Screen Share
          IconButton(
            onPressed: () {
              setState(() => _isScreenSharing = !_isScreenSharing);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isScreenSharing ? 'Screen sharing active' : 'Screen sharing stopped'),
                ),
              );
            },
            icon: Icon(
              Icons.screen_share_rounded,
              color: _isScreenSharing ? const Color(0xFF10B981) : Colors.white,
            ),
            tooltip: 'Share Architectural Floor Plan',
          ),
          const SizedBox(width: 14),

          // Notes
          IconButton(
            onPressed: _showNotesModal,
            icon: const Icon(Icons.sticky_note_2_rounded, color: Colors.white),
            tooltip: 'In-Call Notes & Deliverables',
          ),
        ],
      ),
    );
  }

  void _showNotesModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            'Session Consultation Notes & Action Items',
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          content: SizedBox(
            width: 480,
            child: TextField(
              controller: _notesController,
              maxLines: 8,
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Record design decisions, client material preferences, or next steps...',
                hintStyle: TextStyle(color: Colors.white38),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Save Notes'),
            ),
          ],
        );
      },
    );
  }

  void _showCallEndedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
              const SizedBox(width: 10),
              Text(
                '30-Min Consultation Completed',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A formal Consultation Summary Dossier has been automatically saved in your Client Portal & Project DAM Vault.',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFCBD5E1),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMMERCIAL SETTLEMENT (50-50 SPLIT):',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Total Session Fee: ₹300.00\n• Platform Commission: ₹150.00 (50%)\n• Designer Payout: ₹150.00 (50% Credited to $_designerName)',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFA5B4FC),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onEndCall();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
              child: const Text('Return to Consultation Hub'),
            ),
          ],
        );
      },
    );
  }
}

class _WhiteboardPainter extends CustomPainter {
  final List<WhiteboardStroke> strokes;
  _WhiteboardPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (stroke.points.length > 1) {
        for (int i = 0; i < stroke.points.length - 1; i++) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      } else if (stroke.points.isNotEmpty) {
        canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WhiteboardPainter oldDelegate) => true;
}
