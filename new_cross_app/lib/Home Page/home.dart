import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
//import 'package:jemma/models/user.dart';
//import 'package:jemma/repository.dart';
import 'package:new_cross_app/Home Page/adaptive.dart';
import 'package:new_cross_app/Home Page/responsive.dart';
import 'package:new_cross_app/Home Page/graphical_banner.dart';
import 'package:new_cross_app/Home Page/login_button.dart';
import 'package:new_cross_app/Home Page/nav_bar.dart';
import 'package:new_cross_app/Home Page/notification_panel.dart';
import 'package:new_cross_app/Home Page/search_bar.dart';
import 'package:new_cross_app/Home Page/web_footer.dart';
import 'package:new_cross_app/Home Page/about_jemma.dart';
import 'package:new_cross_app/Home Page/why_jemma.dart';
import 'package:new_cross_app/Routes/route_const.dart';

import '../Calendar/Consumer/Consumer.dart';
import '../Calendar/Consumer/ConsumerProfilePage.dart';
import '../Calendar/Consumer/TradieDemo.dart';
import '../Calendar/RatePage.dart';
import '../Calendar/Tradie/TradieProfilePage.dart';
import '../Login/login.dart';
import '../Profile/profile.dart';
import '../Sign_up/signup.dart';
import '../chat/screens/chat_home_screen.dart';
import '../stripe/card_form_screen.dart';
import '../stripe/check_out.dart';

/// Home screen for guests and customers
///
/// Restricting max width of widgets to be 1080 based on the data from:
/// https://gs.statcounter.com/screen-resolution-stats/desktop/worldwide
class Home extends StatelessWidget {
  bool isConsumer = true;
  String userId = '';
  Home({Key? key, required this.userId}) : super(key: key);

  static const borderRadius = 40.0;
  static const maxWidth = 1080.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Consumer_person consumer = Consumer_person('Lance');
    var scrollController = ScrollController();
    return Scaffold(
      endDrawer: const NotificationPanel(),
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.notifications)),
          ),
        ],
        /*title: ValueListenableBuilder<User?>(
              valueListenable: Repository().user,
              builder: (BuildContext context, User? user, Widget? child) {

                return Row(
                  children:  [
                    const Text("Home"),
                    const Spacer(),
                    if(user == null)
                    const LoginButton(),
                  ],
                );
              })*/
      ),
      drawer: Drawer(
        child: userId != ''
            ? ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: Text(
                      'Menu',
                    ),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    onTap: () {
                      GoRouter.of(context).pushNamed(RouterName.homePage,
                          params: {'userId': userId});
                    },
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(RouterName.profilePage, params: {
                        'userId': userId,
                      });
                    },
                  ),
                  //TODO: Test User Type
                  isConsumer == true
                      ? ListTile(
                          title: const Text('Consumer Calendar'),
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                                RouterName.CalendarConsumer,
                                params: {
                                  'userId': userId,
                                });
                          },
                        )
                      : ListTile(
                          title: const Text('Tradie Calendar'),
                          onTap: () {
                            GoRouter.of(context)
                                .pushNamed(RouterName.CalendarTradie, params: {
                              'userId': userId,
                            });
                          },
                        ),
                  ListTile(
                    title: const Text('Chat'),
                    onTap: () {
                      GoRouter.of(context).pushNamed(RouterName.chat, params: {
                        'userId': userId,
                      });
                    },
                  ),
                ],
              )
            : ListView(
                children: [
                  const DrawerHeader(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      'Please Login First',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(RouterName.Login);
                      },
                      child: const Text(
                        'Login',
                        textScaleFactor: 2.0,
                      )),
                  TextButton(
                      onPressed: () {
                        GoRouter.of(context)
                            .pushNamed(RouterName.SignUp, params: {
                          'userId': userId,
                        });
                      },
                      child: const Text(
                        'Sign Up',
                        textScaleFactor: 2.0,
                      ))
                ],
              ),
      ),
      body: Scrollbar(
        isAlwaysShown: isWeb(),
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  child: Column(children: [
                    SizedBox(height: 2.5.ph(size)),
                    const GraphicalBanner(),
                    Transform.translate(
                        offset: const Offset(
                            0, -GraphicalBanner.bannerHeight * 0.25),
                        child: SearchBar(
                          userId: userId,
                        )),
                    const AboutJemma(),
                    SizedBox(height: 5.ph(size)),
                    WhyJemma(),
                  ]),
                ),
                if (isWeb()) const WebFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
