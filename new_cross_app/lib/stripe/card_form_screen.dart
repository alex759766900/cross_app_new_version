import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// 不要了
class CardFormScreen extends StatelessWidget {
  const CardFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with a Credit Card')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Card Form', style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 20),
            // credit card form
            CardFormField(controller: CardFormEditController()),
            const SizedBox(height: 10),
            // pay button
            ElevatedButton(
                onPressed: () {},
                child: Text('Pay',
                    style: TextStyle(fontSize: 10.0, color: Colors.green))),
          ],
        ),
      ),
    );
  }
}
