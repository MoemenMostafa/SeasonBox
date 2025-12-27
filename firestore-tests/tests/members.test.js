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

describe('Members Subcollection Security Rules', () => {
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
        it('should allow authenticated user to read members', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, 'member1', { role: 'member' });

            const context = getAuthenticatedContext(userId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('member1');

            await assertSucceeds(memberDoc.get());
        });

        it('should allow authenticated user to list members', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, 'member1', { role: 'member' });

            const context = getAuthenticatedContext(userId);
            const membersQuery = context.firestore()
                .collection('families').doc(familyId)
                .collection('members');

            await assertSucceeds(membersQuery.get());
        });

        it('should deny unauthenticated user from reading members', async () => {
            const familyId = 'family1';
            await createTestFamily(familyId);
            await createTestMember(familyId, 'member1', { role: 'member' });

            const context = getUnauthenticatedContext();
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('member1');

            await assertFails(memberDoc.get());
        });
    });

    describe('Create Operations - Admin Invites', () => {
        it('should allow admin to create member invite', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'paid'); // Paid user can invite
            await createTestFamily(familyId, { memberCount: 1 });
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const newMemberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('newmember1');

            await assertSucceeds(
                newMemberDoc.set({
                    id: 'newmember1',
                    name: 'New Member',
                    role: 'member',
                    inviteEmail: 'newmember@test.com',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow admin to add themselves as member even on free tier', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId, { memberCount: 4 }); // At limit

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(adminId);

            await assertSucceeds(
                memberDoc.set({
                    id: adminId,
                    userId: adminId,
                    name: 'Admin',
                    role: 'member',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Create Operations - User Self-Registration', () => {
        it('should allow user to create themselves as admin in personal family', async () => {
            const userId = 'user1';
            await createTestUser(userId, 'free');
            await createTestFamily(userId); // Personal family: familyId == userId

            const context = getAuthenticatedContext(userId);
            const memberDoc = context.firestore()
                .collection('families').doc(userId)
                .collection('members').doc(userId);

            await assertSucceeds(
                memberDoc.set({
                    id: userId,
                    userId: userId,
                    name: 'User One',
                    role: 'admin', // Can be admin in personal family
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow user to join existing family as member', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);

            const context = getAuthenticatedContext(userId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(userId);

            await assertSucceeds(
                memberDoc.set({
                    id: userId,
                    userId: userId,
                    name: 'User One',
                    role: 'member', // Must be member when joining
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should deny user from creating themselves as admin in another family', async () => {
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
                    name: 'User One',
                    role: 'admin', // Cannot be admin in non-personal family
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should deny user from creating member with different userId', async () => {
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
                    userId: 'differentUser', // Trying to spoof userId
                    name: 'User One',
                    role: 'member',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Update Operations', () => {
        it('should allow admin to update any member', async () => {
            const adminId = 'admin1';
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertSucceeds(
                memberDoc.update({
                    name: 'Updated Name',
                })
            );
        });

        it('should allow admin to change member role', async () => {
            const adminId = 'admin1';
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertSucceeds(
                memberDoc.update({
                    role: 'co-admin',
                })
            );
        });

        it('should allow member to update their own details', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertSucceeds(
                memberDoc.update({
                    name: 'Updated Name',
                })
            );
        });

        it('should deny member from promoting themselves', async () => {
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
                    role: 'admin', // Trying to promote self
                })
            );
        });

        it('should deny member from changing their userId', async () => {
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
                    userId: 'differentUser', // Trying to change userId
                })
            );
        });
    });

    describe('Delete Operations', () => {
        it('should allow admin to delete members', async () => {
            const adminId = 'admin1';
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertSucceeds(memberDoc.delete());
        });

        it('should allow member to leave family (delete self)', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertSucceeds(memberDoc.delete());
        });

        it('should allow user to reject invite by email', async () => {
            const userId = 'user1';
            const userEmail = 'user1@test.com';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, 'pendingmember1', {
                inviteEmail: userEmail,
                role: 'member',
            });

            const context = getAuthenticatedContext(userId, { email: userEmail });
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('pendingmember1');

            await assertSucceeds(memberDoc.delete());
        });

        it('should deny member from deleting other members', async () => {
            const member1Id = 'member1';
            const member2Id = 'member2';
            const familyId = 'family1';
            await createTestUser(member1Id, 'free');
            await createTestUser(member2Id, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, member1Id, { role: 'member', userId: member1Id });
            await createTestMember(familyId, member2Id, { role: 'member', userId: member2Id });

            const context = getAuthenticatedContext(member1Id);
            const member2Doc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(member2Id);

            await assertFails(member2Doc.delete());
        });
    });
});
