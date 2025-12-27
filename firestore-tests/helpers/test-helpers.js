const {
    initializeTestEnvironment,
    assertFails,
    assertSucceeds,
} = require('@firebase/rules-unit-testing');
const { setLogLevel } = require('firebase/firestore');
const fs = require('fs');
const path = require('path');

// Global test environment
let testEnv;

/**
 * Initialize the test environment before running tests
 */
async function setupTestEnvironment() {
    // Suppress Firestore logs during testing
    setLogLevel('error');

    testEnv = await initializeTestEnvironment({
        projectId: 'seasonbox-test',
        firestore: {
            rules: fs.readFileSync(path.resolve(__dirname, '../../firestore.rules'), 'utf8'),
            host: 'localhost',
            port: 8080,
        },
    });

    return testEnv;
}

/**
 * Clean up test environment after all tests
 */
async function teardownTestEnvironment() {
    if (testEnv) {
        await testEnv.cleanup();
    }
}

/**
 * Clear all data between tests
 */
async function clearFirestoreData() {
    if (testEnv) {
        await testEnv.clearFirestore();
    }
}

/**
 * Get an authenticated Firestore context
 * @param {string} uid - User ID
 * @param {object} tokenClaims - Additional token claims (e.g., email)
 */
function getAuthenticatedContext(uid, tokenClaims = {}) {
    return testEnv.authenticatedContext(uid, tokenClaims);
}

/**
 * Get an unauthenticated Firestore context
 */
function getUnauthenticatedContext() {
    return testEnv.unauthenticatedContext();
}

/**
 * Create a test user document
 */
async function createTestUser(userId, subscriptionTier = 'free') {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore().collection('users').doc(userId).set({
            id: userId,
            email: `${userId}@test.com`,
            subscriptionTier,
            createdAt: new Date().toISOString(),
        });
    });
}

/**
 * Create a test family document
 */
async function createTestFamily(familyId, data = {}) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore().collection('families').doc(familyId).set({
            id: familyId,
            name: data.name || 'Test Family',
            itemCount: data.itemCount || 0,
            memberCount: data.memberCount || 0,
            inviteCode: data.inviteCode || 'TEST123',
            createdAt: new Date().toISOString(),
            ...data,
        });
    });
}

/**
 * Create a test member document
 */
async function createTestMember(familyId, memberId, data = {}) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore()
            .collection('families')
            .doc(familyId)
            .collection('members')
            .doc(memberId)
            .set({
                id: memberId,
                userId: data.userId || memberId,
                name: data.name || 'Test Member',
                role: data.role || 'member',
                inviteEmail: data.inviteEmail || null,
                createdAt: new Date().toISOString(),
                ...data,
            });
    });
}

/**
 * Create a test item document
 */
async function createTestItem(familyId, itemId, data = {}) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore()
            .collection('families')
            .doc(familyId)
            .collection('items')
            .doc(itemId)
            .set({
                id: itemId,
                familyId,
                title: data.title || 'Test Item',
                category: data.category || 'clothing',
                gender: data.gender || 'unisex',
                size: data.size || 'M',
                ownerId: data.ownerId || null,
                storageLocationId: data.storageLocationId || 'loc1',
                photos: data.photos || [],
                seasonTags: data.seasonTags || [],
                quantity: data.quantity || 1,
                notes: data.notes || '',
                status: data.status || 'stored',
                loanHistory: data.loanHistory || [],
                tags: data.tags || [],
                addedAt: new Date().toISOString(),
                ...data,
            });
    });
}

/**
 * Create a test location document
 */
async function createTestLocation(familyId, locationId, data = {}) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore()
            .collection('families')
            .doc(familyId)
            .collection('locations')
            .doc(locationId)
            .set({
                id: locationId,
                name: data.name || 'Test Location',
                description: data.description || '',
                createdAt: new Date().toISOString(),
                ...data,
            });
    });
}

/**
 * Helper to create multiple items (for testing limits)
 */
async function createMultipleItems(familyId, count, ownerId) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        const batch = [];
        for (let i = 0; i < count; i++) {
            batch.push(
                createTestItem(familyId, `item${i}`, {
                    title: `Item ${i}`,
                    ownerId,
                })
            );
        }
        await Promise.all(batch);
    });
}

/**
 * Helper to create multiple members (for testing limits)
 */
async function createMultipleMembers(familyId, count) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        const batch = [];
        for (let i = 0; i < count; i++) {
            batch.push(
                createTestMember(familyId, `member${i}`, {
                    userId: `member${i}`,
                    name: `Member ${i}`,
                    role: 'member',
                })
            );
        }
        await Promise.all(batch);
    });
}

module.exports = {
    setupTestEnvironment,
    teardownTestEnvironment,
    clearFirestoreData,
    getAuthenticatedContext,
    getUnauthenticatedContext,
    createTestUser,
    createTestFamily,
    createTestMember,
    createTestItem,
    createTestLocation,
    createMultipleItems,
    createMultipleMembers,
    assertFails,
    assertSucceeds,
};
