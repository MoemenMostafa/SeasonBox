const { describe, it, before, after, beforeEach } = require('mocha');
const {
    setupTestEnvironment,
    teardownTestEnvironment,
    clearFirestoreData,
    getAuthenticatedContext,
    getUnauthenticatedContext,
    createTestUser,
    assertFails,
    assertSucceeds,
} = require('../helpers/test-helpers');

describe('Users Collection Security Rules', () => {
    before(async () => {
        await setupTestEnvironment();
    });

    after(async () => {
        await teardownTestEnvironment();
    });

    beforeEach(async () => {
        await clearFirestoreData();
    });

    describe('Read Operations', () => {
        it('should allow authenticated user to read their own profile', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getAuthenticatedContext(userId);
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertSucceeds(userDoc.get());
        });

        it('should deny user from reading another user\'s profile', async () => {
            const user1 = 'user1';
            const user2 = 'user2';
            await createTestUser(user1, 'free');
            await createTestUser(user2, 'paid');

            const context = getAuthenticatedContext(user1);
            const otherUserDoc = context.firestore().collection('users').doc(user2);

            await assertFails(otherUserDoc.get());
        });

        it('should deny unauthenticated user from reading any profile', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getUnauthenticatedContext();
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertFails(userDoc.get());
        });
    });

    describe('Write Operations', () => {
        it('should deny user from creating their own profile', async () => {
            const userId = 'user1';
            const context = getAuthenticatedContext(userId);
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertFails(
                userDoc.set({
                    id: userId,
                    email: 'user1@test.com',
                    subscriptionTier: 'paid', // Trying to set paid tier
                })
            );
        });

        it('should deny user from updating their own profile', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getAuthenticatedContext(userId);
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertFails(
                userDoc.update({
                    subscriptionTier: 'paid', // Trying to upgrade to paid
                })
            );
        });

        it('should deny user from deleting their own profile', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getAuthenticatedContext(userId);
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertFails(userDoc.delete());
        });

        it('should deny unauthenticated user from writing to users collection', async () => {
            const context = getUnauthenticatedContext();
            const userDoc = context.firestore().collection('users').doc('newuser');

            await assertFails(
                userDoc.set({
                    id: 'newuser',
                    email: 'newuser@test.com',
                    subscriptionTier: 'free',
                })
            );
        });
    });
});
