import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/router/app_router.dart';
import '../network/api_exception.dart';

/// Production-grade Global Toast Notification Service for Homio SaaS platform.
/// Displays high-fidelity floating animated toast banners at bottom-center across all devices.
/// Can be invoked globally from any TanStack Query callback (onSuccess / onError), ViewModel, or UI button.
class ToastService {
  ToastService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  /// Extract clean, user-facing error message from backend error responses
  static String extractErrorMessage(dynamic error, {String? defaultMessage}) {
    if (error == null) {
      return defaultMessage ?? 'An unexpected error occurred. Please try again.';
    }
    if (error is ApiException) {
      return error.message;
    }
    if (error is String) {
      return error;
    }
    if (error is Exception) {
      final str = error.toString();
      if (str.startsWith('Exception: ')) {
        return str.substring(11);
      }
      return str;
    }
    return error.toString();
  }

  /// Show Success Toast (bottom-center)
  static void showSuccess(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    BuildContext? context,
  }) {
    _display(
      message: message,
      title: title,
      isSuccess: true,
      duration: duration,
      context: context,
    );
  }

  /// Show Error Toast without generic error word prefix (bottom-center)
  static void showError(
    dynamic error, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    BuildContext? context,
  }) {
    final message = extractErrorMessage(error);
    _display(
      message: message,
      title: title,
      isSuccess: false,
      duration: duration,
      context: context,
    );
  }

  static void _display({
    required String message,
    String? title,
    required bool isSuccess,
    required Duration duration,
    BuildContext? context,
  }) {
    // 1. Try displaying via Root Overlay for premium bottom-center floating toast
    final overlayState = context != null
        ? Overlay.maybeOf(context) ?? AppRouter.rootNavigatorKey.currentState?.overlay
        : AppRouter.rootNavigatorKey.currentState?.overlay;

    if (overlayState != null) {
      _showOverlayToast(
        overlayState: overlayState,
        title: title,
        message: message,
        isSuccess: isSuccess,
        duration: duration,
      );
      return;
    }

    // 2. Fallback to ScaffoldMessenger if overlay is not mounted
    final messenger = context != null
        ? ScaffoldMessenger.maybeOf(context) ?? messengerKey.currentState
        : messengerKey.currentState;

    if (messenger != null) {
      messenger.removeCurrentSnackBar();
      final bg = isSuccess ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D);
      final border = isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      final icon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;

      messenger.showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          width: 380, // Consistent mobile width across all screens
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: border, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  static void _showOverlayToast({
    required OverlayState overlayState,
    String? title,
    required String message,
    required bool isSuccess,
    required Duration duration,
  }) {
    _dismissTimer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastAnimatedBanner(
        title: title,
        message: message,
        isSuccess: isSuccess,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlayState.insert(entry);

    _dismissTimer = Timer(duration + const Duration(milliseconds: 300), () {
      if (_currentEntry == entry) {
        _currentEntry?.remove();
        _currentEntry = null;
      }
    });
  }
}

class _ToastAnimatedBanner extends StatefulWidget {
  final String? title;
  final String message;
  final bool isSuccess;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastAnimatedBanner({
    this.title,
    required this.message,
    required this.isSuccess,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastAnimatedBanner> createState() => _ToastAnimatedBannerState();
}

class _ToastAnimatedBannerState extends State<_ToastAnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _exitTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Smooth entrance slide up from bottom
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();

    _exitTimer = Timer(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  void _dismissNow() {
    _exitTimer?.cancel();
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) widget.onDismiss();
      });
    }
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Consistent compact mobile width across all viewports
    final toastWidth = screenWidth > 420 ? 380.0 : (screenWidth - 32.0);

    final bgGradient = widget.isSuccess
        ? const LinearGradient(
            colors: [Color(0xFF064E3B), Color(0xFF065F46)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF7F1D1D), Color(0xFF991B1B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final borderColor = widget.isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final iconBgColor = widget.isSuccess ? const Color(0xFF047857) : const Color(0xFFB91C1C);
    final iconData = widget.isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;

    return Positioned(
      bottom: 28,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) > 100) {
                    _dismissNow();
                  }
                },
                child: Dismissible(
                  key: const ValueKey('homio_toast_dismissible'),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    widget.onDismiss();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: SizedBox(
                      width: toastWidth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: bgGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor.withValues(alpha: 0.55), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: borderColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: iconBgColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: borderColor.withValues(alpha: 0.8),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(iconData, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.title != null && widget.title!.isNotEmpty) ...[
                                    Text(
                                      widget.title!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                  Text(
                                    widget.message,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.95),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: _dismissNow,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Standalone convenience helpers
void showSuccessToast(String message, {String? title, BuildContext? context}) {
  ToastService.showSuccess(message, title: title, context: context);
}

void showErrorToast(dynamic error, {String? title, BuildContext? context}) {
  ToastService.showError(error, title: title, context: context);
}
