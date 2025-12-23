# User Roles & Permissions

This document outlines the security model and role-based access control (RBAC) enforced in the SeasonBox application via Firestore Security Rules.

## User Roles

There are two primary roles within a family:

1.  **Admin** (`role: 'admin'`)
    *   **Description**: The creator of the family or a designated administrator.
    *   **Scope**: Full control over family members, items, and settings.
2.  **Member** (`role: 'member'`)
    *   **Description**: A regular user who has joined the family.
    *   **Scope**: Can manage their own items and view family data.

## Permission Matrix

| Resource | Action | Admin | Member | Notes |
| :--- | :--- | :---: | :---: | :--- |
| **Family Setup** | View Family Details | ✅ | ✅ | Details like family name. |
| | Update Family Name | ✅ | ❌ | |
| | Delete Family | ✅ | ❌ | |
| **Member Management** | View Members | ✅ | ✅ | |
| | Add Member (Invite) | ✅ | ❌ | Only Admins can send invites. |
| | Remove Member | ✅ | ❌ | Only Admins can remove people. |
| | Update Member Role | ✅ | ❌ | |
| **Item Management** | View Items | ✅ | ✅ | Everyone sees all family items. |
| | Add Item | ✅ | ✅ | Members can only add items with `ownerId == auth.uid`. |
| | Edit/Delete Own Item | ✅ | ✅ | |
| | Edit/Delete Others' Item | ✅ | ❌ | Admins can moderate all items. Members cannot touch others' items. |

## Security Rules Implementation

These permissions are enforced at the database level using `firestore.rules`.

### Key Rules
*   **Isolation**: Users can *only* access data within families they are a member of. Attempting to read another family's data results in `PERMISSION_DENIED`.
*   **Member Validation**: Membership is verified by checking for the existence of a document in `families/{familyId}/members/{auth.uid}`.
*   **Admin Check**: Admin privileges are verified by checking the `role` field on the user's member document.

### Rule Snippets
```javascript
// Check if user is an Admin
function isFamilyAdmin(familyId) {
  return isFamilyMember(familyId) && 
         get(/databases/$(database)/documents/families/$(familyId)/members/$(request.auth.uid)).data.role == 'admin';
}

// Item Creation Restriction
allow create: if isFamilyMember(familyId) && request.resource.data.ownerId == request.auth.uid;
```
