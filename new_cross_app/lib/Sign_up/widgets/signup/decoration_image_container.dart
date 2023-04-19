import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';

///  Decoration Image for the [Sign UP] screen.
class CustomerImageContainer extends StatelessWidget {
  const CustomerImageContainer({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: min(17.5.pw(size), 17.5.ph(size)),
        child: Image.asset("assets/images/family_customer.png"));
  }
}

class TradieImageContainer extends StatelessWidget {
  const TradieImageContainer({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: min(17.5.pw(size), 17.5.ph(size)),
        child: Image.asset("assets/images/plumber.jpg"));
  }
}
