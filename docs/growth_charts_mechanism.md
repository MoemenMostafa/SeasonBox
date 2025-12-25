# Growth Charts Mechanism Documentation

This document describes the implementation of the Growth Charts and Size Prediction mechanism in SeasonBox.

## Overview
The Growth Charts feature allows users to track the size history of family members and visualize their expected growth over the next 24 months. It provides insights into when the next size might be needed, helping parents plan clothing and shoe purchases.

---

## Technical Stack

### Libraries Used
*   **[`fl_chart`](https://pub.dev/packages/fl_chart)**: A powerful Flutter charting library used for rendering the line charts.
*   **`provider`**: Used for dependency injection and state management.
*   **`cloud_firestore`**: Used to persist family member data and size history.
*   **`intl` & `AppLocalizations`**: Used for multi-language support and formatting.

---

## Architecture

The mechanism is divided into two main layers:

### 1. Logic Layer: `GrowthPredictionService`
Located at: `lib/core/services/growth_prediction_service.dart`

This service contains the mathematical models for growth prediction and conversion between measurement systems.

#### **Clothing Growth Model**
The model uses a simplified linear growth rate based on age brackets:
*   **0–24 months**: ~1 size every 4 months (0.25 sizes/month).
*   **2–5 years (24–60 months)**: ~1 size every 8 months (0.125 sizes/month).
*   **5–18 years (60–216 months)**: ~1 size every 12 months (0.083 sizes/month).
*   **18+ years**: Growth is assumed to stop.

#### **Shoe Growth Model**
The shoe model is more granular and incorporates gender-specific development stops:
*   **Max Growth Age**: Females typically stop foot growth around **14 years**, while males stop around **18 years**.
*   **Growth Rates**:
    *   **0–12 months**: 0.5 sizes per month (rapid growth).
    *   **1–3 years**: 1 size every 3 months.
    *   **3–5 years**: 1 size every 4 months.
    *   **5–10 years**: 1 size every 8 months.
    *   **10 years to Max**: 1 size every 12 months.

#### **Measurement Systems & Conversion**
The system supports both Metric (CM/EU) and Imperial (Age/US) systems.
*   **Clothing (Metric)**: Sizes typically follow a 6cm jump pattern (e.g., 80, 86, 92...).
*   **Clothing (Imperial)**: Uses age-based sizing (e.g., 1T, 2T, 3T...).
*   **Shoe Conversion**: Approximated using a ±16 offset between EU and US child sizes.

---

### 2. UI Layer: `GrowthChartScreen`
Located at: `lib/features/members/screens/growth_chart_screen.dart`

This screen provides the visual interface for the growth data.

#### **Chart Components**
*   **Actual Data (Solid Line)**: Points plotted from the `sizeHistory` stored in the `FamilyMember` document.
*   **Expectation Data (Dashed Line)**: Points generated using the `predict*` methods from `GrowthPredictionService` for a 2-year window from the current date.
*   **X-Axis**: Represents the age in years (calculated from months).
*   **Y-Axis**: Represents the size (Double value).

#### **User Interaction**
*   **Type Toggle**: A `SegmentedButton` allows users to switch between "Clothes" and "Shoes".
*   **Tooltips**: Tapping a point on the chart shows a tooltip with the localized label (Actual vs Expectation), the age, and the size.
*   **Insights**: A dynamic card at the bottom displays a localized message like: *"Member will likely need the next size in X months"*.

---

## Data Model Integration

The `FamilyMember` model contains:
*   `clothingSize`: Current clothing size.
*   `shoeSize`: Current shoe size.
*   `birthdate`: Used to calculate age in months.
*   `gender`: Used for shoe growth stop age threshold.
*   `sizeHistory`: A list of maps containing `category`, `size`, and `date`.

---

## Localization Standards
All strings in the charts and insights are localized. Key localization keys include:
*   `members_growthChart_actual`: "Actual"
*   `members_growthChart_expectation`: "Expectation"
*   `members_growthChart_insight`: "Insight regarding months until next size"
*   `members_growthChart_noGrowth`: Message for when growth is expected to have stopped.

---

## Future Improvements
*   [ ] Implement a more accurate data-driven growth model (e.g., CDC/WHO percentiles).
*   [ ] Allow manual adjustment of growth rates if a child grows faster/slower than average.
*   [ ] Support for adult sizes and transitions from child to adult sizing systems.
