import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

/* Address Object */
class Address {
  final TextEditingController address_line_one = TextEditingController(),
      address_line_two = TextEditingController(),
      suburb = TextEditingController(),
      postcode = TextEditingController();
  String? state;
}

class AddressDetails extends StatefulWidget {
  final Address address;

  const AddressDetails({Key? key, required this.address}) : super(key: key);

  @override
  State<AddressDetails> createState() => AddressDetailsState();
}

class AddressDetailsState extends State<AddressDetails> {
  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 10,
            children: <Container>[
              /* Address line one */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: widget.address.address_line_one,
                      validator: (String? value) {
                        if ((value == null) || (value.isEmpty)) {
                          return null;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Address line one",
                          hintText: "Enter your address line one.",
                          labelStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.edit_road),
                          border: OutlineInputBorder()))),

              /* Address line two */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: widget.address.address_line_two,
                      validator: (String? value) {
                        if ((value == null) || (value.isEmpty)) {
                          return null;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Address line two",
                          hintText: "Enter your address line two.",
                          labelStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.edit_road),
                          border: OutlineInputBorder()))),

              /* Suburb name */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: widget.address.suburb,
                      validator: (String? value) {
                        if ((value == null) || (value.isEmpty)) {
                          return null;
                        } else if (!isAlpha(value)) {
                          return "The value should only have alphabets.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Suburb name",
                          hintText: "Enter your Suburb name.",
                          labelStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder()))),

              /* State name */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: DropdownButton(
                    value: widget.address.state,
                    isExpanded: true,
                    onChanged: (value) => setState(() {
                      widget.address.state = value.toString();
                    }),
                    underline: const SizedBox(),
                    hint: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Row(children: const <Expanded>[
                          Expanded(flex: 2, child: Icon(Icons.location_on)),
                          Expanded(
                              flex: 8,
                              child: Text("State",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14)))
                        ])),
                    items: <String>[
                      "ACT",
                      "NSW",
                      "QLD",
                      "VIC",
                      "NT",
                      "WA",
                      "SA",
                      "TAS"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Row(children: <Expanded>[
                            const Expanded(
                                flex: 2, child: Icon(Icons.location_on)),
                            Expanded(
                                flex: 8,
                                child: Text(value,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 14)))
                          ]));
                    }).toList(),
                  )),

              /* Postcode number */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: widget.address.postcode,
                      maxLength: 4,
                      validator: (String? value) {
                        if ((value == null) || (value.isEmpty)) {
                          return null;
                        } else if (!isNumeric(value)) {
                          return "The value should only have numbers.";
                        } else if (value.length != 4) {
                          return "The value should contain 4 numbers.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Postcode number",
                          hintText: "Enter your Postcode number.",
                          labelStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.local_post_office),
                          border: OutlineInputBorder())))
            ]));
  }
}
