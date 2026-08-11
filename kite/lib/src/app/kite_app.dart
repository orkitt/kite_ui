import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../design/responsive/responsive_kite.dart';
import 'package:flutter/foundation.dart';

enum _KiteAppType { navigator, router }

/// Root application widget for Kite.
///
/// Supports both:
///
/// ```dart
/// KiteApp(
///   home: const HomePage(),
/// )
/// ```
///
/// and Router 2.0:
///
/// ```dart
/// KiteApp.router(
///   routerConfig: router,
/// )
/// ```
///
/// Both modes share:
/// - Kite responsive lifecycle protection
/// - Material theme
/// - ScaffoldMessenger
/// - Material/Cupertino localization
/// - HeroController
/// - Kite debug grid
/// - Kite debug banner
class KiteApp extends StatefulWidget {
  /// Creates a classic Navigator-based Kite application.
  ///
  /// Similar usage to [MaterialApp]:
  ///
  /// ```dart
  /// KiteApp(
  ///   home: const HomePage(),
  /// )
  /// ```
  const KiteApp({
    super.key,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.pageRouteBuilder,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.debugGrid = false,
    this.debugShowKiteBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior = const MaterialScrollBehavior(),
  }) : assert(
         home != null ||
             onGenerateRoute != null ||
             onUnknownRoute != null ||
             builder != null,
         'KiteApp requires home, routes, onGenerateRoute, '
         'onUnknownRoute, or builder.',
       ),
       routerConfig = null,
       _type = _KiteAppType.navigator;

  /// Creates a Router 2.0 Kite application.
  ///
  /// ```dart
  /// KiteApp.router(
  ///   routerConfig: router,
  /// )
  /// ```
  const KiteApp.router({
    required this.routerConfig,
    super.key,
    this.scaffoldMessengerKey,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.debugGrid = false,
    this.debugShowKiteBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior = const MaterialScrollBehavior(),
  }) : navigatorKey = null,
       home = null,
       routes = const <String, WidgetBuilder>{},
       initialRoute = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = const <NavigatorObserver>[],
       pageRouteBuilder = null,
       _type = _KiteAppType.router;

  final _KiteAppType _type;

  // ---------------------------------------------------------------------------
  // Navigator
  // ---------------------------------------------------------------------------

  final GlobalKey<NavigatorState>? navigatorKey;

  final Widget? home;

  final Map<String, WidgetBuilder> routes;

  final String? initialRoute;

  final RouteFactory? onGenerateRoute;

  final InitialRouteListFactory? onGenerateInitialRoutes;

  final RouteFactory? onUnknownRoute;

  final List<NavigatorObserver> navigatorObservers;

  final PageRouteFactory? pageRouteBuilder;

  // ---------------------------------------------------------------------------
  // Router
  // ---------------------------------------------------------------------------

  final RouterConfig<Object>? routerConfig;

  // ---------------------------------------------------------------------------
  // Shared application configuration
  // ---------------------------------------------------------------------------

  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Inserts an application-level widget above the active Navigator/Router.
  ///
  /// The supplied context is below Kite's active [Theme].
  final TransitionBuilder? builder;

  final String title;

  final GenerateAppTitle? onGenerateTitle;

  final NotificationListenerCallback<NavigationNotification>?
  onNavigationNotification;

  final Color? color;

  // ---------------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------------

  final ThemeData? theme;

  final ThemeData? darkTheme;

  final ThemeMode themeMode;

  final Duration themeAnimationDuration;

  final Curve themeAnimationCurve;

  // ---------------------------------------------------------------------------
  // Localization
  // ---------------------------------------------------------------------------

  final Locale? locale;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  final LocaleListResolutionCallback? localeListResolutionCallback;

  final LocaleResolutionCallback? localeResolutionCallback;

  final Iterable<Locale> supportedLocales;

  // ---------------------------------------------------------------------------
  // Debug
  // ---------------------------------------------------------------------------

  final bool showPerformanceOverlay;

  final bool showSemanticsDebugger;

  /// Flutter's regular DEBUG banner.
  final bool debugShowCheckedModeBanner;

  /// Shows Kite's visual layout grid.
  ///
  /// This is ignored outside debug mode.
  final bool debugGrid;

  /// Shows a small KITE banner in the top-left corner.
  ///
  /// This is ignored outside debug mode.
  final bool debugShowKiteBanner;

  // ---------------------------------------------------------------------------
  // App behavior
  // ---------------------------------------------------------------------------

  final Map<ShortcutActivator, Intent>? shortcuts;

  final Map<Type, Action<Intent>>? actions;

  final String? restorationScopeId;

  final ScrollBehavior scrollBehavior;

  @override
  State<KiteApp> createState() => _KiteAppState();
}

class _KiteAppState extends State<KiteApp> {
  late final HeroController _heroController = HeroController();

  bool get _usesRouter => widget._type == _KiteAppType.router;

  // ---------------------------------------------------------------------------
  // Localization
  // ---------------------------------------------------------------------------

  Iterable<LocalizationsDelegate<dynamic>> get _effectiveDelegates sync* {
    final delegates = widget.localizationsDelegates;

    if (delegates != null) {
      yield* delegates;
    }

    yield GlobalMaterialLocalizations.delegate;
    yield GlobalCupertinoLocalizations.delegate;
    yield GlobalWidgetsLocalizations.delegate;
  }

  // ---------------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------------

  ThemeData _resolveTheme(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    final useDarkTheme =
        widget.themeMode == ThemeMode.dark ||
        (widget.themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);

    if (useDarkTheme) {
      return widget.darkTheme ??
          widget.theme ??
          ThemeData(brightness: Brightness.dark, useMaterial3: true);
    }

    return widget.theme ??
        ThemeData(brightness: Brightness.light, useMaterial3: true);
  }

  // ---------------------------------------------------------------------------
  // Kite child builder
  // ---------------------------------------------------------------------------

  Widget _kiteBuilder(BuildContext context, Widget? child) {
    final theme = _resolveTheme(context);

    final selectionColor =
        theme.textSelectionTheme.selectionColor ??
        theme.colorScheme.primary.withValues(alpha: 0.40);

    final cursorColor =
        theme.textSelectionTheme.cursorColor ?? theme.colorScheme.primary;

    // -----------------------------------------------------------------------
    // Kite responsive lifecycle boundary
    //
    // This is deliberately installed for BOTH KiteApp() and KiteApp.router().
    // Existing responsive APIs remain exactly the same.
    // -----------------------------------------------------------------------

    Widget result = ResponsiveKite(child: child ?? const SizedBox.shrink());

    // -----------------------------------------------------------------------
    // User app builder
    // -----------------------------------------------------------------------

    if (widget.builder != null) {
      final builderChild = result;

      result = Builder(
        builder: (context) {
          return widget.builder!(context, builderChild);
        },
      );
    }

    // -----------------------------------------------------------------------
    // Debug tools
    // -----------------------------------------------------------------------

    result = _applyDebugTools(theme: theme, child: result);

    // -----------------------------------------------------------------------
    // Material application services
    // -----------------------------------------------------------------------

    result = ScaffoldMessenger(
      key: widget.scaffoldMessengerKey,
      child: DefaultSelectionStyle(
        selectionColor: selectionColor,
        cursorColor: cursorColor,
        child: result,
      ),
    );

    return AnimatedTheme(
      data: theme,
      duration: widget.themeAnimationDuration,
      curve: widget.themeAnimationCurve,
      child: result,
    );
  }

  // ---------------------------------------------------------------------------
  // Debug tooling
  // ---------------------------------------------------------------------------

  Widget _applyDebugTools({required ThemeData theme, required Widget child}) {
    if (!kDebugMode) {
      return child;
    }

    Widget result = child;

    if (widget.debugGrid) {
      result = GridPaper(
        interval: 100,
        divisions: 10,
        subdivisions: 1,
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        child: result,
      );
    }

    if (widget.debugShowKiteBanner) {
      result = Banner(
        message: 'KITE 🪁',
        location: BannerLocation.topStart,
        color: theme.colorScheme.primary,
        textStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
        child: result,
      );
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Classic Navigator app
  // ---------------------------------------------------------------------------

  Widget _buildNavigatorApp({
    required Color appColor,
    required TextStyle textStyle,
  }) {
    return WidgetsApp(
      key: GlobalObjectKey(this),
      navigatorKey: widget.navigatorKey,
      navigatorObservers: widget.navigatorObservers,
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      onNavigationNotification: widget.onNavigationNotification,
      pageRouteBuilder:
          widget.pageRouteBuilder ??
          <T>(RouteSettings settings, WidgetBuilder builder) {
            return MaterialPageRoute<T>(settings: settings, builder: builder);
          },
      builder: _kiteBuilder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      color: appColor,
      textStyle: textStyle,
      locale: widget.locale,
      localizationsDelegates: _effectiveDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales: widget.supportedLocales,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  // ---------------------------------------------------------------------------
  // Router 2.0 app
  // ---------------------------------------------------------------------------

  Widget _buildRouterApp({
    required Color appColor,
    required TextStyle textStyle,
  }) {
    return WidgetsApp.router(
      key: GlobalObjectKey(this),
      routerConfig: widget.routerConfig!,
      onNavigationNotification: widget.onNavigationNotification,
      builder: _kiteBuilder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      color: appColor,
      textStyle: textStyle,
      locale: widget.locale,
      localizationsDelegates: _effectiveDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales: widget.supportedLocales,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final lightTheme =
        widget.theme ??
        ThemeData(brightness: Brightness.light, useMaterial3: true);

    final appColor = widget.color ?? lightTheme.colorScheme.primary;

    final fallbackTextStyle =
        lightTheme.textTheme.bodyMedium ?? const TextStyle();

    final Widget app;

    if (_usesRouter) {
      app = _buildRouterApp(appColor: appColor, textStyle: fallbackTextStyle);
    } else {
      app = _buildNavigatorApp(
        appColor: appColor,
        textStyle: fallbackTextStyle,
      );
    }

    return ScrollConfiguration(
      behavior: widget.scrollBehavior,
      child: HeroControllerScope(controller: _heroController, child: app),
    );
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }
}
