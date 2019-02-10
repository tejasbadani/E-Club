// Import the Firebase SDK for Google Cloud Functions.
const functions = require('firebase-functions');
// Import and initialize the Firebase Admin SDK.
const admin = require('firebase-admin');
admin.initializeApp();
// exports.newMessage = functions.firestore.document('evoice/{evoiceID}').onCreate((snap, context) => {

//     const messageDetails = snap.data();
//     const message = messageDetails['message'];
// });
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
exports.newMessage = functions.firestore.document('evoice/{messageId}').onCreate(
    async (snapshot: any) => {
        // Notification details.
        const text = snapshot.data().message;
        const username = snapshot.data().username;
        const payload = {
            notification: {
                title: username,
                body: text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
                icon: snapshot.data().profileURL || '/images/boy.png',
                sound: 'default',
                click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
            }
        };

        // Get the list of device tokens.
        const allTokens = await admin.firestore().collection('tokens').get();
        const tokens: string[] = [];
        allTokens.forEach((tokenDoc: any) => {
            tokens.push(tokenDoc.id);
        });

        if (tokens.length > 0) {
            // Send notifications to all tokens.
            const response = await admin.messaging().sendToDevice(tokens, payload);
            await cleanupTokens(response, tokens);
            console.log('Notifications have been sent and tokens cleaned up.');
        }
    });
function cleanupTokens(response: any, tokens: any) {
    // For each notification we check if there was an error.
    const tokensDelete: any = [];
    response.results.forEach((result: any, index: any) => {
        const error = result.error;
        if (error) {
            console.error('Failure sending notification to', tokens[index], error);
            // Cleanup the tokens who are not registered anymore.
            if (error.code === 'messaging/invalid-registration-token' ||
                error.code === 'messaging/registration-token-not-registered') {
                const deleteTask = admin.firestore().collection('messages').doc(tokens[index]).delete();
                tokensDelete.push(deleteTask);
            }
        }
    });
    return Promise.all(tokensDelete);
}