// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'dart:async';

import 'package:flutter/material.dart';

import '../design/design.dart';

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
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
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
          onClose: () {
            if (entry.mounted) entry.remove();
            if (identical(_activeEntry, entry)) _activeEntry = null;
          },
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
    _timer = Timer(duration, () {
      if (entry.mounted) entry.remove();
      if (identical(_activeEntry, entry)) _activeEntry = null;
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
  });

  final String? title;
  final String message;
  final KiteToastVariant variant;
  final VoidCallback? onTap;
  final VoidCallback onClose;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final accent = switch (widget.variant) {
      KiteToastVariant.success => colors.success,
      KiteToastVariant.warning => colors.warning,
      KiteToastVariant.error => colors.error,
      KiteToastVariant.info => colors.info,
      KiteToastVariant.neutral => colors.primary,
    };

    return Positioned(
      left: Dimensions.s16,
      right: Dimensions.s16,
      bottom: Dimensions.s24 + MediaQuery.paddingOf(context).bottom,
      child: SafeArea(
        top: false,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          offset: _visible ? Offset.zero : const Offset(0, .25),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: _visible ? 1 : 0,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Material(
                    color: Colors.transparent,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: colors.card,
                        shape: Shapes.rounded16.copyWith(
                          side: BorderSide(color: colors.borderSoft),
                        ),
                        shadows: [
                          BoxShadow(
                            color: colors.textPrimary.withValues(alpha: .12),
                            blurRadius: Dimensions.s24,
                            offset: const Offset(0, Dimensions.s8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: Dimensions.p16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Dimensions.s8,
                              height: Dimensions.s40,
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: Dimensions.radFull,
                              ),
                            ),
                            Dimensions.gapH12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.title != null) ...[
                                    Text(
                                      widget.title!,
                                      style: context.typography.label,
                                    ),
                                    Dimensions.gapV4,
                                  ],
                                  Text(
                                    widget.message,
                                    style: context.typography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Dimensions.gapH12,
                            GestureDetector(
                              onTap: widget.onClose,
                              child: Icon(
                                Icons.close_rounded,
                                size: Dimensions.iconSm,
                                color: colors.icon,
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
