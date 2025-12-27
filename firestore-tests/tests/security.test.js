const { describe, it, before, after, beforeEach } = require('mocha');
const {
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
    assertFails,
    assertSucceeds,
} = require('../helpers/test-helpers');

describe('Security Edge Cases and Vulnerabilities', () => {
    before(async () => {
        await setupTestEnvironment();
    });

    after(async () => {
        await teardownTestEnvironment();
    });

    beforeEach(async () => {
        await clearFirestoreData();
    });

    describe('Cross-Family Access Prevention', () => {
        it('should prevent member from accessing items in different family', async () => {
            const user1 = 'user1';
            const user2 = 'user2';
            const family1 = 'family1';
            const family2 = 'family2';

            await createTestUser(user1, 'free');
            await createTestUser(user2, 'free');
            await createTestFamily(family1);
            await createTestFamily(family2);
            await createTestMember(family1, user1, { role: 'member', userId: user1 });
            await createTestMember(family2, user2, { role: 'member', userId: user2 });
            await createTestItem(family2, 'item1', { ownerId: user2 });

            const context = getAuthenticatedContext(user1);
            const itemDoc = context.firestore()
                .collection('families').doc(family2)
                .collection('items').doc('item1');

            await assertFails(itemDoc.get());
        });

        it('should prevent admin from managing members in different family', async () => {
            const admin1 = 'admin1';
            const admin2 = 'admin2';
            const family1 = 'family1';
            const family2 = 'family2';

            await createTestUser(admin1, 'free');
            await createTestUser(admin2, 'free');
            await createTestFamily(family1);
            await createTestFamily(family2);
            await createTestMember(family1, admin1, { role: 'admin', userId: admin1 });
            await createTestMember(family2, admin2, { role: 'admin', userId: admin2 });

            const context = getAuthenticatedContext(admin1);
            const memberDoc = context.firestore()
                .collection('families').doc(family2)
                .collection('members').doc('newmember');

            await assertFails(
                memberDoc.set({
                    id: 'newmember',
                    name: 'New Member',
                    role: 'member',
                    inviteEmail: 'new@test.com',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Role Escalation Prevention', () => {
        it('should prevent member from promoting themselves to admin', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertFails(
                memberDoc.update({
                    role: 'admin',
                })
            );
        });

        it('should prevent member from promoting themselves to co-admin', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertFails(
                memberDoc.update({
                    role: 'co-admin',
                })
            );
        });

        it('should prevent user from creating themselves as admin in non-personal family', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);

            const context = getAuthenticatedContext(userId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(userId);

            await assertFails(
                memberDoc.set({
                    id: userId,
                    userId: userId,
                    name: 'User',
                    role: 'admin', // Trying to be admin in non-personal family
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('UserId Tampering Prevention', () => {
        it('should prevent user from creating member with different userId', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);

            const context = getAuthenticatedContext(userId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(userId);

            await assertFails(
                memberDoc.set({
                    id: userId,
                    userId: 'differentUser', // Tampering with userId
                    name: 'User',
                    role: 'member',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should prevent member from changing their userId', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertFails(
                memberDoc.update({
                    userId: 'hackedUser',
                })
            );
        });

        it('should prevent member from creating items for other users', async () => {
            const member1 = 'member1';
            const member2 = 'member2';
            const familyId = 'family1';
            await createTestUser(member1, 'free');
            await createTestFamily(familyId, { itemCount: 0 });
            await createTestMember(familyId, member1, { role: 'member', userId: member1 });

            const context = getAuthenticatedContext(member1);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item1');

            await assertFails(
                itemDoc.set({
                    id: 'item1',
                    familyId: familyId,
                    title: 'Test Item',
                    category: 'clothing',
                    gender: 'unisex',
                    size: 'M',
                    ownerId: member2, // Trying to create for another user
                    storageLocationId: 'loc1',
                    photos: [],
                    seasonTags: [],
                    quantity: 1,
                    notes: '',
                    status: 'stored',
                    loanHistory: [],
                    tags: [],
                    addedAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Unauthenticated Access Prevention', () => {
        it('should deny unauthenticated access to all collections', async () => {
            await createTestFamily('family1');
            await createTestMember('family1', 'member1', { role: 'member' });
            await createTestItem('family1', 'item1', { ownerId: 'member1' });
            await createTestLocation('family1', 'loc1', { name: 'Attic' });

            const context = getUnauthenticatedContext();

            // Try to access families
            await assertFails(
                context.firestore().collection('families').doc('family1').get()
            );

            // Try to access members
            await assertFails(
                context.firestore()
                    .collection('families').doc('family1')
                    .collection('members').doc('member1')
                    .get()
            );

            // Try to access items
            await assertFails(
                context.firestore()
                    .collection('families').doc('family1')
                    .collection('items').doc('item1')
                    .get()
            );

            // Try to access locations
            await assertFails(
                context.firestore()
                    .collection('families').doc('family1')
                    .collection('locations').doc('loc1')
                    .get()
            );
        });
    });

    describe('Personal Family Creation', () => {
        it('should allow user to create personal family where familyId equals userId', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getAuthenticatedContext(userId);
            const familyDoc = context.firestore().collection('families').doc(userId);

            await assertSucceeds(
                familyDoc.set({
                    id: userId,
                    name: 'My Personal Family',
                    itemCount: 0,
                    memberCount: 0,
                    inviteCode: 'ABC123',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow user to be admin in their personal family', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');
            await createTestFamily(userId); // Personal family

            const context = getAuthenticatedContext(userId);
            const memberDoc = context.firestore()
                .collection('families').doc(userId)
                .collection('members').doc(userId);

            await assertSucceeds(
                memberDoc.set({
                    id: userId,
                    userId: userId,
                    name: 'User',
                    role: 'admin', // Can be admin in personal family
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow personal family owner to manage their family', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');
            await createTestFamily(userId);

            const context = getAuthenticatedContext(userId);
            const familyDoc = context.firestore().collection('families').doc(userId);

            await assertSucceeds(
                familyDoc.update({
                    name: 'Updated Personal Family',
                })
            );
        });
    });

    describe('Subscription Tier Tampering Prevention', () => {
        it('should prevent user from upgrading their own subscription tier', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getAuthenticatedContext(userId);
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertFails(
                userDoc.update({
                    subscriptionTier: 'paid',
                })
            );
        });

        it('should prevent user from creating their profile with paid tier', async () => {
            const userId = 'user1';

            const context = getAuthenticatedContext(userId);
            const userDoc = context.firestore().collection('users').doc(userId);

            await assertFails(
                userDoc.set({
                    id: userId,
                    email: 'user1@test.com',
                    subscriptionTier: 'paid',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });
});
