import * as admin from 'firebase-admin';
admin.initializeApp();
import * as functions from 'firebase-functions';
const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document('database/{Id}')
    .onCreate(async snapshot => {


        const name = snapshot.get('name');
        const subject = snapshot.get('subject');
 
        // const querySnapshot = await db
        //     .collection('database')
        //     .doc('key')
        //     .collection('tokens')
        //     .get();

        // const tokens = querySnapshot.docs.map(snap => snap.id);

        const token = await db
            .collection('tokens')
            .doc('key').get();

        const key = token.get('token');

        const payload = {
            notification: {
                title: `New message from ${name}`,
                body: ` Subject : ${subject}`,
                // icon: 'your-icon-url',
                // click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return fcm.sendToDevice(key, payload);
    });