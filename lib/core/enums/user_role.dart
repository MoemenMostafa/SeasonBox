import 'package:flutter/material.dart';
import 'package:seasonbox/l10n/app_localizations.dart';

enum UserRole {
  admin,
  member;

  String toShortString() => toString().split('.').last;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.toShortString() == role,
      orElse: () => UserRole.member,
    );
  }

  String getLocalizedName(BuildContext context) {
    switch (this) {
      case UserRole.admin:
        return AppLocalizations.of(context)!.addMember_role_admin;
      case UserRole.member:
        return AppLocalizations.of(context)!.addMember_role_member;
    }
  }
}
