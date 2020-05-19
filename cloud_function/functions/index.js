let functions = require('firebase-functions');
let admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const fcm = admin.messaging();


//5ezinrAZzBYO1F0YqhnM --7-done
//Cm21bRWWHfn6n4CpXAK6 --3-done
//Etch9JmLgPhraaKEZeW1 --1-done
//PwW0oMsgz6U2ynAByctx --4-done
//p0TeEFc1ARdsd0k8TWLT --6-done
//vd7wohcc0jeklkt0xIQ1 --5-done
//yDQoO1UlU47IGHs0RPyE --2-done


exports.createRestaurant_1 = functions.firestore
      .document('order_Etch9JmLgPhraaKEZeW1/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('Etch9JmLgPhraaKEZeW1', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_1 = functions.firestore
      .document('order_Etch9JmLgPhraaKEZeW1/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });


exports.createRestaurant_2 = functions.firestore
      .document('order_yDQoO1UlU47IGHs0RPyE/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('yDQoO1UlU47IGHs0RPyE', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_2 = functions.firestore
      .document('order_yDQoO1UlU47IGHs0RPyE/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });


exports.createRestaurant_3 = functions.firestore
      .document('order_Cm21bRWWHfn6n4CpXAK6/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('Cm21bRWWHfn6n4CpXAK6', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_3 = functions.firestore
      .document('order_Cm21bRWWHfn6n4CpXAK6/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });


exports.createRestaurant_4 = functions.firestore
      .document('order_PwW0oMsgz6U2ynAByctx/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('PwW0oMsgz6U2ynAByctx', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_4 = functions.firestore
      .document('order_PwW0oMsgz6U2ynAByctx/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });

exports.createRestaurant_5 = functions.firestore
      .document('order_vd7wohcc0jeklkt0xIQ1/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('vd7wohcc0jeklkt0xIQ1', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_5 = functions.firestore
      .document('order_vd7wohcc0jeklkt0xIQ1/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });

exports.createRestaurant_6 = functions.firestore
      .document('order_p0TeEFc1ARdsd0k8TWLT/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('p0TeEFc1ARdsd0k8TWLT', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_6 = functions.firestore
      .document('order_p0TeEFc1ARdsd0k8TWLT/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });

exports.createRestaurant_7 = functions.firestore
      .document('order_5ezinrAZzBYO1F0YqhnM/{orderId}')
      .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const order = snap.data();

        // access a particular field as you would any JS property
        const total = order.total;

        let payload = {
            notification: {
                title: 'You have a new order',
                body: "Total: $"+total,
                sound: 'default',
                badge: '1'
            }
        };

        return admin.messaging().sendToTopic('5ezinrAZzBYO1F0YqhnM', payload);

        // perform desired operations ...
      });

exports.updateRestaurant_7 = functions.firestore
      .document('order_5ezinrAZzBYO1F0YqhnM/{orderId}')
      .onUpdate((change, context) => {
            // Get an object representing the document
            // e.g. {'name': 'Marie', 'age': 66}
            const newOrder = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
            const status_text = newOrder.status_text;

            console.log("==========id===========");
            console.log(newOrder.order_id);

            let payload = {
                notification: {
                    title: newOrder.restaurant_name,
                    body: status_text,
                    sound: 'default',
                    badge: '1'
                }
            };

            return admin.messaging().sendToTopic(newOrder.order_id, payload);


            // perform desired operations ...
          });
