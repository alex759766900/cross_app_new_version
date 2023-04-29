const functions = require("firebase-functions");
//const stripe = require("stripe")(functions.config().stripe.testkey);
const stripe = require('stripe')('sk_test_51MxqKoCLNEXP0Gmv34Ixc05ATpLLTkXxK1VmLe4rng6eaiPqiyiDn5iYhaeGA9iZXEdDYIEDZDuTQMMvy4lRKW3J003L5D13iI');

const calculateOrderAmount = (items) => {
  const prices = [];
  const catalog = [
    {"id": "0", "price": 2.99},
    {"id": "1", "price": 3.99},
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
        clientSecret: intent.clientSecret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      return {
        "error": "Your card was denied, please provide a new payment method",
      };
    case "succeeded":
      console.log("Payment succeeded");
      return {clientSecret: intent.clientSecret, status: intent.status};
    default:
      return {error: "Failed"};
  }
};

exports.StripePayEndpointMethodId =
functions.https.onRequest(async (req, res)=>{
  const {paymentMethodId, items, useStripeSdk，currency} = req.body;

  console.log('req.body:  ',req.body);

  // calculate Order Amount
  const orderAmount = calculateOrderAmount(items);
  console.log('orderAmount:  ',orderAmount);

  try {
    if (paymentMethodId) {
      // Create a new PaymentIntent
      const params = {
        amount: orderAmount,
        confirm: true,
        confirmation_method: "manual",
        payment_method: paymentMethodId,
        use_stripe_sdk: useStripeSdk,
        currency：'usd',
      };
      console.log('params:',params)
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


// From chatGPT
//exports.stripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
//  try {
//    const { useStripeSdk, paymentMethodId, currency, items } = req.body;
//    const { amount, description } = items[0];
//    const paymentIntent = await stripe.paymentIntents.create({
//      payment_method: paymentMethodId,
//      amount,
//      currency,
//      description,
//      confirm: useStripeSdk,
//      metadata: {
//        integration_check: 'accept_a_payment',
//      },
//    });
//    res.json({
//      clientSecret: paymentIntent.client_secret,
//      requiresAction: paymentIntent.requires_action,
//    });
//  } catch (err) {
//    res.status(500).json({ error: err.message });
//  }
//});
//
//exports.stripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
//  try {
//    const { paymentIntentId } = req.body;
//    const paymentIntent = await stripe.paymentIntents.confirm(paymentIntentId);
//    res.json(paymentIntent);
//  } catch (err) {
//    res.status(500).json({ error: err.message });
//  }
//});
