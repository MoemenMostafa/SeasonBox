import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/core/services/growth_prediction_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GrowthChartScreen extends StatefulWidget {
  final FamilyMember member;

  const GrowthChartScreen({super.key, required this.member});

  @override
  State<GrowthChartScreen> createState() => _GrowthChartScreenState();
}

class _GrowthChartScreenState extends State<GrowthChartScreen> {
  bool _showClothes = true;
  String _measurementSystem = 'imperial';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final authService = context.read<AuthService>();
    final userService = context.read<UserService>();
    final user = authService.currentUser;
    if (user != null) {
      final doc = await userService.getUserStream(user.uid).first;
      final data = doc.data() as Map<String, dynamic>?;
      if (data?['preferences'] != null) {
        setState(() {
          _measurementSystem =
              data!['preferences']['measurementSystem'] ?? 'imperial';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: '${widget.member.name} - ${l10n.members_tooltipGrowthChart}',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 24),
            _buildChartCard(theme, l10n),
            const SizedBox(height: 24),
            _buildLegend(theme, l10n),
            const SizedBox(height: 24),
            _buildInsightCard(theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment(
            value: true,
            label: Text(l10n.addItem_category_clothes),
            icon: const Icon(Icons.checkroom),
          ),
          ButtonSegment(
            value: false,
            label: Text(l10n.addItem_category_shoes),
            icon: const Icon(Icons
                .show_chart), // Using show_chart for shoes as fallback if no specific shoe icon
          ),
        ],
        selected: {_showClothes},
        onSelectionChanged: (Set<bool> newSelection) {
          setState(() {
            _showClothes = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _showClothes
                ? l10n.addItem_category_clothes
                : l10n.addItem_category_shoes,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              _buildChartData(theme, l10n),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(ThemeData theme, AppLocalizations l10n) {
    final currentAgeMonths =
        DateTime.now().difference(widget.member.birthdate).inDays / 30.0;
    final currentSize = _showClothes
        ? (widget.member.clothingSize ?? 0.0)
        : (widget.member.shoeSize ?? 0.0);

    final system = _measurementSystem == 'metric'
        ? MeasurementSystem.metric
        : MeasurementSystem.imperial;

    // Actual Data Points from History
    final List<FlSpot> actualSpots = [];
    final history = widget.member.sizeHistory;

    for (var entry in history) {
      if (entry['category'] == (_showClothes ? 'clothes' : 'shoes')) {
        final date = (entry['date'] as Timestamp).toDate();
        final ageAtDate =
            date.difference(widget.member.birthdate).inDays / 30.0;
        final size = (entry['size'] as num).toDouble();
        actualSpots.add(FlSpot(ageAtDate, size));
      }
    }

    // Add current size if not redundant
    if (currentSize > 0) {
      // Check if we already have a point around today
      actualSpots.add(FlSpot(currentAgeMonths, currentSize));
    }

    actualSpots.sort((a, b) => a.x.compareTo(b.x));

    // Expected Data Points (Prediction)
    final List<FlSpot> expectedSpots = [];
    if (currentSize > 0) {
      for (int i = 0; i <= 24; i += 3) {
        // Predict 2 years ahead
        final monthsAhead = i;
        final predictedSize = _showClothes
            ? GrowthPredictionService.predictClothingSize(
                currentAgeMonths: currentAgeMonths,
                currentSize: currentSize,
                targetMonths: monthsAhead,
                system: system,
                gender: widget.member.gender,
              )
            : GrowthPredictionService.predictShoeSize(
                currentAgeMonths: currentAgeMonths,
                currentSize: currentSize,
                targetMonths: monthsAhead,
                system: system,
                gender: widget.member.gender,
              );
        expectedSpots.add(FlSpot(currentAgeMonths + i, predictedSize));
      }
    }

    return LineChartData(
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value % 12 == 0) {
                return Text('${(value / 12).toInt()}y',
                    style: const TextStyle(fontSize: 10));
              }
              return const SizedBox();
            },
            reservedSize: 22,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        // Prediction Line (Dashed)
        if (expectedSpots.isNotEmpty)
          LineChartBarData(
            spots: expectedSpots,
            isCurved: true,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            barWidth: 2,
            dashArray: [5, 5],
            dotData: const FlDotData(show: false),
          ),
        // Actual Line
        if (actualSpots.isNotEmpty)
          LineChartBarData(
            spots: actualSpots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 4,
            dotData: const FlDotData(show: true),
          ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final ageYearsStr = (spot.x / 12).toStringAsFixed(1);
              final sizeStr = spot.y.toStringAsFixed(1);
              final label = spot.barIndex == 1
                  ? l10n.members_growthChart_actual
                  : l10n.members_growthChart_expectation;
              return LineTooltipItem(
                '$label\n${l10n.home_member_age(double.parse(ageYearsStr).round())}\n${l10n.home_member_size(sizeStr)}',
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
            theme.colorScheme.primary, l10n.members_growthChart_actual),
        const SizedBox(width: 24),
        _buildLegendItem(theme.colorScheme.primary.withValues(alpha: 0.3),
            l10n.members_growthChart_expectation,
            isDashed: true),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? Center(child: Container(width: 5, color: Colors.white))
              : null,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInsightCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: theme.colorScheme.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.members_tooltipGrowthChart,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.members_growthChart_insight(
                      widget.member.name, 6), // TODO: Calculate actual months
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
