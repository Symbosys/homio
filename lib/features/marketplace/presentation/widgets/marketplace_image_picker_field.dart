import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/image_compressor.dart';
import '../../../../core/utils/toast_service.dart';
import '../../../../core/utils/web_image_picker/web_image_picker.dart';
import '../../../../permission/permission.dart';

class MarketplaceImagePickerField extends StatefulWidget {
  final String label;
  final String? initialUrl;
  final Uint8List? selectedBytes;
  final String? selectedFileName;
  final void Function(Uint8List bytes, String fileName)? onImageSelected;
  final VoidCallback? onImageRemoved;

  const MarketplaceImagePickerField({
    super.key,
    this.label = 'Product Cover Image / Photo',
    this.initialUrl,
    this.selectedBytes,
    this.selectedFileName,
    this.onImageSelected,
    this.onImageRemoved,
  });

  @override
  State<MarketplaceImagePickerField> createState() => _MarketplaceImagePickerFieldState();
}

class _MarketplaceImagePickerFieldState extends State<MarketplaceImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  bool _isCompressing = false;

  Future<void> _handlePickImage() async {
    try {
      final hasPermission = await GalleryPermission.request();
      if (!hasPermission) {
        ToastService.showError('Gallery access was denied. Please allow photos access in settings.');
        return;
      }

      Uint8List? rawBytes;
      String? fileName;

      if (kIsWeb) {
        final webPicked = await pickImageWeb();
        if (webPicked == null) return;
        rawBytes = webPicked.bytes;
        fileName = webPicked.name;
      } else {
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

      final compressedBytes = await ImageCompressor.compressUnder100KB(rawBytes);

      setState(() => _isCompressing = false);

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              // Preview Box
              Container(
                width: 100,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _isCompressing
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        )
                      : hasMemoryImage
                          ? Image.memory(
                              widget.selectedBytes!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 70,
                            )
                          : hasNetworkImage
                              ? Image.network(
                                  widget.initialUrl!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 70,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey,
                                    size: 28,
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 28,
                                    color: isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                ),
              ),
              const SizedBox(width: 14),

              // Actions & Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isCompressing ? null : _handlePickImage,
                          icon: const Icon(Icons.file_upload_outlined, size: 16),
                          label: Text(
                            hasMemoryImage || hasNetworkImage ? 'Change Image' : 'Upload Image',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                        if ((hasMemoryImage || hasNetworkImage) && widget.onImageRemoved != null) ...[
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
                        'Upload JPG, PNG or WEBP from device (auto-compressed < 100 KB).',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
