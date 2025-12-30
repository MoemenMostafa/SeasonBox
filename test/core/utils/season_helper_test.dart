import 'package:flutter_test/flutter_test.dart';
import 'package:seasonbox/core/utils/season_helper.dart';

void main() {
  group('SeasonHelper', () {
    test('getSeasonForMonth returns correct season', () {
      expect(SeasonHelper.getSeasonForMonth(12), Season.winter);
      expect(SeasonHelper.getSeasonForMonth(1), Season.winter);
      expect(SeasonHelper.getSeasonForMonth(2), Season.winter);

      expect(SeasonHelper.getSeasonForMonth(3), Season.spring);
      expect(SeasonHelper.getSeasonForMonth(4), Season.spring);
      expect(SeasonHelper.getSeasonForMonth(5), Season.spring);

      expect(SeasonHelper.getSeasonForMonth(6), Season.summer);
      expect(SeasonHelper.getSeasonForMonth(7), Season.summer);
      expect(SeasonHelper.getSeasonForMonth(8), Season.summer);

      expect(SeasonHelper.getSeasonForMonth(9), Season.fall);
      expect(SeasonHelper.getSeasonForMonth(10), Season.fall);
      expect(SeasonHelper.getSeasonForMonth(11), Season.fall);
    });

    test('getNextSeason returns correct next season', () {
      expect(SeasonHelper.getNextSeason(Season.winter), Season.spring);
      expect(SeasonHelper.getNextSeason(Season.spring), Season.summer);
      expect(SeasonHelper.getNextSeason(Season.summer), Season.fall);
      expect(SeasonHelper.getNextSeason(Season.fall), Season.winter);
    });

    test('getUpcomingSeasonReminder returns correct season depending on month',
        () {
      // November (11) -> Winter (Starts in Dec)
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 11, 15)),
          Season.winter);

      // February (2) -> Spring (Starts in Mar)
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 2, 15)),
          Season.spring);

      // May (5) -> Summer (Starts in Jun)
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 5, 15)),
          Season.summer);

      // August (8) -> Fall (Starts in Sep)
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 8, 15)),
          Season.fall);

      // Other months should return null
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 1, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 12, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 3, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 4, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 6, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 7, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 9, 15)),
          null);
      expect(
          SeasonHelper.getUpcomingSeasonReminder(
              referenceDate: DateTime(2023, 10, 15)),
          null);
    });
  });
}
