import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/ai_suite_tool_header.dart';
import '../../widgets/credit_confirmation_dialog.dart';

class AiDoubtSolverPage extends StatefulWidget {
  const AiDoubtSolverPage({super.key});

  @override
  State<AiDoubtSolverPage> createState() => _AiDoubtSolverPageState();
}

class _AiDoubtSolverPageState extends State<AiDoubtSolverPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _questionCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String _selectedProject = 'DLF Phase 5 Penthouse';
  final String _selectedRoom = 'Kitchen';
  AiDoubtConversationEntity? _activeConversation;

  final List<String> _suggestedPrompts = [
    'Which plywood is best for kitchen cabinets?',
    'How much should a 10x8 wardrobe cost?',
    'What is the difference between MDF and plywood?',
    'Is false ceiling necessary for modern lighting?',
    'What are the best granite alternatives for kitchen tops?',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final repo = AiSuiteRepository.instance;
    if (repo.doubtConversations.isNotEmpty) {
      _activeConversation = repo.doubtConversations.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _questionCtrl.dispose();
    _scrollController.dispose();
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
              AiSuiteToolHeader(
                title: 'Doubt Solver',
                tabBar: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFFF59E0B),
                  unselectedLabelColor: const Color(0xFF64748B),
                  indicatorColor: const Color(0xFFF59E0B),
                  indicatorWeight: 2,
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                  tabs: [
                    const Tab(icon: Icon(Icons.chat_bubble_outline_rounded, size: 15), text: 'Ask AI'),
                    Tab(icon: const Icon(Icons.forum_outlined, size: 15), text: 'Conversations (${repo.doubtConversations.length})'),
                    Tab(icon: const Icon(Icons.pie_chart_outline_rounded, size: 15), text: 'Usage & Quotas (${repo.freeDoubtQueriesRemaining} Free)'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAskAiTab(context, isDark, repo),
                    _buildConversationsTab(context, isDark, repo),
                    _buildUsageQuotasTab(context, isDark, repo),
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
  // TAB 1: ASK AI (CONVERSATIONAL WORKSPACE)
  // ==========================================================================
  Widget _buildAskAiTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final conv = _activeConversation ?? (repo.doubtConversations.isNotEmpty ? repo.doubtConversations.first : null);

    return Column(
      children: [
        // Quota Bar & Context Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: repo.freeDoubtQueriesRemaining > 0
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      repo.freeDoubtQueriesRemaining > 0
                          ? 'FREE: ${repo.freeDoubtQueriesRemaining} REMAINING'
                          : 'RATE: ₹${repo.commercialConfig.doubtQueryFee.toInt()} / Q',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: repo.freeDoubtQueriesRemaining > 0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Context: $_selectedProject • $_selectedRoom', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  final newConv = repo.startNewDoubtConversation(
                    title: 'New Consultation Thread',
                    projectContext: _selectedProject,
                    roomContext: _selectedRoom,
                  );
                  setState(() => _activeConversation = newConv);
                },
                icon: const Icon(Icons.add, size: 12),
                label: const Text('New Chat'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  textStyle: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),

        // Suggested Prompt Chips
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestedPrompts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              return ActionChip(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(_suggestedPrompts[i]),
                labelStyle: const TextStyle(fontSize: 10.5),
                onPressed: () {
                  _questionCtrl.text = _suggestedPrompts[i];
                  _submitQuestion(repo);
                },
              );
            },
          ),
        ),

        // Messages List
        Expanded(
          child: conv == null || conv.messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.psychology_outlined, size: 36, color: Color(0xFFF59E0B)),
                      const SizedBox(height: 8),
                      Text('How can Homio AI assist your project today?', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      const Text('Ask any construction, interior material or budget query.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: conv.messages.length,
                  itemBuilder: (context, index) {
                    final msg = conv.messages[index];
                    return _buildMessageBubble(msg, isDark);
                  },
                ),
        ),

        // Designer Call Upsell Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          color: const Color(0xFFEC4899).withValues(alpha: 0.08),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.video_camera_front_outlined, size: 14, color: Color(0xFFEC4899)),
                  SizedBox(width: 6),
                  Text('Need personalized advice from a senior architect?', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                ],
              ),
              TextButton(
                onPressed: () => context.go(RouteNames.aiDesignerCalls),
                child: const Text('Book 30-Min Call (₹300) →', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFEC4899))),
              ),
            ],
          ),
        ),

        // Input Area
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              border: Border(top: BorderSide(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: 'Ask any construction, design, material or cost question...',
                      hintStyle: TextStyle(fontSize: 11),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onSubmitted: (_) => _submitQuestion(repo),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _submitQuestion(repo),
                  icon: const Icon(Icons.send_rounded, size: 14),
                  label: const Text('Ask AI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _submitQuestion(AiSuiteRepository repo) async {
    final text = _questionCtrl.text.trim();
    if (text.isEmpty) return;
    _questionCtrl.clear();

    final isFree = repo.freeDoubtQueriesRemaining > 0;
    if (!isFree) {
      final fee = repo.commercialConfig.doubtQueryFee;
      final confirmed = await CreditConfirmationDialog.show(
        context,
        actionTitle: 'Ask Expert Doubt Solver',
        actionDescription: 'Your 3 free questions have been utilized. This question will be billed at the standard rate.',
        creditsRequired: (fee / 5.0).round(),
        promptSummary: text,
      );
      if (!confirmed || !mounted) return;

      final deducted = repo.deductCredits(
        amount: (fee / 5.0).round(),
        title: 'Doubt Solver Query',
        referenceId: 'DBT-${DateTime.now().millisecondsSinceEpoch}',
        type: WalletTransactionType.doubtDebit,
        rupeeEquivalent: fee,
      );

      if (!deducted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient credits. Please top up your wallet.')),
        );
        return;
      }
    } else {
      repo.useFreeDoubtQuery();
    }

    final conv = _activeConversation ?? (repo.doubtConversations.isNotEmpty ? repo.doubtConversations.first : null);
    if (conv == null) return;

    repo.addDoubtMessage(
      conversationId: conv.id,
      userQuestion: text,
      aiAnswer: '''Based on **Indian Architectural Standards (BIS)** and Homio specifications for $text:

1. **Material Recommendation:**
   - Always opt for calibrated **BWP Grade (IS:710)** plywood with 2mm PVC edge-banding for wet areas.
   - For dry wardrobes, **HDHMR** or **IS:303 BWR Plywood** is cost-effective and structurally durable.

2. **Quality Checks:**
   - Check for minimal core gaps and zero overlapping veneers.
   - Verify IS certification logo stamped directly on the sheet face.

3. **Estimated Price Index:**
   - Standard MR Grade: ₹65–85 / Sq.Ft.
   - Certified BWP 710 Marine: ₹105–130 / Sq.Ft.''',
      sources: const [
        'BIS Bureau of Indian Standards (IS:710)',
        'Homio Materials & Joinery Handbook v3',
      ],
      followUpChips: const [
        'How to verify genuine IS:710 stamps?',
        'What hardware brands pair best with BWP plywood?',
      ],
      isPaid: !isFree,
      fee: isFree ? 0.0 : repo.commercialConfig.doubtQueryFee,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget _buildMessageBubble(AiDoubtMessage msg, bool isDark) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 40),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology_rounded, color: Color(0xFFF59E0B), size: 16),
                const SizedBox(width: 6),
                Text('Homio AI Consultant', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFF59E0B))),
              ],
            ),
            const SizedBox(height: 6),
            Text(msg.text, style: const TextStyle(fontSize: 12, height: 1.4)),
            if (msg.sources != null && msg.sources!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('SOURCES & REFERENCES', style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
              const SizedBox(height: 2),
              ...msg.sources!.map((s) => Text('• $s', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)))),
            ],
            if (msg.followUpChips != null && msg.followUpChips!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: msg.followUpChips!.map((chip) {
                  return ActionChip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(chip),
                    labelStyle: const TextStyle(fontSize: 9.5),
                    onPressed: () {
                      _questionCtrl.text = chip;
                      _submitQuestion(AiSuiteRepository.instance);
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // TAB 2: CONVERSATIONS
  // ==========================================================================
  Widget _buildConversationsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.doubtConversations.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final conv = repo.doubtConversations[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.forum_rounded, color: Color(0xFFF59E0B), size: 18),
            title: Text(conv.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 12.5)),
            subtitle: Text('Context: ${conv.projectContext} • ${conv.messages.length} messages', style: const TextStyle(fontSize: 10.5)),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() => _activeConversation = conv);
                _tabController.animateTo(0);
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), textStyle: const TextStyle(fontSize: 11)),
              child: const Text('Open Thread'),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 3: USAGE & QUOTAS
  // ==========================================================================
  Widget _buildUsageQuotasTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Doubt Solver Quotas & Commercial Ledger', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildQuotaMetric('Free Questions Remaining', '${repo.freeDoubtQueriesRemaining}', const Color(0xFF10B981)),
              _buildQuotaMetric('Commercial Fee Post-Free', '₹${repo.commercialConfig.doubtQueryFee.toInt()}', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}
