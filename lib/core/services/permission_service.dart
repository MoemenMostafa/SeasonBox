import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/core/enums/gender.dart';

/// Service to handle permission checks for UI elements
/// Based on Firestore security rules, this determines what actions
/// users can perform based on their role
class PermissionService {
  /// Check if the current user is an admin or co-admin
  ///
  /// Returns true if:
  /// - The user owns the family (familyId == currentUserId)
  /// - The user has 'admin' or 'co-admin' role in the family
  static bool isAdmin(
    String? currentUserId,
    String? familyId,
    List<FamilyMember> members,
  ) {
    if (currentUserId == null || familyId == null) return false;

    // Family owner is always admin
    if (familyId == currentUserId) return true;

    // Check if user has admin or co-admin role
    final currentUserMember = members.firstWhere(
      (m) => m.id == currentUserId,
      orElse: () => FamilyMember(
        id: '',
        familyId: '',
        name: '',
        birthdate: DateTime.now(),
        gender: Gender.unisex,
        role: 'member',
      ),
    );

    return currentUserMember.role == 'admin' ||
        currentUserMember.role == 'co-admin';
  }

  /// Check if the current user can manage storage locations
  ///
  /// Only admins and co-admins can create, update, or delete storage locations
  static bool canManageStorage(
    String? currentUserId,
    String? familyId,
    List<FamilyMember> members,
  ) {
    return isAdmin(currentUserId, familyId, members);
  }

  /// Check if the current user can manage a specific family member
  ///
  /// Returns true if:
  /// - User is admin/co-admin (can manage anyone)
  /// - User is managing themselves (can edit own profile, but not role)
  static bool canManageMember(
    String? currentUserId,
    FamilyMember member,
    String? familyId,
    List<FamilyMember> members,
  ) {
    if (currentUserId == null) return false;

    // Admins can manage anyone
    if (isAdmin(currentUserId, familyId, members)) return true;

    // Users can manage themselves (but not change their role)
    return member.id == currentUserId;
  }

  /// Check if the current user can delete a specific family member
  ///
  /// Returns true if:
  /// - User is admin/co-admin (can delete anyone)
  /// - User is deleting themselves (leave family)
  static bool canDeleteMember(
    String? currentUserId,
    FamilyMember member,
    String? familyId,
    List<FamilyMember> members,
  ) {
    if (currentUserId == null) return false;

    // Admins can delete anyone
    if (isAdmin(currentUserId, familyId, members)) return true;

    // Users can delete themselves (leave family)
    return member.id == currentUserId;
  }

  /// Check if the current user can change a member's role
  ///
  /// Only admins and co-admins can change roles
  static bool canChangeRole(
    String? currentUserId,
    String? familyId,
    List<FamilyMember> members, {
    bool isPremium = false,
  }) {
    if (!isAdmin(currentUserId, familyId, members)) return false;
    return isPremium;
  }

  /// Check if the current user can delete a specific item
  ///
  /// Returns true if:
  /// - User is admin/co-admin (can delete any item)
  /// - User owns the item (ownerId matches currentUserId)
  static bool canDeleteItem(
    String? currentUserId,
    Item item,
    String? familyId,
    List<FamilyMember> members,
  ) {
    if (currentUserId == null) return false;

    // Admins can delete any item
    if (isAdmin(currentUserId, familyId, members)) return true;

    // Users can delete their own items
    return item.ownerId == currentUserId;
  }

  /// Check if the current user can edit a specific item
  ///
  /// Returns true if:
  /// - User is admin/co-admin (can edit any item)
  /// - User owns the item (ownerId matches currentUserId)
  static bool canEditItem(
    String? currentUserId,
    Item item,
    String? familyId,
    List<FamilyMember> members,
  ) {
    if (currentUserId == null) return false;

    // Admins can edit any item
    if (isAdmin(currentUserId, familyId, members)) return true;

    // Users can edit their own items
    return item.ownerId == currentUserId;
  }

  /// Check if the current user can add new family members
  ///
  /// Only admins and co-admins can add new members.
  /// Additionally, must be a Premium user to invite others.
  static bool canAddMember(
    String? currentUserId,
    String? familyId,
    List<FamilyMember> members, {
    bool isPremium = false,
  }) {
    if (!isAdmin(currentUserId, familyId, members)) return false;

    // Premium users have unlimited members
    if (isPremium) return true;

    // Free tier is limited to 4 members total
    return members.length < 4;
  }

  /// Get the current user's role as a string
  ///
  /// Returns 'admin', 'co-admin', 'member', or 'child'
  static String getUserRole(
    String? currentUserId,
    String? familyId,
    List<FamilyMember> members,
  ) {
    if (currentUserId == null || familyId == null) return 'member';

    // Family owner is always admin
    if (familyId == currentUserId) return 'admin';

    final currentUserMember = members.firstWhere(
      (m) => m.id == currentUserId,
      orElse: () => FamilyMember(
        id: '',
        familyId: '',
        name: '',
        birthdate: DateTime.now(),
        gender: Gender.unisex,
        role: 'member',
      ),
    );

    return currentUserMember.role;
  }
}
