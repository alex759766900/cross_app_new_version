import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_cross_app/stripe/components/card_type.dart';
import 'package:new_cross_app/stripe/components/card_utilis.dart';
import 'package:new_cross_app/stripe/constains.dart';
import 'components/input_formatters.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  TextEditingController cardNumberCotroller = TextEditingController();

  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNum() {
    // With in first 6 digits we can identify the tpye
    if (cardNumberCotroller.text.length <= 6) {
      String cardNum = CardUtils.getCleanedNumber(cardNumberCotroller.text);

      CardType type = CardUtils.getCardTypeFrmNumber(cardNum);

      if (type != cardType) {
        setState(() {
          cardType = type;
          //restart the app
          // print(cardType);
        });
      }
    }
  }

  @override
  void initState() {
    cardNumberCotroller.addListener(
      () {
        getCardTypeFrmNum();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Credit Card")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            // const Spacer(),
            /**
             * Card number
             */
            // Form(child: Column());
            TextFormField(
              controller: cardNumberCotroller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter() //import input_formatters.drt to call the follow function
              ],
              decoration: InputDecoration(
                hintText: "Card number",
                suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardUtils.getCardIcon(cardType)),
                prefixIcon: cardType == CardType.Invalid
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset("assets/icons/card.svg")),
              ),
            ),

            /**
             * Full name
             */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Full name",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    //svg 不显示 ?-- done:pyam file images dependency setting
                    child: SvgPicture.asset("assets/icons/user.svg"),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                /**
                 * CVV
                 */
                Expanded(
                  child: TextFormField(
                    keyboardType:
                        TextInputType.number, // only provide number keyboard
                    inputFormatters: [
                      // only digits number input allowed
                      FilteringTextInputFormatter.digitsOnly,
                      //limit the input length
                      LengthLimitingTextInputFormatter(4)
                    ],
                    decoration: InputDecoration(
                      hintText: "CVV",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset("assets/icons/Cvv.svg"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),

                /**
                 * MM/YY
                 */
                Expanded(
                  child: TextFormField(
                    keyboardType:
                        TextInputType.number, // only provide number keyboard
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                      CardMonthInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: "MM/YY",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset("assets/icons/calender.svg"),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(flex: 2),
            // Scan button
            // already define button theme on theme in cardpayment.dart
            OutlinedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset("assets/icons/scan.svg"),
              label: Text("Scan"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: defaultPadding),
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Add card"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
