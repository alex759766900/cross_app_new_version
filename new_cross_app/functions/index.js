/*
 1. Customer transfer to Jemma
*/
const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);
// const stripe = require('stripe')(functions.config().stripe.secret_key);

const calculateOrderAmount = (items) => {
  const prices = []; // Add 'let' before variable declaration
  const catalog = [ // Add 'let' before variable declaration
    {"id": "0", "price": 20},
    {"id": "1", "price": 20},
    {"id": "2", "price": 4.99},
    {"id": "3", "price": 5.99},
    {"id": "4", "price": 6.99},
  ];

  items.forEach((item) =>{
    const price = catalog.find((x) => x.id == item.id).price;
    prices.push(price);
  });

  return parseInt(prices.reduce((a, b) => a + b) * 100);
};

const generateResponse = function(intent) {
  switch (intent.status) {
    case "requires_action":
      return {
        clientSecret: intent.client_secret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      return {
        "error": "Your card was denied, please provide a new payment method",
      };
    case "succeeded":
      console.log("Payment succeeded");
      return {clientSecret: intent.client_secret, status: intent.status};
    default:
      return {error: "Failed"};
  }
};

exports.StripePayEndpointMethodId =
functions.https.onRequest(async (req, res)=>{
  const {useStripeSdk, paymentMethodId, currency, items} = req.body;
  // calculate Order Amount
  const orderAmount = calculateOrderAmount(items);

  try {
    if (paymentMethodId) {
      // Create a new PaymentIntent
      const params = {
        amount: orderAmount,
        confirm: true,
        confirmation_method: "manual",
        payment_method: paymentMethodId,
        currency: currency,
        use_stripe_sdk: useStripeSdk,
      };
      // Create a intent object
      const intent = await stripe.paymentIntents.create(params);

      console.log(`Intent: ${intent}`);

      return res.send(generateResponse(intent));

    }
    return res.sendStatus(400);
  } catch (e) {
    return res.send({error: e.message});
  }
});


exports.StripePayEndpointIntentId =
functions.https.onRequest(async (req, res)=>{
  const {paymentIntentId} = req.body;

  try {
    if (paymentIntentId) {
      // Create a intent object
      const intent = await stripe.paymentIntents.confirm(paymentIntentId);
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400);
  } catch (e) {
    return res.send({error: e.message});
  }
});

exports.StripeTransfer=
functions.https.onRequest(async(req, res)=>{
    const {destination_id, amount} = req.body;

    try{
        const params = {
            amount: amount,
            currency: 'aud',
            destination: destination_id,
        }
        const transfer = await stripe.transfers.create(params);
        return res.send(transfer);
    } catch (e) {
        return res.send({error: e.message});
    }
});

/*
 2. Jemma transfer to Tradie
*/
exports.StripeConnectTransfer =
functions.https.onRequest(async (req, res) => {
  const {destination_id, amount} = req.body;
  // TODO：check the status of booking
  try {
    const params = {
      amount: amount,
      currency: 'usd',
      destination: destination_id,
    };
    // TODO：change to tradie's Stripe account
    const transfer = await stripe.transfers.create(params);

    return res.send(transfer);
  } catch (e) {
    return res.send({error: e.message});
  }
});


//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//admin.initializeApp();
//
//// const stripe = require('stripe')('sk_test_51MxqKoCLNEXP0Gmv34Ixc05ATpLLTkXxK1VmLe4rng6eaiPqiyiDn5iYhaeGA9iZXEdDYIEDZDuTQMMvy4lRKW3J003L5D13iI');
//
//exports.createPayment = functions.https.onCall(async (data, context) => {
//  // check if the user login
//  if (!context.auth) {
//    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//  }
//
//  const paymentMethodId = data.paymentMethodId;
//  const destinationAccountId = data.destinationAccountId;
//
//  try {
//    const paymentIntent = await stripe.paymentIntents.create({
//      payment_method: paymentMethodId,
//      amount: 1000, // Amount in cents
//      currency: 'usd',
//      confirmation_method: 'manual',
//      confirm: true,
//      application_fee_amount: 100, // Application fee in cents
//      transfer_data: {
//        destination: destinationAccountId,
//      },
//    });
//
//    return {status: 'success'};
//  } catch (error) {
//    console.error(error);
//    throw new functions.https.HttpsError('internal', 'Failed to create the payment: ' + error.message);
//  }
//});
