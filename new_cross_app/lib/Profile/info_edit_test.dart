import 'package:flutter/material.dart';

class InfoEditTest extends StatefulWidget {
  const InfoEditTest({Key? key,}) : super(key: key);

  @override
  State<InfoEditTest> createState() => _InfoEditTestState();
}

class _InfoEditTestState extends State<InfoEditTest> {


  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black54)),
      ),
      body:Column(
        children: [
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Enter your text',
            ),
            onChanged: (text) {
              print('You entered $text');
            },
          )
        ],
      )
    );
  }
}
