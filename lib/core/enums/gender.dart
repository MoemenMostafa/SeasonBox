import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

enum Gender {
  male,
  female,
  unisex;

  String toFirestore() {
    switch (this) {
      case Gender.male:
        return 'm';
      case Gender.female:
        return 'f';
      case Gender.unisex:
        return 'u';
    }
  }

  static Gender fromFirestore(String? value) {
    switch (value?.toLowerCase()) {
      case 'm':
      case 'boy':
      case 'male':
        return Gender.male;
      case 'f':
      case 'girl':
      case 'female':
        return Gender.female;
      case 'u':
      case 'unisex':
      default:
        return Gender.unisex;
    }
  }

  String toDisplayString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case Gender.male:
        return l10n.gender_male;
      case Gender.female:
        return l10n.gender_female;
      case Gender.unisex:
        return l10n.gender_unisex;
    }
  }

  static Gender fromDisplayString(String? value) {
    switch (value) {
      case 'Male':
      case 'Boy':
        return Gender.male;
      case 'Female':
      case 'Girl':
        return Gender.female;
      case 'Unisex':
      default:
        return Gender.unisex;
    }
  }
}
