import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Connect Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stripe Connect Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              createStripeConnectAccount();
             // _launchURL('https://connect.stripe.com/setup/e/acct_1NfynCCT7aBGEMcn/j2KEJQWxJUKX');
            },
            child: const Text('Stripe Connect Onboarding'),
          ),
        ),
      ),
    );
  }

  Future<void> createStripeConnectAccount() async {
    http.get(
      Uri.parse('https://us-central1-jemma-b0fcd.cloudfunctions.net/createConnectAccount'),
    ).then((response){
      if (response.statusCode == 200) {
        print('请求成功：${response.body}');
        _launchURL(response.body.trim());
      } else {
        print('请求失败：${response.statusCode}');
      }
    }).catchError((error){
      print(error.toString());
    });
  }
}
void _launchURL(String url) async{
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'could not open $url';
  }
}