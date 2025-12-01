/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { setGlobalOptions } = require("firebase-functions/v2");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

// Set global options
setGlobalOptions({ maxInstances: 10 });

/**
 * Trigger: On Parcel Status Change
 * Sends notifications to relevant users when a parcel's status changes.
 */
exports.onParcelStatusChange = onDocumentUpdated("parcels/{parcelId}", async (event) => {
    const parcelId = event.params.parcelId;
    const oldData = event.data.before.data();
    const newData = event.data.after.data();

    // Check if status changed
    if (oldData.status === newData.status) {
        return null;
    }

    const newStatus = newData.status;
    logger.info(`Parcel ${parcelId} status changed from ${oldData.status} to ${newStatus}`);

    // Prepare notification payload
    const payload = {
        notification: {
            title: 'Parcel Status Update',
            body: `Your parcel ${parcelId} is now ${newStatus}.`,
        },
        data: {
            type: 'parcel_status_update',
            parcelId: parcelId,
            status: newStatus,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
    };

    const promises = [];

    // Notify Customer
    if (newData.customerId) {
        promises.push(sendNotificationToUser(newData.customerId, payload));
    }

    // Notify Merchant
    if (newData.merchantId) {
        promises.push(sendNotificationToUser(newData.merchantId, payload));
    }

    // Notify Courier (if assigned)
    if (newData.courierId) {
        promises.push(sendNotificationToUser(newData.courierId, payload));
    }

    await Promise.all(promises);
    return null;
});

/**
 * Trigger: On Parcel Created
 * Assigns a unique barcode if one wasn't provided.
 */
exports.onParcelCreated = onDocumentCreated("parcels/{parcelId}", async (event) => {
    const parcelId = event.params.parcelId;
    const data = event.data.data();

    if (data.barcode) {
        return null;
    }

    // Generate a simple barcode (e.g., timestamp + random suffix)
    // In a real app, you might want a more robust generation logic
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 5).toUpperCase();
    const barcode = `PKG-${timestamp}-${random}`;

    logger.info(`Generating barcode for parcel ${parcelId}: ${barcode}`);

    return event.data.ref.update({ barcode: barcode });
});

/**
 * Trigger: On Review Created
 * Updates the courier's average rating when a new review is added.
 */
exports.onReviewCreated = onDocumentCreated("reviews/{reviewId}", async (event) => {
    const reviewData = event.data.data();
    const courierId = reviewData.courierId;
    const rating = reviewData.rating;

    if (!courierId || !rating) {
        return null;
    }

    const courierRef = db.collection('users').doc(courierId);

    return db.runTransaction(async (transaction) => {
        const courierDoc = await transaction.get(courierRef);
        if (!courierDoc.exists) {
            throw new Error("Courier does not exist!");
        }

        const courierData = courierDoc.data();
        const currentRating = courierData.rating || 0;
        const totalDeliveries = courierData.totalDeliveries || 0; // Assuming totalDeliveries tracks rated deliveries or we need a separate count

        // Note: Ideally, we should track 'numberOfRatings' separately from 'totalDeliveries'
        // For this MVP, let's assume we add a 'numberOfRatings' field to the user model or infer it.
        // If 'numberOfRatings' doesn't exist, we might need to query all reviews (expensive).
        // Let's try to increment a 'numberOfRatings' field on the user if it exists, otherwise initialize it.

        const currentNumRatings = courierData.numberOfRatings || 0;
        const newNumRatings = currentNumRatings + 1;

        // Calculate new average
        const newAverage = ((currentRating * currentNumRatings) + rating) / newNumRatings;

        transaction.update(courierRef, {
            rating: newAverage,
            numberOfRatings: newNumRatings
        });

        logger.info(`Updated courier ${courierId} rating to ${newAverage} (${newNumRatings} ratings)`);
    });
});

/**
 * Helper function to send notification to a user
 */
async function sendNotificationToUser(userId, payload) {
    try {
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) {
            logger.warn(`User ${userId} not found for notification.`);
            return;
        }

        const userData = userDoc.data();
        const fcmToken = userData.fcmToken;

        if (!fcmToken) {
            logger.warn(`User ${userId} has no FCM token.`);
            return;
        }

        await admin.messaging().send({
            token: fcmToken,
            notification: payload.notification,
            data: payload.data
        });

        logger.info(`Notification sent to user ${userId}`);
    } catch (error) {
        logger.error(`Error sending notification to user ${userId}:`, error);
    }
}
