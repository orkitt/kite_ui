import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../dimension.dart';

enum KiteLayoutSize { compact, medium, expanded }

/// Canonical viewport breakpoints used by Kite.
abstract final class KiteBreakpoints {
  static const double medium = 700;
  static const double expanded = 1100;

  static KiteLayoutSize resolve(double width) {
    if (!width.isFinite || width < 0) {
      throw ArgumentError.value(
        width,
        'width',
        'Responsive width must be a finite, non-negative number.',
      );
    }

    if (width < medium) return KiteLayoutSize.compact;
    if (width < expanded) return KiteLayoutSize.medium;
    return KiteLayoutSize.expanded;
  }
}

extension KiteLayoutSizeX on KiteLayoutSize {
  bool get compact => this == KiteLayoutSize.compact;
  bool get medium => this == KiteLayoutSize.medium;
  bool get expanded => this == KiteLayoutSize.expanded;
  bool get wide => medium || expanded;

  double get pagePadding => switch (this) {
    KiteLayoutSize.compact => Dimensions.s16,
    KiteLayoutSize.medium => Dimensions.s24,
    KiteLayoutSize.expanded => Dimensions.s32,
  };

  EdgeInsets get pageInsets => EdgeInsets.symmetric(
    horizontal: pagePadding,
    vertical: Dimensions.s24,
  );

  T value<T>({required T compact, T? medium, T? expanded}) {
    return switch (this) {
      KiteLayoutSize.compact => compact,
      KiteLayoutSize.medium => medium ?? compact,
      KiteLayoutSize.expanded => expanded ?? medium ?? compact,
    };
  }

  int columns({int compact = 1, int medium = 2, int expanded = 3}) {
    return value(compact: compact, medium: medium, expanded: expanded);
  }
}

@immutable
class KiteResponsiveData {
  const KiteResponsiveData({required this.size, required this.width});

  final KiteLayoutSize size;
  final double width;

  bool get compact => size.compact;
  bool get medium => size.medium;
  bool get expanded => size.expanded;
  bool get wide => size.wide;

  double get pagePadding => size.pagePadding;
  EdgeInsets get pageInsets => size.pageInsets;

  T value<T>({required T compact, T? medium, T? expanded}) {
    return size.value(compact: compact, medium: medium, expanded: expanded);
  }

  int columns({int compact = 1, int medium = 2, int expanded = 3}) {
    return size.columns(
      compact: compact,
      medium: medium,
      expanded: expanded,
    );
  }
}

/// App-level responsive access for Kite.
///
/// When a [ResponsiveKite] scope exists, these methods read its lifecycle-safe
/// snapshot. Without a scope they gracefully fall back to Flutter's MediaQuery,
/// preserving the existing public API.
abstract final class KiteResponsive {
  static double widthOf(BuildContext context) {
    final scoped = _KiteResponsiveWidthScope.maybeWidthOf(context);
    if (scoped != null) return scoped;
    return MediaQuery.sizeOf(context).width;
  }

  static double? maybeWidthOf(BuildContext context) {
    final scoped = _KiteResponsiveWidthScope.maybeWidthOf(context);
    if (scoped != null) return scoped;
    return MediaQuery.maybeSizeOf(context)?.width;
  }

  static KiteLayoutSize sizeOf(BuildContext context) {
    final scoped = _KiteResponsiveSizeScope.maybeSizeOf(context);
    if (scoped != null) return scoped;
    return KiteBreakpoints.resolve(MediaQuery.sizeOf(context).width);
  }

  static KiteLayoutSize? maybeSizeOf(BuildContext context) {
    final scoped = _KiteResponsiveSizeScope.maybeSizeOf(context);
    if (scoped != null) return scoped;

    final width = MediaQuery.maybeSizeOf(context)?.width;
    return width == null ? null : KiteBreakpoints.resolve(width);
  }

  static KiteResponsiveData of(BuildContext context) {
    return KiteResponsiveData(
      width: widthOf(context),
      size: sizeOf(context),
    );
  }

  static KiteResponsiveData? maybeOf(BuildContext context) {
    final width = maybeWidthOf(context);
    final size = maybeSizeOf(context);

    if (width == null || size == null) return null;
    return KiteResponsiveData(width: width, size: size);
  }
}

/// Lifecycle-safe responsive boundary.
///
/// Public usage remains unchanged:
///
/// ```dart
/// builder: (context, child) {
///   return ResponsiveKite(child: child!);
/// }
/// ```
///
/// The first application frame intentionally exposes a compact responsive
/// snapshot. On Flutter web debug this avoids eagerly mounting the much larger
/// desktop tree while DDC is still lazily linking libraries. Immediately after
/// that first frame, Kite promotes the scope to the real MediaQuery width.
///
/// Once bootstrapped, MediaQuery changes are applied normally and
/// [WidgetsBindingObserver.didChangeMetrics] provides an extra web/desktop
/// safety net.
class ResponsiveKite extends StatefulWidget {
  const ResponsiveKite({required this.child, super.key});

  final Widget child;

  static KiteResponsiveData? maybeOf(BuildContext context) =>
      KiteResponsive.maybeOf(context);

  static KiteResponsiveData of(BuildContext context) =>
      KiteResponsive.of(context);

  static KiteLayoutSize? maybeSizeOf(BuildContext context) =>
      KiteResponsive.maybeSizeOf(context);

  static KiteLayoutSize sizeOf(BuildContext context) =>
      KiteResponsive.sizeOf(context);

  static double? maybeWidthOf(BuildContext context) =>
      KiteResponsive.maybeWidthOf(context);

  static double widthOf(BuildContext context) =>
      KiteResponsive.widthOf(context);

  @override
  State<ResponsiveKite> createState() => _ResponsiveKiteState();
}

class _ResponsiveKiteState extends State<ResponsiveKite>
    with WidgetsBindingObserver {
  KiteResponsiveData _data = const KiteResponsiveData(
    size: KiteLayoutSize.compact,
    width: 0,
  );

  bool _ready = false;
  bool _syncScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final mediaWidth = MediaQuery.maybeSizeOf(context)?.width;
    if (!_isValidWidth(mediaWidth)) return;

    if (!_ready) {
      // Keep first-frame app-level responsive branches compact. The width is
      // still finite/useful for calculations, but is capped below the medium
      // breakpoint so width-based fallback code cannot accidentally construct
      // the desktop branch during bootstrap.
      final bootstrapWidth = math.min(
        mediaWidth!,
        KiteBreakpoints.medium - 1,
      );

      _data = KiteResponsiveData(
        size: KiteLayoutSize.compact,
        width: bootstrapWidth,
      );

      _schedulePostFrameSync();
      return;
    }

    // Flutter calls build after didChangeDependencies, therefore assigning the
    // new snapshot here is sufficient and avoids an unnecessary setState.
    _data = _resolve(mediaWidth!);
  }

  @override
  void didChangeMetrics() {
    // MediaQuery normally rebuilds this state already. This observer is a
    // defensive fallback for browser resizing/restoration and desktop metrics.
    _schedulePostFrameSync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _schedulePostFrameSync();
    }
  }

  void _schedulePostFrameSync() {
    if (_syncScheduled) return;
    _syncScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (!mounted) return;

      final mediaWidth = MediaQuery.maybeSizeOf(context)?.width;
      if (!_isValidWidth(mediaWidth)) return;

      final next = _resolve(mediaWidth!);
      final shouldRebuild =
          !_ready ||
          next.size != _data.size ||
          next.width != _data.width;

      _ready = true;

      if (!shouldRebuild) {
        _data = next;
        return;
      }

      setState(() {
        _data = next;
      });
    });
  }

  bool _isValidWidth(double? width) {
    return width != null && width.isFinite && width >= 0;
  }

  KiteResponsiveData _resolve(double width) {
    return KiteResponsiveData(
      width: width,
      size: KiteBreakpoints.resolve(width),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _KiteResponsiveSizeScope(
      size: _data.size,
      child: _KiteResponsiveWidthScope(
        width: _data.width,
        child: widget.child,
      ),
    );
  }
}

/// Breakpoint and exact-width subscriptions are kept separate so
/// `context.layoutSize` does not rebuild on every pixel of a desktop resize.
class _KiteResponsiveSizeScope extends InheritedWidget {
  const _KiteResponsiveSizeScope({
    required this.size,
    required super.child,
  });

  final KiteLayoutSize size;

  static KiteLayoutSize? maybeSizeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_KiteResponsiveSizeScope>()
        ?.size;
  }

  @override
  bool updateShouldNotify(_KiteResponsiveSizeScope oldWidget) {
    return size != oldWidget.size;
  }
}

class _KiteResponsiveWidthScope extends InheritedWidget {
  const _KiteResponsiveWidthScope({
    required this.width,
    required super.child,
  });

  final double width;

  static double? maybeWidthOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_KiteResponsiveWidthScope>()
        ?.width;
  }

  @override
  bool updateShouldNotify(_KiteResponsiveWidthScope oldWidget) {
    return width != oldWidget.width;
  }
}

extension KiteResponsiveX on BuildContext {
  KiteResponsiveData get layout => KiteResponsive.of(this);

  KiteLayoutSize get layoutSize => KiteResponsive.sizeOf(this);

  double get responsiveWidth => KiteResponsive.widthOf(this);

  bool get isCompact => layoutSize.compact;
  bool get isMedium => layoutSize.medium;
  bool get isExpanded => layoutSize.expanded;
  bool get isWide => layoutSize.wide;

  T responsive<T>({required T compact, T? medium, T? expanded}) {
    return layoutSize.value(
      compact: compact,
      medium: medium,
      expanded: expanded,
    );
  }
}
