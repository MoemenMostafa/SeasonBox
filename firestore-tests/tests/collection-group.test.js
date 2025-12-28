const { describe, it, before, after, beforeEach } = require('mocha');
const {
    setupTestEnvironment,
    teardownTestEnvironment,
    clearFirestoreData,
    getAuthenticatedContext,
    createTestUser,
    createTestFamily,
    createTestMember,
    assertFails,
    assertSucceeds,
} = require('../helpers/test-helpers');

describe('Collection Group Queries', () => {
    before(async () => {
        await setupTestEnvironment();
    });

    after(async () => {
        await teardownTestEnvironment();
    });

    beforeEach(async () => {
        await clearFirestoreData();
    });

    describe('Pending Invites by Email', () => {
        it('should allow user to find pending invites by their email', async () => {
            const userId = 'user1';
            const userEmail = 'user1@test.com';
            const family1 = 'family1';
            const family2 = 'family2';

            await createTestUser(userId, 'free');
            await createTestFamily(family1);
            await createTestFamily(family2);

            // Create pending invites in different families with user's email
            await createTestMember(family1, 'pending1', {
                inviteEmail: userEmail,
                role: 'member',
            });
            await createTestMember(family2, 'pending2', {
                inviteEmail: userEmail,
                role: 'member',
            });

            const context = getAuthenticatedContext(userId, { email: userEmail });

            // Collection group query to find all pending invites
            const invitesQuery = context.firestore()
                .collectionGroup('members')
                .where('inviteEmail', '==', userEmail);

            await assertSucceeds(invitesQuery.get());
        });

        it('should allow user to read specific pending invite by email', async () => {
            const userId = 'user1';
            const userEmail = 'user1@test.com';
            const familyId = 'family1';

            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, 'pending1', {
                inviteEmail: userEmail,
                role: 'member',
            });

            const context = getAuthenticatedContext(userId, { email: userEmail });
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('pending1');

            await assertSucceeds(memberDoc.get());
        });

        it('should deny user from reading invites for other emails', async () => {
            const userId = 'user1';
            const userEmail = 'user1@test.com';
            const otherEmail = 'other@test.com';
            const familyId = 'family1';

            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, 'pending1', {
                inviteEmail: otherEmail,
                role: 'member',
            });

            const context = getAuthenticatedContext(userId, { email: userEmail });
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('pending1');

            // Should fail to read a specific invite with different email
            await assertFails(memberDoc.get());
        });

        it('should allow user to query their own invites across multiple families', async () => {
            const userId = 'user1';
            const userEmail = 'user1@test.com';

            await createTestUser(userId, 'free');

            // Create multiple families with invites
            for (let i = 1; i <= 3; i++) {
                const familyId = `family${i}`;
                await createTestFamily(familyId);
                await createTestMember(familyId, `pending${i}`, {
                    inviteEmail: userEmail,
                    role: 'member',
                });
            }

            const context = getAuthenticatedContext(userId, { email: userEmail });
            const invitesQuery = context.firestore()
                .collectionGroup('members')
                .where('inviteEmail', '==', userEmail);

            const result = await assertSucceeds(invitesQuery.get());

            // Should find all 3 invites
            if (result.docs.length !== 3) {
                throw new Error(`Expected 3 invites, got ${result.docs.length}`);
            }
        });
    });
});
