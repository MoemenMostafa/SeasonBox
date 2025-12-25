class SizeConstants {
  // --- Imperial (US) Sizes ---

  static const List<String> clothesSizesImperial = [
    'NB', '3M', '6M', '9M', '12M', '18M', '24M', // Baby
    '2T', '3T', '4T', '5T', // Toddler
    '4', '5', '6', '6X', '7', '8', '10', '12', '14', '16', // Kids Numeric
    'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL' // Kids & Adult Alpha
  ];

  static const List<String> shoeSizesImperial = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
    '13', // Little Kids
    '1Y', '2Y', '3Y', '4Y', '5Y', '6Y', '7Y', // Big Kids
    '8', '8.5', '9', '9.5', '10', '10.5', '11', '11.5', '12', '13', '14',
    '15' // Adult
  ];

  // --- Metric (EU) Sizes ---

  static const List<String> clothesSizesMetric = [
    '50', '56', '62', '68', '74', '80', '86',
    '92', // Baby/Toddler (by height in cm)
    '98', '104', '110', '116', '122', '128', '134', '140', '146', '152', '158',
    '164', '170', '176', // Kids (by height in cm)
    'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL' // Standard Alpha
  ];

  static const List<String> shoeSizesMetric = [
    '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27',
    '28', '29', '30', // Toddler/Small Kids
    '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', // Big Kids
    '41', '42', '43', '44', '45', '46', '47', '48' // Adult
  ];
}
