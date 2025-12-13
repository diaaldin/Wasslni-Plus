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
 * Trigger: On Parcel Delivered
 * Updates merchant and courier statistics when a parcel is marked as delivered.
 */
exports.onParcelDelivered = onDocumentUpdated("parcels/{parcelId}", async (event) => {
    const parcelId = event.params.parcelId;
    const oldData = event.data.before.data();
    const newData = event.data.after.data();

    // Check if status changed to 'delivered'
    if (oldData.status !== 'delivered' && newData.status === 'delivered') {
        const merchantId = newData.merchantId;
        const courierId = newData.courierId;
        const deliveryFee = newData.deliveryFee || 0;
        const parcelPrice = newData.parcelPrice || 0;

        const promises = [];

        // Update Merchant Stats
        if (merchantId) {
            const merchantRef = db.collection('users').doc(merchantId);
            promises.push(merchantRef.update({
                totalDelivered: admin.firestore.FieldValue.increment(1),
                totalRevenue: admin.firestore.FieldValue.increment(parcelPrice), // Assuming revenue is parcel price for merchant
                totalDeliveryFees: admin.firestore.FieldValue.increment(deliveryFee)
            }));
        }

        // Update Courier Stats
        if (courierId) {
            const courierRef = db.collection('users').doc(courierId);
            promises.push(courierRef.update({
                totalDeliveries: admin.firestore.FieldValue.increment(1),
                // Courier revenue might be a percentage of delivery fee or fixed. 
                // For now, just increment delivery count.
            }));
        }

        await Promise.all(promises);
        logger.info(`Updated stats for parcel ${parcelId} (Merchant: ${merchantId}, Courier: ${courierId})`);
    }

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

// ==========================================
// CALLABLE FUNCTIONS
// ==========================================

/**
 * Trigger: On User Created
 * Sends a welcome notification to the new user.
 */
exports.onUserCreated = onDocumentCreated("users/{userId}", async (event) => {
    const userId = event.params.userId;
    const userData = event.data.data();

    logger.info(`New user created: ${userId} (${userData.role})`);

    // Only proceed if we have a token (might be set on registration)
    if (userData.fcmToken) {
        const payload = {
            notification: {
                title: 'Welcome to Wasslni Plus!',
                body: `Hello ${userData.name}, we are glad to have you as a ${userData.role}.`,
            },
            data: {
                type: 'welcome',
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
        await sendNotificationToUser(userId, payload);
    }

    return null;
});

const { onCall, HttpsError } = require("firebase-functions/v2/https");

/**
 * Callable: Generate Reports
 * Generates a report for a specific date range and type.
 */
exports.generateReports = onCall(async (request) => {
    // Check authentication
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }

    // Check role (admin or manager only)
    const uid = request.auth.uid;
    const userDoc = await db.collection('users').doc(uid).get();
    const userData = userDoc.data();

    if (userData.role !== 'admin' && userData.role !== 'manager') {
        throw new HttpsError('permission-denied', 'Only admins and managers can generate reports.');
    }

    const { type, startDate, endDate } = request.data;
    logger.info(`Generating ${type} report from ${startDate} to ${endDate} for user ${uid}`);

    // Placeholder logic for report generation
    // In a real app, this would query Firestore, aggregate data, and maybe generate a PDF or CSV

    const reportData = {
        generatedAt: new Date().toISOString(),
        type: type,
        period: { start: startDate, end: endDate },
        summary: {
            totalParcels: 150, // Mock data
            delivered: 120,
            pending: 30,
            revenue: 5000
        },
        url: "https://example.com/reports/report-123.pdf" // Mock URL
    };

    return reportData;
});

/**
 * Callable: Assign Optimal Courier
 * Finds and assigns the best courier for a parcel.
 */
exports.assignOptimalCourier = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }

    const { parcelId } = request.data;
    logger.info(`Assigning optimal courier for parcel ${parcelId}`);

    const parcelRef = db.collection('parcels').doc(parcelId);
    const parcelDoc = await parcelRef.get();

    if (!parcelDoc.exists) {
        throw new HttpsError('not-found', 'Parcel not found.');
    }

    const parcelData = parcelDoc.data();
    if (parcelData.courierId) {
        return { success: false, message: 'Parcel already assigned.' };
    }

    // Logic to find optimal courier
    // 1. Query couriers in the same region
    // 2. Filter by availability (isActive: true)
    // 3. Sort by rating or proximity (mocking logic here)

    const region = parcelData.deliveryRegion;
    const couriersSnapshot = await db.collection('users')
        .where('role', '==', 'courier')
        .where('status', '==', 'active')
        .where('workingRegions', 'array-contains', region)
        .limit(5)
        .get();

    if (couriersSnapshot.empty) {
        return { success: false, message: 'No available couriers in this region.' };
    }

    // Simple selection: pick the one with highest rating
    let bestCourier = null;
    let maxRating = -1;

    couriersSnapshot.forEach(doc => {
        const data = doc.data();
        const rating = data.rating || 0;
        if (rating > maxRating) {
            maxRating = rating;
            bestCourier = doc;
        }
    });

    if (bestCourier) {
        await parcelRef.update({
            courierId: bestCourier.id,
            status: 'assigned', // Assuming 'assigned' is a valid status
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });

        // Notify courier
        const payload = {
            notification: {
                title: 'New Parcel Assigned',
                body: `You have been assigned a new parcel: ${parcelData.barcode || parcelId}`,
            },
            data: {
                type: 'new_parcel_assignment',
                parcelId: parcelId,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
        await sendNotificationToUser(bestCourier.id, payload);

        return { success: true, courierId: bestCourier.id, courierName: bestCourier.data().name };
    }

    return { success: false, message: 'Could not determine optimal courier.' };
});

/**
 * Callable: Send Bulk Notifications
 * Sends a notification to a list of users or a topic.
 */
exports.sendBulkNotifications = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }

    // Check admin role
    const uid = request.auth.uid;
    const userDoc = await db.collection('users').doc(uid).get();
    if (userDoc.data().role !== 'admin') {
        throw new HttpsError('permission-denied', 'Only admins can send bulk notifications.');
    }

    const { title, body, targetRole, targetRegion } = request.data;
    logger.info(`Sending bulk notification: ${title} to role: ${targetRole}, region: ${targetRegion}`);

    let topic = 'all_users';
    if (targetRole) {
        topic = `role_${targetRole}`;
    } else if (targetRegion) {
        topic = `region_${targetRegion}`;
    }

    const message = {
        notification: {
            title: title,
            body: body,
        },
        topic: topic,
        data: {
            type: 'system_announcement',
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    try {
        const response = await admin.messaging().send(message);
        logger.info('Successfully sent message:', response);
        return { success: true, messageId: response };
    } catch (error) {
        logger.error('Error sending message:', error);
        throw new HttpsError('internal', 'Error sending notification.');
    }
});

/**
 * Callable: Calculate Route Optimization
 * Calculates the optimal delivery route for a courier's assigned parcels.
 */
exports.calculateRouteOptimization = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }

    const uid = request.auth.uid;
    const userDoc = await db.collection('users').doc(uid).get();
    const userData = userDoc.data();

    // Only couriers can optimize their routes
    if (userData.role !== 'courier') {
        throw new HttpsError('permission-denied', 'Only couriers can optimize routes.');
    }

    const { parcelIds } = request.data;
    logger.info(`Calculating route optimization for courier ${uid} with ${parcelIds ? parcelIds.length : 0} parcels`);

    // Fetch all assigned parcels for the courier if parcelIds not provided
    let parcelsToOptimize = [];

    if (parcelIds && parcelIds.length > 0) {
        // Fetch specific parcels
        const parcelsPromises = parcelIds.map(id => db.collection('parcels').doc(id).get());
        const parcelDocs = await Promise.all(parcelsPromises);
        parcelsToOptimize = parcelDocs
            .filter(doc => doc.exists)
            .map(doc => ({ id: doc.id, ...doc.data() }));
    } else {
        // Fetch all active parcels assigned to this courier
        const snapshot = await db.collection('parcels')
            .where('courierId', '==', uid)
            .where('status', 'in', ['assigned', 'picked_up', 'out_for_delivery'])
            .get();

        parcelsToOptimize = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    }

    if (parcelsToOptimize.length === 0) {
        return { success: false, message: 'No parcels to optimize.' };
    }

    // Group parcels by region
    const parcelsByRegion = {};
    parcelsToOptimize.forEach(parcel => {
        const region = parcel.deliveryRegion || 'unknown';
        if (!parcelsByRegion[region]) {
            parcelsByRegion[region] = [];
        }
        parcelsByRegion[region].push(parcel);
    });

    // Sort within each region by address (simple alphabetical sort)
    // In a real implementation, you would use geolocation and routing APIs
    const optimizedRoute = [];
    Object.keys(parcelsByRegion).sort().forEach(region => {
        const regionParcels = parcelsByRegion[region].sort((a, b) => {
            const addressA = a.deliveryAddress || '';
            const addressB = b.deliveryAddress || '';
            return addressA.localeCompare(addressB);
        });
        optimizedRoute.push(...regionParcels);
    });

    // Prepare response with ordered parcel IDs and summary
    const optimizedParcelIds = optimizedRoute.map(p => p.id);
    const routeSummary = Object.keys(parcelsByRegion).map(region => ({
        region: region,
        count: parcelsByRegion[region].length
    }));

    logger.info(`Route optimized for courier ${uid}: ${optimizedParcelIds.length} parcels across ${routeSummary.length} regions`);

    return {
        success: true,
        optimizedRoute: optimizedParcelIds,
        summary: {
            totalParcels: optimizedParcelIds.length,
            regions: routeSummary
        },
        details: optimizedRoute.map(p => ({
            id: p.id,
            barcode: p.barcode,
            recipientName: p.recipientName,
            deliveryAddress: p.deliveryAddress,
            deliveryRegion: p.deliveryRegion,
            status: p.status
        }))
    };
});

// ==========================================
// SCHEDULED FUNCTIONS
// ==========================================

const { onSchedule } = require("firebase-functions/v2/scheduler");

/**
 * Scheduled: Daily Analytics Aggregation
 * Runs every day at midnight to aggregate daily stats.
 */
exports.dailyAnalytics = onSchedule("every day 00:00", async (event) => {
    logger.info("Running daily analytics aggregation...");

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    // Query parcels created yesterday
    const parcelsSnapshot = await db.collection('parcels')
        .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(yesterday))
        .where('createdAt', '<', admin.firestore.Timestamp.fromDate(today))
        .get();

    const totalParcels = parcelsSnapshot.size;
    let deliveredCount = 0;
    let revenue = 0;

    parcelsSnapshot.forEach(doc => {
        const data = doc.data();
        if (data.status === 'delivered') {
            deliveredCount++;
        }
        revenue += (data.deliveryFee || 0);
    });

    // Save daily stats
    const statsRef = db.collection('analytics').doc(`daily_${yesterday.toISOString().split('T')[0]}`);
    await statsRef.set({
        date: yesterday,
        totalParcels: totalParcels,
        deliveredCount: deliveredCount,
        revenue: revenue,
        createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    logger.info(`Daily analytics saved: ${totalParcels} parcels, ${deliveredCount} delivered, $${revenue} revenue.`);
});

/**
 * Scheduled: Cleanup Notifications
 * Runs every Sunday at 3 AM to delete notifications older than 30 days.
 */
exports.cleanupNotifications = onSchedule("every sunday 03:00", async (event) => {
    logger.info("Running notification cleanup...");

    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const snapshot = await db.collection('notifications')
        .where('createdAt', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
        .limit(500) // Limit batch size
        .get();

    if (snapshot.empty) {
        logger.info("No old notifications to delete.");
        return;
    }

    const batch = db.batch();
    snapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
    });

    await batch.commit();
    logger.info(`Deleted ${snapshot.size} old notifications.`);
});

/**
 * Scheduled: Send Delivery Reminders
 * Runs every day at 8 AM to send reminders for parcels scheduled for today.
 */
exports.sendDeliveryReminders = onSchedule("every day 08:00", async (event) => {
    logger.info("Sending delivery reminders...");

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    // Find parcels scheduled for delivery today
    // Assuming 'scheduledDate' field exists
    const snapshot = await db.collection('parcels')
        .where('scheduledDate', '>=', admin.firestore.Timestamp.fromDate(today))
        .where('scheduledDate', '<', admin.firestore.Timestamp.fromDate(tomorrow))
        .where('status', 'in', ['pending', 'picked_up', 'out_for_delivery'])
        .get();

    if (snapshot.empty) {
        logger.info("No scheduled deliveries for today.");
        return;
    }

    const promises = [];
    snapshot.forEach(doc => {
        const data = doc.data();

        // Notify Customer
        if (data.customerId) {
            const payload = {
                notification: {
                    title: 'Delivery Reminder',
                    body: `Your parcel ${data.barcode || doc.id} is scheduled for delivery today.`,
                },
                data: {
                    type: 'delivery_reminder',
                    parcelId: doc.id,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                }
            };
            promises.push(sendNotificationToUser(data.customerId, payload));
        }
    });

    await Promise.all(promises);
    logger.info(`Sent reminders for ${snapshot.size} parcels.`);
});

/**
 * Scheduled: Generate Performance Reports
 * Runs every Monday at 6 AM to generate weekly performance reports for admin/managers.
 */
exports.generatePerformanceReports = onSchedule("every monday 06:00", async (event) => {
    logger.info("Generating weekly performance reports...");

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const lastWeek = new Date(today);
    lastWeek.setDate(lastWeek.getDate() - 7);

    // Fetch all parcels from the past week
    const parcelsSnapshot = await db.collection('parcels')
        .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(lastWeek))
        .where('createdAt', '<', admin.firestore.Timestamp.fromDate(today))
        .get();

    // Aggregate statistics
    const stats = {
        totalParcels: parcelsSnapshot.size,
        statusBreakdown: {},
        regionBreakdown: {},
        courierPerformance: {},
        merchantStats: {},
        totalRevenue: 0,
        successRate: 0
    };

    let deliveredCount = 0;

    parcelsSnapshot.forEach(doc => {
        const data = doc.data();

        // Status breakdown
        const status = data.status || 'unknown';
        stats.statusBreakdown[status] = (stats.statusBreakdown[status] || 0) + 1;

        // Region breakdown
        const region = data.deliveryRegion || 'unknown';
        if (!stats.regionBreakdown[region]) {
            stats.regionBreakdown[region] = { count: 0, revenue: 0 };
        }
        stats.regionBreakdown[region].count++;
        stats.regionBreakdown[region].revenue += (data.deliveryFee || 0);

        // Courier performance
        if (data.courierId) {
            if (!stats.courierPerformance[data.courierId]) {
                stats.courierPerformance[data.courierId] = {
                    totalAssigned: 0,
                    delivered: 0,
                    failed: 0,
                    revenue: 0
                };
            }
            stats.courierPerformance[data.courierId].totalAssigned++;
            if (status === 'delivered') {
                stats.courierPerformance[data.courierId].delivered++;
                deliveredCount++;
            } else if (status === 'failed' || status === 'returned') {
                stats.courierPerformance[data.courierId].failed++;
            }
            stats.courierPerformance[data.courierId].revenue += (data.deliveryFee || 0);
        }

        // Merchant stats
        if (data.merchantId) {
            if (!stats.merchantStats[data.merchantId]) {
                stats.merchantStats[data.merchantId] = {
                    totalParcels: 0,
                    delivered: 0,
                    revenue: 0
                };
            }
            stats.merchantStats[data.merchantId].totalParcels++;
            if (status === 'delivered') {
                stats.merchantStats[data.merchantId].delivered++;
            }
            stats.merchantStats[data.merchantId].revenue += (data.totalPrice || data.parcelPrice || 0);
        }

        // Total revenue
        stats.totalRevenue += (data.deliveryFee || 0);
    });

    // Calculate success rate
    stats.successRate = stats.totalParcels > 0
        ? ((deliveredCount / stats.totalParcels) * 100).toFixed(2)
        : 0;

    // Save the report
    const reportRef = db.collection('reports').doc();
    await reportRef.set({
        type: 'weekly_performance',
        period: {
            start: lastWeek,
            end: today
        },
        stats: stats,
        generatedAt: admin.firestore.FieldValue.serverTimestamp(),
        createdBy: 'system'
    });

    logger.info(`Weekly performance report generated: ${stats.totalParcels} parcels, ${stats.successRate}% success rate, $${stats.totalRevenue} revenue.`);

    // Notify admins about the new report
    const adminsSnapshot = await db.collection('users')
        .where('role', 'in', ['admin', 'manager'])
        .get();

    const notificationPromises = [];
    adminsSnapshot.forEach(doc => {
        const payload = {
            notification: {
                title: 'Weekly Performance Report Available',
                body: `New report: ${stats.totalParcels} parcels, ${stats.successRate}% success rate`,
            },
            data: {
                type: 'performance_report',
                reportId: reportRef.id,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            }
        };
        notificationPromises.push(sendNotificationToUser(doc.id, payload));
    });

    await Promise.all(notificationPromises);
    logger.info(`Notified ${adminsSnapshot.size} admins/managers about the new report.`);
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
