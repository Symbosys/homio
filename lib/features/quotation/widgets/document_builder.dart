import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// PDF Document & Proposal Layout customizer matching PRD Section 19 & 31.
class DocumentBuilder extends StatefulWidget {
  final DocumentConfig config;
  final ValueChanged<DocumentConfig> onConfigChanged;

  const DocumentBuilder({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<DocumentBuilder> createState() => _DocumentBuilderState();
}

class _DocumentBuilderState extends State<DocumentBuilder> {
  late TextEditingController _titleCtrl;
  late TextEditingController _subCtrl;
  late List<DocumentSectionType> _sections;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.config.coverTitle);
    _subCtrl = TextEditingController(text: widget.config.coverSubtitle);
    _sections = List.from(widget.config.selectedSections);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onConfigChanged(
      widget.config.copyWith(
        coverTitle: _titleCtrl.text,
        coverSubtitle: _subCtrl.text,
        selectedSections: _sections,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Document Design & Presentation Sections',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Cover Title & Subtitle
          TextFormField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              labelText: 'Proposal Cover Title',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _subCtrl,
            decoration: InputDecoration(
              labelText: 'Cover Subtitle / Tagline',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 16),

          Text(
            'INCLUDED PROPOSAL SECTIONS',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // Toggles for sections
          ...DocumentSectionType.values.map((sec) {
            final isIncluded = _sections.contains(sec);

            return CheckboxListTile(
              value: isIncluded,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Icon(sec.icon, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(sec.label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _sections.add(sec);
                  } else {
                    _sections.remove(sec);
                  }
                });
                _notify();
              },
            );
          }),
        ],
      ),
    );
  }
}
