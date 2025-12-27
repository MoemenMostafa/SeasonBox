# Firestore Security Rules Test Suite

Comprehensive test suite for SeasonBox Firestore security rules using Firebase Emulator and `@firebase/rules-unit-testing`.

## Overview

This test suite validates that all Firestore security rules are:
- ✅ **Secure**: Unauthorized access is properly blocked
- ✅ **Functional**: Authorized users can perform their required operations
- ✅ **Complete**: All collections, subcollections, and edge cases are covered

## Test Coverage

### Collections & Subcollections
- **Users Collection** (`/users/{userId}`)
  - Read own profile ✅
  - Cannot read others' profiles ❌
  - Cannot write (Cloud Functions only) ❌

- **Families Collection** (`/families/{familyId}`)
  - Create, read, update, delete with proper permissions
  - Role-based access control (admin, co-admin, member)

- **Members Subcollection** (`/families/{familyId}/members/{memberId}`)
  - Admin invites and member self-registration
  - Role management and permission enforcement
  - Leave family and reject invites

- **Items Subcollection** (`/families/{familyId}/items/{itemId}`)
  - Ownership-based access control
  - Photo limit enforcement (max 3)
  - Backward compatibility (memberId → ownerId)

- **Locations Subcollection** (`/families/{familyId}/locations/{locationId}`)
  - Read access for all family members
  - Write access for admins only

### Subscription Tiers
- Free tier limits (50 items, 4 members)
- Paid tier unlimited access
- Family owner subscription inheritance

### Security Tests
- Cross-family access prevention
- Role escalation prevention
- UserId tampering prevention
- Unauthenticated access blocking
- Personal family creation

## Installation

```bash
cd firestore-tests
npm install
```

This will install:
- `@firebase/rules-unit-testing` - Firebase security rules testing framework
- `mocha` - Test runner
- `chai` - Assertion library

## Running Tests

### Run All Tests
```bash
npm test
```

### Run Specific Test Files
```bash
# Users collection tests
npm run test:users

# Families collection tests
npm run test:families

# Members subcollection tests
npm run test:members

# Items subcollection tests
npm run test:items

# Locations subcollection tests
npm run test:locations

# Subscription limits tests
npm run test:subscription

# Collection group queries tests
npm run test:collection-group

# Security edge cases tests
npm run test:security
```

### Run Individual Test Suites
```bash
# Run a specific test file directly
npx mocha tests/users.test.js

# Run with verbose output
npx mocha --reporter spec tests/items.test.js
```

## Prerequisites

### Firebase Emulator
The tests require the Firebase Emulator to be running. You have two options:

#### Option 1: Auto-start (Recommended)
The test suite will automatically start the Firestore emulator on port 8080 when tests run.

#### Option 2: Manual start
Start the emulator manually before running tests:
```bash
# From the project root
firebase emulators:start --only firestore
```

### Firestore Rules
The tests automatically load the security rules from `../firestore.rules`. Make sure this file exists and is up to date.

## Test Structure

```
firestore-tests/
├── package.json              # Dependencies and npm scripts
├── .mocharc.json            # Mocha configuration
├── helpers/
│   └── test-helpers.js      # Shared test utilities
└── tests/
    ├── users.test.js        # Users collection tests
    ├── families.test.js     # Families collection tests
    ├── members.test.js      # Members subcollection tests
    ├── items.test.js        # Items subcollection tests
    ├── locations.test.js    # Locations subcollection tests
    ├── subscription-limits.test.js  # Subscription tier tests
    ├── collection-group.test.js     # Collection group query tests
    └── security.test.js     # Security edge cases tests
```

## Test Helpers

The `helpers/test-helpers.js` file provides utilities for:
- Setting up and tearing down test environments
- Creating authenticated/unauthenticated contexts
- Generating test data (users, families, members, items, locations)
- Common assertions (`assertSucceeds`, `assertFails`)

## Writing New Tests

To add new tests:

1. Create a new test file in `tests/` or add to an existing file
2. Import the test helpers:
   ```javascript
   const {
     setupTestEnvironment,
     teardownTestEnvironment,
     clearFirestoreData,
     getAuthenticatedContext,
     createTestUser,
     assertSucceeds,
     assertFails,
   } = require('../helpers/test-helpers');
   ```

3. Set up the test structure:
   ```javascript
   describe('Your Test Suite', () => {
     before(async () => {
       await setupTestEnvironment();
     });

     after(async () => {
       await teardownTestEnvironment();
     });

     beforeEach(async () => {
       await clearFirestoreData();
     });

     it('should test something', async () => {
       // Your test code
     });
   });
   ```

4. Add an npm script in `package.json` if needed

## Understanding Test Results

- ✅ **Green (passing)**: Security rule is working as expected
  - `assertSucceeds` tests verify authorized operations work
  - `assertFails` tests verify unauthorized operations are blocked

- ❌ **Red (failing)**: Security rule needs attention
  - Check the error message for details
  - Review the corresponding rule in `firestore.rules`
  - Verify test data setup is correct

## Common Issues

### Port Already in Use
If you see "Port 8080 is already in use":
- Stop any running Firebase emulators
- Or change the port in `helpers/test-helpers.js`

### Rules Not Loading
If tests fail with "rules not found":
- Verify `firestore.rules` exists in the parent directory
- Check the path in `helpers/test-helpers.js`

### Timeout Errors
If tests timeout:
- Increase timeout in `.mocharc.json`
- Check if emulator is running properly
- Verify network connectivity

## Test Statistics

Total test files: **8**
Estimated total tests: **100+**

Coverage includes:
- All CRUD operations (Create, Read, Update, Delete)
- All user roles (admin, co-admin, member)
- All subscription tiers (free, paid)
- All collections and subcollections
- Edge cases and security vulnerabilities

## Contributing

When adding new security rules:
1. Write tests first (TDD approach)
2. Ensure both positive and negative test cases
3. Test edge cases and boundary conditions
4. Update this README if adding new test files

## Resources

- [Firebase Security Rules Documentation](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Rules Unit Testing](https://firebase.google.com/docs/rules/unit-tests)
- [Mocha Documentation](https://mochajs.org/)
