import '../enums/gender.dart';

enum MeasurementSystem { metric, imperial }

class GrowthPredictionService {
  /// Predicts the size of clothes after [months] from now for a child of [currentAgeMonths].
  /// [currentSize] is the current size in [system].
  static double predictClothingSize({
    required double currentAgeMonths,
    required double currentSize,
    required int targetMonths,
    required MeasurementSystem system,
    required Gender gender,
  }) {
    // Simplified growth model for clothing
    // 0-24 months: ~1 size every 3-4 months
    // 2-5 years: ~1 size every 6-9 months
    // 6+ years: ~1 size every 12 months

    if (currentAgeMonths >= 216) return currentSize; // 18 years

    double growthRate; // Sizes per month
    if (currentAgeMonths < 24) {
      growthRate = 1.0 / 4.0;
    } else if (currentAgeMonths < 60) {
      growthRate = 1.0 / 8.0;
    } else {
      growthRate = 1.0 / 12.0;
    }

    // In Metric (cm), sizes usually jump by 6cm (80, 86, 92...)
    // In Imperial (Age), sizes jump by 1 year (2T, 3T, 4T...)

    double predictedSize = currentSize + (growthRate * targetMonths);

    if (system == MeasurementSystem.metric) {
      // In metric, we usually round to the nearest standard size (multiple of 6 if cm)
      // If the current size is something like 92, and it grows, it should hit 98 next.
      // But let's return the raw double for the chart and let UI handle display rounding if needed.
      return predictedSize;
    } else {
      return predictedSize;
    }
  }

  /// Predicts the size of shoes after [months] from now.
  static double predictShoeSize({
    required double currentAgeMonths,
    required double currentSize,
    required int targetMonths,
    required MeasurementSystem system,
    required Gender gender,
  }) {
    // Refined shoe growth based on EU standards and max growth age
    // Girls: Foot growth typically stops around 14 years (168 months)
    // Boys: Foot growth typically stops around 18 years (216 months)
    final double maxGrowthAge = gender == Gender.male ? 216.0 : 168.0;

    if (currentAgeMonths >= maxGrowthAge) {
      return currentSize; // Growth has stopped
    }

    double growthRate; // EU sizes per month
    // Rates based on average EU foot growth
    if (currentAgeMonths < 12) {
      growthRate = 0.5; // ~0.5 size per month (rapid)
    } else if (currentAgeMonths < 36) {
      growthRate = 1.0 / 3.0; // ~1 size every 3 months (3 sizes per year)
    } else if (currentAgeMonths < 60) {
      growthRate = 1.0 / 4.0; // ~1 size every 4 months (half size every 2 mos)
    } else if (currentAgeMonths < 120) {
      growthRate = 1.0 / 8.0; // ~1 size every 8 months
    } else {
      // Approaching max growth, rate slows down further
      final monthsUntilStop = maxGrowthAge - currentAgeMonths;
      if (monthsUntilStop <= 0) return currentSize;

      // Slow down to ~1 size every 12-18 months
      growthRate = 1.0 / 12.0;

      // Ensure we don't exceed a reasonable adult size jump if very close to stop
      // This is a simplified linear slowdown for the final years
    }

    double predictedSize = currentSize + (growthRate * targetMonths);

    // If we passed the max growth age during the prediction window, cap it
    if (currentAgeMonths + targetMonths > maxGrowthAge) {
      final double activeMonths = maxGrowthAge - currentAgeMonths;
      predictedSize = currentSize + (growthRate * activeMonths);
    }

    return predictedSize;
  }

  /// Calculates the estimated number of months until the next size is needed.
  static int calculateMonthsUntilNextSize({
    required double currentAgeMonths,
    required double currentSize,
    required String category,
    required MeasurementSystem system,
    required Gender gender,
  }) {
    if (currentSize <= 0) return 0;

    // Determine the next "standard" size
    // For EU: 20 -> 21
    // For US: 4.5 -> 5.0 (though users might buy 5.5, let's assume +1 size jump)
    double nextSize = currentSize + 1.0;

    // Use current growth rate to estimate time
    double growthRate;
    if (category == 'clothes') {
      if (currentAgeMonths >= 216) return 0; // 18 years

      if (currentAgeMonths < 24) {
        growthRate = 1.0 / 4.0;
      } else if (currentAgeMonths < 60) {
        growthRate = 1.0 / 8.0;
      } else {
        growthRate = 1.0 / 12.0;
      }
    } else {
      // Shoe rates from predictShoeSize logic
      final double maxGrowthAge = gender == Gender.male ? 216.0 : 168.0;
      if (currentAgeMonths >= maxGrowthAge) return 0;

      if (currentAgeMonths < 12) {
        growthRate = 0.5;
      } else if (currentAgeMonths < 36) {
        growthRate = 1.0 / 3.0;
      } else if (currentAgeMonths < 60) {
        growthRate = 1.0 / 4.0;
      } else if (currentAgeMonths < 120) {
        growthRate = 1.0 / 8.0;
      } else {
        growthRate = 1.0 / 12.0;
      }
    }

    if (growthRate <= 0) return 0;

    final months = (nextSize - currentSize) / growthRate;
    return months.round();
  }

  /// Converts between systems if needed for display
  static double convertClothingSize(
      double size, MeasurementSystem from, MeasurementSystem to) {
    if (from == to) return size;
    // VERY rough conversion: CM to US Age
    // 80 -> 12m (1.0y)
    // 86 -> 18m (1.5y)
    // 92 -> 2y
    // 110 -> 5y
    // Formula: (Size - 80) / 6 + 1.0
    if (from == MeasurementSystem.metric && to == MeasurementSystem.imperial) {
      return (size - 80) / 6 + 1.0;
    } else {
      return (size - 1.0) * 6 + 80;
    }
  }

  static double convertShoeSize(
      double size, MeasurementSystem from, MeasurementSystem to) {
    if (from == to) return size;
    // EU to US Child rough conversion
    if (from == MeasurementSystem.metric && to == MeasurementSystem.imperial) {
      // Rough: US = EU - 16 (for children's sizes)
      return size - 16;
    } else {
      return size + 16;
    }
  }
}
