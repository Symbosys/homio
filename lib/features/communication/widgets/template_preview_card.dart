// Homio CRM — Interactive Template Preview Card

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import 'comm_status_badge.dart';

class TemplatePreviewCard extends StatelessWidget {
  final MessageTemplate template;
  final bool showVariablesTable;

  const TemplatePreviewCard({
    super.key,
    required this.template,
    this.showVariablesTable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meta Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Code: ${template.code} • ${template.language.toUpperCase()} • ${template.category.label}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              CommStatusBadge.fromTemplateStatus(template.status),
            ],
          ),
          const SizedBox(height: 14),

          // WhatsApp Message Phone Bubble Simulation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F2618) : const Color(0xFFDCF8C6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF25D366).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header if present
                if (template.headerType == 'IMAGE' && template.headerMediaUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      template.headerMediaUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 90,
                        color: Colors.black12,
                        child: const Center(child: Icon(Icons.image)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ] else if (template.headerType == 'TEXT' && template.headerText != null) ...[
                  Text(
                    template.headerText!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                ] else if (template.headerType == 'DOCUMENT') ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Color(0xFFEF4444), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          template.headerText ?? 'Quotation_BOQ_Contract.pdf',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Body text with highlighted sample replacements
                Text(
                  template.renderedSample,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),

                // Footer text
                if (template.footerText != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    template.footerText!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],

                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('12:45 PM', style: TextStyle(fontSize: 9, color: Colors.black45)),
                      SizedBox(width: 4),
                      Icon(Icons.done_all, size: 12, color: Color(0xFF2563EB)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          if (template.buttons.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: template.buttons.map((btn) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        btn.type == 'url'
                            ? Icons.open_in_new
                            : (btn.type == 'payment' ? Icons.currency_rupee : Icons.reply),
                        size: 13,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        btn.title,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Variables summary table
          if (showVariablesTable && template.variables.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'Dynamic Variables Mapping',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...template.variables.map((v) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '{{${v.key}}}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '→ ${v.sourceField} (e.g. "${v.sampleValue}")',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
