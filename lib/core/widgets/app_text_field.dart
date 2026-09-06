import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.isDense = false,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool isDense;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;
  bool _isFocused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    // Semantic Colors
    final labelColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final hintColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    Color fillColor = isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurface;
    Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    if (_isFocused) {
      borderColor = hasError
          ? AppColors.error
          : (isDark ? AppColors.primaryLight : AppColors.primary);
      fillColor = isDark
          ? AppColors.darkSurfaceElevated
          : AppColors.primary.withValues(alpha: 0.02);
    } else if (hasError) {
      borderColor = AppColors.error;
    }

    final isDense = widget.isDense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDense ? 12.0 : 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: labelColor,
          ),
        ),
        SizedBox(height: isDense ? 4 : 8),

        // Text Field Container
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(isDense ? 9 : 12),
            border: Border.all(
              color: borderColor,
              width: _isFocused ? (isDense ? 1.5 : 2.0) : 1.2,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: (hasError ? AppColors.error : AppColors.primary).withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(left: isDense ? 11 : 14, right: 4),
                  child: Icon(
                    widget.prefixIcon,
                    size: isDense ? 17 : 20,
                    color: _isFocused
                        ? (isDark ? AppColors.primaryLight : AppColors.primary)
                        : hintColor,
                  ),
                ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  initialValue: widget.initialValue,
                  focusNode: _focusNode,
                  obscureText: widget.isPassword ? _obscureText : false,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isDense ? 13.0 : 14.5,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: isDense ? 12.5 : 14.0,
                      fontWeight: FontWeight.w400,
                      color: hintColor,
                    ),
                    filled: false,
                    isDense: isDense,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 6 : 14,
                      vertical: isDense ? 10 : 14,
                    ),
                  ),
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: isDense ? 18 : 20,
                    color: hintColor,
                  ),
                  padding: isDense ? const EdgeInsets.only(right: 8) : null,
                  constraints: isDense ? const BoxConstraints() : null,
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  tooltip: _obscureText ? 'Show password' : 'Hide password',
                )
              else if (widget.suffix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: widget.suffix!,
                ),
            ],
          ),
        ),

        // Inline Error Text
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
