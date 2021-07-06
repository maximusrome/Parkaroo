/* eslint-disable */
import * as functions from 'firebase-functions';
import Stripe from "stripe";
import * as admin from 'firebase-admin'
admin.initializeApp()

const db = admin.firestore()

exports.sendNewSpotNotifications = functions.firestore
.document('pins/{pinId}')
.onCreate(async (snapshot, context) => {
    const pinId = context.params.pinId

    return db.collection('users').where('basic_notifications', '==', true).get().then((snap) => {
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

const secretKey = functions.config().stripe.secret;
const stripe = new Stripe(secretKey, {apiVersion: "2020-08-27"});

// eslint-disable-next-line max-len
exports.preparePaymentSheet = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError("failed-precondition", "The function must be called while authenticated");
  }
  const auth = context.auth;
  const userEmail = auth?.token.email;
  if (userEmail === null) {
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError("failed-precondition", "The function must be called while authenticated");
  }
  const userId = auth?.token.uid;
  if (userId === null) {
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError("failed-precondition", "The function must be called while authenticated");
  }
  const customerId = await getOrCreateCustomer(userEmail, userId);
  // eslint-disable-next-line max-len
  if (!customerId) throw new functions.https.HttpsError("failed-precondition", "Stripe Customer not found nor created");
  const ephemeralKey = await stripe.ephemeralKeys.create({
    customer: customerId,
  }, {apiVersion: "2020-08-27"});
  const paymentIntent = await stripe.paymentIntents.create({
    amount: 999,
    currency: "usd",
    customer: customerId,
  });

  return {
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customerId,
  };
});

/**
 * Given an email and userId, returns a existing
 * Stripe customer id or creates a new one
 * @param {String} email
 * @param {String} userId
 */
async function getOrCreateCustomer(email?: string, userId?: string) {
  if (email && userId) {
    // eslint-disable-next-line max-len
    const snapshot = await admin.firestore().collection("stripe_customers").doc(userId).get();
    // eslint-disable-next-line camelcase
    const customerId = snapshot.data()?.customer_id;
    if (customerId == null) {
      const newCustomer = await stripe.customers.create({email: email});
      // eslint-disable-next-line max-len
      await admin.firestore().collection("stripe_customers").doc(userId).set({customer_id: newCustomer.id});
      return newCustomer.id;
    } else {
      return customerId;
    }
  } else {
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError("failed-precondition", "The function must be called while authenticated");
  }
}
