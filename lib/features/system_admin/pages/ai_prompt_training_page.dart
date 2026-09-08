import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/system_admin_models.dart';
import '../models/system_admin_mock_data.dart';

class AiPromptTrainingPage extends StatefulWidget {
  const AiPromptTrainingPage({super.key});

  @override
  State<AiPromptTrainingPage> createState() => _AiPromptTrainingPageState();
}

class _AiPromptTrainingPageState extends State<AiPromptTrainingPage> {
  late AiTrainingConfig _config;
  late List<AiKnowledgeSnippet> _snippets;

  // Controllers
  late TextEditingController _promptCtrl;
  late double _temperature;
  late double _maxDiscount;

  // Live Playground State
  final TextEditingController _testMessageCtrl = TextEditingController(
    text: 'Why should I pay ₹18 Lakhs for a 3BHK with Homio when my local carpenter quoted ₹11 Lakhs?',
  );
  bool _isGenerating = false;
  String? _simulatedReply;
  String? _matchedSnippetTitle;

  @override
  void initState() {
    super.initState();
    _config = SystemAdminMockData.aiConfig;
    _snippets = List.from(SystemAdminMockData.knowledgeSnippets);
    _promptCtrl = TextEditingController(text: _config.systemPrompt);
    _temperature = _config.temperature;
    _maxDiscount = _config.maxDiscountPercent;
  }

  @override
  void dispose() {
    _promptCtrl.dispose();
    _testMessageCtrl.dispose();
    super.dispose();
  }

  void _runSimulation() {
    setState(() {
      _isGenerating = true;
      _simulatedReply = null;
      _matchedSnippetTitle = null;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final query = _testMessageCtrl.text.toLowerCase();

      String reply;
      String snippetTitle;

      if (query.contains('carpenter') || query.contains('cheaper') || query.contains('expensive')) {
        snippetTitle = 'Local Carpenter vs Homio Factory Turnkey';
        reply = '''Hello! 👋 That is a very valid and smart question when planning a luxury home.

While a local freelance carpenter may seem economical upfront, here is what sets Homio apart:

✨ 1. Factory CNC Precision: Machine-pressed edge banding with 0% bubbling vs manual hand-gluing on site.
🛡️ 2. 10-Year Insured Structural Warranty: Certified Century BWP Marine Ply (IS:710) guaranteed against termites and water damage.
⏱️ 3. Legally Binding 45-Day Delivery: With zero hidden surprise costs.

Would you like me to book a quick 20-minute video walkthrough with our Senior Architect Ananya so you can see live material samples?''';
      } else if (query.contains('warranty') || query.contains('guarantee')) {
        snippetTitle = '10-Year Structural Warranty Coverage';
        reply = '''Hi! Homio provides a 10-Year Structural Warranty covering all internal plywood carcasses, plus lifetime warranty on German Blum/Hafele soft-close hardware. You also receive 1 full year of complimentary on-demand snag maintenance! 🛠️''';
      } else {
        snippetTitle = 'Starting Pricing & Turnkey Packages';
        reply = '''Thank you for reaching out to Homio Luxury Turnkey Interiors! 🌟 Our comprehensive turnkey interiors start from ₹12 Lakhs for premium 3BHK apartments. Shall I connect you with our lead design consultant for your floor plan review?''';
      }

      setState(() {
        _isGenerating = false;
        _simulatedReply = reply;
        _matchedSnippetTitle = snippetTitle;
      });
    });
  }

  void _showAddSnippetModal(bool isDark) {
    final titleCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'FAQ');
    final patternCtrl = TextEditingController();
    final responseCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.bookmark_add_rounded, color: AppColors.gold, size: 22),
            const SizedBox(width: 10),
            Text(
              'Add Knowledge Base Snippet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Topic Title (e.g. Sobha Villa Case Study)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryCtrl,
                style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Category (FAQ, Case Study, Objection Handling, Policy)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: patternCtrl,
                style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Sample Customer Questions / Keywords'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: responseCtrl,
                maxLines: 4,
                style: TextStyle(color: isDark ? AppColors.pureWhite : AppColors.deepNavy, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Target Architectural WhatsApp Response'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty || responseCtrl.text.isEmpty) return;
              final newSnippet = AiKnowledgeSnippet(
                id: 'KB-${_snippets.length + 1}',
                title: titleCtrl.text,
                category: categoryCtrl.text,
                questionPattern: patternCtrl.text,
                responseBody: responseCtrl.text,
                isVerified: true,
                lastUpdated: DateTime.now(),
              );
              setState(() => _snippets.insert(0, newSnippet));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
            child: const Text('Save Snippet', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _deployPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'WhatsApp Conversational AI Prompt & Knowledge Vector Index deployed to production gateway.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F9D58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildModelStatusBanner(isDark),
            const SizedBox(height: 24),
            _buildPromptStudio(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildGuardrailsRow(isDark, width),
            const SizedBox(height: 24),
            _buildKnowledgeBaseSection(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildLivePlaygroundSection(isDark, isDesktop),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.model_training_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'WhatsApp Conversational AI Prompt & Training',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'PRD Module 14.3: Tune WhatsApp AI persona, knowledge base FAQs, objection handling, and safety escalation guardrails.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _deployPrompt,
          icon: const Icon(Icons.cloud_upload_rounded, size: 16),
          label: const Text('Deploy to Production'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildModelStatusBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.hub_rounded, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ACTIVE ENGINE: ${_config.modelName.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LATENCY 280ms • 99.98% UPTIME',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Connected to Official Meta Cloud API Webhook. Vector Retrieval-Augmented Generation (RAG) enabled with ${_snippets.length} active knowledge snippets.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptStudio(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.code_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'System Persona Prompt (Instruction Rules)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Tone: ${_config.primaryTone}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: TextField(
              controller: _promptCtrl,
              maxLines: 8,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.5,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Sliders Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Creativity / Temperature:', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                        Text(_temperature.toStringAsFixed(2), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.gold)),
                      ],
                    ),
                    Slider(
                      value: _temperature,
                      min: 0.1,
                      max: 0.8,
                      divisions: 14,
                      activeColor: AppColors.gold,
                      onChanged: (val) => setState(() => _temperature = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Max Automated Discount Limit:', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                        Text('${_maxDiscount.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                      ],
                    ),
                    Slider(
                      value: _maxDiscount,
                      min: 0.0,
                      max: 10.0,
                      divisions: 10,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) => setState(() => _maxDiscount = val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuardrailsRow(bool isDark, double width) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Color(0xFFEF4444), size: 18),
              const SizedBox(width: 10),
              Text(
                'Human Escalation Trigger Keywords (Auto-Handoff to Sales Head)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'When an incoming customer message contains any of these phrases, AI stops automated messaging and pages the designated relationship manager immediately.',
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _config.humanEscalationKeywords.map((keyword) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_rounded, size: 12, color: Color(0xFFEF4444)),
                    const SizedBox(width: 6),
                    Text(
                      keyword,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeBaseSection(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_stories_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Knowledge Base RAG Ingestion (${_snippets.length} Verified Snippets)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddSnippetModal(isDark),
                icon: const Icon(Icons.add_rounded, size: 14),
                label: const Text('Add Knowledge Snippet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.deepNavy,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            snippet.category.toUpperCase(),
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.gold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          snippet.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        const Text(
                          'Indexed & Verified',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Triggers on: "${snippet.questionPattern}"',
                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snippet.responseBody,
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLivePlaygroundSection(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.science_outlined, color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Live WhatsApp AI Playground & Verification Sandbox',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _testMessageCtrl,
                  style: TextStyle(fontSize: 13, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                  decoration: InputDecoration(
                    labelText: 'Simulate Incoming Customer WhatsApp Message',
                    prefixIcon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.gold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isGenerating ? null : _runSimulation,
                icon: _isGenerating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.deepNavy))
                    : const Icon(Icons.send_rounded, size: 16),
                label: const Text('Test Bot'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.deepNavy,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          if (_simulatedReply != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.2) : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'RAG CONTEXT RETRIEVED: ${_matchedSnippetTitle ?? "General Persona"} (Confidence 98.4%)',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    _simulatedReply!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
