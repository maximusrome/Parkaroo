/* eslint-disable */
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
admin.initializeApp()

const db = admin.firestore()

exports.sendNewSpotNotifications = functions.firestore
.document('pins/{pinId}')
.onCreate(async (snapshot, context) => {
    const pinId = context.params.pinId

    return db.collection('users').where('advanced_notifications', '==', true).get().then((snap) => {
        const docs = snap.docs

        docs.forEach(function (doc) {
            const accountData = doc.data()
            const user = accountData.uid as string
            const token = accountData.token as string
            let badgeCount = accountData.badge_count as number 
            if (pinId != user) {
                badgeCount++
                sendNotification('New parking spot available!', badgeCount, token)
                updateBadgeCount(user, badgeCount)
            }
        })
    }).catch()
})


exports.createNotification = functions.https
    .onCall((data, _context) => {
        const user = data.user
        const message = data.message

        const ref = db.collection('users').doc(user)

       ref.get().then((snap) => {
            const accountData = snap.data()!
            const token = accountData.token as string 
            const basic = accountData.basic_notifications as boolean
            let badgeCount = accountData.badge_count as number 
            if (basic == true) {
                badgeCount++
                sendNotification(message, badgeCount, token)
                updateBadgeCount(user, badgeCount)
            }
        }).catch()
})

function sendNotification(message: string, badgeCount: number, token: string) {
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
    .then(() => console.log('Notification Sent'))
    .catch()
}

function updateBadgeCount(uid: string, badgeCount: number) {
    admin.firestore().collection('users').doc(uid).update({
        badge_count: badgeCount   
    })
    .then(() => console.log('Badge count updated'))
    .catch(() => 'Error updating badge count')
}