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
    createTestLocation,
    assertFails,
    assertSucceeds,
} = require('../helpers/test-helpers');

describe('Locations Subcollection Security Rules', () => {
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
        it('should allow family member to read locations', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(memberId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertSucceeds(locationDoc.get());
        });

        it('should allow family member to list locations', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });
            await createTestLocation(familyId, 'loc2', { name: 'Basement' });

            const context = getAuthenticatedContext(memberId);
            const locationsQuery = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations');

            await assertSucceeds(locationsQuery.get());
        });

        it('should deny non-member from reading locations', async () => {
            const userId = 'user1';
            const familyId = 'family1';
            await createTestUser(userId, 'free');
            await createTestFamily(familyId);
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(userId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertFails(locationDoc.get());
        });

        it('should deny unauthenticated user from reading locations', async () => {
            const familyId = 'family1';
            await createTestFamily(familyId);
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getUnauthenticatedContext();
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertFails(locationDoc.get());
        });
    });

    describe('Create Operations', () => {
        it('should allow admin to create locations', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });

            const context = getAuthenticatedContext(adminId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('newloc1');

            await assertSucceeds(
                locationDoc.set({
                    id: 'newloc1',
                    name: 'Garage',
                    description: 'Storage in garage',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should allow co-admin to create locations', async () => {
            const coAdminId = 'coadmin1';
            const familyId = 'family1';
            await createTestUser(coAdminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, coAdminId, { role: 'co-admin', userId: coAdminId });

            const context = getAuthenticatedContext(coAdminId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('newloc1');

            await assertSucceeds(
                locationDoc.set({
                    id: 'newloc1',
                    name: 'Garage',
                    description: 'Storage in garage',
                    createdAt: new Date().toISOString(),
                })
            );
        });

        it('should deny regular member from creating locations', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });

            const context = getAuthenticatedContext(memberId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('newloc1');

            await assertFails(
                locationDoc.set({
                    id: 'newloc1',
                    name: 'Garage',
                    description: 'Storage in garage',
                    createdAt: new Date().toISOString(),
                })
            );
        });
    });

    describe('Update Operations', () => {
        it('should allow admin to update locations', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(adminId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertSucceeds(
                locationDoc.update({
                    name: 'Updated Attic',
                })
            );
        });

        it('should allow co-admin to update locations', async () => {
            const coAdminId = 'coadmin1';
            const familyId = 'family1';
            await createTestUser(coAdminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, coAdminId, { role: 'co-admin', userId: coAdminId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(coAdminId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertSucceeds(
                locationDoc.update({
                    name: 'Updated Attic',
                })
            );
        });

        it('should deny regular member from updating locations', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(memberId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertFails(
                locationDoc.update({
                    name: 'Hacked Name',
                })
            );
        });
    });

    describe('Delete Operations', () => {
        it('should allow admin to delete locations', async () => {
            const adminId = 'admin1';
            const familyId = 'family1';
            await createTestUser(adminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, adminId, { role: 'admin', userId: adminId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(adminId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertSucceeds(locationDoc.delete());
        });

        it('should allow co-admin to delete locations', async () => {
            const coAdminId = 'coadmin1';
            const familyId = 'family1';
            await createTestUser(coAdminId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, coAdminId, { role: 'co-admin', userId: coAdminId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(coAdminId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertSucceeds(locationDoc.delete());
        });

        it('should deny regular member from deleting locations', async () => {
            const memberId = 'member1';
            const familyId = 'family1';
            await createTestUser(memberId, 'free');
            await createTestFamily(familyId);
            await createTestMember(familyId, memberId, { role: 'member', userId: memberId });
            await createTestLocation(familyId, 'loc1', { name: 'Attic' });

            const context = getAuthenticatedContext(memberId);
            const locationDoc = context.firestore()
                .collection('families').doc(familyId)
                .collection('locations').doc('loc1');

            await assertFails(locationDoc.delete());
        });
    });
});
