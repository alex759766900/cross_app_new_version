import 'dart:convert';
import 'dart:math';
import 'dart:js' as js;
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/models/user.dart';
import 'package:new_cross_app/Login/providers/login.dart';
import 'package:new_cross_app/Login/repository.dart';

//import 'package:jemma/routes.dart';
import 'package:new_cross_app/Login/utils/adaptive.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Login/utils/notification.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/account_details.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/address_details.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/bank_details.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/card_details.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/company_details.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/decoration_image_container.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/personal_details.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/tradesperson_profile_details.dart';
import 'package:provider/provider.dart';

import '../Login/login.dart';
import '../main.dart';

enum SignupOf { customer, tradesperson }

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100.ph(size)),
                child: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Form(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                    /* Title */
                    ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 30.ph(size)),
                        child: const Center(
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text("Sign up",
                                    style: TextStyle(fontSize: 50))))),

                    /* Header */
                    ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 10.ph(size)),
                        child: const Text(
                            "In which way would you like to use Jemma?",
                            style: TextStyle(fontSize: 15))),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /* Customer Icon */
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupStage2(
                                                signupOf: SignupOf.customer)));
                              },
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                        width:
                                            min(17.5.pw(size), 17.5.ph(size)),
                                        child: Icon(
                                            Icons.account_circle_outlined,
                                            size: 7.pw(size))),
                                    SizedBox(height: 1.pw(size)),
                                    const Text("Customer",
                                        style: TextStyle(fontSize: 15))
                                  ])),
                          SizedBox(width: 15.pw(size)),

                          /* Tradesperson Icon */
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupStage2(
                                                signupOf:
                                                    SignupOf.tradesperson)));
                              },
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                        width:
                                            min(17.5.pw(size), 17.5.ph(size)),
                                        child: Icon(
                                            Icons.account_circle_outlined,
                                            size: 7.pw(size))),
                                    SizedBox(height: 1.pw(size)),
                                    const Text("Tradesperson",
                                        style: TextStyle(fontSize: 15))
                                  ]))
                        ])
                  ]))),

                  /* Decoration Image */
                  Positioned.fill(
                      child: Align(
                          alignment: const Alignment(0.7, 1),
                          child: DecorationImageContainer(size: size)))
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        /*floatingActionButton: isWeb()
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black87)));*/
        // TODO: Need to discuss with other guys on this.
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
            child: const Icon(Icons.arrow_back, color: Colors.black87)));
  }
}

class SignupStage2 extends StatefulWidget {
  final SignupOf signupOf;

  const SignupStage2({Key? key, required this.signupOf}) : super(key: key);

  @override
  State<SignupStage2> createState() => SignupStage2State();
}

class SignupStage2State extends State<SignupStage2> {
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  /*
    NOTE: This manual validation had to stored due to the `formKeyValid`
    function not returning the actual validation when the relevant `Step` is not
    active.
  */
  final List<bool> validations = [false, false, false, false];

  final TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      /* Personal Details */
      firstName = TextEditingController(),
      lastName = TextEditingController(),
      phone = TextEditingController(),
      /* Customer */
      cardName = TextEditingController(),
      cardNumber = TextEditingController(),
      cardValidDate = TextEditingController(),
      cardCVV = TextEditingController(),
      /* Tradesperson */
      companyName = TextEditingController(),
      companyABN = TextEditingController(),
      bankName = TextEditingController(),
      bankNumber = TextEditingController(),
      bankBSB = TextEditingController(),
      travelDistance = TextEditingController();

  final Address primaryAddress = Address(), secondaryAddress = Address();

  /* Stepper Controllers */
  int index = 0;
  bool newIndexInRange(int i) {
    return (i >= 0) && (i <= ((widget.signupOf == SignupOf.customer) ? 2 : 3));
  }

  bool indexIsLast() {
    return index == ((widget.signupOf == SignupOf.customer) ? 2 : 3);
  }

  /* Form Stages Validator */
  bool formKeyValid(int i) {
    if (!newIndexInRange(i)) return false;
    if (formKeys[i].currentState == null) return false;
    return formKeys[i].currentState!.validate();
  }

  bool submit_ALLOW = true;
  void submit() {
    // debugPrint("${!this.validations[0]} | ${!this.validations[1]} | ${!this.validations[2]} | ${!this.validations[3]}");

    if (!submit_ALLOW ||
        !validations[0] ||
        !validations[1] ||
        !validations[2] ||
        ((widget.signupOf == SignupOf.tradesperson) && !validations[3])) return;
    submit_ALLOW = false;

    /*
      POST Data Builder
    */
    Map<String, dynamic> data = {};
    data["user_type"] =
        (widget.signupOf == SignupOf.customer) ? "CUSTOMER" : "TRADIE";
    /* Account details */
    data["email"] = email.text;
    data["password"] = password.text;
    /* Personal details */
    if (firstName.text.isNotEmpty) {
      data["first_name"] = firstName.text;
    }
    if (lastName.text.isNotEmpty) data["last_name"] = lastName.text;
    if (phone.text.isNotEmpty) {
      data["phone_number"] = int.parse(phone.text);
    }
    /* Address details */
    data["address_data"] = {"a1": {}};
    if (primaryAddress.address_line_one.text.isNotEmpty) {
      data["address_data"]["a1"]["address_line_one"] =
          int.parse(primaryAddress.address_line_one.text);
    }
    if (primaryAddress.address_line_two.text.isNotEmpty) {
      data["address_data"]["a1"]["address_line_two"] =
          int.parse(primaryAddress.address_line_two.text);
    }
    if (primaryAddress.suburb.text.isNotEmpty) {
      data["address_data"]["a1"]["suburb"] =
          int.parse(primaryAddress.suburb.text);
    }
    if ((primaryAddress.state != null) && (primaryAddress.state!.isNotEmpty)) {
      data["address_data"]["a1"]["state"] = int.parse(primaryAddress.state!);
    }
    if (primaryAddress.postcode.text.isNotEmpty) {
      data["address_data"]["a1"]["postal_code"] =
          int.parse(primaryAddress.postcode.text);
    }
    if (data["address_data"]["a1"].isEmpty) data["address_data"].remove("a1");

    data["address_data"]["a2"] = {};
    if (secondaryAddress.address_line_one.text.isNotEmpty) {
      data["address_data"]["a2"]["address_line_one"] =
          int.parse(secondaryAddress.address_line_one.text);
    }
    if (secondaryAddress.address_line_two.text.isNotEmpty) {
      data["address_data"]["a2"]["address_line_two"] =
          int.parse(secondaryAddress.address_line_two.text);
    }
    if (secondaryAddress.suburb.text.isNotEmpty) {
      data["address_data"]["a2"]["suburb"] =
          int.parse(secondaryAddress.suburb.text);
    }
    if ((secondaryAddress.state != null) &&
        (secondaryAddress.state!.isNotEmpty)) {
      data["address_data"]["a2"]["state"] = int.parse(secondaryAddress.state!);
    }
    if (secondaryAddress.postcode.text.isNotEmpty) {
      data["address_data"]["a2"]["postal_code"] =
          int.parse(secondaryAddress.postcode.text);
    }
    if (data["address_data"]["a2"].isEmpty) data["address_data"].remove("a2");

    if (data["address_data"].isEmpty) data.remove("address_data");

    if (widget.signupOf == SignupOf.customer) {
      /* Payment details */
      if (cardName.text.isNotEmpty) {
        data["bank_card_holder"] = cardName.text;
      }
      if (cardNumber.text.isNotEmpty) {
        data["bank_card_number"] = int.parse(cardNumber.text);
      }
      if (cardValidDate.text.isNotEmpty) {
        data["bank_card_expiry_date"] = int.parse(cardValidDate.text);
      }
      if (cardCVV.text.isNotEmpty) {
        data["bank_card_cvv"] = int.parse(cardCVV.text);
      }
    } else if (widget.signupOf == SignupOf.tradesperson) {
      /* Company details */
      data["company_name"] = companyName.text;
      data["australian_business_number"] = int.parse(companyABN.text);
      /* Payment details */
      if (bankName.text.isNotEmpty) {
        data["bank_account_name"] = bankName.text;
      }
      if (bankNumber.text.isNotEmpty) {
        data["bank_account_number"] = int.parse(bankNumber.text);
      }
      if (bankBSB.text.isNotEmpty) {
        data["bank_state_branch"] = int.parse(bankBSB.text);
      }
      /* Tradesperson profile details */
      if (travelDistance.text.isNotEmpty) {
        data["travel_distance"] = int.parse(travelDistance.text);
      }
    }

    debugPrint("\n${jsonEncode(data)}\n");

    /* Submit request and show progress */
    showNotification(context, "Submitting", NotificationType.info);

    // TODO: the url below should be tested
    post(Uri.parse("http://localhost:8000/signup/"),
        body: jsonEncode(data),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        }).then((Response value) {
      /* Request Success */
      debugPrint("\nThen: ${value.body}\n");
      var response = json.decode(value.body);
      if (response.containsKey("id")) {
        /*showNotification(context, "Account created", NotificationType.success, duration: Duration(seconds: 3))
            .closed
            .then((_) => Navigator.pop(context));*/
        showNotification(context, "Account created", NotificationType.success,
            duration: const Duration(seconds: 3));

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => LoginNotifier(), child: Login())));

        if (response.containsKey("onboarding")) {
          // If user is TRADIE, redirect to Stripe onboarding
          js.context.callMethod('open', [response["onboarding"]]);
        }
      } else {
        showNotification(context, "Failed signing up", NotificationType.error,
            duration: const Duration(seconds: 3));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => LoginNotifier(), child: Login())));
      }
    }).catchError((x) {
      /* Request Failed */
      debugPrint("\nError: ${x.toString()}\n");
      showNotification(context, "Failed signing up", NotificationType.error,
          duration: const Duration(seconds: 3));
      // fix the navigator, should back to sign up page
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    }).whenComplete(() {
      submit_ALLOW = true;
    });
  }

  // TODO: To make the user log in automatically after sign up
  void autoLogin(String username, String password, Client client) async {
    final url = Uri.parse("${Repository.baseUrl}/login/");
    await client
        .post(url,
            headers: {"Content-type": "application/json"},
            body: jsonEncode({"username": username, "password": password}))
        .then((response) {
      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        Repository().user.value = user;
        Hive.box(Repository.hiveEncryptedBoxName).put("user", user);
      }
    });
  }

  @override
  Scaffold build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100.ph(size)),
                child: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: <
                          ConstrainedBox>[
                    /* Title */
                    ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 18.ph(size)),
                        child: Center(
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Column(children: <Widget>[
                                  const Text("Sign up",
                                      style: TextStyle(fontSize: 50)),
                                  SizedBox(height: max(2.ph(size), 10)),
                                  Text(
                                      (widget.signupOf == SignupOf.customer
                                          ? "Customer"
                                          : "Tradesperson"),
                                      style: const TextStyle(fontSize: 20))
                                ])))),
                    ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: 700.0, width: 150.ph(size)),
                        child: Stepper(
                            type: StepperType.horizontal,
                            currentStep: index,
                            onStepTapped: (int index) {
                              setState(() {
                                this.index = index;
                              });
                            },
                            controlsBuilder: (BuildContext context,
                                ControlsDetails details) {
                              // {VoidCallback? onStepContinue,
                              // VoidCallback? onStepCancel}) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kLogoColor,
                                            elevation: 1),
                                        icon: const Icon(Icons.navigate_before,
                                            color: Colors.black, size: 50),
                                        onPressed: () {
                                          if (index > 0) {
                                            setState(() {
                                              index--;
                                            });
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Signup()));
                                          }
                                        },
                                        label: const Text("Previous",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25))),
                                    SizedBox(width: 5.ph(size)),
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kLogoColor,
                                            elevation: 1),
                                        icon: Icon(
                                            (indexIsLast()
                                                ? Icons.done
                                                : Icons.navigate_next),
                                            color: Colors.black,
                                            size: 50),
                                        onPressed: () {
                                          validations[index] =
                                              formKeyValid(index);
                                          if (!validations[index]) {
                                            showNotification(
                                                context,
                                                "Please properly fill the fields",
                                                NotificationType.error);
                                            return;
                                          }
                                          if (indexIsLast()) {
                                            submit();
                                          } else if (newIndexInRange(
                                              index + 1)) {
                                            setState(() {
                                              index++;
                                            });
                                          }
                                        },
                                        label: Text(
                                            (indexIsLast()
                                                ? (submit_ALLOW
                                                    ? "Submit"
                                                    : "Submitting...")
                                                : "Continue"),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25)))
                                  ]);
                            },
                            steps: <Step>[
                              Step(
                                  title: const Text(''),
                                  isActive: index == 0,
                                  state: !validations[0]
                                      ? StepState.editing
                                      : StepState.complete,
                                  content: Form(
                                      key: formKeys[0],
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <ConstrainedBox>[
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: 20.ph(size),
                                                    maxWidth: 1000),
                                                child:
                                                    Column(children: <Widget>[
                                                  /* Account Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: const Text(
                                                          "Account details",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  const Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  AccountDetails(
                                                      email: email,
                                                      password: password),

                                                  /* Personal Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          "Personal details ${widget.signupOf == SignupOf.customer ? "(Optional)" : ""}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      25))),
                                                  const Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  PersonalDetails(
                                                      signupOf: widget.signupOf,
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      phone: phone)
                                                ]))
                                          ]))),
                              Step(
                                  title: const Text(''),
                                  isActive: index == 1,
                                  state: !validations[1]
                                      ? StepState.editing
                                      : StepState.complete,
                                  content: Form(
                                      key: formKeys[1],
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <ConstrainedBox>[
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: 20.ph(size),
                                                    maxWidth: 1000),
                                                child: Center(
                                                    child: Column(children: <
                                                        Widget>[
                                                  /* Primary Address Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: const Text(
                                                          "Primary address details (Optional)",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  const Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  AddressDetails(
                                                      address: primaryAddress),

                                                  /* Secondary Address Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: const Text(
                                                          "Secondary address details (Optional)",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  const Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  AddressDetails(
                                                      address:
                                                          secondaryAddress),
                                                  SizedBox(
                                                      height:
                                                          max(5.ph(size), 10))
                                                ])))
                                          ]))),
                              Step(
                                  title: const Text(''),
                                  isActive: index == 2,
                                  state: !validations[2]
                                      ? StepState.editing
                                      : StepState.complete,
                                  content: Form(
                                      key: formKeys[2],
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <ConstrainedBox>[
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: 20.ph(size),
                                                    maxWidth: 1000),
                                                child: Center(
                                                    child: Column(children: <
                                                        Widget>[
                                                  if (widget.signupOf ==
                                                      SignupOf.customer) ...[
                                                    /* Payment Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const Text(
                                                            "Payment details (Optional)",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    const Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    CardDetails(
                                                        cardName: cardName,
                                                        cardNumber: cardNumber,
                                                        cardValidDate:
                                                            cardValidDate,
                                                        cardCVV: cardCVV)
                                                  ] else ...[
                                                    /* Company Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const Text(
                                                            "Company details",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    const Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    CompanyDetails(
                                                        companyName:
                                                            companyName,
                                                        companyABN: companyABN),

                                                    /* Payment Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const Text(
                                                            "Payment details (Optional)",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    const Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    BankDetails(
                                                        bankName: bankName,
                                                        bankNumber: bankNumber,
                                                        bankBSB: bankBSB)
                                                  ],
                                                  SizedBox(
                                                      height:
                                                          max(5.ph(size), 10))
                                                ])))
                                          ]))),
                              if (widget.signupOf == SignupOf.tradesperson)
                                (Step(
                                    title: const Text(''),
                                    isActive: index == 3,
                                    state: !validations[3]
                                        ? StepState.editing
                                        : StepState.complete,
                                    content: Form(
                                        key: formKeys[3],
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <ConstrainedBox>[
                                              ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      minHeight: 20.ph(size),
                                                      maxWidth: 1000),
                                                  child: Center(
                                                      child: Column(children: <
                                                          Widget>[
                                                    /* Tradesperson Profile Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const Text(
                                                            "Tradesperson profile details (Optional)",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    const Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    TradespersonProfileDetails(
                                                        travelDistance:
                                                            travelDistance),
                                                    SizedBox(
                                                        height:
                                                            max(5.ph(size), 10))
                                                  ])))
                                            ]))))
                            ]))
                  ])),

                  /* Decoration Image */
                  Positioned.fill(
                      child: Align(
                          alignment: const Alignment(0.7, 1),
                          child: DecorationImageContainer(size: size)))
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: isWeb()
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black87)));
  }
}
