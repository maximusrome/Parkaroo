/* eslint-disable */
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
admin.initializeApp()

const db = admin.firestore()


exports.spotReserved = functions.https
    .onCall((data, _context) => {
        const user = data.user

        const ref = db.collection('users').doc(user)

       ref.get().then((snap) => {
            const accountData = snap.data()!
            const token = accountData.token as string 
            let badgeCount = accountData.badge_count as number 
            const message = 'Your spot has been reserved.'
            badgeCount++
            sendNotification(message, badgeCount, token)
            sendNewNotification(message, badgeCount, token)
            updateBadgeCount(user, badgeCount)
        }).catch()
})

exports.onPinCreated = functions.firestore
    .document('pins/{pin_id}')
    .onCreate(async (snapshot, context) => {
    const uid = context.params.pin_id

    return db.collection('users').doc(uid).get().then((snap) => {
        const accountData = snap.data()!
        const token = accountData.token as string 
        let badgeCount = accountData.badge_count as number 
        const message = 'You created a spot'
        badgeCount++
        sendNotification(message, badgeCount, token)
        updateBadgeCount(uid, badgeCount)
    })
    .then(() => console.log('Create Push Notification Sent'))
    .catch(() => 'Error sending Create push notification')
})

function sendNotification(message: string, badgeCount: number, token: string) {        
    const payload = {
        notification: {
            body: message,
            badge: badgeCount.toString(),
            sound: 'default'
        }
    }
    admin.messaging().sendToDevice(token, payload)
    .then(() => console.log('Notification Sent'))
    .catch(() => console.log('Error sending notification'))
}

function sendNewNotification(message: string, badgeCount: number, token: string) {
    let payload = {
        notification: {
            body: message
        },
        apns: {
            payload: {
                aps: {
                    content_available: true,
                    badge: badgeCount,
                    sound: 'default'
                }
            }
        },
        token: token
    }
    admin.messaging().send(payload)
    .then(() => console.log('New Notification Sent'))
    .catch()
}

function updateBadgeCount(uid: string, badgeCount: number) {
    admin.firestore().collection('users').doc(uid).update({
        badge_count: badgeCount   
    })
    .then(() => console.log('Badge count updated'))
    .catch(() => 'Error updating badge count')
}