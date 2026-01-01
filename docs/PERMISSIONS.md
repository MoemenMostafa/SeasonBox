# User Roles & Permissions

This document outlines the security model and role-based access control (RBAC) enforced in the SeasonBox application via Firestore Security Rules.

## User Roles

| Role | Description | Scope |
| :--- | :--- | :--- |
| **Admin** | Family creator or designated administrator. | Full control over family members, items, and settings. |
| **Member** | Regular user joined via invitation. | Can manage own items and view family data. |

## Subscription Tiers & Limits

Resource limits are enforced based on the family's subscription status.

| Resource | Free Tier | Premium Tier |
| :--- | :--- | :--- |
| **Family Sharing** | Personal use only | Share with up to 5 members |
| **Item Count** | Max 50 items per family | **Unlimited** items |
| **Photos per Item** | 1 photo per item | **3 high-quality** photos |
| **Growth Tracking** | Basic view | **Advanced** trends & charts |
| **Reminders** | None | **Custom** seasonal reminders |

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
| **Storage Locations** | View Locations | ✅ | ✅ | Everyone sees all locations. |
| | Add/Edit/Delete Location | ✅ | ❌ | Only Admins manage storage maps. |

## Security Rules Implementation

These permissions are enforced at the database level using `firestore.rules`.

### Key Rules
*   **Isolation**: Users can *only* access data within families they are a member of. Attempting to read another family's data results in `PERMISSION_DENIED`.
*   **Member Validation**: Membership is verified by checking for the existence of a document in `families/{familyId}/members/{auth.uid}`.
*   **Admin Check**: Admin privileges are verified by checking the `role` field on the user's member document.
*   **userId Requirement**: When users create their own member docs (joining a family), they must include a `userId` field matching their UID.
*   **User Profile**: Users have full read/write access to their own profile. The `familyId` field is a convenience pointer - actual data access is secured at the family level.

### Rule Snippets
```javascript
// Check if user is an Admin
function isFamilyAdmin(familyId) {
  return memberDocExists(familyId) && 
         (getMemberDoc(familyId).data.role == 'admin' ||
          getMemberDoc(familyId).data.role == 'co-admin');
}

// Member creation - requires userId when self-joining
allow create: if isFamilyAdmin(familyId) || 
                 (request.auth.uid == memberId && 
                  request.resource.data.userId == request.auth.uid &&
                  request.resource.data.role == 'member');

// Item Creation Restriction
allow create: if isFamilyMember(familyId) && request.resource.data.ownerId == request.auth.uid;

## Google Play Service Account

The service account used for CI/CD and Backend Subscription Verification requires specific permissions in the **Google Play Console**.

### Required Permissions

| Category | Permission | Usage |
| :--- | :--- | :--- |
| **Publishing** | Release to testing tracks | Push builds to the Internal track. |
| | Manage testing tracks and edit tester lists | Manage testers and release status. |
| | Manage store presence | Update app metadata and handle uploads. |
| **Financial** | View financial data, orders, and cancellation survey responses | Verify subscription status via the API. |
| | Manage orders and subscriptions | Perform refunds or cancellations if needed. |

### Configuration
1. **Google Cloud**: Enable the `Google Play Developer API`.
2. **Google Play Console**: Invite the service account email under **Users and Permissions** and assign the above rights to either the whole account or the `io.mos.seasonbox` app specifically.
