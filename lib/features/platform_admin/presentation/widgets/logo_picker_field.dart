import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/image_compressor.dart';
import '../../../../core/utils/toast_service.dart';
import '../../../../core/utils/web_image_picker/web_image_picker.dart';
import '../../../../permission/permission.dart';

class LogoPickerField extends StatefulWidget {
  final String? initialUrl;
  final Uint8List? selectedBytes;
  final String? selectedFileName;
  final void Function(Uint8List bytes, String fileName)? onImageSelected;
  final VoidCallback? onImageRemoved;

  const LogoPickerField({
    super.key,
    this.initialUrl,
    this.selectedBytes,
    this.selectedFileName,
    this.onImageSelected,
    this.onImageRemoved,
  });

  @override
  State<LogoPickerField> createState() => _LogoPickerFieldState();
}

class _LogoPickerFieldState extends State<LogoPickerField> {
  final ImagePicker _picker = ImagePicker();
  bool _isCompressing = false;

  Future<void> _handlePickImage() async {
    try {
      // 1. Check & request gallery permission across Web, Desktop, Mobile
      final hasPermission = await GalleryPermission.request();
      if (!hasPermission) {
        ToastService.showError('Gallery access was denied. Please allow photos access in settings.');
        return;
      }

      Uint8List? rawBytes;
      String? fileName;

      // 2. On Web: Use native browser file picker (bypasses Flutter plugin channel issues completely)
      if (kIsWeb) {
        final webPicked = await pickImageWeb();
        if (webPicked == null) return;
        rawBytes = webPicked.bytes;
        fileName = webPicked.name;
      } else {
        // On Mobile & Desktop: Use image_picker
        final XFile? picked = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1920,
        );
        if (picked == null) return;
        rawBytes = await picked.readAsBytes();
        fileName = picked.name;
      }

      setState(() => _isCompressing = true);

      // 3. Compress strictly under 100KB using pure Dart engine
      final compressedBytes = await ImageCompressor.compressUnder100KB(rawBytes);

      setState(() => _isCompressing = false);

      // 4. Notify parent callback
      widget.onImageSelected?.call(compressedBytes, fileName);
    } catch (e) {
      if (mounted) {
        setState(() => _isCompressing = false);
        ToastService.showError('Failed to pick image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasMemoryImage = widget.selectedBytes != null && widget.selectedBytes!.isNotEmpty;
    final hasNetworkImage = widget.initialUrl != null && widget.initialUrl!.isNotEmpty;
    final sizeKb = hasMemoryImage
        ? (widget.selectedBytes!.lengthInBytes / 1024).toStringAsFixed(1)
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar / Preview Container
        Stack(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _isCompressing
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B5CF6)),
                        ),
                      )
                    : hasMemoryImage
                        ? Image.memory(
                            widget.selectedBytes!,
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                          )
                        : hasNetworkImage
                            ? Image.network(
                                widget.initialUrl!,
                                width: 76,
                                height: 76,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                              )
                            : Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 30,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
              ),
            ),
            if (hasMemoryImage || hasNetworkImage)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Controls & Status Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _isCompressing ? null : _handlePickImage,
                    icon: const Icon(Icons.upload_file_rounded, size: 16),
                    label: Text(
                      hasMemoryImage || hasNetworkImage ? 'Change Logo' : 'Upload Logo',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  if (hasMemoryImage && widget.onImageRemoved != null) ...[
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: widget.onImageRemoved,
                      icon: const Icon(Icons.close_rounded, size: 14, color: Colors.red),
                      label: Text(
                        'Remove',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              if (sizeKb != null)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '✓ $sizeKb KB (Under 100 KB)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ready to upload',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                )
              else
                Text(
                  'Supports JPG, PNG, WEBP. Auto-compressed under 100 KB.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
