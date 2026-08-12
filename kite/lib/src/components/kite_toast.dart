// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'dart:async';

import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/shapes.dart';
import '../design/typography.dart';

enum KiteToastVariant { neutral, success, warning, error, info }

class KiteToast {
  KiteToast._();

  static OverlayEntry? _activeEntry;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    KiteToastVariant variant = KiteToastVariant.neutral,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _activeEntry?.remove();
    _timer?.cancel();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (overlayContext) {
        return _ToastOverlay(
          title: title,
          message: message,
          variant: variant,
          onTap: onTap,
          onAction: onAction,
          actionLabel: actionLabel,
          onClose: () {
            if (entry.mounted) entry.remove();
            if (identical(_activeEntry, entry)) {
              _activeEntry = null;
              _timer?.cancel();
            }
          },
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);

    _timer = Timer(duration, () {
      if (entry.mounted) {
        // Trigger reverse animation before removing
        _ToastOverlayState.activeState?.dismiss();
      }
    });
  }
}

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.variant,
    required this.onClose,
    this.title,
    this.onTap,
    this.onAction,
    this.actionLabel,
  });

  final String? title;
  final String message;
  final KiteToastVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onAction;
  final String? actionLabel;
  final VoidCallback onClose;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  static _ToastOverlayState? activeState;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    activeState = this;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _controller.forward();
  }

  void dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) widget.onClose();
    });
  }

  @override
  void dispose() {
    if (identical(activeState, this)) activeState = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (accent, icon) = switch (widget.variant) {
      KiteToastVariant.success => (
        colors.success,
        Icons.check_circle_outline_rounded,
      ),
      KiteToastVariant.warning => (colors.warning, Icons.error_outline_rounded),
      KiteToastVariant.error => (
        colors.error,
        Icons.remove_circle_outline_rounded,
      ),
      KiteToastVariant.info => (colors.info, Icons.info_outline_rounded),
      KiteToastVariant.neutral => (
        colors.primary,
        Icons.notifications_none_rounded,
      ),
    };

    return Positioned(
      left: Dimensions.s16,
      right: Dimensions.s16,
      bottom: Dimensions.s24 + MediaQuery.paddingOf(context).bottom,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) => widget.onClose(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTap,
                      borderRadius: Dimensions.rad16,
                      highlightColor: Colors.transparent,
                      splashColor: colors.primary.withValues(alpha: 0.04),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: ShapeDecoration(
                          color: colors.card,
                          shape: Shapes.rounded16.copyWith(
                            side: BorderSide(
                              color:
                                  colors.borderSoft,
                              width: 1,
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Refined Variant Icon Container
                            Container(
                              width: Dimensions.s32,
                              height: Dimensions.s32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: Dimensions.iconSm,
                                color: accent,
                              ),
                            ),

                            Dimensions.hBox12,

                            // Message & Optional Title
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.title != null) ...[
                                    Text(
                                      widget.title!,
                                      style: context.typography.label.copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                  Text(
                                    widget.message,
                                    style: context.typography.paragraph
                                        .copyWith(
                                          color: widget.title != null
                                              ? colors.textSecondary
                                              : colors.textPrimary,
                                          fontSize: 13,
                                          height: 1.35,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            // Optional Action Button
                            if (widget.onAction != null &&
                                widget.actionLabel != null) ...[
                              Dimensions.hBox8,
                              TextButton(
                                onPressed: () {
                                  widget.onAction?.call();
                                  dismiss();
                                },
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  foregroundColor: accent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  textStyle: context.typography.label.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                child: Text(widget.actionLabel!),
                              ),
                            ],

                            Dimensions.hBox8,

                            // Close Button
                            InkWell(
                              onTap: dismiss,
                              borderRadius: Dimensions.radFull,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: Dimensions.iconSm,
                                  color: colors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
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
