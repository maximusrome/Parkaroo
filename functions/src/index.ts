import * as functions from "firebase-functions";
import Stripe from "stripe";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();

exports.sendNewSpotNotifications = functions.firestore
    .document("pins/{pinId}")
    .onCreate(async (snapshot, context) => {
      const pinId = context.params.pinId;

      // eslint-disable-next-line max-len
      const querySnapshot = await db.collection("users").where("basic_notifications", "==", true).get();
      if (!querySnapshot.empty) {
        console.log(`We got ${querySnapshot.size} users`);
        for (const userDocument of querySnapshot.docs) {
          const userData = userDocument.data();
          const userId = userData.uid as string;
          const notificationToken = userData.token as string;
          let badgeCount = userData.badge_count as number;
          if (pinId != userId && notificationToken) {
            badgeCount ++;
            // eslint-disable-next-line max-len
            await sendN("New parking spot available!", badgeCount, notificationToken);
            await updateBadgeCount(userId, badgeCount);
          } else {
            // eslint-disable-next-line max-len
            console.log(`Notification token is null or undefined for user with uid: ${userId}`);
          }
        }
      } else {
        console.log("We didn't get any users to send the notifications");
      }
    });


exports.createNotification = functions.https
    .onCall(async (data, _context) => {
      const user = data.user;
      const message = data.message;

      const ref = db.collection("users").doc(user);

      const snap = await ref.get();
      if (snap.exists) {
        const accountData = snap.data();
        if (accountData == null) {
          // eslint-disable-next-line max-len
          throw new functions.https.HttpsError("failed-precondition", `Cannot find user with uid: ${user}`);
        }
        // Now we are sure there is a value in account data, we get the values
        const token = accountData.token as string;
        const basic = accountData.basic_notifications as boolean;
        let badgeCount = accountData.badge_count as number;
        if (basic && token) {
          badgeCount++;
          await sendN(message, badgeCount, token);
          await updateBadgeCount(user, badgeCount);
        } else {
          // eslint-disable-next-line max-len
          console.log(`Cannot send notification. Notification token doesn't exists for the user with uid: ${user}`);
        }
      }
    });

/**
 * Send Push Notification using the given APNs token
 * @param {String} message
 * @param {number} badgeCount
 * @param {String} token
 */
async function sendN(message: string, badgeCount: number, token: string) {
  try {
    const payload = {
      notification: {
        body: message,
      },
      apns: {
        payload: {
          aps: {
            badge: badgeCount,
            sound: "default",
          },
        },
      },
      token: token,
    };
    await admin.messaging().send(payload);
    console.log("Notification Sent");
  } catch (error) {
    console.error(`Something went wrong: ${error}`);
  }
}

/**
 * Send Push Notification using the given APNs token
 * @param {String} uid
 * @param {number} badgeCount
 */
async function updateBadgeCount(uid: string, badgeCount: number) {
  await admin.firestore().collection("users").doc(uid).update({
    badge_count: badgeCount,
  });
  console.log("Badge count updated");
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
  if (userEmail == null) {
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError("failed-precondition", "The function must be called while authenticated");
  }
  const userId = auth?.token.uid;
  if (userId == null) {
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
    amount: 899,
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
