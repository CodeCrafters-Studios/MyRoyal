import 'package:flutter/material.dart';

// ─── Brand Core ───────────────────────────────────────────────────────────────
/// Deep navy — primary brand identity (appbar, key surfaces)
const primary = Color(0xFF1A1D3B);

/// Mid navy — used on secondary brand surfaces
const primary2 = Color(0xFF2D3580);

/// Warm gold — the signature accent & CTA color
const secondary = Color(0xFFC8922A);

/// Light gold — shimmer / highlight on gold surfaces
const secondary2 = Color(0xFFF0C04A);

// ─── Neutrals ─────────────────────────────────────────────────────────────────
const white = Color(0xFFFFFFFF);
const black = Color.fromRGBO(0, 0, 0, 1);

const grey = Color(0xFFE2E5F0);
const greyHint = Color(0xFFBDBDBD);
const greyIcon = Color.fromRGBO(30, 30, 30, 0.4);
const borderColor = Color(0xFFE2E5F0);
const bgMenuColor = Color.fromRGBO(238, 240, 247, 0.8);

const greyText = Color(0xFF6B7280);
const darkGrey = Color(0xFF9CA3AF);
const grey50 = Color(0xFFF9FAFB);

// ─── Semantic Colors ───────────────────────────────────────────────────────────
const red = Color(0xFFDC2626);
const green = Color(0xFF16A34A);
const urgentColor = Color(0xFFF97316);

// ─── Background & Surface ──────────────────────────────────────────────────────
/// Main scaffold background — soft off-white
const bgColor = Color(0xFFF7F8FC);
const bgColorDark = Color(0xFF1C1F33);
const bgColorDropDown = Color(0xFFF1F5F8);

/// Input field fill color
const inputColor = Color(0xFFEEF0F7);

/// Subtle border color for inputs, dividers
const borderSubtle = Color(0xFFE2E5F0);

const cardColor = Color(0xFFFFFFFF);
const tabbarColor = Color(0xFFFAFAFA);

// ─── Status / Feedback ────────────────────────────────────────────────────────
const focusColor = Color(0xFFC8922A); // Gold focus — consistent with brand
const errorColor = Color(0xFFDC2626);
const successColor = Color(0xFF16A34A);
const normalColor = Color(0xFFB1B1B1);
const disabledColor = Color(0xFF9CA3AF);

// ─── Text ─────────────────────────────────────────────────────────────────────
const appTextColor = Color(0xFF111827);
const appHintColor = Color(0xFF9CA3AF);

// ─── Legacy aliases (kept for backward compatibility) ─────────────────────────
const primaryColor = Color(0xFF1A1D3B); // was 0xFF004BBC
const primaryDark = Color(0xFF111327);
const primaryAccent = Color(0xFF2D3580);

const Color primary10 = Color(0xFF3D4270);
const Color primary20 = Color(0xFF1ABB8C);
const Color primary30 = Color(0xFF5C8DD7);
const Color primary50 = Color(0xFF1A1D3B);
const Color primary70 = Color(0xFF12153A);
const Color primary90 = Color(0xFF0D1030);

const Color secondary90 = Color(0xFF5A3800);
const Color secondary70 = Color(0xFF8B5E00);
const Color secondary50 = Color(0xFFC8922A);
const Color secondary30 = Color(0xFFF0C04A);
const Color secondary10 = Color(0xFFFDE9A0);

const Color neutral90 = Color(0xFF111827);
const Color neutral70 = Color(0xFF374151);
const Color neutral50 = Color(0xFF9CA3AF);
const Color neutral30 = Color(0xFFE5E7EB);
const Color neutral20 = Color(0xFF6B7280);
const Color neutral10 = Color(0xFFF9FAFB);
const Color neutral5 = Color(0xFFFFFFFF);

const greySecond = Color.fromARGB(118, 231, 231, 231);
const favoriteColor = Color(0xFFFAC826);

// Switch Color
const inactiveThumbColor = Color.fromRGBO(84, 110, 122, 1);
const inactiveTrackColor = Color.fromRGBO(189, 189, 189, 1);

const Map<int, Color> materialColor = {
  50: Color.fromRGBO(26, 29, 59, .1),
  100: Color.fromRGBO(26, 29, 59, .2),
  200: Color.fromRGBO(26, 29, 59, .3),
  300: Color.fromRGBO(26, 29, 59, .4),
  400: Color.fromRGBO(26, 29, 59, .5),
  500: Color.fromRGBO(26, 29, 59, .6),
  600: Color.fromRGBO(26, 29, 59, .7),
  700: Color.fromRGBO(26, 29, 59, .8),
  800: Color.fromRGBO(26, 29, 59, .9),
  900: Color.fromRGBO(26, 29, 59, 1),
};

// ─── Gradients ────────────────────────────────────────────────────────────────
class Gradients {
  /// Deep navy header gradient — primary brand gradient
  static LinearGradient primary() {
    return const LinearGradient(
      colors: [Color(0xFF1A1D3B), Color(0xFF2D3580)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Warm gold gradient — for CTA buttons and accent surfaces
  static LinearGradient gold() {
    return const LinearGradient(
      colors: [Color(0xFFC8922A), Color(0xFFF0C04A)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  /// Subtle navy for cards / status surfaces
  static LinearGradient primaryAccent() {
    return const LinearGradient(
      colors: [Color(0xFF2D3580), Color(0xFF3D4270)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Neutral grey gradient for shimmer backgrounds
  static LinearGradient neutral() {
    return const LinearGradient(
      colors: [Color(0xFFE5E7EB), Color(0xFFF9FAFB)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Glass overlay color (use with BackdropFilter)
  static Color get glassOverlay => Colors.white.withOpacity(0.12);
}
