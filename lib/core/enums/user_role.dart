import 'package:flutter/material.dart';
import 'package:seasonbox/l10n/app_localizations.dart';

enum UserRole {
  admin,
  coAdmin,
  member;

  String toShortString() {
    if (this == UserRole.coAdmin) return 'co-admin';
    return toString().split('.').last;
  }

  static UserRole fromString(String role) {
    if (role.toLowerCase() == 'co-admin') return UserRole.coAdmin;
    return UserRole.values.firstWhere(
      (e) => e.toShortString().toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.member,
    );
  }

  String getLocalizedName(BuildContext context) {
    switch (this) {
      case UserRole.admin:
        return AppLocalizations.of(context)!.addMember_role_admin;
      case UserRole.coAdmin:
        return AppLocalizations.of(context)!.addMember_role_coAdmin;
      case UserRole.member:
        return AppLocalizations.of(context)!.addMember_role_member;
    }
  }
}
