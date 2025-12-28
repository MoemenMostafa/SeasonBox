const { describe, it, before, after, beforeEach } = require('mocha');
const {
    setupTestEnvironment,
    teardownTestEnvironment,
    clearFirestoreData,
    getAuthenticatedContext,
    createTestUser,
    createTestFamily,
    createTestMember,
    createMultipleItems,
    createMultipleMembers,
    assertFails,
    assertSucceeds,
} = require('../helpers/test-helpers');

describe('Subscription Tier Limits', () => {
    before(async () => {
        await setupTestEnvironment();
    });

    after(async () => {
        await teardownTestEnvironment();
    });

    beforeEach(async () => {
        await clearFirestoreData();
    });

    describe('Item Limits', () => {
        it('should allow free tier user to add items up to 50', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId, { itemCount: 49 });
            await createTestMember(familyId, userId, { role: 'admin', userId });

            const context = getAuthenticatedContext(userId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item50');

            await assertSucceeds(
                itemDoc.set({
                    id: 'item50',
                    familyId: familyId,
                    title: 'Item 50',
                    category: 'clothing',
                    gender: 'unisex',
                    size: 'M',
                    ownerId: userId,
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

        it('should deny free tier user from adding 51st item', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId, { itemCount: 50 });
            await createTestMember(familyId, userId, { role: 'admin', userId });

            const context = getAuthenticatedContext(userId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item51');

            await assertFails(
                itemDoc.set({
                    id: 'item51',
                    familyId: familyId,
                    title: 'Item 51',
                    category: 'clothing',
                    gender: 'unisex',
                    size: 'M',
                    ownerId: userId,
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

        it('should allow paid tier user to add items beyond 50', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'paid');
            await createTestFamily(familyId, { itemCount: 100 });
            await createTestMember(familyId, userId, { role: 'admin', userId });

            const context = getAuthenticatedContext(userId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item101');

            await assertSucceeds(
                itemDoc.set({
                    id: 'item101',
                    familyId: familyId,
                    title: 'Item 101',
                    category: 'clothing',
                    gender: 'unisex',
                    size: 'M',
                    ownerId: userId,
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

        it('should allow free tier member to add items if family owner is paid', async () => {
            const ownerId = 'owner1';
            const memberId = 'member1';
            const familyId = ownerId; // Personal family of owner
            await createTestUser(ownerId, 'paid'); // Family owner is paid
            await createTestUser(memberId, 'free'); // Member is free
            await createTestFamily(familyId, { itemCount: 60 });
            await createTestMember(familyId, ownerId, { role: 'admin', userId: ownerId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item61');

            await assertSucceeds(
                itemDoc.set({
                    id: 'item61',
                    familyId: familyId,
                    title: 'Item 61',
                    category: 'clothing',
                    gender: 'unisex',
                    size: 'M',
                    ownerId: memberId,
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

    describe('Member Limits', () => {
        it('should allow free tier user to add members up to 4', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId, { memberCount: 3 });
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('member4');

            await assertSucceeds(
                memberDoc.set({
                    id: 'member4',
                    name: 'Member 4',
                    role: 'member',
                    inviteEmail: 'member4@test.com',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should deny free tier user from adding 5th member', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId, { memberCount: 4 });
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('member5');

            await assertFails(
                memberDoc.set({
                    id: 'member5',
                    name: 'Member 5',
                    role: 'member',
                    inviteEmail: 'member5@test.com',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow paid tier user to add members beyond 4', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'paid');
            await createTestFamily(familyId, { memberCount: 10 });
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc('member11');

            await assertSucceeds(
                memberDoc.set({
                    id: 'member11',
                    name: 'Member 11',
                    role: 'member',
                    inviteEmail: 'member11@test.com',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow free tier member to join if family owner is paid', async () => {
            const ownerId = 'owner1';
            const memberId = 'member1';
            const familyId = ownerId; // Personal family of owner
            await createTestUser(ownerId, 'paid'); // Family owner is paid
            await createTestUser(memberId, 'free'); // Member is free
            await createTestFamily(familyId, { memberCount: 5 });
            await createTestMember(familyId, ownerId, { role: 'admin', userId: ownerId });

            const context = getAuthenticatedContext(memberId);
            const memberDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('members').doc(memberId);

            await assertSucceeds(
                memberDoc.set({
                    id: memberId,
                    userId: memberId,
                    name: 'Member',
                    role: 'member',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Photo Limits', () => {
        it('should allow free tier user to add 1 photo', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, userId, { role: 'admin', userId });

            const context = getAuthenticatedContext(userId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item1');

            await assertSucceeds(
                itemDoc.set({
                    id: 'item1',
                    familyId: familyId,
                    title: 'Item 1',
                    ownerId: userId,
                    photos: [{ full: 'url1', thumb: 'url1' }],
                })
            );
        });

        it('should deny free tier user from adding 2nd photo', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, userId, { role: 'admin', userId });

            const context = getAuthenticatedContext(userId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item1');

            await assertFails(
                itemDoc.set({
                    id: 'item1',
                    familyId: familyId,
                    title: 'Item 1',
                    ownerId: userId,
                    photos: [
                        { full: 'url1', thumb: 'url1' },
                        { full: 'url2', thumb: 'url2' },
                    ],
                })
            );
        });

        it('should allow paid tier user to add 3 photos', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'paid');
            await createTestFamily(familyId);
            await createTestMember(familyId, userId, { role: 'admin', userId });

            const context = getAuthenticatedContext(userId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item1');

            await assertSucceeds(
                itemDoc.set({
                    id: 'item1',
                    familyId: familyId,
                    title: 'Item 1',
                    ownerId: userId,
                    photos: [
                        { full: 'url1', thumb: 'url1' },
                        { full: 'url2', thumb: 'url2' },
                        { full: 'url3', thumb: 'url3' },
                    ],
                })
            );
        });

        it('should allow free tier member to add 3 photos if family owner is paid', async () => {
            const ownerId = 'owner1';
            const memberId = 'member1';
            const familyId = ownerId;
            await createTestUser(ownerId, 'paid');
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, ownerId, { role: 'admin', userId: ownerId });
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const itemDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('items').doc('item1');

            await assertSucceeds(
                itemDoc.set({
                    id: 'item1',
                    familyId: familyId,
                    title: 'Item 1',
                    ownerId: memberId,
                    photos: [
                        { full: 'url1', thumb: 'url1' },
                        { full: 'url2', thumb: 'url2' },
                        { full: 'url3', thumb: 'url3' },
                    ],
                })
            );
        });
    });
});
