import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

//import 'package:flutter_stripe_web/flutter_stripe_web.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_cross_app/Routes/route_const.dart';
import 'package:new_cross_app/blocs/payment/payment_bloc.dart';

class CardFormScreen extends StatelessWidget {
  const CardFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with a Credit Card')),
      body: BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
        if (state.status == PaymentStatus.initial) {
          CardFormEditController controller = CardFormEditController(
            initialDetails: state.cardFieldInputDetails,
          );
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Card Form', style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: 20),
                CardFormField(controller: controller),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      (controller.details.complete)
                          ? context.read<PaymentBloc>().add(
                                const PaymentCreateIntent(
                                  billingDetails: const BillingDetails(
                                      email: 'JemmaAUGroup@gmail.com'),
                                  items: [
                                    {'id': 0},
                                    {'id': 1},
                                  ],
                                ),
                              )
                          : ScaffoldMessenger.of(context).showMaterialBanner(
                              const SnackBar(
                                content: Text('The form is not complete.'),
                                // no as MaterialBanner
                              ) as MaterialBanner,
                            );
                    },
                    child: Text('Pay',
                        style: TextStyle(fontSize: 10.0, color: Colors.green))),
              ],
            ),
          );
        }
        if (state.status == PaymentStatus.success) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('The Payment is succeed'),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouterName.homePage,params: {'userId': '1P1AuzZ4ElZTBrIV9WaaTpuTzbu1'});
                },
                child: const Text('Back to home'),
              ),
            ],
          );
        }
        if (state.status == PaymentStatus.failure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('The Payment Failed'),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<PaymentBloc>().add(PaymentStart());
                },
                child: const Text('Try it again.'),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        ;
      }),
    );
  }

  /// https://docs.page/flutter-stripe/flutter_stripe/sheet
  // Future<void> initPaymentSheet() async {
  //   try {
  //     // 1. create payment intent on the server
  //     final data = await _createTestPaymentSheet();
  //
  //     // 2. initialize the payment sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         // Enable custom flow
  //         customFlow: true,
  //         // Main params
  //         merchantDisplayName: 'Flutter Stripe Store Demo',
  //         paymentIntentClientSecret: data['paymentIntent'],
  //         // Customer keys
  //         customerEphemeralKeySecret: data['ephemeralKey'],
  //         customerId: data['customer'],
  //         // Extra options
  //         testEnv: true,
  //         applePay: true,
  //         googlePay: true,
  //         style: ThemeMode.dark,
  //         merchantCountryCode: 'DE',
  //       ),
  //     );
  //     setState(() {
  //       _ready = true;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //     rethrow;
  //   }
  // }
  /// 在 Stripe 中，当用户点击 "Pay" 按钮后，通常会发生以下步骤：
  // 客户端 (前端) 将使用 Stripe SDK 创建一个 PaymentMethod 对象，包含用户支付信息，例如信用卡号、过期日期、CVC 码等。
  // 客户端将 PaymentMethod 对象发送到服务器端 (后端)。
  // 服务器端 (后端) 接收到 PaymentMethod 对象后，使用 Stripe API 进行服务器端验证和处理。
  // 服务器端 (后端) 将从客户端接收到的 PaymentMethod 对象传递给 Stripe API，进行支付验证和创建 PaymentMethod 。
  // Stripe API 返回一个 PaymentMethod 对象的确认结果，包括一个唯一的 PaymentMethod ID 用于标识该 PaymentMethod 。
  // 服务器端 (后端) 将 PaymentMethod ID 返回给客户端 (前端)，作为支付的确认信息。
  // 客户端 (前端) 可以使用返回的 PaymentMethod ID 来完成支付流程，例如将其传递给一个确认订单的 API 请求，或者使用 Stripe SDK 进行更进一步的处理，例如创建 PaymentIntent 或 SetupIntent 。
  // Stripe 将根据 PaymentMethod 的类型和验证结果，向支付渠道发起实际的支付请求，例如向银行发起扣款请求。
  // 支付渠道 (例如银行) 处理支付请求，并返回支付结果给 Stripe。
  // Stripe 接收到支付渠道返回的支付结果后，将支付结果传递给服务器端 (后端)。
  // 服务器端 (后端) 根据支付结果更新订单状态，并通知客户端 (前端) 支付已完成。
  // 客户端 (前端) 根据支付结果更新用户界面，显示支付成功或失败的信息。
  ///
  // Future<void> handlePaymentButtonClick() async {
  //   // 构建 PaymentMethod 参数
  //   PaymentMethodParams paymentMethodParams = PaymentMethodParams.card(
  //     //TODO
  //     /*card: CreditCard(
  //       number: '4242424242424242', // 设置卡号
  //       expMonth: 12, // 设置过期月份
  //       expYear: 2023, // 设置过期年份
  //       cvc: '123', // 设置 CVC 码
  //     ),
  //
  //     PaymentMethodParams(
  //       metadata: {
  //         'order_id': '1234567890', // 自定义的元数据信息
  //         'customer_id': '9876543210', // 自定义的元数据信息
  //       },
  //     ),*/
  //     paymentMethodData: PaymentMethodData(
  //       billingDetails: BillingDetails(
  //         name: 'John Doe', // 设置姓名
  //         email: 'john.doe@example.com', // 设置邮箱
  //         phone: '+15555555555', // 设置电话
  //         // 还可以设置其他 BillingDetails 参数，例如地址等
  //       ),
  //     ),
  //   );
  //
  //   // 调用 Stripe SDK 的 createPaymentMethod 方法创建 PaymentMethod 对象
  //   final paymentMethod = await Stripe.createPaymentMethod(paymentMethodParams);
  //
  //   // 调用 confirmPaymentMethod 方法
  //   final paymentIntent = await Stripe.instance.confirmPaymentMethod(
  //     // 设置 PaymentIntentParams
  //
  //     // 需要传入 paymentMethodId 和 clientSecret
  //     paymentMethodId: paymentMethod.id,
  //     clientSecret: 'YOUR_CLIENT_SECRET', // 替换为你的实际 clientSecret
  //   );
  //
  //   // 获取支付确认的结果，例如 paymentIntent.status
  //
  //   // 根据支付结果进行相应处理
  // }

  /// 将 PaymentMethod 对象发送到服务器端
  // Future<void> sendPaymentMethodToServer(PaymentMethod paymentMethod) async {
  //   // 将 PaymentMethod 对象序列化为 JSON 格式
  //   String paymentMethodJson = jsonEncode(paymentMethod.toJson());
  //
  //   // 发送 POST 请求将 PaymentMethod 对象发送到服务器端
  //   final response = await http.post(
  //     'https://your-backend-api.com/create_payment_method',
  //     headers: {'Content-Type': 'application/json'},
  //     body: paymentMethodJson,
  //   );
  //
  //   // 检查请求是否成功
  //   if (response.statusCode == 200) {
  //     // 处理服务器端返回的响应数据
  //     // TODO: 根据业务需求进行处理
  //     print('PaymentMethod sent to server successfully');
  //   } else {
  //     // 处理请求失败的情况
  //     print('Failed to send PaymentMethod to server: ${response.statusCode}');
  //   }
  // }
}
