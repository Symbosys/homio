import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class AiTrainingPage extends StatefulWidget {
  const AiTrainingPage({super.key});

  @override
  State<AiTrainingPage> createState() => _AiTrainingPageState();
}

class _AiTrainingPageState extends State<AiTrainingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State
  List<AiKnowledgeSource> _sources = [];
  List<AiPricingGuardrail> _guardrails = [];
  List<AiFaqItem> _faqs = [];
  List<AiTestingSimulation> _simulations = [];

  // Testing Playground State
  final TextEditingController _testQueryCtrl = TextEditingController();
  AiTestingSimulation? _currentSimulationResult;
  bool _isSimulatingResponse = false;

  // FAQ Add Modal
  bool _isAddFaqModalOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _sources = List.from(AdminMockData.aiKnowledgeSources);
    _guardrails = List.from(AdminMockData.pricingGuardrails);
    _faqs = List.from(AdminMockData.aiFaqs);
    _simulations = List.from(AdminMockData.playgroundSimulations);
    _currentSimulationResult = _simulations.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _testQueryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: 'AI Training & Guardrails Workspace',
                  description: 'Manage AI knowledge corpus, strict pricing guardrails, objection handling, anti-hallucination rules, and testing simulations.',
                  icon: Icons.psychology_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'AI Training'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => _triggerModelRetraining(),
                      icon: const Icon(Icons.sync_rounded, size: 16),
                      label: const Text('Sync & Reindex Corpus', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isAddFaqModalOpen = true),
                      icon: const Icon(Icons.add_task_rounded, size: 16),
                      label: const Text('Add Knowledge / FAQ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Summary Metrics Ribbon
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Indexed Knowledge Base',
                      value: '${_sources.length} Documents',
                      subtitle: '14,100 Embedded Tokens',
                      icon: Icons.menu_book_outlined,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Strict Pricing Guardrails',
                      value: '${_guardrails.length} Active Rules',
                      subtitle: 'Floor: ₹1,850/sq.ft. Enforced',
                      icon: Icons.shield_outlined,
                      color: AppColors.error,
                    ),
                    AdminMetricItem(
                      label: 'Pre-Approved FAQs',
                      value: '${_faqs.length} Live Scripts',
                      subtitle: 'Objection handling tuned',
                      icon: Icons.quiz_outlined,
                      color: AppColors.success,
                    ),
                    AdminMetricItem(
                      label: 'AI Grounding Accuracy',
                      value: '94.2%',
                      subtitle: 'Evaluated on 450 simulated prompts',
                      icon: Icons.verified_user_outlined,
                      color: AppColors.secondary,
                      trendText: 'High',
                      isPositiveTrend: true,
                    ),
                  ],
                ),

                // 3. Navigation Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (i) => setState(() {}),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(icon: Icon(Icons.science_outlined, size: 18), text: 'AI Testing Playground'),
                      Tab(icon: Icon(Icons.gavel_rounded, size: 18), text: 'Pricing & Anti-Hallucination Guardrails'),
                      Tab(icon: Icon(Icons.question_answer_outlined, size: 18), text: 'Approved FAQs & Sales Guidance'),
                      Tab(icon: Icon(Icons.source_outlined, size: 18), text: 'Knowledge Sources & Corpus'),
                    ],
                  ),
                ),

                // 4. Tab Views
                if (_tabController.index == 0) _buildTestingPlaygroundTab(isDark, isMobile),
                if (_tabController.index == 1) _buildPricingGuardrailsTab(isDark),
                if (_tabController.index == 2) _buildFaqsTab(isDark),
                if (_tabController.index == 3) _buildKnowledgeSourcesTab(isDark),
              ],
            ),
          ),

          // Add FAQ Modal
          if (_isAddFaqModalOpen)
            _buildAddFaqModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: AI TESTING PLAYGROUND
  // ==========================================================================
  Widget _buildTestingPlaygroundTab(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Test Query Simulation Box & Pre-sets
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Simulate Customer Question', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Test how Homio’s AI assistant responds to customer queries using published knowledge and guardrails.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                const SizedBox(height: 14),

                // Presets
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildPresetChip('3BHK Cost Inquiry', 'How much will it cost to design my 3BHK flat in HSR Layout Bangalore (1500 sq.ft)?'),
                    _buildPresetChip('Discount Negotiation', 'Can you give me this entire package for ₹15 Lakhs? My budget is very tight.'),
                    _buildPresetChip('Emergency Snag', 'There is water leaking behind the kitchen cabinet you installed last month! Send someone immediately!'),
                  ],
                ),
                const SizedBox(height: 14),

                // Query Input Area
                TextField(
                  controller: _testQueryCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Type or paste a prospective customer question here...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _runAiSimulation,
                    icon: _isSimulatingResponse
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Evaluate AI Response', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Test environment mode: No customer message or WhatsApp outbound webhook will be triggered.',
                          style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 24),
        Container(width: 1, height: 480, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        const SizedBox(width: 24),

        // Right: Grounded AI Output & Diagnostics
        Expanded(
          flex: 5,
          child: _currentSimulationResult == null
              ? const Center(child: Text('Run an evaluation to view grounded AI output.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              Text('Grounded Model Output', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Confidence: ${(_currentSimulationResult!.confidenceScore * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Response Bubble
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Text(
                          _currentSimulationResult!.aiResponse,
                          style: TextStyle(fontSize: 13, height: 1.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Diagnostics & Citations
                      Text('Grounding Knowledge Source Citation:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_currentSimulationResult!.matchedKnowledgeSource, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Escalation Decision
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text('Escalation to Human Staff: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          AdminStatusBadge(
                            label: _currentSimulationResult!.escalationDecision ? 'Triggered (Emergency/Human)' : 'No Escalation Required',
                            color: _currentSimulationResult!.escalationDecision ? AppColors.error : AppColors.success,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Suggested Staff Action: ${_currentSimulationResult!.suggestedHumanAction}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
        ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, String query) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      avatar: const Icon(Icons.bolt_rounded, size: 14, color: AppColors.primary),
      onPressed: () {
        _testQueryCtrl.text = query;
        _runAiSimulation();
      },
    );
  }

  void _runAiSimulation() {
    setState(() => _isSimulatingResponse = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final q = _testQueryCtrl.text.toLowerCase();
      AiTestingSimulation match = _simulations.first;
      if (q.contains('leak') || q.contains('damage')) {
        match = _simulations[2];
      } else if (q.contains('discount') || q.contains('15')) {
        match = _simulations[1];
      }

      setState(() {
        _isSimulatingResponse = false;
        _currentSimulationResult = match;
      });
    });
  }

  // ==========================================================================
  // TAB 2: PRICING GUARDRAILS
  // ==========================================================================
  Widget _buildPricingGuardrailsTab(bool isDark) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
          ),
          child: const Row(
            children: [
              Icon(Icons.gavel_rounded, color: AppColors.error, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'CRITICAL PRICING GUARDRAILS:\nAI is strictly prohibited from inventing ad-hoc commercial rates or committing to discounts without architect approval.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final g in _guardrails)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(g.topic, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                      AdminStatusBadge(label: 'Strict Non-Negotiable', color: AppColors.error),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(g.rule, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  const Divider(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
                                SizedBox(width: 6),
                                Text('Allowed Disclosure Guidance:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(g.allowedDisclosure, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                                SizedBox(width: 6),
                                Text('Forbidden Disclosure Topics:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(g.forbiddenDisclosure, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================================
  // TAB 3: APPROVED FAQS
  // ==========================================================================
  Widget _buildFaqsTab(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        final faq = _faqs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.question_mark_rounded, size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(faq.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(faq.answer, style: TextStyle(fontSize: 12.5, height: 1.4, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Wrap(
                    spacing: 6,
                    children: faq.keywords.map((k) => Text('#$k', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 4: KNOWLEDGE SOURCES
  // ==========================================================================
  Widget _buildKnowledgeSourcesTab(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: _sources.length,
      itemBuilder: (context, index) {
        final src = _sources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(src.type.icon, size: 24, color: AppColors.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(src.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('${src.category} • ${src.version} • ${src.tokensCount} Tokens', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 6),
                      Text(src.summary, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                AdminStatusBadge(label: src.status, color: AppColors.success),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddFaqModal(bool isDark) {
    final qCtrl = TextEditingController();
    final aCtrl = TextEditingController();

    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 580,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Knowledge FAQ Entry', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextField(controller: qCtrl, decoration: const InputDecoration(labelText: 'Customer Question Pattern *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: aCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Approved Grounded Response *', border: OutlineInputBorder())),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => setState(() => _isAddFaqModalOpen = false), child: const Text('Cancel')),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (qCtrl.text.isNotEmpty && aCtrl.text.isNotEmpty) {
                        setState(() {
                          _faqs.insert(
                            0,
                            AiFaqItem(
                              id: 'faq_${DateTime.now().millisecondsSinceEpoch}',
                              question: qCtrl.text,
                              answer: aCtrl.text,
                              category: 'General Customer Guidance',
                              lastUpdated: DateTime.now(),
                            ),
                          );
                          _isAddFaqModalOpen = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('FAQ added and queued for vector embedding sync.'), backgroundColor: AppColors.success),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Save & Index'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _triggerModelRetraining() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Re-indexing corpus across vector stores. Ready in ~15 seconds.'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
