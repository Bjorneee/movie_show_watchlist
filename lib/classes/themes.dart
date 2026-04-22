import 'package:flutter/material.dart';


/*          == Color Scheme Usage ==
 
 * Scaffold background:   |    surface
 * Movie cards:           |    surfaceContainerLow
 * Search bar:            |    surfaceContainerHighest
 * App bar:               |    surfaceContainer
 * Primary buttons:       |    primary
 * Main text:             |    onSurface
 * Secondary text:        |    onSurfaceVariant
 
 */

final ColorScheme defaultDarkScheme = .fromSeed(
  seedColor: Color(0xFF2563EB),
  brightness: Brightness.dark,

  // Core brand colors
  primary: Color(0xFF2563EB),               // Primary blue
  onPrimary: Color(0xFFFFFFFF),

  secondary: Color(0xFF60A5FA),             // Soft blue accent
  onSecondary: Color(0xFF0B1120),

  tertiary: Color(0xFF22D3EE),              // Cyan accent
  onTertiary: Color(0xFF0B1120),

  // Main surfaces
  surface: Color(0xFF0B1120),               // App background
  onSurface: Color(0xFFE5E7EB),

  // Layered surfaces
  surfaceDim: Color(0xFF0B1120),
  surfaceBright: Color(0xFF1A2335),

  // Elevated surfaces
  surfaceContainerLowest: Color(0xFF0B1120),
  surfaceContainerLow: Color(0xFF111827),
  surfaceContainer: Color(0xFF111827),
  surfaceContainerHigh: Color(0xFF1A2335),
  surfaceContainerHighest: Color(0xFF1F2937),

  onSurfaceVariant: Color(0xFF9CA3AF),

  // Containers
  primaryContainer: Color(0xFF1D4ED8),
  onPrimaryContainer: Color(0xFFE5E7EB),

  secondaryContainer: Color(0xFF1F2937),
  onSecondaryContainer: Color(0xFFE5E7EB),

  tertiaryContainer: Color(0xFF164E63),
  onTertiaryContainer: Color(0xFFE5E7EB),

  // Error
  error: Color(0xFFEF4444),
  onError: Color(0xFFFFFFFF),

  // Outlines / misc
  outline: Color(0xFF1F2937),
  outlineVariant: Color(0xFF374151),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),

  inverseSurface: Color(0xFFE5E7EB),
  onInverseSurface: Color(0xFF0B1120),
  inversePrimary: Color(0xFF60A5FA),
);

/*        == Default Dark Theme ==

 Default theme to be used for watchlist app.
 Also handles themes for the following widgets:
 
 * Text()
 * AppBar()
 * Card()
 * SearchBar()
 * InputDecoration()
 * Icon()
 * ListTile()
 * BottomNavigationBar()
 * NavigationBar()
 * Chip()
 * ElevatedButton()
 * TextButton()
 * FloatingActionButton()
 * Divider()

 */

ThemeData defaultDarkTheme() {
  final scheme = defaultDarkScheme;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,

    scaffoldBackgroundColor: scheme.surface,
    canvasColor: scheme.surface,
    shadowColor: scheme.shadow,
    dividerColor: scheme.outline,

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surfaceContainerLow,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
      ),
      actionsIconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
      ),
    ),

    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shadowColor: scheme.shadow.withValues(alpha: 0.40),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: scheme.outline.withValues(alpha: 0.35),
        ),
      ),
      margin: const EdgeInsets.all(8),
    ),

    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      shadowColor: WidgetStatePropertyAll(
        scheme.shadow.withValues(alpha: 0.35),
      ),
      elevation: const WidgetStatePropertyAll(4),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
      ),
      hintStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: scheme.outline.withValues(alpha: 0.45),
          ),
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) return scheme.error;
        if (states.contains(WidgetState.focused)) return scheme.primary;
        return scheme.onSurfaceVariant;
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) return scheme.error;
        if (states.contains(WidgetState.focused)) return scheme.primary;
        return scheme.onSurfaceVariant;
      }),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: scheme.outline,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: scheme.outline,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: scheme.primary,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: scheme.error,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: scheme.error,
          width: 1.4,
        ),
      ),
    ),

    iconTheme: IconThemeData(
      color: scheme.onSurfaceVariant,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      textColor: scheme.onSurface,
      tileColor: Colors.transparent,
      selectedColor: scheme.secondary,
      selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      selectedItemColor: scheme.secondary,
      unselectedItemColor: scheme.onSurfaceVariant,
      selectedIconTheme: IconThemeData(color: scheme.secondary),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      indicatorColor: scheme.primaryContainer.withValues(alpha: 0.45),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.secondary);
        }
        return IconThemeData(color: scheme.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontFamily: 'Inter',
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? scheme.onSurface
              : scheme.onSurfaceVariant,
        );
      }),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.primaryContainer,
      disabledColor: scheme.surfaceContainer,
      secondarySelectedColor: scheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        color: scheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: TextStyle(
        fontFamily: 'Inter',
        color: scheme.onSecondaryContainer,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.35)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.secondary,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    dividerTheme: DividerThemeData(
      color: scheme.outline.withValues(alpha: 0.5),
      thickness: 1,
      space: 1,
    ),
  );
}