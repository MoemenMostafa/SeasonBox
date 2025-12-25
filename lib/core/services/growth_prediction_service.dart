enum MeasurementSystem { metric, imperial }

class GrowthPredictionService {
  /// Predicts the size of clothes after [months] from now for a child of [currentAgeMonths].
  /// [currentSize] is the current size in [system].
  static double predictClothingSize({
    required double currentAgeMonths,
    required double currentSize,
    required int targetMonths,
    required MeasurementSystem system,
    required String gender,
  }) {
    // Simplified growth model for clothing
    // 0-24 months: ~1 size every 3-4 months
    // 2-5 years: ~1 size every 6-9 months
    // 6+ years: ~1 size every 12 months

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
    required String gender,
  }) {
    // Shoe growth is faster in young children
    // 0-3 years: ~1.5mm / month (~1 EU size every 4-5 months)
    // 3-6 years: ~1mm / month (~1 EU size every 6-8 months)
    // 6+ years: ~0.8mm / month (~1 EU size every 10-12 months)

    double growthRate; // EU sizes per month
    if (currentAgeMonths < 36) {
      growthRate = 1.0 / 4.0;
    } else if (currentAgeMonths < 72) {
      growthRate = 1.0 / 7.0;
    } else {
      growthRate = 1.0 / 11.0;
    }

    double predictedSize = currentSize + (growthRate * targetMonths);
    return predictedSize;
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
    // EU to US Child rough conversion: US = (EU * 1.5) - some constant?
    // Actually EU 20 -> US 4.5
    // EU 25 -> US 8
    // EU 30 -> US 12
    if (from == MeasurementSystem.metric && to == MeasurementSystem.imperial) {
      // Rough: US = EU - 15 (for children's sizes)
      return size - 16;
    } else {
      return size + 16;
    }
  }
}
