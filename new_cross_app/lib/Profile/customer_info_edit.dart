import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Home%20Page/responsive.dart';
import '../Home Page/constants.dart';
import '../services/auth_service.dart';


class CustomerInfoEdit extends StatefulWidget {
  final String userID;
  CustomerInfoEdit({required this.userID});

  @override
  _CustomerInfoEditState createState() => _CustomerInfoEditState();
}

final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('customers');

class _CustomerInfoEditState extends State<CustomerInfoEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    DocumentSnapshot docSnapshot = await colRef.doc(widget.userID).get();
    Map<String, dynamic> values = docSnapshot.data() as Map<String, dynamic>;

    if (values != null) {
      nameController.text = values['fullName'] ?? '';
      phoneController.text = values['Phone'] ?? '';
      passwordController.text = '';
      addressController.text = values['address'] ?? '';
    }
  }

  _updateData() async {
    String name = nameController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String address = addressController.text;

    Map<String, String> updatedInfo = {
      'fullName': name,
      'Phone': phone,
      'address': address,
    };

    // update fullName, phone and address
    try {
      await colRef.doc(widget.userID).update(updatedInfo);
    } catch (e) {
      print("Error updating document: $e");
    }

    // update password
    if (password != '') {
      bool result = await AuthService().updatePassword(password);
      if (result) {
        print("Password updated successfully");
      } else {
        print("Failed to update password");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            attributeEdit(size,nameController,'name','Put your new name here'),
            SizedBox(height: 2.5.ph(size)),

            attributeEdit(size,phoneController,'phone','Put your new phone number here'),
            SizedBox(height: 2.5.ph(size)),

            attributeEdit(size,passwordController,'password','Put your new password here'),
            SizedBox(height: 2.5.ph(size)),

            attributeEdit(size,addressController,'address','Put your new address here'),
            SizedBox(height: 2.5.ph(size)),

            ElevatedButton(
              onPressed: () async {
                await _updateData();
                Navigator.pop(context, 'update');  // 返回到前一个页面，并传递参数，表示信息有更新
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  // Each input text field
  Container attributeEdit(Size size, TextEditingController controller, String labelText, String hintText) {
    return Container(
            width: 50.pw(size),
            constraints: const BoxConstraints(minWidth: 400),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: kLogoColor, width: 1.0),
                ),
              ),
            ),
          );
  }
}
