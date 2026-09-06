import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';
import 'shared_widgets.dart';

/// Screen 5: AI Technical Doubt Solver (/client/ai-doubt-solver)
/// Fully responsive with comprehensive Light and Dark mode theming support.
/// In Light Mode: 1:1 exact pixel match to the Homio AI Technical Consultant reference image.
/// In Dark Mode: Premium obsidian & deep navy architectural aesthetic.
class ClientAiDoubtSolverPage extends StatefulWidget {
  const ClientAiDoubtSolverPage({super.key});

  @override
  State<ClientAiDoubtSolverPage> createState() => _ClientAiDoubtSolverPageState();
}

class _ClientAiDoubtSolverPageState extends State<ClientAiDoubtSolverPage> {
  late final TextEditingController _queryController;
  late final ScrollController _scrollController;
  late final FocusNode _queryFocusNode;

  bool _isProcessing = false;
  String _selectedReasoningMode = 'NBC & IS Code Compliance';
  String _activeSessionId = 'session_1';

  late List<ChatSession> _sessions;
  late List<ChatMessage> _messages;

  final List<String> _quickSuggestions = [
    'Can I use 18mm Commercial MR Ply for wet kitchen under-sink joinery?',
    'What is the standard gap between false ceiling cove and LED strip to avoid hot-spotting?',
    'Is crystalline slurry waterproofing suitable for basement walls?',
  ];

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    _scrollController = ScrollController();
    _queryFocusNode = FocusNode();

    _initializeChatSessions();
  }

  void _initializeChatSessions() {
    // Session 1: Exactly matches the attached design mockup
    final session1Messages = [
      ChatMessage(
        id: 'm_1_1',
        text: 'Can I use 18mm Commercial MR Ply for wet kitchen under-sink joinery?',
        isUser: true,
        timestamp: 'Sep 2, 2026 • 11:30 AM',
      ),
      ChatMessage(
        id: 'm_1_2',
        text:
            'Commercial MR (Moisture Resistant, IS 303) is urea-formaldehyde bonded and CANNOT withstand standing water or RO drain leaks. The urea bond hydrolyzes and dissolves in persistent moisture, causing core delamination and severe termite infestation within 12–18 months.',
        isUser: false,
        timestamp: 'Sep 2, 2026 • 11:31 AM',
        verdict: DoubtVerdict.avoidHazard,
        customVerdictLabel: 'High Risk • Avoid on Site',
        recommendedSpec:
            'You MUST specify IS 710 BWP (Boiling Waterproof) Marine Ply or 18mm Calcium Silicate / PVC foam board specifically for the 3-foot under-sink carcass zone.',
        criticalDetail:
            'Ensure the carpenter primes the backside of the ply with anti-fungal wood primer before fixing back paneling to the damp external wall.',
        costSavingImpact:
            'Prevents ₹42,000 modular kitchen carcass dismantling & plumbing re-run within 2 years.',
        isCodeRef: 'IS 710:2010 (Marine Plywood) & IS 303 Clause 4.2',
      ),
    ];

    // Session 2
    final session2Messages = [
      ChatMessage(
        id: 'm_2_1',
        text: 'What is the standard gap between false ceiling cove and LED strip to avoid hot-spotting?',
        isUser: true,
        timestamp: 'Aug 29, 2026 • 04:15 PM',
      ),
      ChatMessage(
        id: 'm_2_2',
        text:
            'Maintain a minimum vertical light-baffle lip of 65mm (2.5 inches) and horizontal recess depth of 75mm (3.0 inches). Place the LED aluminum profile strip at a 45° angle facing upward toward the white ceiling plenum.',
        isUser: false,
        timestamp: 'Aug 29, 2026 • 04:16 PM',
        verdict: DoubtVerdict.recommended,
        customVerdictLabel: 'Recommended Specification',
        recommendedSpec:
            'Use high-density 120-LEDs/metre or COB (Chip-on-Board) continuous strip (minimum CRI 90+) to achieve seamless, dot-free diffused ambient glow.',
        criticalDetail:
            'Ensure continuous heat dissipation via aluminum extrusions. Never stick bare LED strip directly onto wooden cove pelmet.',
        costSavingImpact:
            'Eliminates ₹18,000 ceiling cutting & re-painting rework post-electrical sign-off.',
        isCodeRef: 'NBC 2016 Part 8 (Lighting & Ventilation Standards)',
      ),
    ];

    // Session 3
    final session3Messages = [
      ChatMessage(
        id: 'm_3_1',
        text: 'Is crystalline slurry waterproofing suitable for basement walls?',
        isUser: true,
        timestamp: 'Aug 22, 2026 • 02:40 PM',
      ),
      ChatMessage(
        id: 'm_3_2',
        text:
            'Crystalline slurry penetrates concrete micro-capillaries to block water seepage from negative side, but cannot bridge dynamic structural settlement or expansion joints.',
        isUser: false,
        timestamp: 'Aug 22, 2026 • 02:42 PM',
        verdict: DoubtVerdict.useWithCaution,
        customVerdictLabel: 'Use With Caution • Dual Layer',
        recommendedSpec:
            'Specify high-solid crystalline slurry (IS 15809) combined with elastomeric polymer modified cementitious coating over structural masonry.',
        criticalDetail:
            'Cast 45-degree angle corner fillets (coving) at all wall-to-raft slab junctions prior to slurry application.',
        costSavingImpact:
            'Protects basement interior from ₹95,000 deep efflorescence and de-bonding damage.',
        isCodeRef: 'IS 15809:2008 & NBC 2016 Part 6 (Waterproofing of Sub-structures)',
      ),
    ];

    _sessions = [
      ChatSession(
        id: 'session_1',
        title: 'Wet Kitchen Under-Sink Carcass Specification',
        lastMessagePreview: 'High Risk • Avoid on Site: Commercial MR vs BWP Marine...',
        timestamp: 'Sep 2, 2026',
        messageCount: session1Messages.length,
        messages: session1Messages,
      ),
      ChatSession(
        id: 'session_2',
        title: 'False Ceiling LED Cove Light Spacing & Hot-Spotting',
        lastMessagePreview: 'Maintain a minimum vertical light-baffle lip of 65mm...',
        timestamp: 'Aug 29, 2026',
        messageCount: session2Messages.length,
        messages: session2Messages,
      ),
      ChatSession(
        id: 'session_3',
        title: 'Basement Crystalline Waterproofing Feasibility',
        lastMessagePreview: 'Specify high-solid crystalline slurry combined with polymer...',
        timestamp: 'Aug 22, 2026',
        messageCount: session3Messages.length,
        messages: session3Messages,
      ),
    ];

    _messages = List.from(session1Messages);
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    _queryFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _submitQuery(String text) {
    if (text.trim().isEmpty || _isProcessing) return;

    if (globalAiWallet.freeDoubtQueriesLeft <= 0 && globalAiWallet.totalTokens < 1) {
      showBuyTokensDialog(context, Theme.of(context).brightness == Brightness.dark);
      return;
    }

    final queryText = text.trim();
    _queryController.clear();

    final userMessage = ChatMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      text: queryText,
      isUser: true,
      timestamp: 'Just now',
    );

    setState(() {
      _messages.add(userMessage);
      _isProcessing = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;

      final isFree = globalAiWallet.freeDoubtQueriesLeft > 0;
      if (isFree) {
        globalAiWallet.freeDoubtQueriesLeft--;
      } else {
        globalAiWallet.totalTokens -= 1;
      }

      final lower = queryText.toLowerCase();
      DoubtVerdict verdict = DoubtVerdict.recommended;
      String verdictLabel = 'Recommended Specification';
      String recSpec =
          'Ensure calibrated materials compliant with IS 2095: Part 1 and verify perimeter anchor spacing at 600mm centers.';
      String critDetail =
          'Substrate moisture must test below 12% prior to permanent mechanical fastening and chemical primer coating.';
      String costImpact =
          'Prevents ₹24,000 in early structural cosmetic cracking & rectification.';
      String codeRef = 'IS 2095:2011 (Gypsum Plasterboard Standards) & IS 2542';
      String bodyText =
          'AI Engineering Verification:\nBased on current Bureau of Indian Standards (BIS) and National Building Code (NBC 2016) regulations, this installation methodology is structurally sound provided expansion joints and moisture barriers are executed.';

      if (lower.contains('sink') || lower.contains('mr') || lower.contains('ply') || lower.contains('wet') || lower.contains('kitchen')) {
        verdict = DoubtVerdict.avoidHazard;
        verdictLabel = 'High Risk • Avoid on Site';
        bodyText =
            'Commercial MR (Moisture Resistant, IS 303) is urea-formaldehyde bonded and CANNOT withstand standing water or RO drain leaks. The urea bond hydrolyzes and dissolves in persistent moisture, causing core delamination and severe termite infestation within 12–18 months.';
        recSpec =
            'You MUST specify IS 710 BWP (Boiling Waterproof) Marine Ply or 18mm Calcium Silicate / PVC foam board specifically for the 3-foot under-sink carcass zone.';
        critDetail =
            'Ensure the carpenter primes the backside of the ply with anti-fungal wood primer before fixing back paneling to the damp external wall.';
        costImpact =
            'Prevents ₹42,000 modular kitchen carcass dismantling & plumbing re-run within 2 years.';
        codeRef = 'IS 710:2010 (Marine Plywood) & IS 303 Clause 4.2';
      } else if (lower.contains('cove') || lower.contains('led') || lower.contains('ceiling') || lower.contains('lighting')) {
        verdict = DoubtVerdict.recommended;
        verdictLabel = 'Recommended Specification';
        bodyText =
            'Maintain a minimum vertical light-baffle lip of 65mm (2.5 inches) and horizontal recess depth of 75mm (3.0 inches). Place the LED aluminum profile strip at a 45° angle facing upward toward the white ceiling plenum.';
        recSpec =
            'Use high-density 120-LEDs/metre or COB (Chip-on-Board) continuous strip (minimum CRI 90+) to achieve seamless, dot-free diffused ambient glow.';
        critDetail =
            'Ensure continuous heat dissipation via aluminum extrusions. Never stick bare LED strip directly onto wooden cove pelmet.';
        costImpact =
            'Eliminates ₹18,000 ceiling cutting & re-painting rework post-electrical sign-off.';
        codeRef = 'NBC 2016 Part 8 (Lighting & Ventilation Standards)';
      } else if (lower.contains('waterproof') || lower.contains('slurry') || lower.contains('basement') || lower.contains('wall')) {
        verdict = DoubtVerdict.useWithCaution;
        verdictLabel = 'Use With Caution • Dual Layer';
        bodyText =
            'Crystalline slurry penetrates concrete micro-capillaries to block water seepage from negative side, but cannot bridge dynamic structural settlement or expansion joints.';
        recSpec =
            'Specify high-solid crystalline slurry (IS 15809) combined with elastomeric polymer modified cementitious coating over structural masonry.';
        critDetail =
            'Cast 45-degree angle corner fillets (coving) at all wall-to-raft slab junctions prior to slurry application.';
        costImpact =
            'Protects basement interior from ₹95,000 deep efflorescence and de-bonding damage.';
        codeRef = 'IS 15809:2008 & NBC 2016 Part 6 (Waterproofing of Sub-structures)';
      }

      final aiMessage = ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: bodyText,
        isUser: false,
        timestamp: 'Just now',
        verdict: verdict,
        customVerdictLabel: verdictLabel,
        recommendedSpec: recSpec,
        criticalDetail: critDetail,
        costSavingImpact: costImpact,
        isCodeRef: codeRef,
      );

      setState(() {
        _messages.add(aiMessage);
        _isProcessing = false;

        final idx = _sessions.indexWhere((s) => s.id == _activeSessionId);
        if (idx != -1) {
          final s = _sessions[idx];
          _sessions[idx] = ChatSession(
            id: s.id,
            title: s.title,
            lastMessagePreview: queryText,
            timestamp: 'Just now',
            messageCount: _messages.length,
            messages: List.from(_messages),
          );
        }
      });

      _scrollToBottom();
    });
  }

  void _cycleReasoningMode() {
    setState(() {
      if (_selectedReasoningMode == 'NBC & IS Code Compliance') {
        _selectedReasoningMode = 'Value Engineering & Savings';
      } else if (_selectedReasoningMode == 'Value Engineering & Savings') {
        _selectedReasoningMode = 'Fast Site Directive';
      } else {
        _selectedReasoningMode = 'NBC & IS Code Compliance';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'AI Reasoning set to: $_selectedReasoningMode',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startNewChat() {
    final newSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    final newSession = ChatSession(
      id: newSessionId,
      title: 'New Technical Consultation',
      lastMessagePreview: 'Started fresh AI session...',
      timestamp: 'Just now',
      messageCount: 0,
      messages: [],
    );

    setState(() {
      _sessions.insert(0, newSession);
      _activeSessionId = newSessionId;
      _messages = [];
    });

    _queryFocusNode.requestFocus();
  }

  void _loadSession(ChatSession session) {
    setState(() {
      _activeSessionId = session.id;
      _messages = List.from(session.messages);
    });
    _scrollToBottom();
  }

  void _deleteSession(String sessionId) {
    setState(() {
      _sessions.removeWhere((s) => s.id == sessionId);
      if (_activeSessionId == sessionId) {
        if (_sessions.isNotEmpty) {
          _activeSessionId = _sessions.first.id;
          _messages = List.from(_sessions.first.messages);
        } else {
          _startNewChat();
        }
      }
    });
  }

  void _exportChatTranscript() {
    if (_messages.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln('HOMIO TECHNICAL AI CONSULTANT — SPECIFICATION AUDIT');
    buffer.writeln('Export Date: ${DateTime.now()}\n');

    for (final m in _messages) {
      if (m.isUser) {
        buffer.writeln('[USER QUESTION • ${m.timestamp}]\n${m.text}\n');
      } else {
        buffer.writeln('[AI VERDICT • ${m.customVerdictLabel ?? m.verdict?.label} • ${m.timestamp}]');
        buffer.writeln(m.text);
        if (m.recommendedSpec != null) {
          buffer.writeln('\nRECOMMENDED SPECIFICATION:\n${m.recommendedSpec}');
        }
        if (m.criticalDetail != null) {
          buffer.writeln('\nCRITICAL DETAIL:\n${m.criticalDetail}');
        }
        if (m.costSavingImpact != null) {
          buffer.writeln('\n${m.costSavingImpact}');
        }
        if (m.isCodeRef != null) {
          buffer.writeln('Governing Standard: ${m.isCodeRef}');
        }
        buffer.writeln('\n----------------------------------------\n');
      }
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied complete conversation transcript to clipboard!',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showChatHistoryModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640, maxHeight: 580),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0084FF).withValues(alpha: isDark ? 0.2 : 0.1),
                              borderRadius: AppRadius.md,
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: Color(0xFF0084FF),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Technical Consultation History',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_sessions.length} archived construction & standard consultation threads',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                            icon: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                            ),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9)),
                      const SizedBox(height: 14),

                      // New Consultation Button
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(dialogCtx).pop();
                          _startNewChat();
                        },
                        icon: const Icon(Icons.add_comment_rounded, size: 16),
                        label: Text(
                          'Start New Consultation Thread',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0084FF),
                          side: BorderSide(color: isDark ? const Color(0xFF0284C7) : const Color(0xFF0084FF)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Sessions List
                      Expanded(
                        child: _sessions.isEmpty
                            ? Center(
                                child: Text(
                                  'No saved threads found. Start a new one!',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _sessions.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                itemBuilder: (context, idx) {
                                  final session = _sessions[idx];
                                  final isActive = session.id == _activeSessionId;

                                  return InkWell(
                                    onTap: () {
                                      _loadSession(session);
                                      Navigator.of(dialogCtx).pop();
                                    },
                                    borderRadius: AppRadius.lg,
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? (isDark ? const Color(0xFF0084FF).withValues(alpha: 0.18) : const Color(0xFFEFF6FF))
                                            : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC)),
                                        borderRadius: AppRadius.lg,
                                        border: Border.all(
                                          color: isActive
                                              ? const Color(0xFF0084FF)
                                              : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                                          width: isActive ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isActive
                                                  ? const Color(0xFF0084FF)
                                                  : (isDark ? AppColors.darkSurfaceElevated : const Color(0xFFE2E8F0)),
                                              borderRadius: AppRadius.md,
                                            ),
                                            child: Icon(
                                              Icons.chat_bubble_outline_rounded,
                                              color: isActive
                                                  ? Colors.white
                                                  : (isDark ? AppColors.darkTextSecondary : const Color(0xFF475569)),
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        session.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.plusJakartaSans(
                                                          fontSize: 13.5,
                                                          fontWeight: FontWeight.w800,
                                                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                                        ),
                                                      ),
                                                    ),
                                                    if (isActive) ...[
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFF0084FF),
                                                          borderRadius: AppRadius.full,
                                                        ),
                                                        child: Text(
                                                          'ACTIVE',
                                                          style: GoogleFonts.plusJakartaSans(
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.w800,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  session.lastMessagePreview,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 11.5,
                                                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '${session.timestamp} • ${session.messageCount} messages',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 10.5,
                                                    color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                            color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                                            tooltip: 'Delete Thread',
                                            onPressed: () {
                                              _deleteSession(session.id);
                                              setModalState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _escalateToDirector(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.video_call_rounded, color: Color(0xFF6366F1), size: 22),
              const SizedBox(width: 10),
              Text(
                '30-Min On-Demand Video Review',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a 1-on-1 private video review session with Principal Architect Ar. Sameer Mehta to inspect technical site drawings & material samples on screen.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: AppRadius.md,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded, color: Color(0xFF6366F1), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Next Available Slot: Today at 06:30 PM (Fee: ₹300 for 30 minutes)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF6366F1),
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
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Video consultation booked with Ar. Sameer Mehta! WebRTC link dispatched to WhatsApp.',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              icon: const Icon(Icons.video_camera_front_rounded, size: 16),
              label: Text(
                'Confirm Video Session (₹300)',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Header Bar (Exact match to image, fully themed for dark mode)
            _buildHeader(context, isDark),

            // 2. Chat Message Stream Area
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
                    child: Column(
                      children: [
                        ..._messages.map((m) {
                          return m.isUser
                              ? _buildUserMessage(m, isDark)
                              : _buildAiResponseCard(m, isDark);
                        }),
                        if (_isProcessing) _buildThinkingIndicator(isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. Quick Suggestions Bar (Exact match to image, fully themed for dark mode)
            _buildQuickSuggestionsBar(isDark),

            // 4. Input Dock & Disclaimer Footer (Exact match to image, fully themed for dark mode)
            _buildInputDock(context, isDark),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. TOP HEADER (EXACT 1:1 TO IMAGE WITH FULL DARK MODE SUPPORT)
  // ==========================================================================
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // App Logo Rounded Square (Blue Gradient with Brain/Network Icon)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0084FF), Color(0xFF0066FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0084FF).withValues(alpha: isDark ? 0.35 : 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title & Online Badge & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Homio Technical AI Consultant',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Green "Online" pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Online',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'AI Senior Architectural & MEP Engineer • BIS / NBC 2016 Compliant Engine',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Token Pill Button (e.g. "240 Tokens")
          InkWell(
            onTap: () => showBuyTokensDialog(context, isDark),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF1D4ED8).withValues(alpha: 0.5) : const Color(0xFFBFDBFE).withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.generating_tokens_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${globalAiWallet.totalTokens} Tokens',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Three-Dot Menu Button (Square rounded border matching image)
          PopupMenuButton<String>(
            tooltip: 'Options',
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
            elevation: 8,
            onSelected: (val) {
              if (val == 'history') {
                _showChatHistoryModal(context);
              } else if (val == 'new_chat') {
                _startNewChat();
              } else if (val == 'reasoning') {
                _cycleReasoningMode();
              } else if (val == 'export') {
                _exportChatTranscript();
              } else if (val == 'escalate') {
                _escalateToDirector(context);
              } else if (val == 'clear') {
                setState(() => _messages.clear());
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 18, color: Color(0xFF0084FF)),
                    const SizedBox(width: 10),
                    Text(
                      'Chat History',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'new_chat',
                child: Row(
                  children: [
                    const Icon(Icons.add_comment_rounded, size: 18, color: Color(0xFF10B981)),
                    const SizedBox(width: 10),
                    Text(
                      'New Consultation Thread',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reasoning',
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF6366F1)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Reasoning: $_selectedReasoningMode',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(
                      Icons.file_download_outlined,
                      size: 18,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Export Chat Transcript',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'escalate',
                child: Row(
                  children: [
                    const Icon(Icons.video_camera_front_rounded, size: 18, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 10),
                    Text(
                      'Director Video Review (₹300)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    const Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFEF4444)),
                    const SizedBox(width: 10),
                    Text(
                      'Clear Current Chat',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Icon(
                  Icons.more_vert_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. USER MESSAGE BUBBLE (EXACT 1:1 TO IMAGE WITH FULL DARK MODE SUPPORT)
  // ==========================================================================
  Widget _buildUserMessage(ChatMessage m, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 60),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0084FF),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0084FF).withValues(alpha: isDark ? 0.35 : 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      m.timestamp,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User Avatar (Light blue circle with blue person icon)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 3. AI RESPONSE CARD (EXACT 1:1 TO IMAGE WITH FULL DARK MODE SUPPORT)
  // ==========================================================================
  Widget _buildAiResponseCard(ChatMessage m, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar on left (Matching header blue rounded square)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0084FF), Color(0xFF0066FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Main Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Red Tag Badge ("High Risk • Avoid on Site") + Timestamp
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.35) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error,
                              size: 14,
                              color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              m.customVerdictLabel ?? (m.verdict?.label ?? 'High Risk • Avoid on Site'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        m.timestamp,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Main explanation paragraph
                  Text(
                    m.text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
                    ),
                  ),

                  // Recommended Specification Item
                  if (m.recommendedSpec != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            size: 22,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RECOMMENDED SPECIFICATION',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.recommendedSpec!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Divider between Spec and Detail
                  if (m.criticalDetail != null) ...[
                    const SizedBox(height: 14),
                    Divider(height: 1, thickness: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9)),
                    const SizedBox(height: 14),

                    // Critical Detail Item (Purple square with 'E')
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text(
                                'E',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CRITICAL DETAIL',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.criticalDetail!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Green Tinted Box (Financial Impact & Governing Standard)
                  if (m.costSavingImpact != null || m.isCodeRef != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.25) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? const Color(0xFF065F46).withValues(alpha: 0.8) : const Color(0xFFA7F3D0).withValues(alpha: 0.8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (m.costSavingImpact != null) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.verified_user_rounded,
                                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    m.costSavingImpact!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (m.isCodeRef != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Governing Standard: ${m.isCodeRef!}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Bottom Right Actions: Copy & Thumbs Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                        tooltip: 'Copy',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: m.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Copied to clipboard!',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                        tooltip: 'Helpful',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Thanks for your feedback!',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0084FF), Color(0xFF0066FF)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0084FF)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Homio AI is reviewing IS Codes & structural registries...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4. QUICK SUGGESTIONS BAR (EXACT 1:1 TO IMAGE WITH FULL DARK MODE SUPPORT)
  // ==========================================================================
  Widget _buildQuickSuggestionsBar(bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
        child: Container(
          height: 38,
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Chip 1: Selected / Light Blue Pill with blue 4-pointed star
              _buildSuggestionChip(
                _quickSuggestions[0],
                isSelected: true,
                isDark: isDark,
              ),
              const SizedBox(width: 10),
              // Chip 2: White Pill with blue 4-pointed star
              _buildSuggestionChip(
                _quickSuggestions[1],
                isSelected: false,
                isDark: isDark,
              ),
              const SizedBox(width: 10),
              // Chip 3: White Pill with blue 4-pointed star
              _buildSuggestionChip(
                _quickSuggestions[2],
                isSelected: false,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text, {required bool isSelected, required bool isDark}) {
    return InkWell(
      onTap: () => _submitQuery(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEFF6FF))
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? const Color(0xFF1D4ED8).withValues(alpha: 0.8) : const Color(0xFFBFDBFE))
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              color: isSelected
                  ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF0084FF))
                  : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF0084FF))
                    : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 5. BOTTOM INPUT DOCK & DISCLAIMER (EXACT 1:1 TO IMAGE WITH FULL DARK MODE SUPPORT)
  // ==========================================================================
  Widget _buildInputDock(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Paperclip Attachment Icon
                  IconButton(
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
                      size: 22,
                    ),
                    tooltip: 'Attach Drawing / Spec Sheet',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Attached spec sheet: Villa_402_Specifications.pdf',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: const Color(0xFF0084FF),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),

                  // Input Text Field
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      focusNode: _queryFocusNode,
                      onSubmitted: _submitQuery,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask any construction, material, or Indian Standard code question...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Blue Circular Send Button
                  InkWell(
                    onTap: _isProcessing ? null : () => _submitQuery(_queryController.text),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0084FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.near_me_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Legal Disclaimer centered at bottom
        Text(
          'Homio AI references Bureau of Indian Standards (BIS) & NBC 2016. Not a legal substitute for licensed structural PE stamping.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
