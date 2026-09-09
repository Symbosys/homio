import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AfterSalesHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final String activeTab;
  final Widget? trailing;
  final String selectedDateFilter;
  final ValueChanged<String>? onDateFilterChanged;

  const AfterSalesHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.activeTab,
    this.trailing,
    this.selectedDateFilter = 'This Month',
    this.onDateFilterChanged,
  });

  @override
  State<AfterSalesHeader> createState() => _AfterSalesHeaderState();
}

class _AfterSalesHeaderState extends State<AfterSalesHeader> {
  late String _currentFilter;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.selectedDateFilter;
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(color: borderColor.withValues(alpha: 0.6)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'AFTER-SALES & CUSTOMER CARE',
                            style: TextStyle(
                              color: Color(0xFF0284C7),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, size: 14, color: textMutedColor),
                        const SizedBox(width: 4),
                        Text(
                          widget.activeTab,
                          style: TextStyle(
                            color: textSecondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: textSecondaryColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Date Range Filter Dropdown & Trailing Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.getBackground(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentFilter,
                        icon: const Icon(Icons.calendar_today_rounded, size: 15),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                        items: const [
                          DropdownMenuItem(value: 'Today', child: Text('Today')),
                          DropdownMenuItem(value: 'Yesterday', child: Text('Yesterday')),
                          DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                          DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                          DropdownMenuItem(value: 'Last Month', child: Text('Last Month')),
                          DropdownMenuItem(value: 'Custom Date Range', child: Text('Custom Range')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _currentFilter = val);
                            widget.onDateFilterChanged?.call(val);
                          }
                        },
                      ),
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 12),
                    widget.trailing!,
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
