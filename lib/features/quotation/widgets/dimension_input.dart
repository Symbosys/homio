import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Architectural L×W×H dimension calculator component with auto-computed areas.
class DimensionInput extends StatefulWidget {
  final double lengthFt;
  final double widthFt;
  final double heightFt;
  final void Function(double length, double width, double height) onDimensionsChanged;

  const DimensionInput({
    super.key,
    required this.lengthFt,
    required this.widthFt,
    required this.heightFt,
    required this.onDimensionsChanged,
  });

  @override
  State<DimensionInput> createState() => _DimensionInputState();
}

class _DimensionInputState extends State<DimensionInput> {
  late TextEditingController _lenCtrl;
  late TextEditingController _widCtrl;
  late TextEditingController _hgtCtrl;

  @override
  void initState() {
    super.initState();
    _lenCtrl = TextEditingController(text: widget.lengthFt > 0 ? widget.lengthFt.toString() : '');
    _widCtrl = TextEditingController(text: widget.widthFt > 0 ? widget.widthFt.toString() : '');
    _hgtCtrl = TextEditingController(text: widget.heightFt > 0 ? widget.heightFt.toString() : '10.0');
  }

  @override
  void didUpdateWidget(covariant DimensionInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lengthFt != widget.lengthFt) {
      _lenCtrl.text = widget.lengthFt > 0 ? widget.lengthFt.toString() : '';
    }
    if (oldWidget.widthFt != widget.widthFt) {
      _widCtrl.text = widget.widthFt > 0 ? widget.widthFt.toString() : '';
    }
    if (oldWidget.heightFt != widget.heightFt) {
      _hgtCtrl.text = widget.heightFt > 0 ? widget.heightFt.toString() : '';
    }
  }

  @override
  void dispose() {
    _lenCtrl.dispose();
    _widCtrl.dispose();
    _hgtCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final l = double.tryParse(_lenCtrl.text) ?? 0.0;
    final w = double.tryParse(_widCtrl.text) ?? 0.0;
    final h = double.tryParse(_hgtCtrl.text) ?? 0.0;
    widget.onDimensionsChanged(l, w, h);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = double.tryParse(_lenCtrl.text) ?? 0.0;
    final w = double.tryParse(_widCtrl.text) ?? 0.0;
    final h = double.tryParse(_hgtCtrl.text) ?? 0.0;

    final carpetSqft = l * w;
    final wallSqft = 2 * (l + w) * h;
    final ceilingSqft = l * w;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
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
              Icon(Icons.straighten_rounded, size: 15, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Room Dimensions (Feet)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDimField('Length (ft)', _lenCtrl, isDark),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('×', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: _buildDimField('Width (ft)', _widCtrl, isDark),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('×', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: _buildDimField('Height (ft)', _hgtCtrl, isDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Auto-calculated badges
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _buildComputedBadge('Carpet Area', '${carpetSqft.toStringAsFixed(1)} sq.ft', isDark),
              _buildComputedBadge('Wall Area', '${wallSqft.toStringAsFixed(1)} sq.ft', isDark),
              _buildComputedBadge('Ceiling Area', '${ceilingSqft.toStringAsFixed(1)} sq.ft', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDimField(String label, TextEditingController ctrl, bool isDark) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => _notify(),
      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 11),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
    );
  }

  Widget _buildComputedBadge(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
