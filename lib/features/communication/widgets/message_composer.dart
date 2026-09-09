// Homio CRM — Enterprise Multi-Channel Message Composer

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';

class MessageComposer extends StatefulWidget {
  final CommunicationChannel initialChannel;
  final ValueChanged<ChatMessage> onSendMessage;
  final VoidCallback? onScheduleMessage;
  final String conversationId;
  final String recipientName;
  final bool isInternalNoteDefault;

  const MessageComposer({
    super.key,
    this.initialChannel = CommunicationChannel.whatsapp,
    required this.onSendMessage,
    this.onScheduleMessage,
    required this.conversationId,
    required this.recipientName,
    this.isInternalNoteDefault = false,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  late final TextEditingController _controller;
  late CommunicationChannel _channel;
  late bool _isInternalNote;
  final List<MessageAttachment> _stagedAttachments = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _channel = widget.initialChannel;
    _isInternalNote = widget.isInternalNoteDefault;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty && _stagedAttachments.isEmpty) return;

    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: widget.conversationId,
      direction: _isInternalNote ? MessageDirection.internal : MessageDirection.outgoing,
      senderName: 'Priya Sharma',
      senderRole: 'Senior Architect',
      content: text,
      contentType: _stagedAttachments.isNotEmpty
          ? (_stagedAttachments.first.fileType.contains('pdf') ? MessageContentType.document : MessageContentType.image)
          : MessageContentType.text,
      status: MessageStatus.delivered,
      timestamp: DateTime.now(),
      attachments: List.from(_stagedAttachments),
      isInternalNote: _isInternalNote,
    );

    widget.onSendMessage(msg);
    _controller.clear();
    setState(() {
      _stagedAttachments.clear();
    });
  }

  void _showTemplatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Insert Approved WhatsApp Template',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: CommunicationMockData.templates.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final tpl = CommunicationMockData.templates[idx];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _controller.text = tpl.renderedSample;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tpl.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'APPROVED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tpl.renderedSample,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
        );
      },
    );
  }

  void _showVariablePicker() {
    final vars = [
      {'key': '{{customer_name}}', 'desc': 'Client Full Name'},
      {'key': '{{project_name}}', 'desc': 'Residence / Site Name'},
      {'key': '{{designer_name}}', 'desc': 'Assigned Lead Architect'},
      {'key': '{{due_amount}}', 'desc': 'Pending Milestone Balance'},
      {'key': '{{meeting_datetime}}', 'desc': 'Upcoming Consultation Slot'},
      {'key': '{{portal_url}}', 'desc': 'Homio 3D Client Portal URL'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Insert Dynamic CRM Variable', style: TextStyle(fontSize: 15)),
          content: SizedBox(
            width: 320,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: vars.length,
              separatorBuilder: (_, i) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final v = vars[idx];
                return ListTile(
                  dense: true,
                  title: Text(v['key']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                  subtitle: Text(v['desc']!, style: const TextStyle(fontSize: 11)),
                  onTap: () {
                    _controller.text = '${_controller.text} ${v['key']} ';
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addMockAttachment(String type) {
    if (type == 'pdf') {
      setState(() {
        _stagedAttachments.add(
          const MessageAttachment(
            id: 'att_staged_pdf',
            fileName: 'Homio_BOQ_Drawings_V3.pdf',
            fileType: 'application/pdf',
            fileSize: 3450000,
            url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          ),
        );
      });
    } else {
      setState(() {
        _stagedAttachments.add(
          const MessageAttachment(
            id: 'att_staged_img',
            fileName: 'Site_Inspection_MasterSuite.jpg',
            fileType: 'image/jpeg',
            fileSize: 2100000,
            url: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: _isInternalNote
            ? const Color(0xFFFEF3C7).withValues(alpha: isDark ? 0.12 : 0.4)
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        border: Border(
          top: BorderSide(
            color: _isInternalNote
                ? const Color(0xFFF59E0B).withValues(alpha: 0.6)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: _isInternalNote ? 2.0 : 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Staged Attachments Preview
          if (_stagedAttachments.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _stagedAttachments.map((att) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8, right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          att.fileType.contains('pdf') ? Icons.picture_as_pdf : Icons.image,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          att.fileName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => setState(() => _stagedAttachments.remove(att)),
                          child: const Icon(Icons.close, size: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Toolbar row: Channel / Note toggle / Quick insertions
          Row(
            children: [
              // Channel selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _channel.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CommunicationChannel>(
                    value: _channel,
                    isDense: true,
                    icon: Icon(Icons.arrow_drop_down, size: 16, color: _channel.color),
                    onChanged: (c) {
                      if (c != null) setState(() => _channel = c);
                    },
                    items: CommunicationChannel.values.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(c.icon, size: 14, color: c.color),
                            const SizedBox(width: 6),
                            Text(
                              c.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: c.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Internal Note Toggle
              InkWell(
                onTap: () => setState(() => _isInternalNote = !_isInternalNote),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isInternalNote
                        ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
                        : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isInternalNote
                          ? const Color(0xFFF59E0B)
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isInternalNote ? Icons.lock : Icons.lock_open,
                        size: 12,
                        color: _isInternalNote ? const Color(0xFFD97706) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isInternalNote ? 'Internal Note (Staff Only)' : 'Public Reply',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: _isInternalNote ? FontWeight.bold : FontWeight.normal,
                          color: _isInternalNote ? const Color(0xFFD97706) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Quick Action Icons
              IconButton(
                icon: const Icon(Icons.dynamic_form_outlined, size: 18),
                tooltip: 'Insert Template',
                onPressed: _showTemplatePicker,
              ),
              IconButton(
                icon: const Icon(Icons.data_object, size: 18),
                tooltip: 'Insert CRM Variable',
                onPressed: _showVariablePicker,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.attach_file, size: 18),
                tooltip: 'Add Attachment',
                onSelected: (val) => _addMockAttachment(val),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'img',
                    child: Row(
                      children: [
                        Icon(Icons.photo_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Site Photo / 3D Render'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('BOQ / Quotation PDF'),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.onScheduleMessage != null)
                IconButton(
                  icon: const Icon(Icons.schedule_send_outlined, size: 18),
                  tooltip: 'Schedule Message',
                  onPressed: widget.onScheduleMessage,
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Message Text Input
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: _isInternalNote
                        ? 'Type staff note for team architects & project managers...'
                        : 'Reply to ${widget.recipientName} via ${_channel.label}...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _isInternalNote ? const Color(0xFFF59E0B) : AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isInternalNote ? const Color(0xFFD97706) : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isInternalNote ? Icons.note_add : Icons.send, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _isInternalNote ? 'Save Note' : 'Send',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
}
