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
    assertFails,
    assertSucceeds,
} = require('../helpers/test-helpers');

describe('Families Collection Security Rules', () => {
    before(async () => {
        await setupTestEnvironment();
    });

    after(async () => {
        await teardownTestEnvironment();
    });

    beforeEach(async () => {
        await clearFirestoreData();
    });

    describe('Create Operations', () => {
        it('should allow authenticated user to create a family', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');

            const context = getAuthenticatedContext(userId);
            const familyDoc = context.firestore().collection('families').doc('family1');

            await assertSucceeds(
                familyDoc.set({
                    id: 'family1',
                    name: 'My Family',
                    itemCount: 0,
                    memberCount: 0,
                    inviteCode: 'ABC123',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should deny unauthenticated user from creating a family', async () => {
            const context = getUnauthenticatedContext();
            const familyDoc = context.firestore().collection('families').doc('family1');

            await assertFails(
                familyDoc.set({
                    id: 'family1',
                    name: 'My Family',
                    itemCount: 0,
                    memberCount: 0,
                    inviteCode: 'ABC123',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Read Operations', () => {
        it('should allow authenticated user to read any family document', async () => {
            const user1 = 'user1';
            const user2 = 'user2';
            await createTestUser(user1, 'free');
            await createTestUser(user2, 'free');
            await createTestFamily('family1');

            const context = getAuthenticatedContext(user1);
            const familyDoc = context.firestore().collection('families').doc('family1');

            await assertSucceeds(familyDoc.get());
        });

        it('should allow authenticated user to list families', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');
            await createTestFamily('family1');
            await createTestFamily('family2');

            const context = getAuthenticatedContext(userId);
            const familiesQuery = context.firestore().collection('families');

            await assertSucceeds(familiesQuery.get());
        });

        it('should deny unauthenticated user from reading families', async () => {
            await createTestFamily('family1');

            const context = getUnauthenticatedContext();
            const familyDoc = context.firestore().collection('families').doc('family1');

            await assertFails(familyDoc.get());
        });
    });

    describe('Update Operations', () => {
        it('should allow family admin to update family', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const familyDoc = context.firestore().collection('families').doc(familyId);

            await assertSucceeds(
                familyDoc.update({
                    name: 'Updated Family Name',
                })
            );
        });

        it('should allow personal family owner to update their family', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');
            await createTestFamily(userId); // familyId == userId for personal family

            const context = getAuthenticatedContext(userId);
            const familyDoc = context.firestore().collection('families').doc(userId);

            await assertSucceeds(
                familyDoc.update({
                    name: 'My Personal Family',
                })
            );
        });

        it('should deny regular member from updating family', async () => {
            const adminId = 'admin1';
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const familyDoc = context.firestore().collection('families').doc(familyId);

            await assertFails(
                familyDoc.update({
                    name: 'Hacked Name',
                })
            );
        });

        it('should deny non-member from updating family', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);

            const context = getAuthenticatedContext(userId);
            const familyDoc = context.firestore().collection('families').doc(familyId);

            await assertFails(
                familyDoc.update({
                    name: 'Hacked Name',
                })
            );
        });
    });

    describe('Delete Operations', () => {
        it('should allow family admin to delete family', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const familyDoc = context.firestore().collection('families').doc(familyId);

            await assertSucceeds(familyDoc.delete());
        });

        it('should allow co-admin to delete family', async () => {
            const coAdminId = 'coadmin1';
            const familyId = 'family1';
            await createTestUser(coAdminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, coAdminId, { role: 'co-admin', userId: coAdminId });

            const context = getAuthenticatedContext(coAdminId);
            const familyDoc = context.firestore().collection('families').doc(familyId);

            await assertSucceeds(familyDoc.delete());
        });

        it('should deny regular member from deleting family', async () => {
            const adminId = 'admin1';
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const familyDoc = context.firestore().collection('families').doc(familyId);

            await assertFails(familyDoc.delete());
        });
    });
});
