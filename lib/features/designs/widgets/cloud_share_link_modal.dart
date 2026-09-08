import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// Modal to generate secure, expiring share links for cloud assets.
class CloudShareLinkModal extends StatefulWidget {
  final String itemName;
  final bool isFolder;
  final String? itemType;

  const CloudShareLinkModal({
    super.key,
    required this.itemName,
    this.isFolder = false,
    this.itemType,
  });

  static void show({
    required BuildContext context,
    required String itemName,
    bool isFolder = false,
    String? itemType,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => CloudShareLinkModal(
        itemName: itemName,
        isFolder: isFolder || (itemType == 'Folder'),
        itemType: itemType,
      ),
    );
  }

  @override
  State<CloudShareLinkModal> createState() => _CloudShareLinkModalState();
}

class _CloudShareLinkModalState extends State<CloudShareLinkModal> {
  String _expiry = '7 Days';
  bool _requirePassword = true;
  final _passwordController = TextEditingController(text: 'Homio@2026');
  bool _allowDownload = false;
  late String _generatedLink;

  @override
  void initState() {
    super.initState();
    _generatedLink = 'https://vault.homio.in/share/token_sec_${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.share_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate Secure Share Link',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Encrypted client / contractor vault access',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),

              Text(
                'Sharing: "${widget.itemName}"',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Expiry Dropdown
              DropdownButtonFormField<String>(
                initialValue: _expiry,
                decoration: const InputDecoration(labelText: 'Link Expiry Window'),
                items: const [
                  DropdownMenuItem(value: '24 Hours', child: Text('24 Hours (Fast Review)')),
                  DropdownMenuItem(value: '7 Days', child: Text('7 Days (Standard)')),
                  DropdownMenuItem(value: '30 Days', child: Text('30 Days (Extended)')),
                  DropdownMenuItem(value: 'Never', child: Text('Permanent (Client Handover)')),
                ],
                onChanged: (v) => setState(() => _expiry = v!),
              ),
              const SizedBox(height: 14),

              // Password Protection Switch
              SwitchListTile(
                title: const Text('Require Password Access'),
                subtitle: const Text('Recipient must enter passkey to view CAD/renders', style: TextStyle(fontSize: 11)),
                value: _requirePassword,
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _requirePassword = val),
              ),
              if (_requirePassword)
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Client Access Password',
                    prefixIcon: Icon(Icons.lock_outline, size: 18),
                  ),
                ),
              const SizedBox(height: 10),

              // Download Permission
              SwitchListTile(
                title: const Text('Allow Direct File Download'),
                subtitle: const Text('If off, files are view-only with anti-piracy watermark', style: TextStyle(fontSize: 11)),
                value: _allowDownload,
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _allowDownload = val),
              ),
              const SizedBox(height: 14),

              // Generated Link Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _generatedLink,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      tooltip: 'Copy Link',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Secure vault link copied to clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Secure access link dispatched via WhatsApp to client.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Send via WhatsApp'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
