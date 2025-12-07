// Firebase Cloud Messaging Service Worker
// This file must be served from the root of your domain

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker
// TODO: Replace with your Firebase config
// You can get this from your Firebase Console -> Project Settings -> General -> Your apps -> Firebase SDK snippet
firebase.initializeApp({
    apiKey: "AIzaSyCdUMZP62XJR4A3UjrWuV8ursRqLAkA_Wo",
    authDomain: "wani-plus.firebaseapp.com",
    projectId: "wani-plus",
    storageBucket: "wani-plus.firebasestorage.app",
    messagingSenderId: "827477887076",
    appId: "1:827477887076:web:cc6658e8995ca0b73cf771",
    measurementId: "G-BQH2ENT560"
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    const notificationTitle = payload.notification?.title || 'New Notification';
    const notificationOptions = {
        body: payload.notification?.body || 'You have a new notification',
        icon: '/icons/Icon-192.png',
        badge: '/icons/Icon-192.png',
        tag: payload.data?.parcelId || 'notification',
        data: payload.data
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification clicks
self.addEventListener('notificationclick', (event) => {
    console.log('[firebase-messaging-sw.js] Notification click received.');

    event.notification.close();

    // Handle notification click - navigate to specific page based on data
    event.waitUntil(
        clients.matchAll({ type: 'window', includeUncontrolled: true })
            .then((clientList) => {
                // If a window is already open, focus it
                for (const client of clientList) {
                    if (client.url === '/' && 'focus' in client) {
                        return client.focus();
                    }
                }
                // Otherwise, open a new window
                if (clients.openWindow) {
                    return clients.openWindow('/');
                }
            })
    );
});
