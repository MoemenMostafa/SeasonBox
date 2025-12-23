# Family & Invitation System Architecture

This document describes the relationship between Users and Families in SeasonBox, as well as the secure mechanism for inviting and managing members.

## 1. Core Concepts

### User-Family Relationship
In SeasonBox, every user **must** always be part of a Family. This simplifies the data model (items always belong to a family).

- **1:1 Relationship**: A User belongs to exactly one Family at a time.
- **Family ID**: Stored in the `users` collection document as `familyId`.

### Types of Family States

1.  **Solo Family (Personal)**:
    - Default state for new users.
    - **Characteristics**: `familyId` is identical to the user's `uid`.
    - The user is the Admin and the only member.

2.  **Shared Family**:
    - A family group with multiple members.
    - **Characteristics**: `familyId` matches the creator's `uid` (or a generated UUID) and has >1 member in the `members` subcollection.
    - The creator is the Admin.

---

## 2. Data Model

### `users` Collection
Stores profile information and the link to the active family.

```json
users/{uid}
{
  "uid": "user123",
  "email": "user@example.com",
  "displayName": "John Doe",
  "familyId": "family_abc_123",  // Links to families collection
  "photoURL": "...",
  "role": "member" // or "admin"
}
```

### `families` Collection
Stores family-level settings.

```json
families/{familyId}
{
  "id": "family_abc_123",
  "settings": {}
}
```

### `members` Subcollection
Stores the list of people in a family, their roles, and invitation status.

```json
families/{familyId}/members/{memberId}
{
  "id": "user123",           // Matches user.uid
  "name": "John Doe",
  "role": "admin",           // "admin", "member", "child"
  "inviteStatus": "accepted", // "pending", "accepted", "none"
  "inviteEmail": "user@example.com" // For pending invites
}
```

---

## 3. Invitation Mechanism

Joining a family is strictly **Invitation-Based**. A user cannot join a family ID unless they have been explicitly invited by email.

### The Workflow

1.  **Admin Sends Invite**:
    - In "Add Member" screen, Admin enters name and email.
    - App creates a doc in `families/{familyId}/members` with `inviteStatus: 'pending'` and `inviteEmail: 'new@email.com'`.

2.  **Cloud Function Trigger** (`sendFamilyInvitation`):
    - **Trigger**: `onWrite` to `families/{familyId}/members/{memberId}`.
    - **Logic**: Checks if `inviteStatus` is `pending` and `inviteEmail` is present.
    - **Action**: Sends an email via `nodemailer` (Gmail) containing the `familyId`.

3.  **User Joins**:
    - **New User**:
        - Enters `familyId` during Registration.
    - **Existing User**:
        - Enters `familyId` in "Join Family" dialog (Profile Screen).

4.  **Verification (Security)**:
    - The backend (`UserService`) queries: `families/{familyId}/members` where `inviteEmail == user.email` AND `inviteStatus == 'pending'`.
    - **If Found**:
        - Updates `user.familyId` to target family.
        - Updates member doc status to `accepted` (and sets `id` to `user.uid`).
    - **If Not Found**:
        - Throws error ("No active invitation found").

### Security Note: Email Mismatch
The system enforces a strict email match.
- If a user is invited as `alice@work.com` but logs in with `alice@gmail.com`, **they cannot join**.
- The `inviteEmail` in the pending member record MUST match the `auth.token.email` of the user attempting to join.
- This prevents unauthorized users from joining if they simply guess a Family ID.

---

## 4. Join / Leave Logic

### Joining
- **Constraint**: A user can only join a new family if they are currently in their **Solo Family**.
- **UI**: The "Join Family" button is hidden if `isSoloFamily` is false (i.e., user is already in a shared family).
- **Reasoning**: Prevents users from being "lost" between families or accidentally abandoning a group.

### Leaving
- **Regular Member**:
    - Can leave at any time.
    - **Action**: Removed from current family's `members` list.
    - **Result**: Reverted to a new Personal Family (`familyId = uid`).

- **Family Creator (Admin)**:
    - Since `familyId` usually equals their `uid`, they cannot "leave" in the traditional sense.
    - **Action**: "Disband Family".
    - **Result**: All **other** members are removed from the family group. The Creator remains as the sole member of their Personal Family.
    - **Migration**: UI shows a warning dialog explaining that the group will be deleted.
