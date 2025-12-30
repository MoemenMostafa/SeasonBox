import 'package:flutter/material.dart';
import 'package:seasonbox/l10n/app_localizations.dart';

enum Season { winter, spring, summer, fall }

class SeasonHelper {
  /// Returns the season that is currently active.
  static Season getCurrentSeason({DateTime? referenceDate}) {
    final date = referenceDate ?? DateTime.now();
    return getSeasonForMonth(date.month);
  }

  /// Returns the season for a given month (1-12).
  static Season getSeasonForMonth(int month) {
    if (month == 12 || month == 1 || month == 2) return Season.winter;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    return Season.fall;
  }

  /// Returns the next season.
  static Season getNextSeason(Season current) {
    switch (current) {
      case Season.winter:
        return Season.spring;
      case Season.spring:
        return Season.summer;
      case Season.summer:
        return Season.fall;
      case Season.fall:
        return Season.winter;
    }
  }

  /// Determines if a new season is approaching (within 1 month).
  /// We show the reminder for the NEXT season if we are in the last month of the current season.
  static Season? getUpcomingSeasonReminder({DateTime? referenceDate}) {
    final date = referenceDate ?? DateTime.now();
    final month = date.month;

    // Check if we are in the month preceding a season change
    // Winter starts Dec (Preceding: Nov)
    // Spring starts Mar (Preceding: Feb)
    // Summer starts Jun (Preceding: May)
    // Fall starts Sep (Preceding: Aug)

    if (month == 11) return Season.winter;
    if (month == 2) return Season.spring;
    if (month == 5) return Season.summer;
    if (month == 8) return Season.fall;

    return null;
  }

  /// Returns the title and message for the given season.
  static ({String title, String message}) getSeasonStrings(
      BuildContext context, Season season) {
    final l10n = AppLocalizations.of(context)!;
    switch (season) {
      case Season.winter:
        return (
          title: l10n.home_reminder_winterTitle,
          message: l10n.home_reminder_winterMessage
        );
      case Season.spring:
        return (
          title: l10n.home_reminder_springTitle,
          message: l10n.home_reminder_springMessage
        );
      case Season.summer:
        return (
          title: l10n.home_reminder_summerTitle,
          message: l10n.home_reminder_summerMessage
        );
      case Season.fall:
        return (
          title: l10n.home_reminder_fallTitle,
          message: l10n.home_reminder_fallMessage
        );
    }
  }
}
