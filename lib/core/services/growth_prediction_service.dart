import '../enums/gender.dart';

enum MeasurementSystem { metric, imperial }

class GrowthPredictionService {
  static const List<double> _euClothingSizes = [
    50,
    56,
    62,
    68,
    74,
    80,
    86,
    92,
    98,
    104,
    110,
    116,
    122,
    128,
    134,
    140,
    146,
    152,
    158,
    164,
    170,
    176
  ];

  /// Predicts the size of clothes after [months] from now for a child of [currentAgeMonths].
  /// [currentSize] is the current size in [system].
  static double predictClothingSize({
    required double currentAgeMonths,
    required double currentSize,
    required int targetMonths,
    required MeasurementSystem system,
    required Gender gender,
  }) {
    if (currentAgeMonths >= 216) return currentSize; // 18 years

    if (system == MeasurementSystem.metric) {
      // Metric logic: EU sizes are heights in cm.
      // Growth rates in cm per month:
      // 0-12m: ~2.0 cm/month
      // 1-2y: ~1.0 cm/month
      // 2-6y: ~0.7 cm/month
      // 6-12y: ~0.5 cm/month (steady until puberty)
      // 12-16y: ~0.4 cm/month (simplified puberty average)

      double totalHeightGrowth = 0;
      double tempAge = currentAgeMonths;

      for (int i = 0; i < targetMonths; i++) {
        if (tempAge >= 216) break;
        totalHeightGrowth += _getHeightGrowthRate(tempAge, gender);
        tempAge += 1.0;
      }

      return currentSize + totalHeightGrowth;
    } else {
      // Imperial logic: US sizes are ages (2, 3, 4...).
      // Growth is roughly 1 year-size per 12 months.
      double growthRate; // Sizes per month
      if (currentAgeMonths < 24) {
        growthRate = 1.0 / 4.0; // Rapid growth in infancy
      } else if (currentAgeMonths < 60) {
        growthRate = 1.0 / 10.0; // Slightly slower
      } else {
        growthRate = 1.0 / 12.0; // 1 year per 12 months
      }

      return currentSize + (growthRate * targetMonths);
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
    // Refined shoe growth based on provided velocity charts (8-18 years)
    // Girls: Velocity peaks at ~10.5y (126m), finishes at ~14y (168m)
    // Boys: Velocity peaks at ~11.5y (138m), finishes at ~16y (192m)

    double totalGrowth = 0;
    double tempAge = currentAgeMonths;

    for (int i = 0; i < targetMonths; i++) {
      final double maxGrowthAge = gender == Gender.male ? 192.0 : 168.0;

      if (tempAge >= maxGrowthAge) break;

      double growthRate; // sizes per month
      if (tempAge < 36) {
        growthRate = 1.0 / 3.0; // ~1 size every 3 months
      } else if (tempAge < 96) {
        // 3-8 years
        growthRate = 1.0 / 6.0; // ~1 size every 6 months
      } else {
        // 8-18 years: Gender-specific non-linear velocity
        if (gender == Gender.female) {
          // Girls peak at 126m
          if (tempAge < 126) {
            // Accelerating towards peak (rough linear increase from 1/12 to 1/4)
            growthRate = (1.0 / 12.0) +
                ((1.0 / 4.0 - 1.0 / 12.0) * (tempAge - 96) / (126 - 96));
          } else {
            // Decelerating after peak (1/4 to 0)
            growthRate = (1.0 / 4.0) * (1 - (tempAge - 126) / (168 - 126));
          }
        } else {
          // Boys peak at 138m
          if (tempAge < 138) {
            // Accelerating towards peak (rough linear increase from 1/12 to 1/3)
            growthRate = (1.0 / 12.0) +
                ((1.0 / 3.0 - 1.0 / 12.0) * (tempAge - 96) / (138 - 96));
          } else {
            // Decelerating after peak (1/3 to 0)
            growthRate = (1.0 / 3.0) * (1 - (tempAge - 138) / (192 - 138));
          }
        }
      }

      totalGrowth += growthRate;
      tempAge += 1.0;
    }

    return currentSize + totalGrowth;
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

    double targetSize;
    if (category == 'clothes' && system == MeasurementSystem.metric) {
      // Find the next EU standard size
      targetSize = _euClothingSizes.firstWhere(
        (size) => size > currentSize,
        orElse: () => currentSize + 6.0, // Default jump if outside range
      );
    } else {
      // Standard increments for shoe or imperial clothing
      targetSize = currentSize + 1.0;
    }

    int months = 0;
    double projectedSize = currentSize;
    double tempAge = currentAgeMonths;

    // Simulate month by month to find target
    while (projectedSize < targetSize && months < 60) {
      // Limit to 5 years prediction
      double growthRate;
      if (category == 'clothes') {
        if (tempAge >= 216) break;
        if (system == MeasurementSystem.metric) {
          growthRate = _getHeightGrowthRate(tempAge, gender);
        } else {
          if (tempAge < 24) {
            growthRate = 1.0 / 4.0;
          } else if (tempAge < 60) {
            growthRate = 1.0 / 10.0;
          } else {
            growthRate = 1.0 / 12.0;
          }
        }
      } else {
        // Use the same logic as predictShoeSize
        final double maxGrowthAge = gender == Gender.male ? 192.0 : 168.0;
        if (tempAge >= maxGrowthAge) break;

        if (tempAge < 36) {
          growthRate = 1.0 / 3.0;
        } else if (tempAge < 96) {
          growthRate = 1.0 / 6.0;
        } else {
          if (gender == Gender.female) {
            if (tempAge < 126) {
              growthRate = (1.0 / 12.0) +
                  ((1.0 / 4.0 - 1.0 / 12.0) * (tempAge - 96) / (126 - 96));
            } else {
              growthRate = (1.0 / 4.0) * (1 - (tempAge - 126) / (168 - 126));
            }
          } else {
            if (tempAge < 138) {
              growthRate = (1.0 / 12.0) +
                  ((1.0 / 3.0 - 1.0 / 12.0) * (tempAge - 96) / (138 - 96));
            } else {
              growthRate = (1.0 / 3.0) * (1 - (tempAge - 138) / (192 - 138));
            }
          }
        }
      }

      if (growthRate <= 0) break;
      projectedSize += growthRate;
      tempAge += 1.0;
      months++;
    }

    return months;
  }

  static double _getHeightGrowthRate(double ageMonths, Gender gender) {
    if (ageMonths < 12) return 2.0;
    if (ageMonths < 24) return 1.0;
    if (ageMonths < 60) return 0.7; // < 5 years

    // WHO 5-19y Reference approximations
    if (gender == Gender.male) {
      // Boys
      if (ageMonths < 120) return 0.5; // 5-10y
      if (ageMonths < 156) return 0.65; // 10-13y
      if (ageMonths < 180) return 0.8; // 13-15y (Peak spurt)
      if (ageMonths < 204) return 0.3; // 15-17y
      if (ageMonths < 216) return 0.1; // 17-18y
      return 0.0;
    } else {
      // Girls
      if (ageMonths < 108) return 0.5; // 5-9y
      if (ageMonths < 132) return 0.65; // 9-11y
      if (ageMonths < 156) return 0.7; // 11-13y (Peak spurt)
      if (ageMonths < 180) return 0.2; // 13-15y
      if (ageMonths < 216) return 0.05; // 15-18y
      return 0.0;
    }
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
