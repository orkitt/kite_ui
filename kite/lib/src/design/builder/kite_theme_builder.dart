part of 'kite_theme.dart';

// =============================================================================
// Theme Builder
// =============================================================================

ThemeData _buildKiteTheme({
  required KiteColors colors,
  required KiteTypography typography,
  required Brightness brightness,
}) {
  final type = typography.resolve(colors);
  final textTheme = type.toTextTheme();

  final colorScheme = _buildColorScheme(colors: colors, brightness: brightness);

  final inputTheme = _buildInputTheme(colors: colors, typography: type);

  final base = ThemeData.from(
    colorScheme: colorScheme,
    textTheme: textTheme,
    useMaterial3: true,
  );

  return base.copyWith(
    // =========================================================================
    // Foundation
    // =========================================================================
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.background,
    disabledColor: colors.textDisabled,

    visualDensity: const VisualDensity(horizontal: -1, vertical: -1),

    materialTapTargetSize: MaterialTapTargetSize.padded,

    extensions: <ThemeExtension<dynamic>>[colors, type],

    // =========================================================================
    // Typography
    // =========================================================================
    textTheme: textTheme,

    // =========================================================================
    // Icons
    // =========================================================================
    iconTheme: IconThemeData(color: colors.icon, size: Dimensions.iconMd),

    primaryIconTheme: IconThemeData(
      color: colors.onPrimary,
      size: Dimensions.iconMd,
    ),

    // =========================================================================
    // Text Selection
    // =========================================================================
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colors.primary,
      selectionColor: colors.primarySoft,
      selectionHandleColor: colors.primary,
    ),

    // =========================================================================
    // App Bar
    // =========================================================================
    appBarTheme: AppBarThemeData(
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: Dimensions.appBarHeight,
      titleSpacing: Dimensions.screenPadding,
      titleTextStyle: type.h3,
      iconTheme: IconThemeData(color: colors.icon, size: Dimensions.iconMd),
      actionsIconTheme: IconThemeData(
        color: colors.icon,
        size: Dimensions.iconMd,
      ),
    ),

    // =========================================================================
    // Cards
    // =========================================================================
    cardTheme: CardThemeData(
      color: colors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: Shapes.rounded16.copyWith(
        side: BorderSide(color: colors.borderSoft),
      ),
    ),

    // =========================================================================
    // Inputs
    // =========================================================================
    inputDecorationTheme: inputTheme,

    // =========================================================================
    // Search
    // =========================================================================
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(colors.inputFill),
      //foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      side: WidgetStatePropertyAll(BorderSide(color: colors.border)),
      shape: WidgetStatePropertyAll(Shapes.rounded12),
      padding: const WidgetStatePropertyAll(Dimensions.px16),
      textStyle: WidgetStatePropertyAll(type.body),
      hintStyle: WidgetStatePropertyAll(
        type.body.copyWith(color: colors.textDisabled),
      ),
    ),

    // =========================================================================
    // Filled Button
    // =========================================================================
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.muted,
        disabledForegroundColor: colors.textDisabled,
        minimumSize: const Size(Dimensions.zero, Dimensions.buttonHeightMd),
        padding: Dimensions.px16,
        textStyle: type.label,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: Shapes.rounded12,
      ),
    ),

    // =========================================================================
    // Elevated Button
    // =========================================================================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.card,
        foregroundColor: colors.textPrimary,
        disabledBackgroundColor: colors.muted,
        disabledForegroundColor: colors.textDisabled,
        minimumSize: const Size(Dimensions.zero, Dimensions.buttonHeightMd),
        padding: Dimensions.px16,
        textStyle: type.label,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: Shapes.rounded12.copyWith(
          side: BorderSide(color: colors.border),
        ),
      ),
    ),

    // =========================================================================
    // Outlined Button
    // =========================================================================
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        disabledForegroundColor: colors.textDisabled,
        minimumSize: const Size(Dimensions.zero, Dimensions.buttonHeightMd),
        padding: Dimensions.px16,
        textStyle: type.label,
        side: BorderSide(color: colors.borderStrong),
        shape: Shapes.rounded12,
      ),
    ),

    // =========================================================================
    // Text Button
    // =========================================================================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        disabledForegroundColor: colors.textDisabled,
        minimumSize: const Size(Dimensions.zero, Dimensions.buttonHeightMd),
        padding: Dimensions.px16,
        textStyle: type.label,
        shape: Shapes.rounded12,
      ),
    ),

    // =========================================================================
    // Icon Button
    // =========================================================================
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colors.icon,
        disabledForegroundColor: colors.textDisabled,
        minimumSize: const Size.square(Dimensions.touchTarget),
        iconSize: Dimensions.iconMd,
        shape: Shapes.rounded12,
      ),
    ),

    // =========================================================================
    // Floating Action Button
    // =========================================================================
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 2,
      shape: Shapes.rounded16,
    ),

    // =========================================================================
    // Chips
    // =========================================================================
    chipTheme: ChipThemeData(
      backgroundColor: colors.muted,
      selectedColor: colors.primarySoft,
      disabledColor: colors.muted,
      labelStyle: type.labelSmall,
      secondaryLabelStyle: type.labelSmall.copyWith(color: colors.primary),
      side: BorderSide(color: colors.borderSoft),
      padding: Dimensions.px8,
      shape: RoundedRectangleBorder(borderRadius: Dimensions.radFull),
      showCheckmark: false,
    ),

    // =========================================================================
    // Checkbox
    // =========================================================================
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: Dimensions.rad4),
      side: BorderSide(color: colors.borderStrong, width: 1.5),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.muted;
        }

        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }

        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(colors.onPrimary),
    ),

    // =========================================================================
    // Radio
    // =========================================================================
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textDisabled;
        }

        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }

        return colors.icon;
      }),
    ),

    // =========================================================================
    // Switch
    // =========================================================================
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textDisabled;
        }

        if (states.contains(WidgetState.selected)) {
          return colors.onPrimary;
        }

        return colors.card;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.muted;
        }

        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }

        return colors.muted;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }

        return colors.borderStrong;
      }),
    ),

    // =========================================================================
    // Slider
    // =========================================================================
    sliderTheme: SliderThemeData(
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.muted,
      thumbColor: colors.primary,
      overlayColor: colors.primarySoft,
      valueIndicatorColor: colors.textPrimary,
      valueIndicatorTextStyle: type.caption.copyWith(color: colors.background),
    ),

    // =========================================================================
    // Progress Indicator
    // =========================================================================
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.muted,
    ),

    // =========================================================================
    // Dividers
    // =========================================================================
    dividerTheme: DividerThemeData(
      color: colors.borderSoft,
      thickness: 1,
      space: 1,
    ),

    // =========================================================================
    // List Tile
    // =========================================================================
    listTileTheme: ListTileThemeData(
      dense: true,
      contentPadding: Dimensions.px16,
      iconColor: colors.icon,
      textColor: colors.textPrimary,
      titleTextStyle: type.title,
      subtitleTextStyle: type.bodySmall,
      leadingAndTrailingTextStyle: type.labelSmall,
      shape: Shapes.rounded12,
    ),

    // =========================================================================
    // Tabs
    // =========================================================================
    tabBarTheme: TabBarThemeData(
      labelColor: colors.primary,
      unselectedLabelColor: colors.textSecondary,
      labelStyle: type.labelSmall.copyWith(color: colors.primary),
      unselectedLabelStyle: type.labelSmall,
      indicatorColor: colors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: colors.borderSoft,
      dividerHeight: 1,
    ),

    // =========================================================================
    // Navigation Bar
    // =========================================================================
    navigationBarTheme: NavigationBarThemeData(
      height: Dimensions.navigationBarHeight,
      backgroundColor: colors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: colors.primarySoft,
      indicatorShape: Shapes.rounded12,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);

        return IconThemeData(
          color: selected ? colors.primary : colors.textSecondary,
          size: Dimensions.iconMd,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);

        return type.labelSmall.copyWith(
          color: selected ? colors.primary : colors.textSecondary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        );
      }),
    ),

    // =========================================================================
    // Navigation Rail
    // =========================================================================
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colors.card,
      indicatorColor: colors.primarySoft,
      useIndicator: true,
      elevation: 0,
      minWidth: Dimensions.railWidth,
      minExtendedWidth: Dimensions.railExtendedWidth,
      selectedIconTheme: IconThemeData(
        color: colors.primary,
        size: Dimensions.iconMd,
      ),
      unselectedIconTheme: IconThemeData(
        color: colors.textSecondary,
        size: Dimensions.iconMd,
      ),
      selectedLabelTextStyle: type.labelSmall.copyWith(
        color: colors.primary,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelTextStyle: type.labelSmall,
    ),

    // =========================================================================
    // Bottom Sheet
    // =========================================================================
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.card,
      modalBackgroundColor: colors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      showDragHandle: true,
      dragHandleColor: colors.borderStrong,
      dragHandleSize: const Size(Dimensions.s32, Dimensions.s4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.r24),
        ),
      ),
    ),

    // =========================================================================
    // Dialog
    // =========================================================================
    dialogTheme: DialogThemeData(
      backgroundColor: colors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconColor: colors.primary,
      titleTextStyle: type.h3,
      contentTextStyle: type.body.copyWith(color: colors.textSecondary),
      shape: Shapes.rounded20.copyWith(
        side: BorderSide(color: colors.borderSoft),
      ),
    ),

    // =========================================================================
    // Popup Menu
    // =========================================================================
    popupMenuTheme: PopupMenuThemeData(
      color: colors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      textStyle: type.body,
      labelTextStyle: WidgetStatePropertyAll(type.body),
      shape: Shapes.rounded12.copyWith(
        side: BorderSide(color: colors.borderSoft),
      ),
    ),

    // =========================================================================
    // Data Table
    // =========================================================================
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(colors.muted),
      headingTextStyle: type.labelSmall.copyWith(color: colors.textPrimary),
      dataTextStyle: type.bodySmall.copyWith(color: colors.textPrimary),
      dividerThickness: 1,
    ),

    // =========================================================================
    // SnackBar
    // =========================================================================
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.textPrimary,
      contentTextStyle: type.bodySmall.copyWith(color: colors.background),
      actionTextColor: colors.primary,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: Shapes.rounded12,
    ),

    // =========================================================================
    // Tooltip
    // =========================================================================
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.textPrimary,
        borderRadius: Dimensions.rad8,
      ),
      textStyle: type.caption.copyWith(color: colors.background),
    ),
  );
}

// =============================================================================
// Input Theme
// =============================================================================

InputDecorationThemeData _buildInputTheme({
  required KiteColors colors,
  required KiteTypography typography,
}) {
  return InputDecorationThemeData(
    filled: true,
    fillColor: colors.inputFill,
    isDense: true,

    contentPadding: Dimensions.px16 + Dimensions.py12,

    hintStyle: typography.body.copyWith(color: colors.textDisabled),

    labelStyle: typography.body.copyWith(color: colors.textSecondary),

    floatingLabelStyle: typography.labelSmall.copyWith(color: colors.primary),

    helperStyle: typography.caption.copyWith(color: colors.textSecondary),

    errorStyle: typography.caption.copyWith(color: colors.error),

    counterStyle: typography.caption.copyWith(color: colors.textSecondary),

    prefixIconColor: colors.icon,
    suffixIconColor: colors.icon,

    border: Shapes.inputBorder(color: colors.border),

    enabledBorder: Shapes.inputBorder(color: colors.border),

    focusedBorder: Shapes.inputBorder(color: colors.primary, width: 1.5),

    errorBorder: Shapes.inputBorder(color: colors.error),

    focusedErrorBorder: Shapes.inputBorder(color: colors.error, width: 1.5),

    disabledBorder: Shapes.inputBorder(color: colors.borderSoft),
  );
}

// =============================================================================
// Color Scheme
// =============================================================================

ColorScheme _buildColorScheme({
  required KiteColors colors,
  required Brightness brightness,
}) {
  return ColorScheme(
    brightness: brightness,

    // Brand
    primary: colors.primary,
    onPrimary: colors.onPrimary,

    primaryContainer: colors.primarySoft,
    onPrimaryContainer: colors.textPrimary,

    secondary: colors.secondary,
    onSecondary: colors.onSecondary,

    secondaryContainer: colors.secondarySoft,
    onSecondaryContainer: colors.textPrimary,

    // Status
    error: colors.error,
    onError: colors.background,

    errorContainer: colors.errorSoft,
    onErrorContainer: colors.error,

    // Material compatibility
    surface: colors.card,
    onSurface: colors.textPrimary,

    surfaceDim: colors.muted,
    surfaceBright: colors.card,

    surfaceContainerLowest: colors.background,
    surfaceContainerLow: colors.card,
    surfaceContainer: colors.muted,
    surfaceContainerHigh: colors.inputFill,
    surfaceContainerHighest: colors.muted,

    onSurfaceVariant: colors.textSecondary,

    outline: colors.borderStrong,
    outlineVariant: colors.border,

    surfaceTint: Colors.transparent,

    shadow: colors.textPrimary.withValues(alpha: 0.10),

    scrim: colors.textPrimary.withValues(alpha: 0.55),

    inverseSurface: colors.textPrimary,
    onInverseSurface: colors.background,
    inversePrimary: colors.primary,
  );
}
